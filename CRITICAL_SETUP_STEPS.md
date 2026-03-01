# Critical Setup Steps - Expense Tracker

## Prerequisites

### System Requirements
- Flutter SDK: ^3.10.7
- Dart SDK: ^3.10
- Android SDK: API level 21+
- iOS: Minimum deployment target 11.0+
- macOS: Minimum deployment target 10.11+
- Windows: Windows 10+

### Dependencies Already Added
All required dependencies are configured in `pubspec.yaml`. Run:
```bash
flutter pub get
```

---

## 1. Firebase Project Configuration ⚠️ REQUIRED

### Step 1.1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Name: "Expense Tracker" (or your preference)
4. Enable Google Analytics (optional)
5. Create project

### Step 1.2: Set Up Firebase for Android
1. In Firebase console, click "Add app"
2. Select Android
3. Fill in:
   - Package name: `com.example.money` (from android/app/build.gradle)
   - App nickname: "Expense Tracker Android"
   - Debug signing certificate SHA-1: (optional for development)
4. Follow download instructions and place `google-services.json` in:
   ```
   android/app/google-services.json
   ```

### Step 1.3: Set Up Firebase for iOS
1. Click "Add app" again
2. Select iOS
3. Fill in:
   - Bundle ID: `com.example.money` (from ios/Runner/Info.plist → CFBundleIdentifier)
   - App nickname: "Expense Tracker iOS"
4. Download `GoogleService-Info.plist`
5. In Xcode:
   - Open `ios/Runner.xcworkspace`
   - Drag `GoogleService-Info.plist` into project
   - Ensure it's added to Runner target

### Step 1.4: Get Firebase Configuration for Web/Desktop
1. In Firebase console → Project Settings
2. Copy the config object:
```javascript
{
  "apiKey": "YOUR_API_KEY",
  "authDomain": "YOUR_PROJECT.firebaseapp.com",
  "projectId": "YOUR_PROJECT_ID",
  "storageBucket": "YOUR_PROJECT.appspot.com",
  "messagingSenderId": "YOUR_MESSAGING_SENDER_ID",
  "appId": "YOUR_APP_ID"
}
```

### Step 1.5: Update firebase_options.dart

**File**: `lib/firebase_options.dart`

Replace placeholder values:

```dart
class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY_HERE',
    appId: 'YOUR_APP_ID_HERE',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID_HERE',
    projectId: 'YOUR_PROJECT_ID_HERE',
    authDomain: 'YOUR_PROJECT.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID_HERE',
    projectId: 'YOUR_PROJECT_ID_HERE',
    storageBucket: 'YOUR_PROJECT.appspot.com',
  );

  // ... iOS, macOS, Windows configs
}
```

**Important**: Do NOT commit actual API keys to version control. Use environment variables or `.env` files for production.

---

## 2. Firestore Database Setup

### Step 2.1: Create Firestore Database
1. Firebase Console → Firestore Database
2. Click "Create database"
3. Select region closest to your users
4. Choose start mode: **Test mode** (for development only)
   - ⚠️ **WARNING**: Test mode allows all read/write operations
   - Change to **Production** before launching

### Step 2.2: Create Collections
Firestore will auto-create collections when you first add documents. Collections needed:
- `transactions`
- `categories`
- `settings`
- `reports`

### Step 2.3: Set Firestore Security Rules (For Production)

**DO NOT USE TEST MODE IN PRODUCTION**

Replace default rules in Firestore Console with:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users can only read/write their own data
    match /transactions/{document=**} {
      allow read, write: if request.auth.uid == resource.data.userId 
                         || request.auth.uid == request.resource.data.userId;
      allow create: if request.auth.uid == request.resource.data.userId;
      allow delete: if request.auth.uid == resource.data.userId;
    }
    
    match /categories/{document=**} {
      allow read, write: if request.auth.uid == resource.data.userId
                         || request.auth.uid == request.resource.data.userId;
      allow create: if request.auth.uid == request.resource.data.userId;
      allow delete: if request.auth.uid == resource.data.userId;
    }
    
    match /settings/{document=**} {
      allow read, write: if request.auth.uid == resource.data.userId
                         || request.auth.uid == request.resource.data.userId;
      allow create: if request.auth.uid == request.resource.data.userId;
    }
    
    match /reports/{document=**} {
      allow read: if request.auth.uid == resource.data.userId;
      allow write: if request.auth.uid == resource.data.userId;
    }
  }
}
```

### Step 2.4: Create Firestore Indexes (Optional but Recommended)

In Firebase Console → Firestore → Indexes, create:

1. **Collection**: transactions
   - Fields: `userId` (Ascending), `date` (Descending)

2. **Collection**: categories
   - Fields: `userId` (Ascending), `createdAt` (Descending)

3. **Collection**: reports
   - Fields: `userId` (Ascending), `month` (Ascending), `year` (Ascending)

---

## 3. Firebase Authentication Setup

### Step 3.1: Enable Authentication
1. Firebase Console → Authentication
2. Click "Get started"
3. Enable sign-in providers:
   - **Email/Password** (basic)
   - **Google** (recommended)
   - **Phone** (optional)

### Step 3.2: Implement Sign-In Screens
The app currently uses hardcoded `userId = 'test_user_123'`. Replace with:

**Files to update**:
- `lib/features/home/presentation/view/monthly_report_screen.dart` (line 24)
- `lib/features/home/presentation/view/analysis_screen.dart` (line 28)
- `lib/features/home/presentation/view/settings_screen.dart` (line 35)

**Replace**:
```dart
final String _userId = 'test_user_123';
```

**With**:
```dart
late String _userId;

