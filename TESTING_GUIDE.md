# SafePay Ghana - Comprehensive Testing Guide

## 🎯 Testing Objectives
Test all features with two user accounts:
- Account creation and authentication
- Wallet funding
- P2P transfers with instant notifications
- Escrow transactions with notifications
- Real-time balance updates
- Transaction success pages
- Notification system (30-second polling)

---

## 📋 Pre-Testing Setup

### 1. Start Backend Server
```bash
cd ~/Projects/suresend/backend
npm start
# Backend should be running on http://localhost:3000
```

### 2. Start Mobile App
```bash
cd ~/Projects/suresend/mobile
flutter run -d linux
```

### 3. Set Up Database (Option A - Via SQL)

**Execute the test account setup script:**
```bash
cd ~/Projects/suresend
psql -U your_db_user -d suresend_db -f database/test_accounts_setup.sql
```

**Note:** You'll need to update the password hashes in the SQL file. Use bcrypt to generate:
```javascript
// In Node.js console
const bcrypt = require('bcrypt');
bcrypt.hash('Test123!', 10).then(hash => console.log(hash));
```

### 3. Set Up Database (Option B - Via API - RECOMMENDED)

**Create Account 1 - Alice (Buyer):**
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "alice_buyer",
    "phoneNumber": "0241111111",
    "fullName": "Alice Buyer",
    "email": "alice@test.com",
    "password": "Test123!",
    "userType": "user"
  }'
```

**Create Account 2 - Bob (Seller):**
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "bob_seller",
    "phoneNumber": "0242222222",
    "fullName": "Bob Seller",
    "email": "bob@test.com",
    "password": "Test123!",
    "userType": "user"
  }'
```

**Fund Alice's Wallet (Direct SQL):**
```sql
-- Update Alice's wallet balance
UPDATE wallets
SET balance = 1000.00
WHERE user_id = (SELECT id FROM users WHERE username = 'alice_buyer');

-- Log the funding transaction
INSERT INTO wallet_transactions (wallet_id, amount, type, description, reference, balance_before, balance_after, created_at)
SELECT id, 1000.00, 'credit', 'Test funding', 'TEST_FUND_001', 0.00, 1000.00, NOW()
FROM wallets WHERE user_id = (SELECT id FROM users WHERE username = 'alice_buyer');
```

---

## 🧪 Test Scenario 1: Login & Dashboard

### Alice's Account
1. **Open mobile app**
2. **Login with:**
   - Username: `alice_buyer`
   - Password: `Test123!`
3. **Verify Dashboard:**
   - [ ] "Hi, Alice 👋" appears in top bar
   - [ ] "Welcome to SafePay Ghana" subtitle
   - [ ] Notification bell in top right
   - [ ] Wallet balance card shows **₵ 1,000.00**
   - [ ] Quick Actions grid (6 buttons)
   - [ ] Escrow Summary widget
   - [ ] Recent Activity section (empty)
   - [ ] Delivery Tracking widget
   - [ ] Floating bottom navigation (5 tabs)

### Bob's Account
1. **Logout Alice** (Manage Account → Logout)
2. **Login with:**
   - Username: `bob_seller`
   - Password: `Test123!`
3. **Verify Dashboard:**
   - [ ] "Hi, Bob 👋" appears
   - [ ] Wallet balance: **₵ 0.00**
   - [ ] All UI elements present

---

## 🧪 Test Scenario 2: P2P Transfer (Alice → Bob)

### Step 1: Initiate Transfer (Alice)
1. **Login as Alice**
2. **Tap "Send Money"** from Quick Actions
3. **Verify:**
   - [ ] Available Balance card shows **₵ 1,000.00** at top ✅
   - [ ] Label says "Username or Phone Number" ✅

### Step 2: Search for Recipient
4. **Enter:** `bob_seller` OR `0242222222`
5. **Tap search icon** (🔍)
6. **Verify:**
   - [ ] Loading spinner appears
   - [ ] Green checkmark appears ✅
   - [ ] Green card shows:
     - Name: "Bob Seller"
     - Username: "@bob_seller"

