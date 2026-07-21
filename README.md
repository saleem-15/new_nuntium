<h1 align="center">Nuntium — Clean Architecture News Client</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.38-02569B?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/State-BLoC_%2F_Cubit-01579B" alt="BLoC" />
  <img src="https://img.shields.io/badge/Architecture-Clean-6C3483" alt="Architecture" />
  <img src="https://img.shields.io/badge/Error_Handling-Functional_(Dartz)-27AE60" alt="Dartz" />
  <img src="https://img.shields.io/badge/Firebase-Auth_%7C_Crashlytics-FFCA28?logo=firebase" alt="Firebase" />
  <img src="https://img.shields.io/badge/DI-GetIt_Scopes-F5B041" alt="GetIt" />
  <img src="https://img.shields.io/badge/Storage-Hive-F5B041" alt="Hive" />
</p>

**Developer's Note:** *This repository is a from-scratch reconstruction of a project I originally authored in 2023. After an involuntary two-year hiatus due to the conflict in Gaza, I rebuilt this system to rigorously re-solidify my mastery of Clean Architecture, functional error handling, and reactive state management. It is a deliberate exercise in professional discipline and technical resilience.*

## 📱 App Showcase

| Articles Infinite Scrolling | Bookmark Article |
| :---: | :---: |
| <img src="docs/media/articles_infinite_scrolling_demo.gif" width="250" alt="Articles Infinite Scrolling Demo"> | <img src="docs/media/bookmark_article_demo.gif" width="250" alt="Bookmark Article Demo"> |
| **Change Language** | **Google Sign In** |
| <img src="docs/media/change_language_demo.gif" width="250" alt="Change Language Demo"> | <img src="docs/media/google_sign_in_demo.gif" width="250" alt="Google Sign In Demo"> |

## ✨ Key Features

- **Full BLoC / Cubit State Management**: Migrated entirely from GetX to `flutter_bloc`. Every feature uses a dedicated BLoC or Cubit with well-defined events, states, and `Equatable` for efficient rebuilds.
- **Email Verification Flow**: After sign-up, users are redirected to a verification screen that auto-polls Firebase every 3 seconds until the email is confirmed — no manual refresh needed.
- **Scoped Dependency Injection**: Session-scoped DI via `GetIt.pushNewScope()`. All user-specific dependencies (repositories, BLoCs, use cases) live inside a named scope that is atomically disposed on logout — zero stale data leaks between sessions.
- **Optimistic Bookmark Toggling**: Instant UI feedback on bookmark taps with automatic rollback on failure and race-condition protection via an in-flight toggle guard.
- **Reactive Cross-Screen Sync**: Bookmark changes stream across the entire app. Toggling a bookmark on the Article Details screen is automatically reflected on the Home feed via `WatchBookmarksChangesUseCase`.
- **Local Bookmarks**: Articles are saved locally with Hive for instant access — no cloud sync, no account dependency. The network layer handles connectivity drops gracefully via `OfflineFailure`.
- **Robust Authentication**: Google Sign-In, Facebook Auth, email/password login, sign-up, password reset, and password change — all routed through `Either<Failure, Success>`.
- **Multilingual Support (i18n)**: Runtime language switching using `easy_localization` with correct text-direction handling (LTR/RTL).
- **Paginated Infinite Scrolling**: BLoC-driven pagination with `droppable()` concurrency transformer to prevent duplicate API calls on rapid scrolling.
- **Search Functionality**: Keyword-based article search powered by a dedicated `SearchNewsUseCase`, with paginated results routed through the repository layer.
- **Feature-First Clean Architecture**: Scalable, modular structure with strict separation between Data, Domain, and Presentation layers per feature.

## 🛠 Tech Stack & Libraries

| Category | Libraries |
| :--- | :--- |
| **State Management** | `flutter_bloc`, `bloc_concurrency`, `equatable` |
| **Dependency Injection** | `get_it` (with scoped session management) |
| **Networking & API** | `dio`, `pretty_dio_logger`, `internet_connection_checker` |
| **Authentication** | `firebase_auth`, `google_sign_in`, `flutter_facebook_auth` |
| **Local Storage** | `hive`, `hive_flutter`, `shared_preferences` |
| **Error Handling** | `dartz` — Functional `Either<Failure, Success>` across all repository boundaries |
| **Localization** | `easy_localization` |
| **Observability** | `firebase_crashlytics`, `logger` |
| **Environment** | `envied` — Compile-time safe access to `.env` variables |
| **UI & Animations** | `flutter_screenutil`, `shimmer`, `lottie`, `cached_network_image`, `carousel_slider`, `pinput` |

