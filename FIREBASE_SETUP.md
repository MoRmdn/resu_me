# Firebase Setup Instructions

This project now uses Firebase Firestore to store contact form submissions. Follow these steps to set up Firebase for your project:

## 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter your project name (e.g., "resume-portfolio")
4. Enable Google Analytics (optional)
5. Click "Create project"

## 2. Enable Firestore Database

1. In your Firebase project, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location for your database
5. Click "Done"

## 3. Configure Firestore Security Rules

Update your Firestore security rules to allow contact form submissions:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow anyone to write to contact_submissions collection
    match /contact_submissions/{document} {
      allow write: if true;
      allow read: if false; // Only allow writes, not reads for security
    }
  }
}
```

## 4. Get Firebase Configuration

### For Web:
1. Go to Project Settings > General
2. Scroll down to "Your apps" section
3. Click the web icon (`</>`) to add a web app
4. Register your app with a nickname
5. Copy the Firebase configuration object

### For Android:
1. Click the Android icon to add an Android app
2. Enter your package name (check `android/app/build.gradle.kts`)
3. Download `google-services.json` and place it in `android/app/`

### For iOS:
1. Click the iOS icon to add an iOS app
2. Enter your bundle ID (check `ios/Runner/Info.plist`)
3. Download `GoogleService-Info.plist` and add it to your iOS project

## 5. Update Firebase Configuration

Replace the placeholder values in `firebase_options.dart` with your actual Firebase configuration:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-actual-web-api-key',
  appId: 'your-actual-web-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'your-actual-project-id',
  authDomain: 'your-actual-project-id.firebaseapp.com',
  storageBucket: 'your-actual-project-id.appspot.com',
);
```

## 6. Test the Integration

1. Run your Flutter app: `flutter run`
2. Navigate to the contact form
3. Fill out and submit the form
4. Check your Firestore database to see the submission

## 7. Optional: Set up Admin Dashboard

You can create a simple admin dashboard to view contact submissions by using the `FirestoreService.getContactSubmissions()` method.

## Troubleshooting

- Make sure your Firebase project has Firestore enabled
- Verify that your security rules allow writes to the `contact_submissions` collection
- Check that your Firebase configuration is correct in `firebase_options.dart`
- Ensure you have the latest Firebase dependencies installed (`flutter pub get`)

## Security Considerations

- The current setup allows anyone to write to the database (suitable for contact forms)
- Consider implementing rate limiting or CAPTCHA for production use
- Monitor your Firestore usage to avoid unexpected costs
- Consider implementing email notifications for new submissions
