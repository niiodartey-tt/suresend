#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# API Configuration
API_URL="${API_URL:-http://localhost:3000/api/v1}"
HEALTH_URL="${HEALTH_URL:-http://localhost:3000/health}"

# Test tracking
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Test data storage
BUYER_TOKEN=""
SELLER_TOKEN=""
RIDER_TOKEN=""
BUYER_ID=""
SELLER_ID=""
RIDER_ID=""
ESCROW_ID=""
TRANSACTION_ID=""

echo ""
echo "╔═══════════════════════════════════════════════╗"
echo "║   SureSend Stage 3 Backend Test Suite        ║"
echo "║   Escrow & Transaction Functionality          ║"
echo "╚═══════════════════════════════════════════════╝"
echo ""

# Helper function to print test results
print_test_result() {
    local test_name="$1"
    local result="$2"
    local details="$3"

    TOTAL_TESTS=$((TOTAL_TESTS + 1))

    if [ "$result" = "pass" ]; then
        echo -e "${GREEN}✅ PASS${NC}: $test_name"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}❌ FAIL${NC}: $test_name"
        if [ -n "$details" ]; then
            echo -e "${YELLOW}   Details: $details${NC}"
        fi
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# Helper function to make API calls with better error handling
api_call() {
    local method="$1"
    local endpoint="$2"
    local data="$3"
    local token="$4"

    local headers=(-H "Content-Type: application/json")

    if [ -n "$token" ]; then
        headers+=(-H "Authorization: Bearer $token")
    fi

    # Create temporary files
    local temp_response=$(mktemp)
    local temp_output=$(mktemp)

    if [ "$method" = "GET" ]; then
        curl -s -w "\n%{http_code}" -X GET "${API_URL}${endpoint}" "${headers[@]}" -o "$temp_response" > "$temp_output" 2>&1
        http_code=$(tail -n1 "$temp_response")
        body=$(head -n-1 "$temp_response")
    else
        curl -s -w "\n%{http_code}" -X "$method" "${API_URL}${endpoint}" "${headers[@]}" -d "$data" > "$temp_response" 2>&1
        http_code=$(echo "$temp_response" | tail -n1)
        body=$(cat "$temp_response" | head -n-1)
    fi

    # If curl failed, try simpler approach
    if [ -z "$http_code" ] || [ "$http_code" = "" ]; then
        if [ "$method" = "GET" ]; then
            full_response=$(curl -s -w "\n%{http_code}" -X GET "${API_URL}${endpoint}" "${headers[@]}")
        else
            full_response=$(curl -s -w "\n%{http_code}" -X "$method" "${API_URL}${endpoint}" "${headers[@]}" -d "$data")
        fi

        http_code=$(echo "$full_response" | tail -n1)
        body=$(echo "$full_response" | sed '$d')
    fi

    # Store in global variables
    API_RESPONSE_CODE="$http_code"
    API_RESPONSE_BODY="$body"

    # Cleanup
    rm -f "$temp_response" "$temp_output"

    echo "$body"
}

# Check if backend is running
echo "Checking backend status..."
health_response=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_URL")

if [ "$health_response" != "200" ]; then
    echo -e "${RED}❌ Backend is not running at $HEALTH_URL${NC}"
    echo "Please start the backend server first:"
    echo "  cd backend && npm start"
    exit 1
fi

echo -e "${GREEN}✅ Backend is running${NC}"
echo ""

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}⚠ Warning: 'jq' command not found. Installing for better JSON parsing...${NC}"
    # Try to provide helpful message
    echo "Please install jq: sudo apt-get install jq (or brew install jq on macOS)"
    echo "Continuing without jq..."
    JQ_AVAILABLE=false
else
    JQ_AVAILABLE=true
fi

echo "═══════════════════════════════════════════════"
echo "  Setup: Creating Test Users"
echo "═══════════════════════════════════════════════"
echo ""

# Generate unique phone numbers for this test run
TIMESTAMP=$(date +%s)
BUYER_PHONE="+233${TIMESTAMP:0:9}"
SELLER_PHONE="+233${TIMESTAMP:1:9}"
RIDER_PHONE="+233${TIMESTAMP:2:9}"

# 1. Register Buyer
echo "Creating test buyer account..."
buyer_data=$(cat <<EOF
{
  "username": "testbuyer_${TIMESTAMP}",
  "phoneNumber": "$BUYER_PHONE",
  "password": "TestPass123!",
  "fullName": "Test Buyer",
  "userType": "buyer",
  "email": "testbuyer${TIMESTAMP}@example.com"
}
EOF
)

buyer_response=$(api_call "POST" "/auth/register" "$buyer_data" "")
buyer_status=$?

if [ $buyer_status -eq 201 ]; then
    print_test_result "Buyer registration" "pass"
    if [ "$JQ_AVAILABLE" = true ]; then
        BUYER_ID=$(echo "$buyer_response" | jq -r '.data.user.id // empty')
    fi
    echo "   Phone: $BUYER_PHONE"
else
    print_test_result "Buyer registration" "fail" "HTTP $buyer_status: $(echo "$buyer_response" | head -c 200)"
    echo ""
    echo "Cannot proceed without buyer account"
    exit 1
fi

