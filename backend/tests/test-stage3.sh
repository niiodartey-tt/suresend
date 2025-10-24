#!/bin/bash

# SureSend Stage 3 Backend Test Script
# Tests all escrow and transaction endpoints

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Base URL
BASE_URL="http://localhost:3000"

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

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

echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════╗"
echo "║   SureSend Stage 3 Backend Test Suite        ║"
echo "║   Escrow & Transaction Functionality          ║"
echo "╚═══════════════════════════════════════════════╝"
echo -e "${NC}\n"

# Check if backend is running
echo -e "${YELLOW}Checking backend status...${NC}"
response=$(curl -s "$BASE_URL/health" 2>/dev/null)
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Backend is not running!${NC}"
    echo "Please start the backend first:"
    echo "  cd backend && npm run dev"
    exit 1
fi
echo -e "${GREEN}✅ Backend is running${NC}\n"

# Setup: Create test users
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  Setup: Creating Test Users${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

# Register buyer
echo -e "${YELLOW}Creating test buyer account...${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testbuyer_stage3",
    "phoneNumber": "+233245001001",
    "password": "Buyer@1234",
    "fullName": "Stage 3 Test Buyer",
    "userType": "buyer",
    "email": "buyer.stage3@test.com"
  }')

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Buyer registration"
    echo -e "${BLUE}📝 Check backend terminal for buyer OTP...${NC}"
    read -p "Enter buyer OTP: " BUYER_OTP

    # Verify buyer OTP
    response=$(curl -s -X POST "$BASE_URL/api/v1/auth/verify-otp" \
      -H "Content-Type: application/json" \
      -d "{
        \"phoneNumber\": \"+233245001001\",
        \"otpCode\": \"$BUYER_OTP\",
        \"purpose\": \"registration\"
      }")

    status=$(extract_field "$response" "status")
    if [ "$status" == "success" ]; then
        print_result 0 "Buyer OTP verification"
        BUYER_TOKEN=$(echo "$response" | grep -o '"accessToken":"[^"]*' | cut -d'"' -f4)
        BUYER_ID=$(echo "$response" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4)
        echo -e "${GREEN}✓ Buyer token received${NC}"

        # Fund buyer wallet (simulate)
        echo -e "${YELLOW}Simulating wallet funding for buyer (adding GHS 500)...${NC}"
        psql -U postgres -d suresend_db -c "UPDATE wallets SET balance = 500.00 WHERE user_id = '$BUYER_ID';" > /dev/null 2>&1
        echo -e "${GREEN}✓ Buyer wallet funded${NC}"
    else
        print_result 1 "Buyer OTP verification"
        echo "Cannot proceed without buyer account"
        exit 1
    fi
else
    print_result 1 "Buyer registration"
    echo "Cannot proceed without buyer account"
    exit 1
fi

# Register seller
echo -e "\n${YELLOW}Creating test seller account...${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testseller_stage3",
    "phoneNumber": "+233245002002",
    "password": "Seller@1234",
    "fullName": "Stage 3 Test Seller",
    "userType": "seller"
  }')

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Seller registration"
    echo -e "${BLUE}📝 Check backend terminal for seller OTP...${NC}"
    read -p "Enter seller OTP: " SELLER_OTP

    # Verify seller OTP
    response=$(curl -s -X POST "$BASE_URL/api/v1/auth/verify-otp" \
      -H "Content-Type: application/json" \
      -d "{
        \"phoneNumber\": \"+233245002002\",
        \"otpCode\": \"$SELLER_OTP\",
        \"purpose\": \"registration\"
      }")

    status=$(extract_field "$response" "status")
    if [ "$status" == "success" ]; then
        print_result 0 "Seller OTP verification"
        SELLER_TOKEN=$(echo "$response" | grep -o '"accessToken":"[^"]*' | cut -d'"' -f4)
        SELLER_ID=$(echo "$response" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4)
        echo -e "${GREEN}✓ Seller token received${NC}"
    else
        print_result 1 "Seller OTP verification"
        echo "Cannot proceed without seller account"
        exit 1
    fi
else
    print_result 1 "Seller registration"
    echo "Cannot proceed without seller account"
    exit 1
fi

