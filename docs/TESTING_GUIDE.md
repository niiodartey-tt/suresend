# SureSend - Complete Testing Guide (Stage 1 & 2)

## Prerequisites
- PostgreSQL installed and running
- Node.js and npm installed
- Flutter SDK installed
- Terminal/Command Prompt access

---

## Part 1: Database Testing (Stage 1)

### Test 1.1: Check PostgreSQL Status
```bash
# Check if PostgreSQL is running
sudo systemctl status postgresql

# If not running, start it
sudo systemctl start postgresql
```

**Expected:** PostgreSQL should be active and running

---

### Test 1.2: Create Database
```bash
cd database

# Create the database
psql -U postgres -f scripts/create_database.sql

# Enter your PostgreSQL password when prompted
```

**Expected Output:**
```
Database suresend_db created successfully!
Next step: Run setup.sql to create tables
```

---

### Test 1.3: Setup Database Schema
```bash
# Run the setup script
psql -U postgres -d suresend_db -f scripts/setup.sql
```

**Expected Output:**
```
CREATE EXTENSION
CREATE TYPE
...
INSERT 0 1
          message
----------------------------------
 Database setup completed successfully!
```

---

### Test 1.4: Verify Database Tables
```bash
# List all tables
psql -U postgres -d suresend_db -c "\dt"

# Should show:
# - users
# - wallets
# - transactions
# - escrow_accounts
# - otp_verifications
# - kyc_documents
# - transaction_logs
# - notifications
# - wallet_transactions
# - disputes
```

**Expected:** 10 tables listed

---

### Test 1.5: Verify Admin User
```bash
# Check if admin user exists
psql -U postgres -d suresend_db -c "SELECT username, phone_number, user_type, is_verified FROM users WHERE username='admin';"
```

**Expected Output:**
```
 username | phone_number  | user_type | is_verified
----------+---------------+-----------+-------------
 admin    | +233000000000 | buyer     | t
```

---

## Part 2: Backend API Testing (Stage 1 & 2)

### Test 2.1: Start Backend Server
```bash
cd backend
npm run dev
```

**Expected Output:**
```
================================================
🚀 SureSend API Server Started Successfully
================================================
Environment: development
Port: 3000
API Version: v1
Health Check: http://localhost:3000/health
API Base: http://localhost:3000/api
================================================
```

**⚠️ Keep this terminal open! Open a new terminal for the next tests.**

---

### Test 2.2: Health Check Endpoint
Open a new terminal and run:

```bash
curl http://localhost:3000/health
```

**Expected Output:**
```json
{
  "status": "success",
  "message": "SureSend API is running",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "environment": "development"
}
```

---

### Test 2.3: API Base Endpoint
```bash
curl http://localhost:3000/api
```

**Expected Output:**
```json
{
  "status": "success",
  "message": "Welcome to SureSend API",
  "version": "v1",
  "endpoints": {
    "health": "/health",
    "api": "/api",
    "auth": { ... },
    "users": { ... }
  }
}
```

---

### Test 2.4: Register a Buyer
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testbuyer",
    "phoneNumber": "+233241234567",
    "password": "Test@1234",
    "fullName": "Test Buyer",
    "userType": "buyer",
    "email": "testbuyer@example.com"
  }'
```

**Expected Output:**
```json
{
  "status": "success",
  "message": "Registration successful. OTP sent to your phone.",
  "data": {
    "user": {
      "id": "uuid-here",
      "username": "testbuyer",
      "phoneNumber": "+233241234567",
      "fullName": "Test Buyer",
      "userType": "buyer",
      "email": "testbuyer@example.com"
    },
    "requiresOTP": true
  }
}
```

**📝 IMPORTANT:** Check the backend terminal for the OTP code!
Look for:
```
========================================
📱 SMS OTP (Development Mode)
========================================
To: +233241234567
Purpose: registration
OTP Code: 123456
Expires: ...
========================================
```

**✍️ Write down the OTP code: _____________**

---

### Test 2.5: Verify Registration OTP
Replace `123456` with the OTP from your terminal:

```bash
curl -X POST http://localhost:3000/api/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "+233241234567",
    "otpCode": "123456",
    "purpose": "registration"
  }'
