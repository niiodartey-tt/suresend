# Authentication API Testing Guide

This guide shows how to test the authentication endpoints using curl or any HTTP client.

## Prerequisites
- Backend server running on http://localhost:3000
- PostgreSQL database set up

## Test Endpoints

### 1. Register a New User

**Request:**
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

**Expected Response:**
```json
{
  "status": "success",
  "message": "Registration successful. OTP sent to your phone.",
  "data": {
    "user": {
      "id": "uuid",
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

**Check Terminal Output:**
Look for the OTP code in your terminal where the backend is running.

---

### 2. Verify OTP (Complete Registration)

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -D '{
    "phoneNumber": "+233241234567",
    "otpCode": "123456",
    "purpose": "registration"
  }'
```

**Expected Response:**
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
      "email": "testbuyer@example.com",
      "isVerified": true,
      "kycStatus": "pending",
      "walletBalance": "0.00"
    }
  }
}
```

**Save the accessToken** - you'll need it for authenticated requests.

---

### 3. Login

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "identifier": "testbuyer",
    "password": "Test@1234"
  }'
```

**Expected Response:**
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

**Check Terminal Output** for the login OTP code.

---

### 4. Verify Login OTP

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "+233241234567",
    "otpCode": "123456",
    "purpose": "login"
  }'
```

**Expected Response:**
Same as step 2 - includes accessToken and user data.

---

### 5. Get User Profile (Authenticated)

**Request:**
```bash
curl -X GET http://localhost:3000/api/v1/users/profile \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN_HERE"
```

**Expected Response:**
```json
{
  "status": "success",
  "message": "Profile retrieved successfully",
  "data": {
    "user": {
      "id": "uuid",
      "username": "testbuyer",
      "phoneNumber": "+233241234567",
      "fullName": "Test Buyer",
      "userType": "buyer",
      "email": "testbuyer@example.com",
      "isVerified": true,
      "kycStatus": "pending"
    },
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

### 6. Update Profile (Authenticated)

**Request:**
```bash
curl -X PUT http://localhost:3000/api/v1/users/profile \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Test Buyer Updated",
    "email": "updated@example.com"
  }'
```

---

### 7. Resend OTP

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/resend-otp \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "+233241234567",
    "purpose": "login"
  }'
```

---

### 8. Logout (Authenticated)

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/logout \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN_HERE"
```

---

## Test Different User Types

### Register a Seller
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

### Register a Rider
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

---

## Error Cases

### Invalid Credentials
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "identifier": "testbuyer",
    "password": "WrongPassword"
  }'
```

**Expected Response:**
```json
{
  "status": "error",
  "message": "Invalid credentials"
}
```

### Missing Token
```bash
curl -X GET http://localhost:3000/api/v1/users/profile
```

**Expected Response:**
```json
{
  "status": "error",
  "message": "No token provided"
}
```

### Invalid OTP
```bash
curl -X POST http://localhost:3000/api/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "+233241234567",
    "otpCode": "000000",
    "purpose": "login"
  }'
```

**Expected Response:**
```json
{
  "status": "error",
  "message": "Invalid OTP code"
}
```

---

## Using Postman

1. Import the endpoints into Postman
2. Create an environment variable for `accessToken`
3. Set up authorization header: `Bearer {{accessToken}}`
4. Test the flow: Register → Verify OTP → Login → Verify OTP → Access Protected Routes

---

## Notes

- OTP codes are logged to the console in development mode
- In production, OTP codes will be sent via SMS (Twilio)
- Access tokens expire after 24 hours (configurable in .env)
- Refresh tokens expire after 7 days (configurable in .env)
- All phone numbers must be in format: +233XXXXXXXXX (Ghana)
- Passwords must contain: uppercase, lowercase, number, special character
