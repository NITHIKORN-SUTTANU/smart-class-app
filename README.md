# Smart Class Check-in & Learning Reflection App

A Flutter mobile application that enables students to check in to class sessions and reflect on their learning experience. The system verifies physical presence using GPS location and QR code scanning, while collecting valuable learning reflection data.

## 📋 Project Description

This application solves the problem of reliable attendance tracking and learning engagement monitoring in university classrooms. Traditional paper-based attendance is slow and easy to falsify. This app combines:

- **GPS verification** to confirm physical presence in the classroom
- **QR code scanning** to verify participation in the specific session
- **Pre-class reflection** to understand student preparation and expectations
- **Post-class feedback** to capture learning outcomes and instructor feedback
- **Offline-first architecture** with SQLite for reliability
- **Cloud sync** with Firebase Firestore for data analysis

## ✨ Features

### Check-in Flow (Before Class)
1. Student enters their student ID
2. System captures GPS location automatically
3. Student scans instructor's session QR code
4. Student completes pre-class reflection:
   - What was covered in previous class
   - What they expect to learn today
   - Current mood (1–5 scale with emoji  selector)
5. Data saved to local SQLite and synced to Firebase

### Finish Class Flow (After Class)
1. Student rescans the QR code
2. System captures GPS location again
3. Student completes post-class reflection:
   - What they learned today
   - Feedback for the class or instructor
4. Data saved locally and synced to cloud

## 🛠 Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter 3.41.4** | Cross-platform mobile framework |
| **Dart** | Programming language |
| **geolocator** | GPS location services |
| **mobile_scanner** | QR code scanning |
| **sqflite** | Local SQLite database (offline-first) |
| **Firebase Core** | Firebase initialization |
| **Cloud Firestore** | Cloud database for data sync |
| **permission_handler** | Runtime permissions management |
| **intl** | Date/time formatting |

## 📦 Project Structure

```
lib/
├── main.dart                        # App entry point with Firebase init
├── models/
│   └── checkin_record.dart          # Data models (CheckInRecord, CheckOutRecord)
├── db/
│   └── database_helper.dart         # SQLite database operations
├── services/
│   └── firestore_service.dart       # Firebase Firestore sync operations
└── screens/
    ├── home_screen.dart             # Landing page with navigation
    ├── checkin_screen.dart          # Check-in flow implementation
    └── finish_class_screen.dart     # Finish class flow implementation
```

## 🚀 Setup Instructions

### Prerequisites

- Flutter SDK 3.x or later
- Dart SDK 3.11.1 or later
- Android Studio / Xcode (for mobile development)
- Git
- Firebase account (optional, for cloud features)

### Installation Steps

1. **Clone the repository**:
   ```bash
   git clone <your-github-repo-url>
   cd Smart_class_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify installation**:
   ```bash
   flutter doctor
   ```

4. **(Optional) Configure Firebase**:

   The app works without Firebase using SQLite-only mode. To enable cloud sync:

   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli

   # Configure Firebase
   flutterfire configure
   ```

   See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed Firebase configuration instructions.

## ▶️ How to Run the App

### Run on Android Emulator or Device

```bash
flutter run
```

### Run on iOS Simulator (macOS only)

```bash
flutter run -d ios
```

### Run on Web (for testing)

```bash
flutter run -d chrome
```

### Build Release APK (Android)

```bash
flutter build apk --release
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

## 🔧 Configuration Notes

### Permissions

The app requires the following permissions:

**Android** (`android/app/src/main/AndroidManifest.xml`):
- `ACCESS_FINE_LOCATION` - GPS location
- `ACCESS_COARSE_LOCATION` - GPS location fallback
- `CAMERA` - QR code scanning

**iOS** (`ios/Runner/Info.plist` - needs manual addition):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs your location to verify classroom check-in.</string>
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes.</string>
```

### Firebase Configuration

- App works in **offline-first** mode — Firebase is optional
- If Firebase is not configured, the app will gracefully fall back to SQLite-only mode
- See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for Firebase setup instructions

#### Firebase Collections

When Firebase is configured, data syncs to:
- `check_ins` — Check-in records with pre-class reflections
- `check_outs` — Check-out records with post-class feedback

## 🗄 Database Schema

### SQLite Tables

**checkin**
| Column | Type | Description |
|---|---|---|
| id | INTEGER PRIMARY KEY | Auto-increment ID |
| studentId | TEXT | Student identifier |
| checkInTime | TEXT | ISO 8601 timestamp |
| gpsLat | REAL | Latitude |
| gpsLng | REAL | Longitude |
| qrCodeData | STRING | Scanned QR code value |
| previousTopic | TEXT | What was taught previously |
| expectedTopic | TEXT | What student expects to learn |
| moodBefore | INTEGER | Mood scale (1–5) |

**checkout**
| Column | Type | Description |
|---|---|---|
| id | INTEGER PRIMARY KEY | Auto-increment ID |
| studentId | TEXT | Student identifier |
| checkOutTime | TEXT | ISO 8601 timestamp |
| gpsLat | REAL | Latitude |
| gpsLng | REAL | Longitude |
| qrCodeData | STRING | Scanned QR code value |
| whatLearned | TEXT | Learning outcomes |
| feedback | TEXT | Feedback for instructor |

## 🧪 Testing

### Run Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

## 📱 Screenshots

*(Add screenshots after deployment)*

## 🐛 Troubleshooting

| Issue | Solution |
|---|---|
| **Camera not working** | Check camera permissions in device settings |
| **GPS not updating** | Use a real device; emulators have limited GPS simulation |
| **Firebase errors** | App falls back to SQLite-only mode; see FIREBASE_SETUP.md |
| **Build fails** | Run `flutter clean && flutter pub get` |

## 📄 License

This project was developed for academic purposes as part of the Mobile Application Development course (1305216).

## 👥 Contributors

- Developed with assistance from AI tools (Claude Code)
- See [AI_USAGE_REPORT.md](AI_USAGE_REPORT.md) for details on AI contributions

## 📞 Support

For questions or issues, please open an issue in the GitHub repository.

---

**Developed for:** 1305216 Mobile Application Development — Midterm Lab Exam
**Date:** March 13, 2026
