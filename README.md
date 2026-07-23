# Tanglish 🌟

> **Learn Telugu through real-life English conversations**

A production-ready Flutter app helping children (ages 5–12) and families worldwide learn Telugu naturally — through everyday phrases, not rote memorisation.

---

## Features

| Feature | Details |
|---------|---------|
| 🔐 Authentication | Google Sign-In, Apple Sign-In (iOS), Email |
| 📚 5 Categories | Family · School · Playground · Food · Daily Activities |
| 🔊 Audio playback | Native pronunciation per phrase |
| 🔥 Streaks & XP | Daily streak tracking, XP gamification |
| 📊 Progress tracking | Firestore-backed per-lesson completion |
| 📱 Cross-platform | Android · iOS · Web |
| 🛡️ Secure by default | COPPA/GDPR-friendly, Firestore rules, CSP |

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter 3.22+ / Dart 3.3+ |
| State management | Riverpod 2 (StateNotifier + StreamProvider) |
| Navigation | GoRouter 14 |
| Backend | Firebase Auth · Firestore · Analytics · Crashlytics |
| Architecture | Clean Architecture + Repository Pattern |
| Audio | just_audio |
| Design system | Material 3 |

---

## Project Structure

```
lib/
├── core/
│   ├── constants/       # AppConstants
│   ├── errors/          # Failure types
│   ├── router/          # GoRouter configuration
│   ├── theme/           # AppTheme, AppColors
│   └── utils/           # Validators, sanitisation
├── domain/
│   ├── entities/        # UserEntity, LessonEntity, ProgressEntity
│   ├── repositories/    # Abstract repository interfaces
│   └── usecases/        # Business logic (one class per use-case)
├── data/
│   ├── datasources/     # Firebase remote data sources
│   ├── models/          # Firestore serialisation models
│   ├── repositories/    # Concrete repository implementations
│   └── seed/            # Lesson seed data
├── providers/           # Riverpod DI providers
└── presentation/
    ├── auth/            # Login screen + widgets
    ├── home/            # Home screen + stat cards
    ├── lesson/          # Categories, lesson player + widgets
    ├── profile/         # Profile screen
    └── splash/          # Animated splash
```

---

## Getting Started

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Configure Firebase
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

### 3. Run
```bash
# Android / iOS
flutter run

# Web
flutter run -d chrome
```

### 4. Run tests
```bash
flutter test

# Generate Mockito mocks before first test run
dart run build_runner build --delete-conflicting-outputs
```

---

## Security Design

| Concern | Approach |
|---------|---------|
| Auth | Firebase Auth — no passwords stored |
| Authorization | Firestore rules enforce per-user data isolation |
| Input validation | `Validators` class at all system boundaries |
| XSS protection | CSP meta tag + `X-XSS-Protection` header |
| Clickjacking | `X-Frame-Options: DENY` header |
| HTTPS | Enforced via Firebase Hosting + HSTS |
| Error messages | Sanitised — internal details never reach the UI |
| COPPA | Minimal PII collected; parental consent notice on login |
| GDPR | No passwords stored; data erasure possible via Firestore |

---

## Deployment

See [DEPLOYMENT.md](DEPLOYMENT.md) for full Android / iOS / Web / Firebase Hosting instructions.

---

## License

MIT © Tanglish
