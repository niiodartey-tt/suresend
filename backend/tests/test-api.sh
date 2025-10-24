#!/bin/bash

# SureSend API Automated Test Script
# Tests all authentication endpoints

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base URL
BASE_URL="http://localhost:3000"

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Print header
echo -e "${BLUE}"
echo "========================================="
echo "  SureSend API Test Suite"
echo "========================================="
echo -e "${NC}"

# Function to print test result
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ PASS${NC}: $2"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC}: $2"
        ((TESTS_FAILED++))
    fi
}

# Function to extract JSON field
extract_field() {
    echo "$1" | grep -o "\"$2\"[^,}]*" | cut -d'"' -f4
}

# Test 1: Health Check
echo -e "\n${YELLOW}Test 1: Health Check${NC}"
response=$(curl -s "$BASE_URL/health")
status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Health check endpoint"
else
    print_result 1 "Health check endpoint"
    echo "Response: $response"
fi

# Test 2: API Base
echo -e "\n${YELLOW}Test 2: API Base Endpoint${NC}"
response=$(curl -s "$BASE_URL/api")
status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "API base endpoint"
else
    print_result 1 "API base endpoint"
fi

# Test 3: Register Buyer
echo -e "\n${YELLOW}Test 3: Register Buyer${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testbuyer123",
    "phoneNumber": "+233241111111",
    "password": "Test@1234",
    "fullName": "Test Buyer Script",
    "userType": "buyer",
    "email": "testbuyer123@example.com"
  }')

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "User registration (buyer)"
    echo -e "${BLUE}📝 Check your backend terminal for the OTP code!${NC}"
else
    print_result 1 "User registration (buyer)"
    echo "Response: $response"
fi

# Prompt for OTP
echo -e "\n${YELLOW}Enter the OTP code from backend terminal:${NC} "
read OTP_CODE

# Test 4: Verify Registration OTP
echo -e "\n${YELLOW}Test 4: Verify Registration OTP${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/auth/verify-otp" \
  -H "Content-Type: application/json" \
  -d "{
    \"phoneNumber\": \"+233241111111\",
    \"otpCode\": \"$OTP_CODE\",
    \"purpose\": \"registration\"
  }")

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "OTP verification (registration)"
    # Extract access token
    ACCESS_TOKEN=$(echo "$response" | grep -o '"accessToken":"[^"]*' | cut -d'"' -f4)
    echo -e "${BLUE}✓ Access token received${NC}"
else
    print_result 1 "OTP verification (registration)"
    echo "Response: $response"
fi

# Test 5: Get Profile (Protected)
echo -e "\n${YELLOW}Test 5: Get User Profile (Protected Route)${NC}"
response=$(curl -s -X GET "$BASE_URL/api/v1/users/profile" \
  -H "Authorization: Bearer $ACCESS_TOKEN")

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Get user profile (protected)"
else
    print_result 1 "Get user profile (protected)"
    echo "Response: $response"
fi

# Test 6: Update Profile
echo -e "\n${YELLOW}Test 6: Update User Profile${NC}"
response=$(curl -s -X PUT "$BASE_URL/api/v1/users/profile" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Test Buyer Updated",
    "email": "updated@example.com"
  }')

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Update user profile"
else
    print_result 1 "Update user profile"
    echo "Response: $response"
fi

# Test 7: Login
echo -e "\n${YELLOW}Test 7: Login with Credentials${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "identifier": "testbuyer123",
    "password": "Test@1234"
  }')

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Login with credentials"
    echo -e "${BLUE}📝 Check your backend terminal for the login OTP!${NC}"
else
    print_result 1 "Login with credentials"
    echo "Response: $response"
fi

# Prompt for login OTP
echo -e "\n${YELLOW}Enter the login OTP code:${NC} "
read LOGIN_OTP

# Test 8: Verify Login OTP
echo -e "\n${YELLOW}Test 8: Verify Login OTP${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/auth/verify-otp" \
  -H "Content-Type: application/json" \
  -d "{
    \"phoneNumber\": \"+233241111111\",
    \"otpCode\": \"$LOGIN_OTP\",
    \"purpose\": \"login\"
  }")

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "OTP verification (login)"
    NEW_ACCESS_TOKEN=$(echo "$response" | grep -o '"accessToken":"[^"]*' | cut -d'"' -f4)
else
    print_result 1 "OTP verification (login)"
    echo "Response: $response"
fi

# Test 9: Resend OTP
echo -e "\n${YELLOW}Test 9: Resend OTP${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/auth/resend-otp" \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "+233241111111",
    "purpose": "login"
  }')

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Resend OTP"
else
    print_result 1 "Resend OTP"
    echo "Response: $response"
fi

# Test 10: Register Seller
echo -e "\n${YELLOW}Test 10: Register Seller${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testseller123",
    "phoneNumber": "+233242222222",
    "password": "Seller@1234",
    "fullName": "Test Seller Script",
    "userType": "seller"
  }')

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "User registration (seller)"
else
    print_result 1 "User registration (seller)"
fi

# Test 11: Register Rider
echo -e "\n${YELLOW}Test 11: Register Rider${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testrider123",
    "phoneNumber": "+233243333333",
    "password": "Rider@1234",
    "fullName": "Test Rider Script",
    "userType": "rider"
  }')

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "User registration (rider)"
else
    print_result 1 "User registration (rider)"
fi

# Test 12: Invalid Credentials
echo -e "\n${YELLOW}Test 12: Invalid Credentials (Should Fail)${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "identifier": "testbuyer123",
    "password": "WrongPassword"
  }')

status=$(extract_field "$response" "status")
if [ "$status" == "error" ]; then
    print_result 0 "Invalid credentials rejected"
else
    print_result 1 "Invalid credentials should be rejected"
fi

# Test 13: Unauthorized Access
echo -e "\n${YELLOW}Test 13: Unauthorized Access (Should Fail)${NC}"
response=$(curl -s -X GET "$BASE_URL/api/v1/users/profile")
status=$(extract_field "$response" "status")
if [ "$status" == "error" ]; then
    print_result 0 "Unauthorized access blocked"
else
    print_result 1 "Unauthorized access should be blocked"
fi

# Test 14: Invalid Token
echo -e "\n${YELLOW}Test 14: Invalid Token (Should Fail)${NC}"
response=$(curl -s -X GET "$BASE_URL/api/v1/users/profile" \
  -H "Authorization: Bearer invalid_token")
status=$(extract_field "$response" "status")
if [ "$status" == "error" ]; then
    print_result 0 "Invalid token rejected"
else
    print_result 1 "Invalid token should be rejected"
fi

# Test 15: Logout
echo -e "\n${YELLOW}Test 15: Logout${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/auth/logout" \
  -H "Authorization: Bearer $NEW_ACCESS_TOKEN")
status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "User logout"
else
    print_result 1 "User logout"
fi

# Print summary
echo -e "\n${BLUE}"
echo "========================================="
echo "  Test Summary"
echo "========================================="
echo -e "${NC}"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"

TOTAL=$((TESTS_PASSED + TESTS_FAILED))
echo -e "Total: $TOTAL"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}✅ All tests passed! Stage 2 backend is working perfectly.${NC}\n"
    exit 0
else
    echo -e "\n${RED}❌ Some tests failed. Please review the errors above.${NC}\n"
    exit 1
fi
