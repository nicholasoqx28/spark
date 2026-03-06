# Spark Flutter App

Flutter client for the Spark sports platform, targeting:
- **Web** — Admin & merchant dashboard (Flutter web)
- **PWA** — Player app (installable from browser)
- **Android / iOS** — Future native mobile builds

## Architecture

```
lib/
├── main.dart                  # Entry point
├── app.dart                   # MaterialApp + router setup
├── core/
│   ├── api/api_client.dart    # Dio HTTP client → Next.js API
│   ├── auth/
│   │   ├── auth_provider.dart # Riverpod auth state notifier
│   │   └── router.dart        # go_router with auth guards
│   ├── models/                # Dart data models
│   └── theme/app_theme.dart   # Material 3 theme
├── features/
│   ├── auth/                  # Login & register screens
│   ├── dashboard/             # Home screen (role-aware)
│   ├── tournaments/           # Tournament list + registration
│   ├── shop/                  # Product catalog
│   └── academy/               # Course list + enrolment
└── shared/widgets/            # Reusable UI components
```

## Prerequisites

- Flutter SDK ≥ 3.22 — [install](https://docs.flutter.dev/get-started/install)
- Next.js API running (see root `README.md`)

## Getting Started

```bash
cd flutter_app

# Install dependencies
flutter pub get

# Run for web (connects to localhost:3000 API)
flutter run -d chrome

# Run on Android emulator
flutter run -d android

# Build web PWA
flutter build web --release
```

## Connecting to the API

The API base URL is set in `lib/core/api/api_client.dart`:

```dart
const _baseUrl = 'http://localhost:3000'; // ← change for production
```

For production, set this to your deployed Next.js API URL.

## State Management

- **Riverpod** (`flutter_riverpod`) for all app state
- `authProvider` — global auth state + session restore
- Feature-level `FutureProvider`s for API data fetching

## Platform Notes

### Web / PWA
- `web/manifest.json` enables PWA install prompt
- Run `flutter build web --release` then serve the `build/web/` directory

### Android / iOS
- Needs platform-specific setup (see Flutter docs)
- `flutter_secure_storage` handles token persistence natively
