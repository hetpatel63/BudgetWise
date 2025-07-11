# 🚀 GitHub Actions Workflow Setup Guide

This guide will help you set up automated APK building and releasing for your BudgetWise Android app.

## 📋 Prerequisites

1. **GitHub Repository**: Your code should be pushed to a GitHub repository
2. **Android Project**: Valid Android project with `build.gradle` files
3. **Repository Secrets**: Required for APK signing (optional but recommended)

## 🔧 Setup Instructions

### Step 1: Repository Secrets (For Signed APKs)

To create signed release APKs, you need to add these secrets to your GitHub repository:

1. Go to your GitHub repository
2. Click on **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** and add the following:

#### Required Secrets for APK Signing:

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `SIGNING_KEY` | Base64 encoded keystore file | See instructions below |
| `ALIAS` | Keystore alias name | Your keystore alias |
| `KEY_STORE_PASSWORD` | Keystore password | Your keystore password |
| `KEY_PASSWORD` | Key password | Your key password |

#### How to Generate Signing Key:

```bash
# 1. Generate a keystore (if you don't have one)
keytool -genkey -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias

# 2. Convert keystore to base64
base64 -i my-release-key.jks | tr -d '\n' | tee keystore.base64.txt

# 3. Copy the content of keystore.base64.txt to SIGNING_KEY secret
```

### Step 2: Workflow Files

The workflow files are already created in `.github/workflows/`:

1. **`build-and-release.yml`** - Builds and creates releases
2. **`build-apk.yml`** - Simple build for testing

### Step 3: Triggering Builds

#### Option A: Automatic Release (Recommended)

1. **Create a version tag**:
```bash
git tag v1.0.0
git push origin v1.0.0
```

2. **The workflow will automatically**:
   - Build debug and release APKs
   - Sign the release APK (if secrets are configured)
   - Create a GitHub release
   - Upload APKs to the release

#### Option B: Manual Release

1. Go to your GitHub repository
2. Click **Actions** tab
3. Select **Build and Release Android APK**
4. Click **Run workflow**
5. Fill in the release details:
   - **Release name**: e.g., `v1.0.0`
   - **Release notes**: Description of changes
6. Click **Run workflow**

#### Option C: Regular Build (No Release)

- Automatically triggers on push to `main` or `develop` branches
- Creates APK artifacts (available for 7 days)
- No release is created

## 📱 Workflow Features

### 🎯 What the Workflow Does:

1. **Environment Setup**:
   - ✅ Sets up JDK 17
   - ✅ Configures Android SDK (API 34)
   - ✅ Caches Gradle dependencies

2. **Build Process**:
   - ✅ Builds debug APK
   - ✅ Builds release APK
   - ✅ Signs release APK (if secrets configured)
   - ✅ Renames APKs with version numbers

3. **Release Creation**:
   - ✅ Creates GitHub release
   - ✅ Uploads APK files
   - ✅ Generates release notes
   - ✅ Includes build information

4. **Artifacts**:
   - ✅ Stores APKs as workflow artifacts
   - ✅ Includes build information file

### 📦 Generated Files:

- `BudgetWise-v1.0.0-debug.apk` - Debug version for testing
- `BudgetWise-v1.0.0-release-signed.apk` - Signed release version
- `BUILD_INFO.txt` - Build details and information

## 🔧 Customization Options

### Modify Version Information

Edit `app/build.gradle`:
```gradle
android {
    defaultConfig {
        versionCode 1
        versionName "1.0.0"
    }
}
```

### Change Trigger Conditions

Edit `.github/workflows/build-and-release.yml`:
```yaml
on:
  push:
    tags:
      - 'v*'  # Change this pattern
    branches:
      - 'release/*'  # Add branch triggers
```

### Customize Release Notes

The workflow automatically generates release notes, but you can customize the template in the workflow file.

## 🐛 Troubleshooting

### Common Issues:

#### 1. **Build Fails - SDK Not Found**
```
Solution: The workflow automatically sets up Android SDK
If issues persist, check the API level in the workflow matches your app's target SDK
```

#### 2. **Gradle Build Fails**
```
Solution: Ensure your project builds locally first
Check that all dependencies are properly declared in build.gradle
```

#### 3. **Signing Fails**
```
Solution: Verify all signing secrets are correctly set:
- SIGNING_KEY (base64 encoded keystore)
- ALIAS (keystore alias)
- KEY_STORE_PASSWORD (keystore password)
- KEY_PASSWORD (key password)
```

#### 4. **Release Creation Fails**
```
Solution: Ensure you have proper permissions
The GITHUB_TOKEN is automatically provided by GitHub Actions
```

### Debug Steps:

1. **Check workflow logs** in the Actions tab
2. **Verify secrets** are properly set
3. **Test local build** first: `./gradlew assembleDebug`
4. **Check permissions** on the repository

## 📊 Workflow Status

You can monitor your builds:

1. **Actions Tab**: See all workflow runs
2. **Releases Tab**: View created releases
3. **Artifacts**: Download APKs from workflow runs

## 🎉 Success Indicators

When everything works correctly, you'll see:

- ✅ Green checkmark on workflow runs
- 📱 APK files in the releases section
- 📦 Artifacts available for download
- 🔗 Release notes with build information

## 🚀 Next Steps

1. **Test the workflow** with a simple tag push
2. **Verify APK installation** on Android devices
3. **Set up branch protection** rules if needed
4. **Configure notifications** for build failures
5. **Add more workflow triggers** as needed

## 📞 Support

If you encounter issues:

1. Check the workflow logs in GitHub Actions
2. Verify all prerequisites are met
3. Test local builds first
4. Check GitHub Actions documentation for advanced configurations

---

**Happy Building! 🎉**