# 2. Verify Buyer OTP
echo ""
echo "Verifying buyer OTP..."
# In development, OTP is logged to console. Using a default OTP for testing
buyer_otp_data=$(cat <<EOF
{
  "phoneNumber": "$BUYER_PHONE",
  "otpCode": "123456",
  "purpose": "registration"
}
EOF
)

buyer_otp_response=$(api_call "POST" "/auth/verify-otp" "$buyer_otp_data" "")
buyer_otp_status=$?

if [ $buyer_otp_status -eq 200 ]; then
    print_test_result "Buyer OTP verification" "pass"
    if [ "$JQ_AVAILABLE" = true ]; then
        BUYER_TOKEN=$(echo "$buyer_otp_response" | jq -r '.data.accessToken // empty')
        BUYER_ID=$(echo "$buyer_otp_response" | jq -r '.data.user.id // empty')
    fi
else
    print_test_result "Buyer OTP verification" "fail" "HTTP $buyer_otp_status"
    echo ""
    echo "Note: Make sure OTP code is '123456' in development mode"
    echo "Or check the backend logs for the actual OTP code"
    exit 1
fi

# 3. Register Seller
echo ""
echo "Creating test seller account..."
seller_data=$(cat <<EOF
{
  "username": "testseller_${TIMESTAMP}",
  "phoneNumber": "$SELLER_PHONE",
  "password": "TestPass123!",
  "fullName": "Test Seller",
  "userType": "seller",
  "email": "testseller${TIMESTAMP}@example.com"
}
EOF
)

seller_response=$(api_call "POST" "/auth/register" "$seller_data" "")
seller_status=$?

if [ $seller_status -eq 201 ]; then
    print_test_result "Seller registration" "pass"
    if [ "$JQ_AVAILABLE" = true ]; then
        SELLER_ID=$(echo "$seller_response" | jq -r '.data.user.id // empty')
    fi
    echo "   Phone: $SELLER_PHONE"
else
    print_test_result "Seller registration" "fail" "HTTP $seller_status: $(echo "$seller_response" | head -c 200)"
fi

# 4. Verify Seller OTP
echo ""
echo "Verifying seller OTP..."
seller_otp_data=$(cat <<EOF
{
  "phoneNumber": "$SELLER_PHONE",
  "otpCode": "123456",
  "purpose": "registration"
}
EOF
)

seller_otp_response=$(api_call "POST" "/auth/verify-otp" "$seller_otp_data" "")
seller_otp_status=$?

if [ $seller_otp_status -eq 200 ]; then
    print_test_result "Seller OTP verification" "pass"
    if [ "$JQ_AVAILABLE" = true ]; then
        SELLER_TOKEN=$(echo "$seller_otp_response" | jq -r '.data.accessToken // empty')
        SELLER_ID=$(echo "$seller_otp_response" | jq -r '.data.user.id // empty')
    fi
else
    print_test_result "Seller OTP verification" "fail" "HTTP $seller_otp_status"
fi

# 5. Register Rider
echo ""
echo "Creating test rider account..."
rider_data=$(cat <<EOF
{
  "username": "testrider_${TIMESTAMP}",
  "phoneNumber": "$RIDER_PHONE",
  "password": "TestPass123!",
  "fullName": "Test Rider",
  "userType": "rider",
  "email": "testrider${TIMESTAMP}@example.com"
}
EOF
)

rider_response=$(api_call "POST" "/auth/register" "$rider_data" "")
rider_status=$?

if [ $rider_status -eq 201 ]; then
    print_test_result "Rider registration" "pass"
    if [ "$JQ_AVAILABLE" = true ]; then
        RIDER_ID=$(echo "$rider_response" | jq -r '.data.user.id // empty')
    fi
    echo "   Phone: $RIDER_PHONE"
else
    print_test_result "Rider registration" "fail" "HTTP $rider_status: $(echo "$rider_response" | head -c 200)"
fi

# 6. Verify Rider OTP
echo ""
echo "Verifying rider OTP..."
rider_otp_data=$(cat <<EOF
{
  "phoneNumber": "$RIDER_PHONE",
  "otpCode": "123456",
  "purpose": "registration"
}
EOF
)

rider_otp_response=$(api_call "POST" "/auth/verify-otp" "$rider_otp_data" "")
rider_otp_status=$?

if [ $rider_otp_status -eq 200 ]; then
    print_test_result "Rider OTP verification" "pass"
    if [ "$JQ_AVAILABLE" = true ]; then
        RIDER_TOKEN=$(echo "$rider_otp_response" | jq -r '.data.accessToken // empty')
        RIDER_ID=$(echo "$rider_otp_response" | jq -r '.data.user.id // empty')
    fi
else
    print_test_result "Rider OTP verification" "fail" "HTTP $rider_otp_status"
fi

echo ""
echo "═══════════════════════════════════════════════"
echo "  Stage 3: Escrow & Transaction Tests"
echo "═══════════════════════════════════════════════"
echo ""
echo -e "${YELLOW}Note: Stage 3 endpoints will be implemented next${NC}"
echo ""

# Summary
echo "═══════════════════════════════════════════════"
echo "  Test Summary"
echo "═══════════════════════════════════════════════"
echo ""
echo "Total Tests: $TOTAL_TESTS"
echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"
echo -e "${RED}Failed: $FAILED_TESTS${NC}"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}✨ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi
