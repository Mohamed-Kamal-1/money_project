# Firestore Security Rules

Copy these rules to your Firebase Console (Firestore Database → Rules) to ensure user data isolation.

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // User-specific expenses collection
    // Each user can only read/write their own expenses
    match/users/{userId}/expenses/{expenseId} {
      // Allow read and write only if the authenticated user matches the userId
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Optional: User profile document (if you want to store user data)
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Deny all other access by default
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

## How to Apply

1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Firestore Database** → **Rules**
4. Replace the existing rules with the above
5. Click **Publish**

## What These Rules Do

- ✅ Users can only access expenses under `users/{their-uid}/expenses/`
- ✅ Users cannot see or modify other users' data
- ❌ Unauthenticated requests are denied
- ❌ Access to other collections is blocked

## Testing

Test in Firebase Console → Firestore Database → Rules Playground:
- Authenticated as user A → CAN access `/users/A/expenses/doc1`
- Authenticated as user A → CANNOT access `/users/B/expenses/doc1`
- Unauthenticated → CANNOT access any user data
