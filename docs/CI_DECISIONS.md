# CI Decisions Log

Non-obvious gotchas, workarounds, and constraints in the CI pipeline.
Each entry follows a **Symptom → Root Cause → Fix** structure because CI issues
are almost always "the tool did something surprising" rather than open design choices.

Workflows:
- [validate-pr.yml](../.github/workflows/validate-pr.yml) — lint & test gate on PRs
- Dev deploy and production release workflows (triggered on merge to `dev` / `main`)

---

## 2026-07-17 — Three-workflow split instead of one monolithic pipeline

**Context:** The original `main.yml` triggered build + release on pushes to `main`,
`dev`, and `test`. This was an anti-pattern: every push ran a full release build
even when all that was needed was a lint check.

**Decision:** Split into three separate workflows with distinct triggers:

| Workflow | Trigger | Job |
|---|---|---|
| **Validate** | PR to `dev` or `main` | `flutter analyze` + `flutter test` only. No builds, no secrets exposed. |
| **Dev Deploy** | Merge to `dev` | Build APK → push to Firebase App Distribution for device testing. |
| **Production** | Merge to `main` | Release build → upload Crashlytics symbols → GitHub Release. |

**Reasoning:** A PR validation step should never need release secrets. Separating
concerns means a contributor's PR can't accidentally (or maliciously) exfiltrate
secrets through a modified workflow, and you don't burn GitHub Actions minutes on
full APK builds just to check if the code compiles.

---

## 2026-07-17 — `envied` migration created the `build_runner` CI dependency

**Context:** The app originally used `flutter_dotenv`, which loads secrets from a
`.env` file bundled as a Flutter asset. This means API keys ship **in plain text**
inside the APK — anyone with `apktool` can extract them in seconds.

**Decision:** Migrated to `envied` with `@EnviedField(obfuscate: true)`, which
XOR-obfuscates secrets into generated Dart code at compile time. This means:

- `.env` is no longer a Flutter asset (removed from `pubspec.yaml` assets)
- `env.g.dart` is gitignored (contains obfuscated secrets, machine-specific)
- CI must inject `.env` from GitHub Secrets and run `build_runner` to regenerate
  `env.g.dart` before every build or analyze step

This is why the `build_runner` step exists in the validate workflow at all — it's
not optional infrastructure, it's a direct consequence of the security architecture.

---

## 2026-07-17 — `FIREBASE_TOKEN` deprecated — migrated to Service Account

**Symptom:** Dev deploy workflow fails with:

```
Error: Failed to authenticate, have you run firebase login?
```

**Root cause:** The workflow used `FIREBASE_TOKEN` (generated via
`firebase login:ci`) to authenticate with Firebase CLI. This method is deprecated
and being removed. The tokens are also long-lived, hard to rotate, and often grant
overly broad access to the entire Firebase account.

**Fix:** Switched to a Google Service Account JSON key:

1. Created a dedicated Service Account in Google Cloud Console with the narrowest
   permissions needed (App Distribution + Crashlytics only)
2. Saved the private key JSON as a GitHub Secret
3. Workflow writes the JSON to a temp file on the runner and sets
   `GOOGLE_APPLICATION_CREDENTIALS` to point at it

---

## 2026-07-17 — Package name mismatch between Gradle and Firebase Console

**Symptom:** Firebase App Distribution upload fails with a generic error after a
successful APK build.

**Root cause:** The APK was built with package name `com.example.nuntium` (from
Gradle config), but the Firebase App ID in the workflow expected
`com.example.new_nuntium` (matching a different project instance in Firebase Console).

One character difference. Twenty minutes of reading runner logs.

**Fix:** Aligned the Gradle `applicationId` with the Firebase Console app registration.

**Standing rule:** When CI builds succeed but deployment/upload fails, check
configuration alignment (Gradle `applicationId`, Firebase App ID, bundle identifiers)
before touching code. These are the most common and hardest-to-spot CI failures
in mobile development.

---

## 2026-07-22 — `build_runner` deletes pre-committed generated files on clean CI

**Symptom:** `flutter analyze` fails with `uri_has_not_been_generated` for
`article_hive_model.g.dart` and `uri_does_not_exist` for every `.mocks.dart` —
even though all these files are committed and checked out.

**Root cause:** On a clean machine (no `.dart_tool/build/` cache), `build_runner`
discovers every registered builder (mockito, envied, hive annotations), marks their
expected outputs as "managed", runs only the filtered build (`env.g.dart`), then
**deletes every other managed output it didn't produce** as "stale".

`--build-filter` restricts which files get **generated** — not which files get
**cleaned up**. This distinction is undocumented and counterintuitive.

Locally this never surfaces because `.dart_tool/build/` caches the previous full
build, so `build_runner` knows those files are valid. CI has no such cache.

**Reproduced locally by:**

```bash
# Simulate clean CI
rm -rf .dart_tool/build

# Run the exact CI command
flutter pub run build_runner build --force-jit --build-filter="lib/core/env/env.g.dart"

# Confirm deletion
git status --short -- "*.g.dart" "*.mocks.dart"
# Output: D for every .g.dart and .mocks.dart except env.g.dart
```

**Fix:** Backup generated files before `build_runner`, restore them after:

```yaml
- name: Generate Env Secrets Code (build_runner)
  run: |
    # Backup pre-committed generated files
    find . -name '*.g.dart' -not -name 'env.g.dart' -o -name '*.mocks.dart' \
      | while read f; do cp "$f" "$f.bak"; done

    flutter pub run build_runner build --force-jit --build-filter="lib/core/env/env.g.dart"

    # Restore backed-up files
    find . -name '*.bak' | while read f; do mv "$f" "${f%.bak}"; done
```

**Why not just run a full `build_runner build` without `--build-filter`?**
`hive_generator` is intentionally disabled (commented out in `pubspec.yaml`)
due to a conflict. A full build would fail or produce incorrect output.
Only `env.g.dart` needs runtime generation because it depends on injected secrets.

---

## 2026-07-22 — `build_runner` AOT compilation fails with build hooks

**Symptom:** CI exits with code 78:

```
E 'dart compile' does not support build hooks, use 'dart build' instead.
E Failed to compile build script.
```

**Root cause:** Dart 3.6+ (Flutter 3.38) introduced native asset build hooks.
By default, `build_runner` pre-compiles its build script using AOT (`dart compile exe`),
which explicitly does not support packages that use build hooks.

**Fix:** Add `--force-jit` to force JIT compilation, bypassing the AOT path:

```yaml
flutter pub run build_runner build --force-jit --build-filter="lib/core/env/env.g.dart"
```

**Trade-off:** JIT compilation is slightly slower than AOT on first run (~5s), but
this is irrelevant in CI where there's no cached AOT binary anyway.

