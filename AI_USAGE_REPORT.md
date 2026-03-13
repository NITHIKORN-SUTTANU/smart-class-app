# AI Usage Report

**Course:** 1305216 Mobile Application Development
**Project:** Smart Class Check-in & Learning Reflection App
**Date:** March 13, 2026

---

## AI Tools Used

- **Claude Code (Claude Opus 4.6)** — Primary development assistant
- Used for code generation, architecture design, and documentation

---

## What AI Helped Generate

### 1. Product Requirement Document (PRD.md)
**AI Contribution:** 95%
- Generated complete PRD structure with problem statement, user flows, data fields, and tech stack
- Defined clear feature specifications from ambiguous exam requirements
- Created data model tables with typed fields

**My Contribution:**
- Reviewed and approved the PRD
- Verified alignment with exam requirements

---

### 2. Flutter Application Architecture
**AI Contribution:** 90%
- Generated complete folder structure (models/, db/, services/, screens/)
- Created three main screens with Material Design UI components
- Implemented navigation flow between HomeScreen → CheckInScreen/FinishClassScreen
- Built reusable UI components (_ActionCard, _SectionCard, _QRScannerPage)

**My Contribution:**
- Reviewed code structure for clarity
- Understood the widget hierarchy and state management approach
- Can explain how MaterialApp, Scaffold, and navigation Stack work

---

### 3. GPS Location Integration
**AI Contribution:** 90%
- Integrated `geolocator` package with permission handling
- Implemented LocationPermission checks (denied, deniedForever)
- Created LocationSettings with high accuracy configuration
- Added error handling with user-friendly SnackBar messages

**My Contribution:**
- Understand GPS permission flow on Android/iOS
- Know why high accuracy LocationAccuracy is needed for classroom verification
- Can explain why emulators have limited GPS capabilities

---

### 4. QR Code Scanner
**AI Contribution:** 90%
- Integrated `mobile_scanner` package
- Created dedicated _QRScanner Page with MobileScanner widget
- Implemented barcode detection with onDetect callback
- Added duplicate scan prevention with `_detected` flag

**My Contribution:**
- Understand barcode?.rawValue extraction
- Can explain why Navigator.pop returns the scanned QR value
- Know that camera permissions are required

---

### 5. Form Input & Validation
**AI Contribution:** 85%
- Created TextEditingController for each input field
- Implemented Form widget with GlobalKey<FormState>
- Added validator functions with null/empty checks
- Built mood slider with emoji labels (1–5 scale)

**My Contribution:**
- Modified mood emoji labels to match exam requirements
- Understand validator logic (returns error string or null)
- Can explain why TextEditingController.dispose() is needed

---

### 6. SQLite Database (database_helper.dart)
**AI Contribution:** 95%
- Created DatabaseHelper singleton pattern
- Implemented SQLite table schema with CREATE TABLE statements
- Built CRUD operations (insertCheckIn, insertCheckOut, getAllCheckIns, getAllCheckOuts)
- Used ConflictAlgorithm.replace for upsert behavior

**My Contribution:**
- Reviewed database schema matches PRD data model
- Understand singleton pattern (_internal constructor)
- Can explain why we use Future<Database> for async operations

---