### Step 3: Enter Transfer Details
7. **Amount field:**
   - [ ] Shows **₵** symbol (not $) ✅
   - [ ] Enter: `100.00`
8. **Description:** `Test P2P transfer`
9. **Tap "Transfer Money"**

### Step 4: Confirm Transfer
10. **Verify Confirmation Dialog:**
    - [ ] Amount: ₵ 100.00 (in teal color)
    - [ ] To: bob_seller
    - [ ] Recipient Name: Bob Seller
    - [ ] Description: Test P2P transfer
    - [ ] Warning: "This action cannot be undone"
11. **Tap "Confirm"**

### Step 5: Success Page
12. **Verify Success Screen Appears:** ✅
    - [ ] Large green checkmark icon
    - [ ] Title: "Transfer Successful!"
    - [ ] Message: "Your money has been sent successfully"
    - [ ] Amount: ₵ 100.00
    - [ ] Reference number shown
    - [ ] Details card shows:
      - Recipient: Bob Seller
      - Username: @bob_seller
      - Description: Test P2P transfer
13. **Tap "Go to Dashboard"**

### Step 6: Verify Alice's Dashboard
14. **Check:**
    - [ ] Balance updated: **₵ 900.00** ✅
    - [ ] Notification badge shows **1** (if Alice got confirmation) ✅
    - [ ] Recent Activity shows transfer ✅

---

## 🧪 Test Scenario 3: Verify Bob Received Funds

### Step 1: Check Notifications
1. **Logout Alice → Login as Bob**
2. **Verify:**
   - [ ] Notification badge shows **1** ✅
3. **Tap notification bell**
4. **Verify Notification:**
   - [ ] Title: "Money Received" or similar
   - [ ] Message: "You received GHS 100.00 from Alice Buyer"
   - [ ] Timestamp shown
5. **Tap notification** to mark as read
6. **Verify:** Badge count decreases

### Step 2: Check Balance
7. **Go back to Dashboard**
8. **Verify:**
   - [ ] Wallet balance: **₵ 100.00** ✅
   - [ ] Recent Activity shows: "Transfer from Alice Buyer"

### Step 3: Check Transaction History
9. **Tap "View Transaction History"** (on wallet card)
10. **Verify:**
    - [ ] Opens Wallet Transactions Screen (not Wallet Screen) ✅
    - [ ] Shows 1 transaction
    - [ ] Type: Credit (green icon)
    - [ ] Amount: +₵ 100.00
    - [ ] Description: "Transfer from alice_buyer" or similar
11. **Tap transaction**
12. **Verify Detail Modal:**
    - [ ] Amount: +₵ 100.00
    - [ ] Type: CREDIT
    - [ ] Balance Before: ₵ 0.00
    - [ ] Balance After: ₵ 100.00

---

## 🧪 Test Scenario 4: Escrow Transaction

### Step 1: Create Escrow (Alice Buys from Bob)
1. **Login as Alice**
2. **Tap "Create Escrow"** from Quick Actions
3. **Select Seller:**
   - Tap "Search Sellers"
   - Search: `bob_seller` or `0242222222`
   - Select Bob Seller
4. **Enter Details:**
   - Amount: `500.00` (verify **₵** symbol) ✅
   - Description: `Test escrow transaction - laptop purchase`
   - Payment Method: **Wallet**
5. **Tap "Create Transaction"**

### Step 2: Verify Success Page
6. **Verify Success Screen:** ✅
   - [ ] Title: "Escrow Created Successfully!"
   - [ ] Message: "Your escrow payment has been secured..."
   - [ ] Amount: ₵ 500.00
   - [ ] Reference: ESC... (transaction ref)
   - [ ] Details card shows:
     - Description: Test escrow transaction - laptop purchase
     - Seller: Bob Seller
     - Commission: ₵ 10.00 (2% of 500)
     - Total Paid: ₵ 510.00
     - Payment Method: Wallet
7. **Tap "Go to Dashboard"**

