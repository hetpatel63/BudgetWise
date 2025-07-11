#!/bin/bash

# 🔐 BudgetWise Keystore Secrets Setup Script
# This script helps you set up GitHub secrets for APK signing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔐 BudgetWise Keystore Secrets Setup${NC}"
echo "===================================="

# Check if keystore file exists
KEYSTORE_FILE="budgetwise-release-key.jks"
BASE64_FILE="keystore-base64.txt"

if [ ! -f "$KEYSTORE_FILE" ]; then
    echo -e "${RED}❌ Error: Keystore file '$KEYSTORE_FILE' not found${NC}"
    echo "Please run this script from the project root directory where the keystore file is located."
    exit 1
fi

if [ ! -f "$BASE64_FILE" ]; then
    echo -e "${YELLOW}⚠️  Base64 file not found. Generating...${NC}"
    base64 -i "$KEYSTORE_FILE" | tr -d '\n' > "$BASE64_FILE"
    echo -e "${GREEN}✅ Generated $BASE64_FILE${NC}"
fi

# Read the base64 content
BASE64_CONTENT=$(cat "$BASE64_FILE")

echo ""
echo -e "${GREEN}📋 GitHub Secrets Configuration${NC}"
echo "================================="
echo ""
echo -e "${PURPLE}To set up APK signing in GitHub Actions, add these secrets to your repository:${NC}"
echo ""
echo -e "${BLUE}🔗 Go to: https://github.com/YOUR_USERNAME/YOUR_REPO/settings/secrets/actions${NC}"
echo ""

echo -e "${YELLOW}📝 Add the following secrets:${NC}"
echo ""

echo -e "${GREEN}1. Secret Name: ${NC}SIGNING_KEY"
echo -e "${GREEN}   Value: ${NC}"
echo "   $BASE64_CONTENT"
echo ""

echo -e "${GREEN}2. Secret Name: ${NC}ALIAS"
echo -e "${GREEN}   Value: ${NC}budgetwise-key"
echo ""

echo -e "${GREEN}3. Secret Name: ${NC}KEY_STORE_PASSWORD"
echo -e "${GREEN}   Value: ${NC}budgetwise2024"
echo ""

echo -e "${GREEN}4. Secret Name: ${NC}KEY_PASSWORD"
echo -e "${GREEN}   Value: ${NC}budgetwise2024"
echo ""

echo -e "${PURPLE}📋 Copy-Paste Ready Format:${NC}"
echo "=========================="
echo ""
echo "Secret 1:"
echo "Name: SIGNING_KEY"
echo "Value: $BASE64_CONTENT"
echo ""
echo "Secret 2:"
echo "Name: ALIAS"
echo "Value: budgetwise-key"
echo ""
echo "Secret 3:"
echo "Name: KEY_STORE_PASSWORD"
echo "Value: budgetwise2024"
echo ""
echo "Secret 4:"
echo "Name: KEY_PASSWORD"
echo "Value: budgetwise2024"
echo ""

# Create a secrets file for easy copying
SECRETS_FILE="github-secrets.txt"
cat > "$SECRETS_FILE" << EOF
# GitHub Secrets for BudgetWise APK Signing
# Copy these values to your GitHub repository secrets

SIGNING_KEY=$BASE64_CONTENT

ALIAS=budgetwise-key

KEY_STORE_PASSWORD=budgetwise2024

KEY_PASSWORD=budgetwise2024

# Instructions:
# 1. Go to your GitHub repository
# 2. Navigate to Settings → Secrets and variables → Actions
# 3. Click "New repository secret" for each secret above
# 4. Copy the name and value exactly as shown
# 5. Save each secret

# Repository URL format:
# https://github.com/YOUR_USERNAME/YOUR_REPO/settings/secrets/actions
EOF

echo -e "${GREEN}✅ Secrets saved to: $SECRETS_FILE${NC}"
echo ""

echo -e "${BLUE}🚀 Next Steps:${NC}"
echo "=============="
echo "1. 📋 Copy the secrets from above (or from $SECRETS_FILE)"
echo "2. 🌐 Go to your GitHub repository settings"
echo "3. 🔐 Navigate to: Settings → Secrets and variables → Actions"
echo "4. ➕ Add each secret using 'New repository secret'"
echo "5. ✅ Test the workflow by creating a release tag"
echo ""

echo -e "${YELLOW}🔒 Security Reminders:${NC}"
echo "====================="
echo "• Never commit keystore files to version control"
echo "• Keep keystore passwords secure"
echo "• Backup your keystore file safely"
echo "• The base64 content is sensitive - treat it like a password"
echo ""

echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo "=================="
echo "Your keystore is ready for GitHub Actions APK signing."
echo ""

# Verify keystore
echo -e "${BLUE}🔍 Keystore Verification:${NC}"
keytool -list -v -keystore "$KEYSTORE_FILE" -storepass budgetwise2024 | head -20

echo ""
echo -e "${GREEN}✅ Keystore verified successfully!${NC}"