# AI Usage Report

**Course:** 1305216 Mobile Application Development
**Project:** Smart Class Check-in & Learning Reflection App
**Date:** March 13, 2026
**AI Tool:** Claude Code (Claude Sonnet 4.6)

---

## Summary

AI was used as the primary development assistant throughout this project. It helped generate code, structure the architecture, and write documentation based on my requirements and decisions.

**Overall AI contribution: ~90% | My contribution: ~10%**

---

## What AI Generated

| Area | AI % | Notes |
|------|------|-------|
| PRD & Documentation | 95% | PRD.md, README.md, Firebase setup guide |
| App Architecture | 90% | Folder structure, routing, state management |
| UI Screens | 90% | HomeScreen, CheckInScreen, FinishClassScreen |
| GPS Integration | 90% | Permission handling, location capture |
| QR Scanner | 90% | `mobile_scanner` integration, scan overlay |
| SQLite Database | 95% | Schema, CRUD operations, singleton pattern |
| Firebase Firestore | 95% | Sync service, error handling, offline fallback |
| Firebase Auth | 90% | Login screen, auth state stream, session management |
| Android Permissions | 100% | Camera, location in AndroidManifest.xml |
| Git Setup | 90% | `.gitignore`, initial commits |

---

## What I Did

- Interpreted exam requirements and chose the full-score implementation path (Firebase + SQLite)
- Decided on the tech stack (Flutter, Firestore, geolocator, mobile_scanner)
- Reviewed all generated code for correctness and understanding
- Configured the Firebase project and connected it to the app
- Fixed dependency version conflicts in `pubspec.yaml`
- Pushed the repository to GitHub

---

## My Understanding

I can explain:
- Why the app uses **both SQLite and Firestore** (offline-first design)
- How **GPS + QR code** provides two-factor attendance verification
- Flutter's **StatefulWidget lifecycle** and `setState()` pattern
- How **Firebase Auth** manages login state via `authStateChanges()` stream
- Dart **async/await**, null safety, and singleton patterns
- Why **try-catch** wraps all Firebase calls (graceful degradation)

---

**Prepared by:** [Nithikorn Suttanu]
**Date:** March 13, 2026
