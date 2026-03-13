# Firebase Setup Guide

This app includes optional Firebase Firestore integration for cloud data sync. The app will work with SQLite-only mode if Firebase is not configured.

## Option 1: Quick Setup with FlutterFire CLI (Recommended)

1. **Install FlutterFire CLI**:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Login to Firebase**:
   ```bash
   firebase login
   ```

3. **Configure Firebase for your Flutter project**:
   ```bash
   cd C:/Users/LAB/Desktop/Smart_class_app
   flutterfire configure
   ```

   This will:
   - Prompt you to select or create a Firebase project
- Automatically generate `firebase_options.dart`
   - Configure Firebase for Android, iOS, and Web platforms

4. **Update main.dart** (if using flutterfire configure):
   Replace the Firebase initialization in `lib/main.dart` with:
   ```dart
   import 'firebase_options.dart';

   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

## Option 2: Manual Setup

### For Android:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing one
3. Add an Android app with package name: `com.student.smart_class_app`
4. Download `google-services.json`
5. Place it in: `android/app/google-services.json`
6. Add to `android/build.gradle.kts` (project level):
   ```kotlin
   dependencies {
       classpath("com.google.gms:google-services:4.4.2")
   }
   ```
7. Add to `android/app/build.gradle.kts`:
   ```kotlin
   plugins {
       id("com.google.gms.google-services")
   }
   ```

### For iOS:
1. In Firebase Console, add an iOS app with bundle ID: `com.student.smartClassApp`
2. Download `GoogleService-Info.plist`
3. Place it in: `ios/Runner/GoogleService-Info.plist`
4. Open `ios/Runner.xcworkspace` in Xcode and add the file to the project

### For Web:
1. In Firebase Console, add a Web app
2. Copy the Firebase config object
3. Update `web/index.html` with Firebase SDK initialization

## Firestore Database Rules

Set up your Firestore security rules (for development/testing):

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // WARNING: Open access for testing only
    }
  }
}
```

**For production**, restrict access appropriately.

## Verify Firebase is Working

After setup:
1. Run the app
2. Check the console/logs - you should NOT see "Firebase initialization failed"
3. Check-in or finish class
4. Go to Firebase Console → Firestore Database
5. You should see `check_ins` and `check_outs` collections with data

## Troubleshooting

- **"Firebase initialization failed"**: The app will still work with SQLite only
- **No data in Firestore**: Check your internet connection and Firestore rules
- **Build errors**: Run `flutter clean && flutter pub get`

## Collections Created

- `check_ins` - Check-in records with GPS, QR code, and pre-class reflection
- `check_outs` - Check-out records with GPS, QR code, and post-class feedback