```

**Expected Output:**
```json
{
  "status": "success",
  "message": "Authentication successful",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "uuid",
      "username": "testbuyer",
      "phoneNumber": "+233241234567",
      "fullName": "Test Buyer",
      "userType": "buyer",
      "isVerified": true,
      "kycStatus": "pending",
      "walletBalance": "0.00"
    }
  }
}
```

**✍️ Copy the accessToken and save it:**
```
export TOKEN="paste-your-token-here"
```

---

### Test 2.6: Get User Profile (Protected Route)
```bash
curl -X GET http://localhost:3000/api/v1/users/profile \
  -H "Authorization: Bearer $TOKEN"
```

**Expected Output:**
```json
{
  "status": "success",
  "message": "Profile retrieved successfully",
  "data": {
    "user": { ... },
    "wallet": {
      "balance": "0.00",
      "currency": "GHS"
    },
    "stats": {
      "totalTransactions": 0,
      "completedTransactions": 0
    }
  }
}
```

---

### Test 2.7: Login Flow
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "identifier": "testbuyer",
    "password": "Test@1234"
  }'
```

**Expected Output:**
```json
{
  "status": "success",
  "message": "Credentials verified. OTP sent to your phone.",
  "data": {
    "phoneNumber": "+233241234567",
    "requiresOTP": true
  }
}
```

**📝 Check backend terminal for login OTP code**

---

### Test 2.8: Verify Login OTP
```bash
curl -X POST http://localhost:3000/api/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "+233241234567",
    "otpCode": "YOUR_OTP_HERE",
    "purpose": "login"
  }'
```

**Expected:** Same as Test 2.5 (new tokens + user data)

---

### Test 2.9: Resend OTP
```bash
curl -X POST http://localhost:3000/api/v1/auth/resend-otp \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "+233241234567",
    "purpose": "login"
  }'
```

**Expected Output:**
```json
{
  "status": "success",
  "message": "New OTP sent to your phone",
  "data": {
    "phoneNumber": "+233241234567"
  }
}
```

---

### Test 2.10: Update Profile
```bash
curl -X PUT http://localhost:3000/api/v1/users/profile \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Test Buyer Updated",
    "email": "updated@example.com"
  }'
```

**Expected Output:**
```json
{
  "status": "success",
  "message": "Profile updated successfully",
  "data": {
    "user": { ... }
  }
}
```

---

### Test 2.11: Register Different User Types

**Seller:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testseller",
    "phoneNumber": "+233247654321",
    "password": "Seller@1234",
    "fullName": "Test Seller",
    "userType": "seller"
  }'
```

**Rider:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testrider",
    "phoneNumber": "+233243334444",
    "password": "Rider@1234",
    "fullName": "Test Rider",
    "userType": "rider"
  }'
```

**📝 Remember to verify OTP for each user type!**

---

### Test 2.12: Invalid Credentials
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "identifier": "testbuyer",
    "password": "WrongPassword"
  }'
```

**Expected Output:**
```json
{
  "status": "error",
  "message": "Invalid credentials"
}
```

---

### Test 2.13: Invalid OTP
```bash
curl -X POST http://localhost:3000/api/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "+233241234567",
    "otpCode": "000000",
    "purpose": "login"
  }'
```

**Expected Output:**
```json
{
  "status": "error",
  "message": "Invalid OTP code"
}
```

---

### Test 2.14: Unauthorized Access
```bash
curl -X GET http://localhost:3000/api/v1/users/profile
```

**Expected Output:**
```json
{
  "status": "error",
  "message": "No token provided"
}
```

---

## Part 3: Mobile App Testing (Stage 1 & 2)

### Test 3.1: Install Dependencies
```bash
cd mobile
flutter pub get
```

**Expected:** All dependencies installed successfully

---

### Test 3.2: Check Flutter Setup
```bash
flutter doctor
```

**Expected:** No critical issues (warnings are okay)

---

### Test 3.3: Configure API Endpoint (Android Emulator)
If using Android emulator, edit `lib/config/app_config.dart`:

```dart
// Change from:
static const String apiBaseUrl = 'http://localhost:3000/api/v1';

