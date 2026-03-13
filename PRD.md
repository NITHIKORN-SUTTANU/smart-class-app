# Product Requirement Document (PRD)

**Project:** Smart Class Check-in & Learning Reflection App
**Course:** 1305216 Mobile Application Development
**Date:** 2026-03-13
**Version:** 1.0

---

## 1. Problem Statement

Universities currently have no reliable way to confirm that students are **physically present** in a classroom and **actively engaged** in the learning session. Traditional paper-based attendance is slow, easy to falsify, and provides no data on student experience. This app solves both problems by combining GPS verification, QR code scanning, and structured learning reflection into a single mobile workflow.

---

## 2. Target Users

| User | Description |
|------|-------------|
| **Student** | Checks in before class, reflects on learning after class |
| **Instructor** | Generates QR codes for each session; reviews attendance and reflection data |

---

## 3. Feature List

### Core Features (MVP)
- **Check-in** — Student presses Check-in; system captures GPS location and timestamp automatically
- **QR Code Scan** — Student scans the session QR code displayed by the instructor to verify classroom presence
- **Pre-class Reflection Form** — Student submits: previous topic recap, expected topic for today, and mood (1–5)
- **Finish Class** — Student presses Finish Class; system captures GPS and timestamp again
- **Post-class Reflection Form** — Student submits: what they learned today, and feedback for instructor
- **Data Persistence** — All check-in and check-out records are saved locally (SQLite) and synced to Firebase Firestore

---

## 4. User Flow

### Check-in Flow (Before Class)
```
Home Screen
  └─► Press "Check-in"
        └─► GPS + Timestamp captured automatically
              └─► Scan QR Code (instructor's session code)
                    └─► Fill Pre-class Form:
                          · Previous class topic (text)
                          · Expected topic today (text)
                          · Mood before class (1–5 emoji scale)
                              └─► Submit → Save to DB → Return to Home
```

### Finish Class Flow (After Class)
```
Home Screen
  └─► Press "Finish Class"
        └─► Scan QR Code (same or end-of-session code)
              └─► GPS + Timestamp captured automatically
                    └─► Fill Post-class Form:
                          · What I learned today (text)
                          · Feedback for class/instructor (text)
                              └─► Submit → Save to DB → Return to Home
```

---

## 5. Data Fields

### Check-in Record
| Field | Type | Description |
|-------|------|-------------|
| `studentId` | String | Device-generated or entered student ID |
| `checkInTime` | DateTime | Timestamp when check-in was submitted |
| `gpsLat` | double | Latitude at time of check-in |
| `gpsLng` | double | Longitude at time of check-in |
| `qrCodeData` | String | Decoded value from scanned QR code |
| `previousTopic` | String | What was taught in the previous class |
| `expectedTopic` | String | What the student expects to learn today |
| `moodBefore` | int (1–5) | Student mood before class |

### Check-out Record
| Field | Type | Description |
|-------|------|-------------|
| `studentId` | String | Matched to the check-in record |
| `checkOutTime` | DateTime | Timestamp when finish class was submitted |
| `gpsLat` | double | Latitude at time of check-out |
| `gpsLng` | double | Longitude at time of check-out |
| `qrCodeData` | String | Decoded value from end-of-session QR code |
| `whatLearned` | String | What the student learned in this session |
| `feedback` | String | Student feedback about the class or instructor |

---

## 6. Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Mobile Framework** | Flutter (Dart) | Cross-platform mobile app (iOS & Android) |
| **GPS** | `geolocator` package | Retrieve device latitude/longitude |
| **QR Code Scanner** | `mobile_scanner` package | Scan QR codes via device camera |
| **Local Storage** | `sqflite` (SQLite) | Offline-first data persistence |
| **Cloud Database** | Firebase Firestore | Cloud sync of check-in/check-out records |
| **Deployment** | Firebase Hosting | Host Flutter Web build as a demo/landing page |
| **Version Control** | GitHub | Source code repository |

---

## 7. Constraints & Assumptions

- Students must grant **camera** and **location** permissions for the app to function
- A valid **internet connection** is required for Firebase sync; local SQLite ensures offline resilience
- The instructor is responsible for displaying the QR code; this app does not generate QR codes (out of scope for MVP)
- Student identity is based on a self-entered student ID (no authentication server required for MVP)

---

## 8. Out of Scope (MVP)

- Instructor dashboard / admin panel
- QR code generation
- Push notifications
- Biometric verification
- Offline-to-online sync conflict resolution
