# Testing Decisions Log

A running record of the non-trivial decisions, trade-offs, and bugs found while building
out test coverage for Nuntium. Not a changelog of every test written — only the moments
where a real choice was made or a real bug was caught.

---

## 2026-07-18 — Equatable `stringify` on exception/failure classes

**Problem:** Needed to decide whether `AppException`/`Failure` subclasses should override
`stringify => true` when extending `Equatable`.

**Options considered:**
- Leave `stringify` at its default (`false`)
- Set `stringify => true` per class
- Set `EquatableConfig.stringify = true` globally in test setup

**Decision:** `stringify => true`, set explicitly per class.

**Trade-off accepted:** A few extra lines per exception/failure class, in exchange for
readable failure diffs (`ServerException(500, Internal Error)` instead of
`Instance of 'ServerException'`) whenever a test assertion fails.

---

## 2026-07-18 — Testing functions that `throw` instead of `return`

**Problem:** First attempt at testing `handleDioError` called the throwing function
directly inside `expect(...)`, which crashed the test runner before `expect` ever ran,
and also had the actual/matcher arguments swapped.

**Root cause:** `expect(actual, matcher)` requires the code under test to be wrapped in
a closure (`() => handleDioError(...)`) when it's expected to throw — calling it directly
evaluates it eagerly.

**Decision:** Standard pattern going forward for any exception-throwing code:
`expect(() => methodUnderTest(), throwsA(expectedException))`.

**Standing rule established:** Test payloads must mirror the exact shape the
implementation reads (e.g. `response.data['message']`, not `response.statusMessage`) —
a mismatch here fails silently with a fallback value instead of an obvious error.

---

## 2026-07-18 — Decoupling `ErrorHandler` from `FirebaseCrashlytics`

**Problem:** `ErrorHandler.handle()` called a global `crashlytics` object
(`FirebaseCrashlytics.instance`) directly, making it impossible to unit test without
hitting real Firebase or crashing in the test environment.

**Options considered:**
- **A — Method injection:** optional `CrashlyticsService?` parameter on `handle()`
- **B — Mutable static field seam:** swappable `static CrashReporter reporter` field,
  overridden in test `setUp`/`tearDown`
- **C — Full constructor injection:** `CrashReporter` interface, real implementation
  and fake implementation both registered through the existing GetIt container

**Decision:** Option C.

**Reasoning:** GetIt-based DI is already the established pattern elsewhere in Nuntium
(session-scoped repositories, BLoCs, use cases), so this is consistent rather than a
one-off. Option A risks call sites silently forgetting to pass a reporter in production
with no compiler signal. Option B works but relies on disciplined `tearDown` resets to
avoid state leaking between tests — an avoidable risk when full DI is already cheap here.

**Trade-off accepted:** Every call site of `ErrorHandler.handle()` had to move from a
static call to an instance pulled from GetIt (`getIt<ErrorHandler>().handle(...)`).
Mechanical change, but touched multiple files.

---

## 2026-07-18 — GetIt generic type registration bug

**Problem:** `error_handler_test.dart` failed with
`Bad state: Object/factory with type CrashReporter is not registered inside GetIt`,
even though a `FakeCrashReporter` was registered in `setUpAll`.

**Root cause:** `getIt.registerSingleton(FakeCrashReporter())` registers the fake under
its concrete type, not the `CrashReporter` interface `ErrorHandler` actually looks up.

**Decision:** Always explicitly pin the interface type when registering:
`getIt.registerSingleton<CrashReporter>(FakeCrashReporter())`.

**Standing rule established:** This applies outside tests too — any GetIt registration
intended to satisfy an interface lookup must specify the generic type explicitly, or a
concrete-type registration will silently fail to resolve for callers that ask for the
abstraction.

---

## 2026-07-18 — Testing a pure pass-through use case

**Problem:** `FetchNewsUseCase` is a 3-line pass-through with no transformation,
validation, or multi-repository orchestration. Question raised: is a test for it useless?

**Decision:** Write it anyway — one short test asserting the use case forwards params
and results unchanged, with `verifyNoMoreInteractions` on the mocked repository.

**Reasoning:** The test isn't protecting the use case's current behavior — it's a cheap
tripwire against silent logic creep later. BLoC tests mock `FetchNewsUseCase`, not the
repository directly, so BLoC test correctness silently depends on the use case staying a
pure pass-through. Nothing else in the suite would catch it if that assumption quietly
became false (e.g. a filter or transform added later without anyone noticing the
contract changed). Cost was a few minutes against an otherwise-undetectable regression
class — asymmetry favored writing it.

**Standing rule established:** Skipping a cheap test to avoid trivial coverage is fine
in principle, but the decision should rest on the cost/risk trade-off, not on "it's
short so it must be pointless."

---

## 2026-07-18 — `BookmarksCubit` double-emission bug

**Problem:** `blocTest` for `BookmarksCubit` showed `Actual: []` on first attempt, then
after adding an explicit `act:` trigger, `getSavedArticlesUseCase` was found to be
called twice instead of once.

**First fix attempted (rejected):** Update the test assertion to `.called(2)` instead
of `.called(1)` to make it pass.

**Root cause:** The cubit's constructor called `_init()` synchronously, which called
`getSavedArticles()` and emitted states before `blocTest` had subscribed to the stream —
so the emissions were missed entirely. The test's `act:` step then triggered a second,
real invocation of the same use case, masking the real problem behind a passing test
with the wrong expected count.

**Decision:** Rejected the `.called(2)` patch. Fixed the constructor with
`scheduleMicrotask(_init)` to defer the initial fetch until after listeners (both
`blocTest` and real `BlocBuilder`/`BlocListener` widgets) have attached.

**Reasoning:** Emitting state synchronously inside a constructor is a general BLoC
anti-pattern — it doesn't just break this test, it means any real widget listening to
this cubit would miss the initial `Loading`/`Loaded` emissions too. The microtask
deferral fixes the actual production bug, not just the test output.

**Standing rule established (project-wide):** Never resolve a failing test by loosening
the assertion without first confirming the underlying behavior is correct. A test that
was patched to match buggy behavior is worse than no test at all, because it actively
hides the bug from future runs.

---

## 2026-07-18 — Remote Data Source Testing Strategy

**Problem:** How to thoroughly test `NewsRemoteDataSource` and its network logic.
**Options considered:** Mock `ApiClient` via Mockito vs. intercept real Dio requests using `http_mock_adapter`.
**Decision:** Chose `http_mock_adapter`. Expose `Dio` inside `ApiClient` using `@visibleForTesting`.
**Trade-off accepted:** Slightly more setup, but vastly better ROI. It validates Dio config, interceptors, error bubbling, and JSON parsing—things Mockito would completely bypass.