// To:
static const String apiBaseUrl = 'http://10.0.2.2:3000/api/v1';
```

**For iOS simulator or physical device:** Keep `localhost:3000` or use your computer's IP address.

---

### Test 3.4: Run the App
```bash
flutter run
```

**Expected:** App launches successfully

---

### Test 3.5: Splash Screen Navigation
**Steps:**
1. App shows splash screen for 2 seconds
2. Automatically navigates to Login screen (if not logged in)

**✅ Pass if:** App navigates to login screen

---

### Test 3.6: Registration Flow
**Steps:**
1. Click "Sign Up" on login screen
2. Select user type (Buyer/Seller/Rider)
3. Fill in registration form:
   - Full Name: `Mobile Test Buyer`
   - Username: `mobilebuyer`
   - Phone: `+233245555555`
   - Email: `mobile@test.com` (optional)
   - Password: `Mobile@1234`
   - Confirm Password: `Mobile@1234`
4. Click "Create Account"
5. Wait for OTP screen
6. Check backend terminal for OTP
7. Enter OTP (6 digits)
8. Click "Verify OTP"

**✅ Pass if:**
- Form validation works
- OTP screen appears
- After verification, navigates to Buyer Dashboard
- Shows welcome message with user name

---

### Test 3.7: Login Flow
**Steps:**
1. If logged in, logout first (tap menu → Logout)
2. On login screen, enter:
   - Username: `mobilebuyer`
   - Password: `Mobile@1234`
3. Click "Login"
4. Wait for OTP screen
5. Check backend terminal for OTP
6. Enter OTP
7. Click "Verify OTP"

**✅ Pass if:**
- Navigates to OTP screen
- After verification, navigates to Buyer Dashboard
- User data displays correctly

---

### Test 3.8: Buyer Dashboard
**Check:**
- [ ] Welcome card shows user name
- [ ] Verified badge displays
- [ ] Wallet balance shows ₵0.00
- [ ] Quick action cards display
- [ ] Drawer menu works
- [ ] Profile info in drawer is correct
- [ ] Notification icon visible
- [ ] "Coming in Stage 3" card displays

**✅ Pass if:** All elements render correctly

---

### Test 3.9: Seller Dashboard
**Steps:**
1. Logout from buyer account
2. Register as seller:
   - Username: `mobileseller`
   - Phone: `+233246666666`
   - User Type: **Seller**
   - Password: `Seller@1234`
3. Complete OTP verification

**Check:**
- [ ] Seller Dashboard loads
- [ ] Different color scheme (teal/secondary color)
- [ ] Wallet balance displays
- [ ] "Coming in Stage 3 & 4" message shows
- [ ] Drawer menu works

**✅ Pass if:** Seller-specific dashboard displays

---

### Test 3.10: Rider Dashboard
**Steps:**
1. Logout from seller account
2. Register as rider:
   - Username: `mobilerider`
   - Phone: `+233247777777`
   - User Type: **Rider**
   - Password: `Rider@1234`
3. Complete OTP verification

**Check:**
- [ ] Rider Dashboard loads
- [ ] Different color scheme (amber/accent color)
- [ ] Earnings section displays
- [ ] "Coming in Stage 3" message shows
- [ ] Drawer menu works

**✅ Pass if:** Rider-specific dashboard displays

---

### Test 3.11: Persistent Login
**Steps:**
1. Login as any user
2. Completely close the app (not just minimize)
3. Reopen the app

**✅ Pass if:** App automatically logs in and goes to dashboard (no login screen)

---

### Test 3.12: Logout
**Steps:**
1. From any dashboard, tap menu icon (top left)
2. Scroll to bottom of drawer
3. Tap "Logout"

**✅ Pass if:**
- Navigates back to login screen
- User data cleared
- On app restart, shows login screen (not dashboard)

---

### Test 3.13: Form Validation
**Test on registration screen:**

Invalid cases that should show errors:
- [ ] Empty username → "Please enter a username"
- [ ] Username "ab" → "Username must be at least 3 characters"
- [ ] Username "test@user" → "Username can only contain letters and numbers"
- [ ] Phone "1234567890" → "Phone must be in format +233XXXXXXXXX"
- [ ] Password "weak" → Error about password requirements
- [ ] Password "NoNumber!" → "Password must contain a number"
- [ ] Confirm password doesn't match → "Passwords do not match"

**✅ Pass if:** All validation messages show correctly

---

### Test 3.14: OTP Resend
**Steps:**
1. On OTP screen, wait 60 seconds
2. Click "Resend" link
3. Check backend terminal for new OTP

**✅ Pass if:**
- Countdown timer shows (60s)
- After countdown, "Resend" link becomes active
- New OTP generates and displays in terminal
- Success message shows in app

---

### Test 3.15: Backend Connection Test (Old Placeholder)
If you kept the placeholder home screen:
1. Navigate to it
2. Click "Test Backend Connection" button

**✅ Pass if:** Shows "Connected to Backend ✓" in green

---

## Part 4: Error Handling Tests

### Test 4.1: Backend Offline
**Steps:**
1. Stop the backend server (Ctrl+C in backend terminal)
2. Try to login in mobile app

**✅ Pass if:** Shows connection error message

---

### Test 4.2: Invalid Token
```bash
curl -X GET http://localhost:3000/api/v1/users/profile \
  -H "Authorization: Bearer invalid_token_here"
