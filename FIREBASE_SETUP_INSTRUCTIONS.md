# Firebase Setup Instructions

This project uses Firebase for backend services. To set up Firebase for your own project:

## 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable the following services:
   - Realtime Database
   - Authentication (if needed)
   - Hosting (if deploying)

## 2. Configure Firebase for Flutter

### Android Setup

1. Copy `android/app/google-services.json.template` to `android/app/google-services.json`
2. Replace the placeholder values with your actual Firebase project values:
   - `YOUR_PROJECT_NUMBER`: Found in Firebase Console > Project Settings > General
   - `YOUR_PROJECT_ID`: Your Firebase project ID
   - `YOUR_REGION`: Your database region (e.g., `europe-west1`)
   - `YOUR_ANDROID_APP_ID`: Found in Firebase Console > Project Settings > General > Your apps
   - `YOUR_ANDROID_API_KEY`: Found in Firebase Console > Project Settings > General > Your apps

### iOS Setup

1. Copy `ios/Runner/GoogleService-Info.plist.template` to `ios/Runner/GoogleService-Info.plist`
2. Replace the placeholder values with your actual Firebase project values:
   - `YOUR_IOS_API_KEY`: Found in Firebase Console > Project Settings > General > Your apps
   - `YOUR_SENDER_ID`: Found in Firebase Console > Project Settings > General > Your apps
   - `YOUR_PROJECT_ID`: Your Firebase project ID
   - `YOUR_IOS_APP_ID`: Found in Firebase Console > Project Settings > General > Your apps
   - `YOUR_REGION`: Your database region (e.g., `europe-west1`)

### macOS Setup

1. Copy `macos/Runner/GoogleService-Info.plist.template` to `macos/Runner/GoogleService-Info.plist`
2. Replace the placeholder values with your actual Firebase project values (same as iOS)

## 3. Update Firebase Options

Update `lib/firebase_options.dart` with your actual Firebase configuration values.

## 4. Security Rules

Make sure to configure appropriate security rules for your Firebase services:

- **Realtime Database**: Set up rules in `database.rules.json`
- **Firestore**: Set up rules in `firestore.rules`

## 5. Environment Variables (Optional)

For additional security, you can use environment variables instead of hardcoding values in `firebase_options.dart`.

## Important Notes

- Never commit actual Firebase configuration files to version control
- The `.gitignore` file is configured to exclude these sensitive files
- Always use template files for public repositories
- Keep your Firebase project secure by following Firebase security best practices
