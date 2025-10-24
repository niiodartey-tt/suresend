# SureSend Backend Testing Guide

## Running Tests

### Stage 3 Test Suite

The Stage 3 test suite tests escrow and transaction functionality. Run it with:

```bash
cd backend/tests
./test-stage3.sh
```

## Common Registration Failures

If you're getting "Buyer registration failed" errors, check these common issues:

### 1. Invalid Phone Number Format

**Requirement:** Phone number must be exactly in format `+233XXXXXXXXX` (12 characters total)

**Examples:**
- ✅ Correct: `+233241234567` (9 digits after +233)
- ❌ Wrong: `233241234567` (missing +)
- ❌ Wrong: `+23324123456` (only 8 digits)
- ❌ Wrong: `+2332412345678` (10 digits)

### 2. Weak Password

**Requirements:**
- Minimum 8 characters
- At least one uppercase letter (A-Z)
- At least one lowercase letter (a-z)
- At least one number (0-9)
- At least one special character (@$!%*?&#)

**Examples:**
- ✅ Correct: `TestPass123!`
- ❌ Wrong: `testpass` (no uppercase, number, or special char)
- ❌ Wrong: `Test1234` (no special character)
- ❌ Wrong: `Test!` (too short, no number)

### 3. Invalid Username

**Requirements:**
- Alphanumeric only (no special characters)
- 3-30 characters

**Examples:**
- ✅ Correct: `testbuyer`, `buyer123`
- ❌ Wrong: `test-buyer` (contains hyphen)
- ❌ Wrong: `te` (too short)
- ❌ Wrong: `test_buyer` (contains underscore)

### 4. Invalid User Type

**Requirements:** Must be exactly one of: `buyer`, `seller`, `rider`

**Examples:**
- ✅ Correct: `buyer`
- ❌ Wrong: `Buyer` (case sensitive)
- ❌ Wrong: `customer` (not a valid type)

### 5. Duplicate User

If you've already created a user with the same username or phone number:

**Error:** `Username or phone number already exists`

**Solution:** Use unique usernames and phone numbers for each test run. The new test script automatically generates unique values using timestamps.

## OTP Verification

In development mode, the OTP code is logged to the backend console. Look for:

```
OTP Code for +233XXXXXXXXX: 123456
```

The test script uses `123456` as the default OTP. If you've configured a different OTP, update the script.

## Database Connection Issues

If tests fail with database errors:

1. Check PostgreSQL is running:
   ```bash
   sudo systemctl status postgresql
   ```

2. Verify connection settings in `.env`:
   ```
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=suresend_db
   DB_USER=your_user
   DB_PASSWORD=your_password
   ```

3. Test database connection:
   ```bash
   psql -h localhost -U your_user -d suresend_db
   ```

## Manual Testing

You can also test endpoints manually with curl:

### Register a User

```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testbuyer123",
    "phoneNumber": "+233241234567",
    "password": "TestPass123!",
    "fullName": "Test Buyer",
    "userType": "buyer",
    "email": "test@example.com"
  }'
```

### Verify OTP

```bash
curl -X POST http://localhost:3000/api/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "+233241234567",
    "otpCode": "123456",
    "purpose": "registration"
  }'
```

## Debugging Tips

### View Detailed Error Messages

The new test script shows detailed error messages. Look for:

```
❌ FAIL: Buyer registration
   Details: HTTP 400: {"status":"error","message":"Validation error",...}
```

### Check Backend Logs

The backend logs show detailed errors:

```bash
cd backend
npm start  # Watch the console output
```

### Use jq for Better JSON Parsing

Install jq for formatted JSON output:

```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq
```

## Environment Setup

Before running tests, ensure:

1. Backend is running:
   ```bash
   cd backend
   npm install
   npm start
   ```

2. Database is initialized:
   ```bash
   psql -U postgres -d suresend_db -f migrations/001_initial_schema.sql
   ```

3. Environment variables are set (`.env` file exists)

## Test Coverage

### Stage 3 Tests Include:

- ✅ User Registration (Buyer, Seller, Rider)
- ✅ OTP Verification
- 🔄 Escrow Creation (Coming soon)
- 🔄 Transaction Flow (Coming soon)
- 🔄 Delivery Management (Coming soon)

## Troubleshooting Checklist

- [ ] Backend server is running at http://localhost:3000
- [ ] Database is connected and running
- [ ] `.env` file exists with correct credentials
- [ ] Phone numbers are in correct format (+233XXXXXXXXX)
- [ ] Passwords meet all requirements
- [ ] Usernames are alphanumeric only
- [ ] No duplicate users in database
- [ ] OTP code matches what's logged in backend console

## Getting Help

If you're still having issues:

1. Check the exact error message in the test output
2. Review backend console logs
3. Verify all validation requirements above
4. Try manual curl commands to isolate the issue
5. Check database for existing test data

## Clean Up Test Data

To remove test users from database:

```sql
-- Be careful! This deletes all test users
DELETE FROM users WHERE username LIKE 'test%';
DELETE FROM otp_verifications WHERE phone_number LIKE '+233%';
```
