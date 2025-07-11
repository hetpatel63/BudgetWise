# 🚀 BudgetWise - Automated APK Building & Releases

This repository includes automated GitHub Actions workflows to build and release your BudgetWise Android app.

## 📱 Quick Start

### Option 1: Create a Release (Recommended)
```bash
# Create a version tag to trigger automatic release
git tag v1.0.0
git push origin v1.0.0
```

### Option 2: Use the Setup Script
```bash
# Run the interactive setup script
./scripts/setup-release.sh
```

### Option 3: Manual Workflow Trigger
1. Go to **Actions** tab in your GitHub repository
2. Select **"Build and Release Android APK"**
3. Click **"Run workflow"**
4. Fill in release details and run

## 📦 What You Get

When the workflow completes, you'll have:

- ✅ **Debug APK**: `BudgetWise-v1.0.0-debug.apk`
- ✅ **Release APK**: `BudgetWise-v1.0.0-release-signed.apk` (if signing configured)
- ✅ **GitHub Release**: Automatically created with release notes
- ✅ **Build Info**: Detailed build information file

## 🔧 Setup Requirements

### For Basic APK Building (No Setup Required)
- The workflow will build unsigned APKs automatically

### For Signed APK Releases (Recommended)
Add these secrets to your GitHub repository (**Settings** → **Secrets and variables** → **Actions**):

| Secret | Description |
|--------|-------------|
| `SIGNING_KEY` | Base64 encoded keystore file |
| `ALIAS` | Keystore alias name |
| `KEY_STORE_PASSWORD` | Keystore password |
| `KEY_PASSWORD` | Key password |

## 📋 Workflow Files

- **`.github/workflows/build-and-release.yml`** - Main release workflow
- **`.github/workflows/build-apk.yml`** - Simple build workflow
- **`scripts/setup-release.sh`** - Interactive release script

## 🎯 Features

### Automatic Release Workflow
- ✅ Builds both debug and release APKs
- ✅ Signs release APKs (if configured)
- ✅ Creates GitHub releases automatically
- ✅ Generates release notes from commits
- ✅ Uploads APK files to releases
- ✅ Includes build information

### Build Workflow
- ✅ Runs on every push to main/develop
- ✅ Creates APK artifacts
- ✅ Caches dependencies for faster builds

## 🔗 Links

- **Detailed Setup Guide**: [.github/WORKFLOW_SETUP.md](.github/WORKFLOW_SETUP.md)
- **GitHub Actions**: Check the Actions tab in your repository
- **Releases**: Check the Releases section for built APKs

## 🎉 Success!

Once set up, every time you create a version tag (like `v1.0.0`), the workflow will:

1. 🔨 Build your Android app
2. 📱 Create signed APK files
3. 📋 Generate release notes
4. 🚀 Upload everything to GitHub releases

**No manual APK building required!** 🎊