## 🏗 Architecture

The project strictly follows a **Feature-First Clean Architecture**, separating responsibilities logically. Each feature is self-contained with its own `data/`, `domain/`, and `presentation/` layers.

```text
lib/
 ┣ core/                      # Shared utilities, theme, localization, networking, entities
 ┃ ┣ entities/                # App-wide domain entities (Article)
 ┃ ┣ errors/                  # Failure classes for functional error handling
 ┃ ┣ network/                 # ApiClient (Dio), NetworkInfo
 ┃ ┣ localization/            # Language config, text-direction logic
 ┃ ┣ theme/                   # App-wide theming (colors, typography)
 ┃ ┗ services/                # StorageService (Hive), SharedPreferences wrapper
 ┣ config/
 ┃ ┣ dependency_injection.dart  # App-level & session-scoped DI (GetIt scopes)
 ┃ ┗ routes.dart                # Centralized route definitions & BlocProvider wiring
 ┣ features/
 ┃ ┣ auth/                    # Login, Sign-up, Forget/Change Password, Email Verification
 ┃ ┣ home/                    # News feed, search, category filtering (BLoC)
 ┃ ┣ bookmarks/               # Hive-backed offline bookmark CRUD (Cubit)
 ┃ ┣ categories/              # Category browsing (Cubit)
 ┃ ┣ article_details/         # Full article view with bookmark toggle (Cubit)
 ┃ ┣ profile/                 # User profile, sign-out (Cubit)
 ┃ ┣ language/                # Runtime i18n language switching
 ┃ ┣ splash/                  # Splash screen with auth-state routing (Cubit)
 ┃ ┣ onboarding/              # First-launch onboarding flow (Cubit)
 ┃ ┣ select_favorite_topics/  # Topic preference selection (Cubit)
 ┃ ┣ main/                    # Bottom nav shell with persistent tabs (Cubit)
 ┃ ┗ terms_and_conditions/    # Static legal content screens
```

### Dependency Injection Lifecycle

```text
┌─────────────────────────────────────┐  ← Session scope (pushNewScope)
│  Repositories, BLoCs, Use Cases     │    Disposed atomically on logout
│  (user-specific, mutable state)     │
├─────────────────────────────────────┤
│  App-level scope (default)          │  ← Firebase, ApiClient, AuthRepository
│  (stateless adapters, live forever) │    Registered once in main()
└─────────────────────────────────────┘
```

## ⚙️ CI/CD Pipeline (GitHub Actions)

The project uses a **3-workflow** CI/CD pipeline:

| Workflow | Trigger | Purpose |
| :--- | :--- | :--- |
| **Validate PR** | Pull requests to `main` / `dev` | Runs `flutter analyze` + `flutter test` with mock secrets fallback |
| **Dev Release** | Push to `dev` | Builds APK and deploys to **Firebase App Distribution** for tester access |
| **Production Release** | Push to `main` | Builds obfuscated arm64 APK, uploads Crashlytics symbols, creates GitHub Release |

**Key pipeline features:**
- **Obfuscated Builds**: Production APKs are built with `--obfuscate --split-debug-info` for reverse-engineering protection.
- **Crashlytics Symbol Upload**: Debug symbols are automatically uploaded to Firebase Crashlytics for human-readable crash reports.
- **Secure Secret Injection**: API keys, `google-services.json`, and signing keystores are injected via GitHub Secrets — never committed to the repo.
- **Gradle & Build Runner Caching**: Both Gradle dependencies and `build_runner` outputs are cached for faster CI runs.

## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/saleem-15/nuntium.git
   cd nuntium
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Setup Environment Variables:**
   Create a `.env` file in the project root based on [`.env.example`](.env.example):
   ```env
   API_KEY=your_news_api_key_here
   SERVER_CLIENT_ID=your_google_server_client_id_here
   ```

4. **Run Code Generation:**
   ```bash
   dart run build_runner build -d
   ```

5. **Run the App:**
   ```bash
   flutter run
   ```

## 📫 Let's Connect!

I am actively open to new **Flutter Mobile Development** roles. Feel free to reach out if you'd like to discuss how I can add value to your team.

- **LinkedIn**: [Saleem Mahdi](https://www.linkedin.com/in/saleem-mahdi)
- **Email**: [saleemmahdi10@gmail.com](mailto:saleemmahdi10@gmail.com)