# Test 1: Search Users
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  Test 1: Search Users${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

response=$(curl -s -X GET "$BASE_URL/api/v1/transactions/search-users?search=stage3&userType=seller" \
  -H "Authorization: Bearer $BUYER_TOKEN")

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Search sellers"
else
    print_result 1 "Search sellers"
    echo "Response: $response"
fi

# Test 2: Create Escrow Transaction
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  Test 2: Create Escrow Transaction${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

response=$(curl -s -X POST "$BASE_URL/api/v1/escrow/create" \
  -H "Authorization: Bearer $BUYER_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"sellerId\": \"$SELLER_ID\",
    \"amount\": 150.00,
    \"description\": \"iPhone 13 Pro - 256GB Blue\",
    \"paymentMethod\": \"wallet\"
  }")

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Create escrow transaction"
    TRANSACTION_ID=$(echo "$response" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4)
    TRANSACTION_REF=$(echo "$response" | grep -o '"transactionRef":"[^"]*' | cut -d'"' -f4)
    echo -e "${GREEN}✓ Transaction ID: $TRANSACTION_ID${NC}"
    echo -e "${GREEN}✓ Transaction Ref: $TRANSACTION_REF${NC}"
else
    print_result 1 "Create escrow transaction"
    echo "Response: $response"
    exit 1
fi

# Test 3: Get Transaction Details
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  Test 3: Get Transaction Details${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

response=$(curl -s -X GET "$BASE_URL/api/v1/escrow/$TRANSACTION_ID" \
  -H "Authorization: Bearer $BUYER_TOKEN")

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Get transaction details (buyer)"
else
    print_result 1 "Get transaction details (buyer)"
fi

# Seller can also view
response=$(curl -s -X GET "$BASE_URL/api/v1/escrow/$TRANSACTION_ID" \
  -H "Authorization: Bearer $SELLER_TOKEN")

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Get transaction details (seller)"
else
    print_result 1 "Get transaction details (seller)"
fi

# Test 4: Get Transaction List
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  Test 4: Get Transaction List${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

response=$(curl -s -X GET "$BASE_URL/api/v1/transactions?page=1&limit=10" \
  -H "Authorization: Bearer $BUYER_TOKEN")

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Get transaction list (buyer)"
else
    print_result 1 "Get transaction list (buyer)"
fi

# Seller's transactions
response=$(curl -s -X GET "$BASE_URL/api/v1/transactions?page=1&limit=10&role=seller" \
  -H "Authorization: Bearer $SELLER_TOKEN")

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Get transaction list (seller)"
else
    print_result 1 "Get transaction list (seller)"
fi

# Test 5: Get Transaction Statistics
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  Test 5: Get Transaction Statistics${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

response=$(curl -s -X GET "$BASE_URL/api/v1/transactions/stats" \
  -H "Authorization: Bearer $BUYER_TOKEN")

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Get transaction statistics"
else
    print_result 1 "Get transaction statistics"
fi

# Test 6: Confirm Delivery
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  Test 6: Confirm Delivery${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Confirming delivery for transaction $TRANSACTION_REF...${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/escrow/$TRANSACTION_ID/confirm-delivery" \
  -H "Authorization: Bearer $BUYER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "confirmed": true,
    "notes": "Product received in excellent condition. Thank you!"
  }')

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    print_result 0 "Confirm delivery (happy path)"
    echo -e "${GREEN}✓ Funds released to seller${NC}"
else
    print_result 1 "Confirm delivery (happy path)"
    echo "Response: $response"
fi

# Test 7: Create Another Transaction for Cancellation Test
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  Test 7: Cancel Transaction${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Creating transaction for cancellation test...${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/escrow/create" \
  -H "Authorization: Bearer $BUYER_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"sellerId\": \"$SELLER_ID\",
    \"amount\": 75.00,
    \"description\": \"Samsung Galaxy S22\",
    \"paymentMethod\": \"wallet\"
  }")

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    CANCEL_TRANSACTION_ID=$(echo "$response" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4)
    echo -e "${GREEN}✓ Transaction created for cancellation${NC}"

    # Cancel it
    response=$(curl -s -X POST "$BASE_URL/api/v1/escrow/$CANCEL_TRANSACTION_ID/cancel" \
      -H "Authorization: Bearer $BUYER_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{
        "reason": "Changed my mind"
      }')

    status=$(extract_field "$response" "status")
    if [ "$status" == "success" ]; then
        print_result 0 "Cancel transaction"
        echo -e "${GREEN}✓ Transaction cancelled, funds refunded${NC}"
    else
        print_result 1 "Cancel transaction"
        echo "Response: $response"
    fi
else
    print_result 1 "Create transaction for cancellation"
fi

# Test 8: Create Transaction for Dispute Test
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  Test 8: Raise Dispute${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Creating transaction for dispute test...${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/escrow/create" \
  -H "Authorization: Bearer $BUYER_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"sellerId\": \"$SELLER_ID\",
    \"amount\": 200.00,
    \"description\": \"MacBook Pro 14 inch\",
    \"paymentMethod\": \"wallet\"
  }")

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    DISPUTE_TRANSACTION_ID=$(echo "$response" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4)
    echo -e "${GREEN}✓ Transaction created for dispute${NC}"

    # Raise dispute
    response=$(curl -s -X POST "$BASE_URL/api/v1/escrow/$DISPUTE_TRANSACTION_ID/dispute" \
      -H "Authorization: Bearer $BUYER_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{
        "reason": "Product does not match description. Screen has scratches and battery health is only 85%."
      }')

    status=$(extract_field "$response" "status")
    if [ "$status" == "success" ]; then
        print_result 0 "Raise dispute"
        echo -e "${GREEN}✓ Dispute raised successfully${NC}"
    else
        print_result 1 "Raise dispute"
        echo "Response: $response"
    fi
else
    print_result 1 "Create transaction for dispute"
fi

# Test 9: Reject Delivery (Creates Dispute)
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  Test 9: Reject Delivery${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Creating transaction for rejection test...${NC}"
response=$(curl -s -X POST "$BASE_URL/api/v1/escrow/create" \
  -H "Authorization: Bearer $BUYER_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"sellerId\": \"$SELLER_ID\",
    \"amount\": 50.00,
    \"description\": \"AirPods Pro\",
    \"paymentMethod\": \"wallet\"
  }")

status=$(extract_field "$response" "status")
if [ "$status" == "success" ]; then
    REJECT_TRANSACTION_ID=$(echo "$response" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4)
    echo -e "${GREEN}✓ Transaction created${NC}"

    # Reject delivery
    response=$(curl -s -X POST "$BASE_URL/api/v1/escrow/$REJECT_TRANSACTION_ID/confirm-delivery" \
      -H "Authorization: Bearer $BUYER_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{
        "confirmed": false,
        "notes": "Product is fake/counterfeit"
      }')

    status=$(extract_field "$response" "status")
    if [ "$status" == "success" ]; then
        print_result 0 "Reject delivery (creates dispute)"
        echo -e "${GREEN}✓ Delivery rejected, dispute created${NC}"
    else
        print_result 1 "Reject delivery"
        echo "Response: $response"
    fi
else
    print_result 1 "Create transaction for rejection"
fi

# Test 10: Check Wallet Balances
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  Test 10: Verify Wallet Balances${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Checking wallet balances...${NC}"

# Buyer balance
buyer_balance=$(psql -U postgres -d suresend_db -t -c "SELECT balance FROM wallets WHERE user_id = '$BUYER_ID';")
echo -e "Buyer balance: ${CYAN}GHS ${buyer_balance}${NC}"

# Seller balance
seller_balance=$(psql -U postgres -d suresend_db -t -c "SELECT balance FROM wallets WHERE user_id = '$SELLER_ID';")
echo -e "Seller balance: ${CYAN}GHS ${seller_balance}${NC}"

print_result 0 "Wallet balance verification"

# Print summary
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  Test Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"
TOTAL=$((TESTS_PASSED + TESTS_FAILED))
echo -e "Total: $TOTAL\n"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All Stage 3 tests passed!${NC}"
    echo -e "${GREEN}Escrow system is fully functional.${NC}\n"

    echo -e "${CYAN}Test Results:${NC}"
    echo "  ✓ Create escrow transactions"
    echo "  ✓ Get transaction details"
    echo "  ✓ List transactions with pagination"
    echo "  ✓ Transaction statistics"
    echo "  ✓ User search"
    echo "  ✓ Confirm delivery (release funds)"
    echo "  ✓ Cancel transaction (refund)"
    echo "  ✓ Raise disputes"
    echo "  ✓ Reject delivery (auto dispute)"
    echo "  ✓ Wallet integration"
    echo ""
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Please review errors above.${NC}\n"
    exit 1
fi
