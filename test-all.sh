#!/bin/bash

# SureSend Complete Test Script
# Tests database, backend, and provides mobile testing instructions

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════╗"
echo "║   SureSend Complete Test Suite             ║"
echo "║   Stage 1 & Stage 2 Verification           ║"
echo "╚════════════════════════════════════════════╝"
echo -e "${NC}\n"

# Check if PostgreSQL is running
echo -e "${YELLOW}Checking PostgreSQL...${NC}"
if command -v systemctl &> /dev/null; then
    if systemctl is-active --quiet postgresql; then
        echo -e "${GREEN}✅ PostgreSQL is running${NC}"
    else
        echo -e "${RED}❌ PostgreSQL is not running${NC}"
        echo "Starting PostgreSQL..."
        sudo systemctl start postgresql
    fi
else
    echo -e "${BLUE}ℹ️  Cannot check PostgreSQL status (systemctl not available)${NC}"
    echo "Please ensure PostgreSQL is running manually"
fi

# Test 1: Database Verification
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  PART 1: Database Verification${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Running database verification...${NC}"
psql -U postgres -d suresend_db -f database/scripts/verify.sql

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✅ Database verification completed${NC}"
else
    echo -e "\n${RED}❌ Database verification failed${NC}"
    echo -e "${YELLOW}Run the setup script first:${NC}"
    echo "  cd database"
    echo "  psql -U postgres -f scripts/create_database.sql"
    echo "  psql -U postgres -d suresend_db -f scripts/setup.sql"
    exit 1
fi

# Test 2: Backend Health Check
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  PART 2: Backend Health Check${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Checking if backend is running...${NC}"
response=$(curl -s http://localhost:3000/health 2>/dev/null)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Backend is running${NC}"
    echo "Response: $response"

    # Run API tests
    echo -e "\n${YELLOW}Do you want to run the full API test suite? (y/n)${NC} "
    read -r run_tests

    if [ "$run_tests" == "y" ] || [ "$run_tests" == "Y" ]; then
        echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
        echo -e "${BLUE}  PART 3: API Endpoint Tests${NC}"
        echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

        bash backend/tests/test-api.sh
    fi
else
    echo -e "${RED}❌ Backend is not running${NC}"
    echo -e "\n${YELLOW}To start the backend:${NC}"
    echo "  cd backend"
    echo "  npm run dev"
    echo ""
    echo "Then run this script again."
fi

# Mobile Testing Instructions
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  PART 4: Mobile App Testing${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

echo -e "${CYAN}Mobile app testing should be done manually.${NC}"
echo -e "\nFollow these steps:\n"

echo "1. Ensure backend is running (http://localhost:3000)"
echo ""
echo "2. If using Android emulator, update the API URL:"
echo "   Edit: mobile/lib/config/app_config.dart"
echo "   Change: http://localhost:3000/api/v1"
echo "   To:     http://10.0.2.2:3000/api/v1"
echo ""
echo "3. Run the Flutter app:"
echo "   cd mobile"
echo "   flutter pub get"
echo "   flutter run"
echo ""
echo "4. Test the following:"
echo "   ✓ Registration flow (Buyer/Seller/Rider)"
echo "   ✓ OTP verification"
echo "   ✓ Login flow"
echo "   ✓ Dashboard navigation"
echo "   ✓ Logout"
echo ""

# Summary
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  Test Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

echo -e "For detailed testing instructions, see:"
echo -e "${CYAN}docs/TESTING_GUIDE.md${NC}\n"

echo -e "${GREEN}Testing complete!${NC}\n"