### Step 3: Verify Alice's Dashboard
8. **Check:**
   - [ ] Balance: **₵ 390.00** (900 - 510) ✅
   - [ ] Escrow Summary shows:
     - Total Escrows: 1
     - Active: 1
     - Completed: 0
   - [ ] Recent Activity shows escrow transaction
   - [ ] Notification badge shows new notification ✅

### Step 4: Check Alice's Notification
9. **Tap notification bell**
10. **Verify:**
    - [ ] "Escrow Created" notification
    - [ ] Message: "Your escrow payment of GHS 500.00..."

---

## 🧪 Test Scenario 5: Seller Receives Escrow Notification

### Step 1: Check Bob's Notifications
1. **Logout → Login as Bob**
2. **Verify:**
   - [ ] Notification badge shows **1** (new escrow) ✅
3. **Tap notification bell**
4. **Verify Notification:**
   - [ ] Title: "New Escrow Payment"
   - [ ] Message: "You have received an escrow payment of GHS 500.00..."
   - [ ] Reference number shown

### Step 2: Check Bob's Dashboard
5. **Go to Dashboard**
6. **Verify:**
   - [ ] Balance still: **₵ 100.00** (escrow not released yet)
   - [ ] Escrow Summary shows:
     - Total Escrows: 1
     - Active: 1 (as seller)
   - [ ] Recent Activity shows escrow transaction

---

## 🧪 Test Scenario 6: Delivery Confirmation & Fund Release

### Step 1: Find Transaction (Alice)
1. **Login as Alice**
2. **Go to:** All Transactions or tap escrow in Recent Activity
3. **Find:** "Test escrow transaction - laptop purchase"
4. **Tap transaction** to open details

### Step 2: Confirm Delivery
5. **In transaction detail:**
   - [ ] Status shows: "In Escrow"
   - [ ] "Confirm Delivery" button visible
6. **Tap "Confirm Delivery"**
7. **Enter notes (optional):** "Product received in good condition"
8. **Confirm delivery**

### Step 3: Verify Alice's Notification
9. **Check notifications:**
   - [ ] "Delivery Confirmed" notification ✅
   - [ ] Message: "You have confirmed delivery and released GHS 500.00..."

### Step 4: Verify Alice's Dashboard
10. **Go to Dashboard**
11. **Verify:**
    - [ ] Escrow Summary:
      - Active: 0
      - Completed: 1 ✅
    - [ ] Transaction status: "Completed"

---

## 🧪 Test Scenario 7: Seller Receives Released Funds

### Step 1: Check Bob's Notifications
1. **Logout → Login as Bob**
2. **Verify:**
   - [ ] Notification badge shows **1** ✅
3. **Tap notification bell**
4. **Verify Notification:**
   - [ ] Title: "Payment Released" ✅
   - [ ] Message: "Delivery confirmed! GHS 500.00 has been credited to your wallet" ✅

### Step 2: Verify Bob's Balance
5. **Go to Dashboard**
6. **Verify:**
   - [ ] Balance: **₵ 600.00** (100 + 500) ✅✅✅
   - [ ] Real-time update (no manual refresh needed!) ✅

### Step 3: Check Bob's Transaction History
7. **Tap "View Transaction History"**
8. **Verify:**
   - [ ] New transaction: "Escrow payment received"
   - [ ] Type: Credit (green)
   - [ ] Amount: +₵ 500.00
   - [ ] Balance After: ₵ 600.00

---

## 🧪 Test Scenario 8: Additional UI/UX Tests

### Test Currency Symbol (₵ vs $)
- [ ] Fund Wallet screen: Shows **₵** ✅
- [ ] Withdraw screen: Shows **₵** ✅
- [ ] Transfer screen: Shows **₵** ✅
- [ ] All amount displays: Uses **₵** ✅

### Test Pull-to-Refresh
1. **On Dashboard:** Pull down
   - [ ] Balance refreshes
   - [ ] Transactions reload
   - [ ] Stats update
2. **On Wallet Transactions:** Pull down
   - [ ] Transaction list reloads
3. **On Notification Screen:** Pull down
   - [ ] Notifications reload

