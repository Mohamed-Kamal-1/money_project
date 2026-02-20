# Firebase Console Setup Guide

Complete these steps in the Firebase Console to enable Google Sign-In for your Money Manager app.

## Step 1: Enable Google Sign-In

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Authentication** → **Sign-in method**
4. Click on **Google**
5. Toggle **Enable**
6. Set a project support email
7. Click **Save**

## Step 2: Android Configuration

### Get SHA-1 Fingerprint

Run this command in your project directory:

```bash
cd android
./gradlew signingReport
```

Look for the **SHA-1** fingerprint under the `debug` variant (and `release` if deploying to production).

### Add to Firebase

1. In Firebase Console → **Project Settings** → **Your apps**
2. Select your Android app
3. Scroll to **SHA certificate fingerprints**
4. Click **Add fingerprint**
5. Paste the SHA-1 value
6. Download the updated `google-services.json`
7. Replace the file in `android/app/google-services.json`

### Verify android/build.gradle

Ensure you have:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
}
```

### Verify android/app/build.gradle

Ensure you have:
```gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
}
```

## Step 3: iOS Configuration (if applicable)

### Download GoogleService-Info.plist

1. Firebase Console → **Project Settings** → **Your apps**
2. Select iOS app (or add one if not exists)
3. Download `GoogleService-Info.plist`
4. Add to `ios/Runner/` in Xcode

### Add URL Scheme

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** → **Info** → **URL Types**
3. Add a new URL Type
4. **Identifier**: `com.googleusercontent.apps`
5. **URL Schemes**: Copy `REVERSED_CLIENT_ID` from `GoogleService-Info.plist`

## Step 4: Test

1. Run the app: `flutter run`
2. Tap **Sign in with Google**
3. Select your Google account
4. App should navigate to HomeTab
5. Verify expenses are saved to Firestore under `users/{your-uid}/expenses/`

## Troubleshooting

### "Sign-in failed" error
- Check SHA-1 fingerprint is correct
- Ensure Google Sign-In is enabled in Firebase Console
- Verify `google-services.json` is up to date

### "Network error"
- Check internet connection
- Ensure Firebase project has billing enabled (for external APIs)

### Expenses not showing
- Check Firestore security rules are published
- Verify user is authenticated (`getCurrentUser()` returns non-null)
- Check Firestore console for data under `users/{uid}/expenses/`