```

**Expected Output:**
```json
{
  "status": "error",
  "message": "Invalid or expired token"
}
```

---

### Test 4.3: Expired OTP
**Steps:**
1. Register a new user
2. Wait 6 minutes (OTP expires after 5 minutes)
3. Try to verify the old OTP

**Expected:** "OTP has expired" error

---

### Test 4.4: Duplicate Username
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testbuyer",
    "phoneNumber": "+233249999999",
    "password": "Test@1234",
    "fullName": "Duplicate Test",
    "userType": "buyer"
  }'
```

**Expected Output:**
```json
{
  "status": "error",
  "message": "Username or phone number already exists"
}
```

---

## Test Results Checklist

### Stage 1: System Architecture ✅
- [ ] Database created successfully
- [ ] All 10 tables exist
- [ ] Admin user seeded
- [ ] Backend server starts
- [ ] Health endpoint responds
- [ ] API base endpoint responds

### Stage 2: Backend Authentication ✅
- [ ] User registration works
- [ ] OTP generation works
- [ ] OTP verification works
- [ ] Login with credentials works
- [ ] Login OTP works
- [ ] Profile retrieval works (protected route)
- [ ] Profile update works
- [ ] Resend OTP works
- [ ] All 3 user types can register
- [ ] Invalid credentials rejected
- [ ] Invalid OTP rejected
- [ ] Unauthorized access blocked

### Stage 2: Mobile App ✅
- [ ] App starts successfully
- [ ] Splash screen navigation works
- [ ] Registration flow works
- [ ] Login flow works
- [ ] OTP screen works
- [ ] Buyer dashboard loads
- [ ] Seller dashboard loads
- [ ] Rider dashboard loads
- [ ] Persistent login works
- [ ] Logout works
- [ ] Form validation works
- [ ] OTP resend works
- [ ] Role-based navigation works

### Error Handling ✅
- [ ] Backend offline handling
- [ ] Invalid token handling
- [ ] Expired OTP handling
- [ ] Duplicate registration handling

---

## Summary

If all tests pass:
✅ **Stage 1 & 2 are fully functional!**

Next steps:
- Stage 3: Escrow Core Functionality
- Stage 4: Wallet & Payments
- Stage 5: UI Polish
- Stage 6: Security & Fraud Prevention
- Stage 7: Testing & Deployment

---

## Troubleshooting

### Database Issues
```bash
# Reset database
psql -U postgres -c "DROP DATABASE IF EXISTS suresend_db;"
psql -U postgres -f database/scripts/create_database.sql
psql -U postgres -d suresend_db -f database/scripts/setup.sql
```

### Backend Issues
```bash
cd backend
rm -rf node_modules package-lock.json
npm install
npm run dev
```

### Mobile Issues
```bash
cd mobile
flutter clean
flutter pub get
flutter run
```

---

**Happy Testing! 🧪**
