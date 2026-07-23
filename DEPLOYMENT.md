# Tanglish — Deployment Guide

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Flutter SDK | ≥ 3.22 | https://docs.flutter.dev/get-started/install |
| Dart SDK | ≥ 3.3 | bundled with Flutter |
| Firebase CLI | ≥ 13 | `npm install -g firebase-tools` |
| FlutterFire CLI | latest | `dart pub global activate flutterfire_cli` |
| Xcode | ≥ 15 | App Store (iOS only) |
| Android Studio | latest | https://developer.android.com/studio |

---

## 1. Firebase Project Setup

### 1.1 Create Project
```bash
firebase login
firebase projects:create tanglish-prod --display-name "Tanglish"
```

### 1.2 Auto-configure Flutter
```bash
cd "c:/Git Repos/VibeCode/Tanglish"
flutterfire configure --project=tanglish-prod
```
This regenerates `lib/firebase_options.dart` with real credentials for all platforms.

### 1.3 Enable Services (Firebase Console)
- **Authentication** → Sign-in methods → Enable **Google** and **Apple**
- **Firestore** → Create database → Start in **production mode**
- **Analytics** → Enable
- **Crashlytics** → Enable (requires a real build)

---

## 2. Firestore Setup

### 2.1 Deploy Security Rules & Indexes
```bash
firebase deploy --only firestore:rules,firestore:indexes
```

### 2.2 Seed Lesson Data
The app auto-seeds on first category load (idempotent). Alternatively:
```bash
# Using Firebase Emulator for local testing
firebase emulators:start --only firestore
# Then run the app against the emulator
flutter run --dart-define=USE_EMULATOR=true
```

---

## 3. Web Deployment (Firebase Hosting)

```bash
# Install dependencies
flutter pub get

# Build optimised web bundle
flutter build web --release --web-renderer canvaskit

# Preview locally
firebase serve --only hosting

# Deploy
firebase deploy --only hosting
```

### Custom Domain
1. Firebase Console → Hosting → **Add custom domain**
2. Add the DNS records provided by Firebase
3. SSL certificate is provisioned automatically (allow up to 24 h)

---

## 4. Android Deployment

### 4.1 Configure
1. Add `android/app/google-services.json` (from Firebase Console → Android app)
2. Set your `applicationId` in `android/app/build.gradle`:
   ```gradle
   applicationId "com.yourcompany.tanglish"
   ```

### 4.2 Generate Signing Key (first time only)
```bash
keytool -genkey -v -keystore tanglish-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias tanglish
```

### 4.3 Configure `android/key.properties`
```
storePassword=<your_store_password>
keyPassword=<your_key_password>
keyAlias=tanglish
storeFile=../tanglish-release.jks
```

### 4.4 Build Release AAB
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### 4.5 Google Play Console
1. Upload `app-release.aab` to Play Console
2. Add SHA-1 and SHA-256 fingerprints to Firebase → Android App settings

---

## 5. iOS Deployment

### 5.1 Configure
1. Add `ios/Runner/GoogleService-Info.plist` (from Firebase Console → iOS app)
2. Open in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
3. Set Bundle ID: `com.yourcompany.tanglish`
4. Set your Development Team
5. Enable capability: **Sign In with Apple**
6. Add `Associated Domains` entitlement for Apple Sign-In

### 5.2 Build
```bash
flutter build ios --release
```
Then in Xcode: **Product → Archive → Distribute App**

### 5.3 Apple Developer Configuration
- Create App ID with **Sign In with Apple** capability in Apple Developer Portal
- Configure **Service ID** for web OAuth redirect URL

---

## 6. Environment & Security Checklist

- [ ] `lib/firebase_options.dart` has real credentials
- [ ] `firebase_options.dart` added to `.gitignore` (for public repos)
- [ ] Firestore security rules deployed and tested in Rules Playground
- [ ] Google OAuth Client ID configured
- [ ] Apple Service ID configured
- [ ] SHA-256 certificate fingerprints added to Firebase (Android)
- [ ] Associated Domains entitlement configured (iOS)
- [ ] Crashlytics enabled for production builds
- [ ] Analytics events verified in DebugView
- [ ] Privacy Policy URL added to app listings (COPPA requirement)

---

## 7. Local Development with Emulators

```bash
# Start all emulators
firebase emulators:start

# Emulator UI: http://localhost:4000
# Firestore: localhost:8080
# Auth: localhost:9099
```

In `main.dart`, add emulator connections for local testing:
```dart
// Development only — remove before production
if (kDebugMode) {
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
}
```

---

## 8. CI/CD (Optional — GitHub Actions)

```yaml
# .github/workflows/deploy.yml
name: Deploy to Firebase Hosting
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.x'
      - run: flutter pub get
      - run: flutter build web --release
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: ${{ secrets.GITHUB_TOKEN }}
          firebaseServiceAccount: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
          channelId: live
          projectId: tanglish-prod
```

---

## 9. Post-Deployment Monitoring

| Service | URL |
|---------|-----|
| Analytics | Firebase Console → Analytics |
| Crashlytics | Firebase Console → Crashlytics |
| Firestore Usage | Firebase Console → Firestore → Usage |
| Hosting | Firebase Console → Hosting |
