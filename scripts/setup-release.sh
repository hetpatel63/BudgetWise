#!/bin/bash

# 🚀 BudgetWise Release Setup Script
# This script helps you create a release and trigger the GitHub Actions workflow

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 BudgetWise Release Setup Script${NC}"
echo "=================================="

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: Not in a git repository${NC}"
    exit 1
fi

# Check if we have uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}⚠️  Warning: You have uncommitted changes${NC}"
    echo "Please commit your changes before creating a release."
    echo ""
    echo "Uncommitted files:"
    git status --porcelain
    echo ""
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Get current version from build.gradle
if [ -f "app/build.gradle" ]; then
    CURRENT_VERSION=$(grep -oP 'versionName\s+"\K[^"]+' app/build.gradle || echo "1.0.0")
    CURRENT_CODE=$(grep -oP 'versionCode\s+\K\d+' app/build.gradle || echo "1")
else
    echo -e "${RED}❌ Error: app/build.gradle not found${NC}"
    exit 1
fi

echo -e "${GREEN}📱 Current app version: ${CURRENT_VERSION} (${CURRENT_CODE})${NC}"
echo ""

# Ask for new version
echo "🏷️  Release Version Setup"
echo "========================"
read -p "Enter new version name (current: ${CURRENT_VERSION}): " NEW_VERSION
if [ -z "$NEW_VERSION" ]; then
    NEW_VERSION=$CURRENT_VERSION
fi

read -p "Enter new version code (current: ${CURRENT_CODE}): " NEW_CODE
if [ -z "$NEW_CODE" ]; then
    NEW_CODE=$((CURRENT_CODE + 1))
fi

echo ""
echo -e "${BLUE}📝 Release Information${NC}"
echo "======================"
read -p "Enter release title (default: BudgetWise v${NEW_VERSION}): " RELEASE_TITLE
if [ -z "$RELEASE_TITLE" ]; then
    RELEASE_TITLE="BudgetWise v${NEW_VERSION}"
fi

echo ""
echo "Enter release notes (press Ctrl+D when finished):"
RELEASE_NOTES=$(cat)

# Update version in build.gradle
echo ""
echo -e "${YELLOW}🔧 Updating version in build.gradle...${NC}"
sed -i.bak "s/versionName \".*\"/versionName \"${NEW_VERSION}\"/" app/build.gradle
sed -i.bak "s/versionCode .*/versionCode ${NEW_CODE}/" app/build.gradle

echo -e "${GREEN}✅ Updated version to ${NEW_VERSION} (${NEW_CODE})${NC}"

# Show changes
echo ""
echo -e "${BLUE}📋 Changes made:${NC}"
git diff app/build.gradle

# Ask for confirmation
echo ""
echo -e "${YELLOW}🤔 Ready to create release?${NC}"
echo "Version: ${NEW_VERSION}"
echo "Version Code: ${NEW_CODE}"
echo "Title: ${RELEASE_TITLE}"
echo ""
read -p "Continue with release creation? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🚫 Release cancelled. Reverting changes...${NC}"
    mv app/build.gradle.bak app/build.gradle
    exit 0
fi

# Commit version changes
echo ""
echo -e "${YELLOW}📝 Committing version changes...${NC}"
git add app/build.gradle
git commit -m "Bump version to ${NEW_VERSION} (${NEW_CODE})"

# Create and push tag
echo -e "${YELLOW}🏷️  Creating and pushing tag...${NC}"
git tag -a "v${NEW_VERSION}" -m "${RELEASE_TITLE}

${RELEASE_NOTES}"

git push origin main
git push origin "v${NEW_VERSION}"

# Clean up backup file
rm -f app/build.gradle.bak

echo ""
echo -e "${GREEN}🎉 Release created successfully!${NC}"
echo "=================================="
echo -e "${GREEN}✅ Version updated to ${NEW_VERSION} (${NEW_CODE})${NC}"
echo -e "${GREEN}✅ Changes committed and pushed${NC}"
echo -e "${GREEN}✅ Tag v${NEW_VERSION} created and pushed${NC}"
echo ""
echo -e "${BLUE}🔗 Next steps:${NC}"
echo "1. Check GitHub Actions: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^.]*\).*/\1/')/actions"
echo "2. Monitor the build progress"
echo "3. Once complete, check releases: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^.]*\).*/\1/')/releases"
echo ""
echo -e "${GREEN}🚀 Your APK will be automatically built and uploaded to releases!${NC}"