### Test Bottom Navigation
- [ ] Home tab (active by default)
- [ ] Escrow tab (placeholder screen)
- [ ] Messages tab (placeholder screen)
- [ ] Reports tab (placeholder screen)
- [ ] Profile tab (placeholder screen)
- [ ] Teal highlight on active tab ✅

### Test Notification Auto-Polling
1. **Keep app open for 30+ seconds**
2. **In another window:** Create a transaction or notification
3. **Wait for polling cycle**
4. **Verify:** Badge count updates automatically ✅

### Test "Manage Account" Menu
1. **Tap "Manage Account"** in Quick Actions
2. **Verify Modal Shows:**
   - [ ] Profile (coming soon)
   - [ ] Wallet → Opens wallet screen
   - [ ] Settings (coming soon)
   - [ ] Help & Support (coming soon)
   - [ ] Logout (works)

### Test Username/Phone Search
1. **Send Money screen**
2. **Try searching by:**
   - [ ] Username: `bob_seller` ✅
   - [ ] Phone: `0242222222` ✅
   - [ ] Partial name: `Bob` ✅
3. **Verify:** All searches work

---

## ✅ Final Verification Checklist

### Design & Branding
- [ ] Teal (#00C9A7) used for primary actions
- [ ] Deep blue (#1E1E2F) for headers/backgrounds
- [ ] Rounded corners (20-25px) on cards
- [ ] Soft shadows for depth
- [ ] "SafePay Ghana" branding

### Wallet Features
- [ ] Balance displays correctly
- [ ] ₵ symbol everywhere (no $)
- [ ] Fund wallet flow works
- [ ] Withdraw flow works
- [ ] P2P transfer flow works
- [ ] Transaction history with filters

### Escrow Features
- [ ] Create escrow works
- [ ] Commission calculated (2%)
- [ ] Funds deducted from buyer
- [ ] Escrow summary accurate
- [ ] Delivery confirmation works
- [ ] Funds released to seller

### Notifications
- [ ] Instant notifications for escrow created
- [ ] Instant notifications for transfer
- [ ] Instant notifications for delivery confirmed
- [ ] Badge shows unread count
- [ ] 30-second auto-polling works
- [ ] Mark as read works
- [ ] Swipe to delete works

### Success Pages
- [ ] Escrow creation shows success page
- [ ] P2P transfer shows success page
- [ ] "Go to Dashboard" clears navigation stack
- [ ] No blank screens

### Real-Time Updates
- [ ] Balance updates after operations
- [ ] Dashboard refreshes automatically
- [ ] Pull-to-refresh works everywhere
- [ ] Provider pattern updates UI

---

## 📊 Expected Final State

After all tests:

**Alice's Account:**
- Balance: ₵ 390.00
- Transactions: 2 (1 transfer out, 1 escrow)
- Notifications: 3-4

**Bob's Account:**
- Balance: ₵ 600.00
- Transactions: 2 (1 transfer in, 1 escrow payment)
- Notifications: 2-3

---

## 🐛 If Something Doesn't Work

1. **Check backend logs:**
   ```bash
   # In backend terminal
   # Look for errors
   ```

2. **Check database state:**
   ```sql
   -- Check balances
   SELECT u.username, w.balance FROM users u JOIN wallets w ON u.id = w.user_id;

   -- Check notifications
   SELECT u.username, n.title, n.is_read FROM notifications n JOIN users u ON n.user_id = u.id ORDER BY n.created_at DESC LIMIT 10;

   -- Check transactions
   SELECT transaction_ref, status, amount FROM transactions ORDER BY created_at DESC LIMIT 5;
   ```

3. **Flutter errors:**
   ```bash
   # Check console output
   # Look for red error messages
   ```

---

## 🎉 Success Criteria

All tests pass when:
- ✅ Both accounts created and funded
- ✅ P2P transfer successful with notifications
- ✅ Escrow created with success page
- ✅ Both parties notified instantly
- ✅ Delivery confirmation releases funds
- ✅ Balances update in real-time
- ✅ No blank screens
- ✅ All ₵ symbols display correctly
- ✅ Success pages show after operations
- ✅ Navigation works smoothly

---

**Ready to test!** 🚀

Start by executing the account creation scripts, then follow each test scenario in order.