### 7. Firebase Firestore Integration
**AI Contribution:** 95%
- Created FirestoreService with singleton pattern
- Implemented syncCheckIn and syncCheckOut methods
- Added graceful error handling (debugPrint, doesn't crash app)
- Used FieldValue.serverTimestamp() for sync tracking

**My Contribution:**
- Understand why Firebase sync is wrapped in try-catch (offline resilience)
- Modified Firestore initialization in main.dart to understand Firebase.initializeApp()
- Can explain why app works without Firebase (offline-first design)

---

### 8. Android Permissions (AndroidManifest.xml)
**AI Contribution:** 100%
- Added ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION, CAMERA permissions

**My Contribution:**
- Understand why these permissions are required
- Know that users must grant these at runtime on Android 6.0+

---

### 9. Firebase Setup Guide (FIREBASE_SETUP.md)
**AI Contribution:** 95%
- Generated complete setup instructions for FlutterFire CLI
- Provided manual setup steps for Android/iOS/Web
- Included Firestore security rules example
- Added troubleshooting section

**My Contribution:**
- Reviewed accuracy of setup steps
- Can execute these steps independently

---

### 10. README.md
**AI Contribution:** 95%
- Generated comprehensive project documentation
- Created installation instructions, setup steps, and run commands
- Built database schema tables and troubleshooting guide
- Added project structure diagram

**My Contribution:**
- Verified all commands are correct
- Understand the project structure
- Can explain each section to an instructor

---

### 11. Git Repository Setup
**AI Contribution:** 90%
- Initialized git repository
- Updated .gitignore to exclude Firebase config files and build artifacts
- Created initial commit with detailed commit message

**My Contribution:**
- Understand .gitignore patterns
- Can push to GitHub repository independently
- Know why Firebase config files should not be committed

---

## What I Implemented/Modified Myself

1. **Requirements Analysis**: Interpreted the exam requirements and chose Option B (full score path with Firebase)
2. **Technology Decisions**: Approved the tech stack (Flutter, SQLite, Firebase Firestore, geolocator, mobile_scanner)
3. **Code Review**: Reviewed all generated code for correctness and understanding
4. **Error Analysis**: Analyzed and fixed dependency version conflicts in pubspec.yaml
5. **Testing Plan**: Understand how to test GPS, QR scanner, and form validation
6. **Firebase Configuration**: Will configure Firebase project using FlutterFire CLI or manual setup
7. **GitHub Repository**: Will create GitHub repository and push code
8. **Deployment**: Will build Flutter Web and deploy to Firebase Hosting

---

## Code Understanding Assessment

I can explain the following concepts implemented in this project:

### Flutter Concepts
- StatefulWidget vs StatelessWidget lifecycle
- BuildContext and widget tree
- Navigator.push/pop for screen navigation
- Form validation with GlobalKey<FormState>
- TextEditingController and disposing resources
- Material Design components (Scaffold, AppBar, Card, ElevatedButton)

### Dart Concepts
- async/await for asynchronous operations
- Future<T> return types
- Null safety (?, !, ??)
- Factory constructors (CheckInRecord.fromMap)
- Singleton pattern (DatabaseHelper.instance)

### Architecture Concepts
- Separation of concerns (models, db, services, screens)
- Offline-first design with local SQLite + cloud sync
- Graceful degradation (app works without Firebase)
- Error handling with try-catch and user feedback

### Database Concepts
- SQL table creation with typed columns
- Primary keys with AUTOINCREMENT
- CRUD operations (Create, Read)
- ConflictAlgorithm for upsert logic

### Firebase Concepts
- Firebase.initializeApp() lifecycle
- Firestore collections and documents
- FieldValue.serverTimestamp() for server-side timestamps
- Graceful offline handling

---

## Honest Assessment

**AI Contribution:** ~90% of code generation
**My Contribution:** ~10% of decision-making, review, and understanding

**What this means:**
- AI generated most of the boilerplate and implementation code
- I made architectural decisions and requirement interpretations
- I reviewed and understand all generated code
- I can explain the system design and implementation choices
- I can debug issues and make modifications independently

---

## Instructor Verification Questions I Can Answer

1. **Why use SQLite + Firestore instead of just Firestore?**
   - Offline-first architecture ensures app works without internet
   - SQLite provides instant local persistence
   - Firestore sync happens in background without blocking UI

2. **How does GPS verification confirm classroom presence?**
   - Geolocator captures lat/lng coordinates at check-in
   - Instructor can verify coordinates match classroom location
   - Both check-in and check-out GPS data prevent early departure

3. **Why is QR code scanning needed in addition to GPS?**
   - GPS can be spoofed or inaccurate indoors
   - QR code requires physical presence to scan instructor's display
   - Provides two-factor verification of attendance

4. **How does the mood slider work?**
   - Slider widget with min=1, max=5, divisions=4
   - setState() updates UI when slider value changes
   - Value stored as int (1–5) in moodBefore field

5. **What happens if Firebase is not configured?**
   - App catches Firebase.initializeApp() exception in main.dart
   - FirestoreService methods catch exceptions and debugPrint them
   - App continues with SQLite-only mode
   - No data loss — everything saved locally

---

**Conclusion:**
AI tools significantly accelerated development, but I understand the system architecture, can explain all implementation choices, and can maintain/extend this codebase independently.

---

**Prepared by:** [Student Name]
**Date:** March 13, 2026
**AI Assistant:** Claude Code (Claude Opus 4.6)
