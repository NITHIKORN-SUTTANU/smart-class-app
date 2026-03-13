# Firebase Hosting Deployment Guide

## Prerequisites

1. **Firebase CLI installed**:
   ```bash
   npm install -g firebase-tools
   ```

2. **Firebase Project**: Have a Firebase project created at [Firebase Console](https://console.firebase.google.com/)

---

## Deployment Steps

### 1. Login to Firebase

```bash
firebase login
```

This will open a browser window for authentication.

### 2. Initialize Firebase Hosting (if not done)

```bash
cd C:/Users/LAB/Desktop/Smart_class_app
firebase init hosting
```

**Configuration prompts:**
- What do you want to use as your public directory? → `build/web`
- Configure as a single-page app? → `Yes`
- Set up automatic builds with GitHub? → `No` (optional)
- File build/web/index.html already exists. Overwrite? → `No`

### 3. Build Flutter Web (already done)

```bash
flutter build web --release
```

Output: `build/web/` directory with compiled web app

### 4. Deploy to Firebase Hosting

```bash
firebase deploy --only hosting
```

**Expected output:**
```
=== Deploying to 'your-project-id'...

i  deploying hosting
i  hosting[your-project-id]: beginning deploy...
i  hosting[your-project-id]: found X files in build/web
✔  hosting[your-project-id]: file upload complete
i  hosting[your-project-id]: finalizing version...
✔  hosting[your-project-id]: version finalized
i  hosting[your-project-id]: releasing new version...
✔  hosting[your-project-id]: release complete

✔  Deploy complete!

Project Console: https://console.firebase.google.com/project/your-project-id/overview
Hosting URL: https://your-project-id.web.app
```

### 5. Save Your Deployment URL

Your app is live at: `https://your-project-id.web.app`

---

## Quick Deploy Command

After initial setup, one-command deployment:

```bash
flutter build web --release && firebase deploy --only hosting
```

---

## Troubleshooting

| Issue | Solution |
|---|---|
| **"firebase command not found"** | Install Firebase CLI: `npm install -g firebase-tools` |
| **"No project active"** | Run `firebase init` to select project |
| **"Permission denied"** | Run `firebase login` again |
| **Build errors** | Run `flutter clean && flutter pub get` |
| **Camera/GPS not working on web** | Web has limited device access; use mobile build for full features |

---

## Web Limitations

The web version has these limitations compared to mobile:

❌ **QR Scanner** - Web browsers have limited camera API access
❌ **GPS** - Web geolocation is less accurate and requires HTTPS
❌ **SQLite** - Web uses IndexedDB instead of SQLite

**Recommendation:** Deploy web version as a demo/landing page, but use Android/iOS builds for production.

---

## Redeployment

To update your deployed site:

```bash
# Make code changes
git add .
git commit -m "Update message"

# Rebuild and redeploy
flutter build web --release
firebase deploy --only hosting
```

---

## Firebase Hosting Features

- **Free SSL certificate** (HTTPS automatically enabled)
- **Global CDN** for fast loading worldwide
- **Automatic rollbacks** if deployment fails
- **Custom domain** support (optional)

---

**Deployment Time:** ~2-3 minutes from build to live URL

**Exam Requirement:** ✅ Accessible URL required for submission
