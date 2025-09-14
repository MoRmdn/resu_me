# GitHub Actions & Firebase Deployment Setup

This guide will help you set up automated CI/CD for your Flutter portfolio project using GitHub Actions and Firebase Hosting.

## 🚀 Quick Start

### 1. Enable GitHub Pages (Optional)

If you want to deploy to GitHub Pages instead of Firebase Hosting:

1. Go to your repository settings
2. Navigate to "Pages" section
3. Select "GitHub Actions" as the source
4. The workflow will automatically deploy to GitHub Pages

### 2. Firebase Hosting Setup

#### Step 1: Install Firebase CLI
```bash
npm install -g firebase-tools
```

#### Step 2: Login to Firebase
```bash
firebase login
```

#### Step 3: Initialize Firebase in your project
```bash
firebase init hosting
```

#### Step 4: Configure Firebase Hosting
- Select your Firebase project
- Set public directory to `build/web`
- Configure as single-page app: `Yes`
- Set up automatic builds: `No` (we'll use GitHub Actions)

#### Step 5: Deploy Firestore Rules
```bash
firebase deploy --only firestore:rules
```

### 3. GitHub Actions Setup

#### For GitHub Pages Deployment:
The `ci.yml` workflow is already configured and will work automatically.

#### For Firebase Hosting Deployment:

1. **Create a Firebase Service Account:**
   ```bash
   # In your Firebase project console
   # Go to Project Settings > Service Accounts
   # Click "Generate new private key"
   # Download the JSON file
   ```

2. **Add GitHub Secrets:**
   - Go to your GitHub repository
   - Navigate to Settings > Secrets and variables > Actions
   - Add these secrets:
     - `FIREBASE_SERVICE_ACCOUNT`: Paste the entire content of the downloaded JSON file
     - `GITHUB_TOKEN`: This is automatically provided by GitHub

3. **Update Firebase Project ID:**
   - Edit `.github/workflows/firebase-deploy.yml`
   - Replace `your-project-id` with your actual Firebase project ID

## 📁 File Structure

```
.github/
├── workflows/
│   ├── ci.yml              # Main CI/CD pipeline
│   └── firebase-deploy.yml # Firebase hosting deployment
firebase.json               # Firebase configuration
firestore.rules            # Firestore security rules
firestore.indexes.json     # Firestore indexes
```

## 🔧 Workflow Details

### CI Pipeline (`ci.yml`)
- **Triggers:** Push to main/develop, Pull requests
- **Jobs:**
  - Test: Runs tests, analysis, and formatting checks
  - Build Web: Builds the Flutter web app
  - Deploy: Deploys to GitHub Pages (if on main branch)

### Firebase Deploy (`firebase-deploy.yml`)
- **Triggers:** Push to main, Manual dispatch
- **Jobs:**
  - Build: Builds Flutter web app
  - Deploy: Deploys to Firebase Hosting

## 🛠️ Customization

### Environment Variables
You can customize the workflows by modifying:
- Flutter version in the workflows
- Build commands
- Deployment targets
- Environment-specific configurations

### Domain Configuration
To use a custom domain:
1. Update `firebase.json` with your domain
2. Configure DNS settings in Firebase Console
3. Update the `cname` field in `ci.yml` if using GitHub Pages

## 🔒 Security Considerations

### Firestore Rules
The current rules allow:
- ✅ Anyone to submit contact forms
- ❌ No one to read contact submissions (admin access required)

### GitHub Secrets
- Never commit service account keys to your repository
- Use GitHub Secrets for all sensitive information
- Regularly rotate service account keys

## 🐛 Troubleshooting

### Common Issues:

1. **Service Account Error:**
   ```
   Service account does not exist
   ```
   - Solution: Create a new service account in Firebase Console
   - Make sure the service account has the correct permissions

2. **Build Failures:**
   ```
   Flutter build web failed
   ```
   - Check Flutter version compatibility
   - Ensure all dependencies are properly installed
   - Check for any linting errors

3. **Deployment Failures:**
   ```
   Firebase deploy failed
   ```
   - Verify Firebase project ID is correct
   - Check service account permissions
   - Ensure Firebase CLI is properly authenticated

### Debug Steps:
1. Check GitHub Actions logs for detailed error messages
2. Test Firebase deployment locally: `firebase deploy --only hosting`
3. Verify Firestore rules: `firebase deploy --only firestore:rules`

## 📊 Monitoring

### GitHub Actions
- View workflow runs in the "Actions" tab
- Monitor build times and success rates
- Set up notifications for failed builds

### Firebase Console
- Monitor hosting deployments
- Check Firestore usage and performance
- Review security rules and indexes

## 🎯 Next Steps

1. **Set up monitoring:** Configure alerts for failed deployments
2. **Add testing:** Expand test coverage for better CI reliability
3. **Performance optimization:** Add Lighthouse CI for web performance monitoring
4. **Security scanning:** Add dependency vulnerability scanning

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Firebase Hosting Documentation](https://firebase.google.com/docs/hosting)
- [Flutter Web Deployment](https://flutter.dev/docs/deployment/web)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)

## 🔧 **Quick Fix:**

**Edit the `firestore.indexes.json` file** and replace its contents with:

```json
{
  "indexes": [],
  "fieldOverrides": []
}
```

## 📝 **Why This Happens:**

Firestore automatically creates single-field indexes for all fields, so you don't need to explicitly define an index for just the `timestamp` field. The error occurs because:

1. ✅ Firestore database was created successfully
2. ✅ Firestore rules compiled successfully  
3. ❌ The custom index is unnecessary (Firestore auto-creates single-field indexes)

## 🚀 **After Making the Change:**

1. **Update the file** with the empty indexes array
2. **Deploy again:**
   ```bash
   firebase deploy
   ```

## 🎯 **Alternative: Deploy Only What You Need**

If you want to deploy just the hosting for now:

```bash
firebase deploy --only hosting
```

This will deploy your Flutter web app without trying to deploy the Firestore configuration.

## 📚 **What This Means:**

- Your contact form will still work perfectly
- Firestore will automatically handle the `timestamp` field indexing
- You can add custom indexes later if you need complex queries
- The deployment will complete successfully

The main thing is that your Firestore database is now created and ready to receive contact form submissions!
