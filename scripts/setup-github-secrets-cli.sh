#!/bin/bash

# 🔐 GitHub Secrets Setup using GitHub CLI
# This script sets up secrets using 'gh' command if available

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔐 GitHub Secrets Setup using GitHub CLI${NC}"
echo "=========================================="

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI (gh) is not installed${NC}"
    echo ""
    echo -e "${YELLOW}📋 Manual Setup Required:${NC}"
    echo "1. Go to: https://github.com/hetpatel63/BudgetWise/settings/secrets/actions"
    echo "2. Use the values from COPY_PASTE_SECRETS.txt"
    echo ""
    echo -e "${BLUE}💡 To install GitHub CLI:${NC}"
    echo "• macOS: brew install gh"
    echo "• Ubuntu: sudo apt install gh"
    echo "• Windows: winget install GitHub.cli"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${RED}❌ Not authenticated with GitHub CLI${NC}"
    echo ""
    echo -e "${YELLOW}🔑 Please authenticate first:${NC}"
    echo "gh auth login"
    exit 1
fi

echo -e "${GREEN}✅ GitHub CLI is installed and authenticated${NC}"
echo ""

# Read keystore base64 content
if [ ! -f "keystore-base64.txt" ]; then
    echo -e "${RED}❌ keystore-base64.txt not found${NC}"
    echo "Please run this script from the project root directory."
    exit 1
fi

SIGNING_KEY=$(cat keystore-base64.txt)

echo -e "${YELLOW}🔧 Setting up GitHub secrets...${NC}"
echo ""

# Set secrets using GitHub CLI
echo "Setting SIGNING_KEY..."
echo "$SIGNING_KEY" | gh secret set SIGNING_KEY

echo "Setting ALIAS..."
echo "budgetwise-key" | gh secret set ALIAS

echo "Setting KEY_STORE_PASSWORD..."
echo "budgetwise2024" | gh secret set KEY_STORE_PASSWORD

echo "Setting KEY_PASSWORD..."
echo "budgetwise2024" | gh secret set KEY_PASSWORD

echo ""
echo -e "${GREEN}🎉 All secrets have been set successfully!${NC}"
echo ""

# Verify secrets
echo -e "${BLUE}📋 Verifying secrets...${NC}"
gh secret list

echo ""
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo "==================="
echo -e "${BLUE}🚀 Next steps:${NC}"
echo "1. Create a release tag: git tag v1.0.0 && git push origin v1.0.0"
echo "2. Watch GitHub Actions build your signed APK"
echo "3. Download from releases: https://github.com/hetpatel63/BudgetWise/releases"
echo ""
echo -e "${GREEN}🎊 Your automated APK building is now ready!${NC}"