@override
void initState() {
  super.initState();
  _userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
}
```

Or create an auth notifier to manage this globally.

### Step 3.3: Create Authentication Guard
Add a splash/auth screen that checks if user is logged in:

```dart
@override
Widget build(BuildContext context) {
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SplashScreen();
      }
      
      if (snapshot.hasData && snapshot.data != null) {
        return const HomeScreen();  // User logged in
      }
      
      return const AuthScreen();  // Show login
    },
  );
}
```

---

## 4. SharedPreferences Setup (Already Integrated)

SharedPreferences is used for local caching of:
- Dark mode preference
- Notifications enabled/disabled
- User app settings

**No additional setup** is required. The Settings Screen automatically saves/loads preferences.

---

## 5. Run Application

### Development Mode
```bash
# For Android
flutter run -d emulator-5554

# For iOS
flutter run -d "iPhone 14"

# For Web
flutter run -d web-server

# For Windows
flutter run -d windows
```

### Build Release
```bash
# Android APK
flutter build apk --release

# Android App Bundle (Google Play)
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

---

## 6. Testing Checklist

### Before Using:
- [ ] Firebase project created
- [ ] google-services.json placed in android/app/
- [ ] GoogleService-Info.plist added to iOS project
- [ ] firebase_options.dart updated with actual credentials
- [ ] Firestore database created (Test mode OK for development)
- [ ] Collections created (or auto-created on first write)
- [ ] `flutter pub get` executed successfully

### Functional Tests:
- [ ] App launches without Firebase initialization errors
- [ ] Can add a transaction → verify in Firestore
- [ ] Can add a category → visible in category dropdown
- [ ] Monthly report calculates correctly
- [ ] Dark mode toggle persists across restarts
- [ ] Sign out button clears SharedPreferences
- [ ] Analytics show real-time updates

---

## 7. Troubleshooting

### "Firebase not initialized" Error
```
Error: Database uninitialized
```
**Solution**: Ensure `Firebase.initializeApp()` is called in `main()` before `runApp()`.

---

### "Permission denied" on Firestore
```
Error: Missing or insufficient permissions
```
**Solutions**:
1. Check Firestore security rules allow operation
2. Verify user is authenticated (`FirebaseAuth.instance.currentUser` is not null)
3. Verify `userId` in data matches authenticated user's `uid`
4. If testing, switch to **Test mode** in Firestore (development only)

---

### "Google login not working"
**Solution**:
1. In Firebase Console → Authentication → Google provider
2. Copy OAuth 2.0 Client ID
3. Ensure client ID is registered in android/app/build.gradle:
```gradle
android {
  ...
  signingConfigs {
    googlePlayConfig {
      keyAlias = System.getenv("ANDROID_KEY_ALIAS")
      keyPassword = System.getenv("ANDROID_KEY_PASSWORD")
      storeFile = System.getenv("ANDROID_KEYSTORE_PATH")
      storePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD")
    }
  }
}
```

---

### "Collections not visible in Firestore"
**Solution**: Collections are auto-created on first document write. Run app, add a transaction, then check Firestore console.

---

### "Timestamps not parsing correctly"
**Solution**: Ensure all date operations use `Timestamp.fromDate()` for Firestore and `.toDate()` for local DateTime.

---

### "Settings not persisting"
**Solution**: Check that `SharedPreferences.getInstance()` succeeds. On some platforms, may require:
```bash
flutter clean
flutter pub get
flutter run
```

---

## 8. Environment Variables (Optional but Recommended)

Create `.env` file in project root:
```
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
FIREBASE_APP_ID=your-app-id
```

Then load in dart code:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

await dotenv.load();
final projectId = dotenv.env['FIREBASE_PROJECT_ID'];
```

---

## 9. Production Checklist

Before releasing to app stores:

- [ ] Firestore security rules configured (not test mode)
- [ ] Authentication properly implemented
- [ ] API keys restricted in Firebase Console
- [ ] Sensitive data not logged or exposed
- [ ] Error messages don't leak sensitive info
- [ ] Performance tested with real Firestore
- [ ] All TODO comments addressed
- [ ] User ID no longer hardcoded
- [ ] Proper error handling for all Firestore operations
- [ ] Offline capability handled gracefully
- [ ] Rate limiting considered for analytics queries

---

## 10. Deployment Guides

### Android (Google Play)
1. Create Google Play Developer account
2. Build signed APK: `flutter build apk --release`
3. Upload to Google Play Console
4. Configure release notes and pricing
5. Submit for review

### iOS (App Store)
1. Create Apple Developer account
2. Build for iOS: `flutter build ios --release`
3. Archive in Xcode: `Xcode → Product → Archive`
4. Submit via Transporter
5. Submit for App Review

### Web Deployment
```bash
flutter build web --release
# Deploy build/web/ to Firebase Hosting

firebase init hosting
firebase deploy
```

---

## Support Resources

- **Flutter Docs**: https://flutter.dev/docs
- **Firebase Docs**: https://firebase.google.com/docs
- **Cloud Firestore Reference**: https://firebase.google.com/docs/firestore
- **Firebase Authentication**: https://firebase.google.com/docs/auth

---

**Critical**: Do not proceed to production without completing Firebase setup and security rules configuration.

Last Updated: February 26, 2026
