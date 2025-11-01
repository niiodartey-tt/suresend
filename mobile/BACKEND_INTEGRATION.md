# Backend Integration Guide

## Overview

This document provides a comprehensive guide for integrating the SureSend mobile app with the backend API.

## Architecture

### Service Layer
- **ApiService**: Base HTTP client for all API calls (`lib/services/api_service.dart`)
- **AuthService**: Authentication-specific operations
- **TransactionService**: Transaction-related operations
- **WalletService**: Wallet and payment operations

### State Management
- **Provider Pattern**: Used for state management across the app
- **AuthProvider**: Manages authentication state
- **TransactionProvider**: Manages transaction data
- **WalletProvider**: Manages wallet balance and operations
- **NotificationProvider**: Manages notifications

### Routing
- **AppRoutes**: Named route constants (`lib/config/routes.dart`)
- **AppRouteGenerator**: Centralized route generation with argument passing

## Configuration

### API Base URL

Update the API base URL in `lib/config/app_config.dart`:

```dart
static const String apiBaseUrl = 'YOUR_BACKEND_URL/api/v1';
```

For local development:
```dart
static const String apiBaseUrl = 'http://localhost:3000/api/v1';
```

For production:
```dart
static const String apiBaseUrl = 'https://api.suresend.com/api/v1';
```

## API Endpoints

### Authentication

#### Login
```
POST /auth/login
Body: {
  "email": "user@example.com",
  "password": "password123"
}
Response: {
  "success": true,
  "data": {
    "token": "jwt_token_here",
    "user": { ... }
  }
}
```

#### Verify OTP
```
POST /auth/verify-otp
Body: {
  "email": "user@example.com",
  "otp": "123456"
}
Response: {
  "success": true,
  "data": {
    "verified": true
  }
}
```

#### Logout
```
POST /auth/logout
Headers: Authorization: Bearer {token}
Response: {
  "success": true,
  "message": "Logged out successfully"
}
```

### Transactions

#### Get All Transactions
```
GET /transactions?status=in_escrow&limit=20&offset=0
Headers: Authorization: Bearer {token}
Response: {
  "success": true,
  "data": {
    "transactions": [
      {
        "id": "ESC-12345",
        "item": "iPhone 15 Pro",
        "amount": 850.00,
        "status": "in_escrow",
        "buyer": { "id": "...", "name": "John Doe" },
        "seller": { "id": "...", "name": "Jane Smith" },
        "createdAt": "2025-10-28T14:30:00Z"
      }
    ],
    "total": 45,
    "limit": 20,
    "offset": 0
  }
}
```

#### Get Transaction by ID
```
GET /transactions/:id
Headers: Authorization: Bearer {token}
Response: {
  "success": true,
  "data": {
    "transaction": {
      "id": "ESC-12345",
      "item": "iPhone 15 Pro",
      "category": "Physical Product",
      "amount": 850.00,
      "status": "in_escrow",
      "description": "Brand new iPhone 15 Pro",
      "buyer": { "id": "...", "name": "John Doe", "username": "@johndoe" },
      "seller": { "id": "...", "name": "Jane Smith", "username": "@janesmith" },
      "createdAt": "2025-10-28T14:30:00Z",
      "updatedAt": "2025-10-28T14:30:00Z"
    }
  }
}
```

#### Create Buy Transaction
```
POST /transactions/buy
Headers: Authorization: Bearer {token}
Body: {
  "item": "iPhone 15 Pro",
  "category": "Physical Product",
  "seller": "@seller_username",
  "amount": 850.00,
  "description": "Brand new iPhone 15 Pro"
}
Response: {
  "success": true,
  "data": {
    "transaction": {
      "id": "ESC-12345",
      ...
    }
  }
}
```

#### Create Sell Transaction
```
POST /transactions/sell
Headers: Authorization: Bearer {token}
Body: {
  "item": "MacBook Pro",
  "category": "Physical Product",
  "buyer": "@buyer_username",
  "amount": 1200.00,
  "description": "MacBook Pro 2024"
}
Response: {
  "success": true,
  "data": {
    "transaction": {
      "id": "ESC-12346",
      ...
    }
  }
}
```

#### Confirm Transaction (Release Funds)
```
POST /transactions/:id/confirm
Headers: Authorization: Bearer {token}
Body: {
  "pin": "1234"
}
Response: {
  "success": true,
  "message": "Transaction confirmed. Funds released to seller."
}
```

#### Raise Dispute
```
POST /transactions/:id/dispute
Headers: Authorization: Bearer {token}
Body: {
  "reason": "Item not as described"
}
Response: {
  "success": true,
  "message": "Dispute raised successfully"
}
```

### Wallet

#### Get Wallet Balance
```
GET /wallet/balance
Headers: Authorization: Bearer {token}
Response: {
  "success": true,
  "data": {
    "balance": 4500.00,
    "escrowBalance": 200.00,
    "currency": "USD"
  }
}
```

#### Fund Wallet
```
POST /wallet/fund
Headers: Authorization: Bearer {token}
Body: {
  "amount": 100.00,
  "paymentMethod": "MTN"
}
Response: {
  "success": true,
  "data": {
    "reference": "REF-123456",
    "amount": 100.00,
    "status": "pending"
  }
}
```

#### Withdraw Funds
```
POST /wallet/withdraw
Headers: Authorization: Bearer {token}
Body: {
  "amount": 500.00,
  "method": "Bank",
  "accountDetails": {
    "accountNumber": "1234567890",
    "accountName": "John Doe"
  }
}
Response: {
  "success": true,
  "data": {
    "reference": "WD-123456",
    "amount": 500.00,
    "status": "processing"
  }
}
```

### Profile

#### Get Profile
```
GET /profile
Headers: Authorization: Bearer {token}
Response: {
  "success": true,
  "data": {
    "profile": {
      "id": "USER-123",
      "name": "John Doe",
      "username": "@johndoe",
      "email": "john@example.com",
      "phone": "+233123456789",
      "verified": true,
      "memberSince": "2024-01-15"
    }
  }
}
```

#### Update Profile
```
PUT /profile
Headers: Authorization: Bearer {token}
Body: {
  "name": "John Updated Doe",
  "phone": "+233987654321"
}
Response: {
  "success": true,
  "message": "Profile updated successfully"
}
```

#### Change Password
```
POST /profile/change-password
Headers: Authorization: Bearer {token}
Body: {
  "currentPassword": "oldpass123",
  "newPassword": "newpass456"
}
Response: {
  "success": true,
  "message": "Password changed successfully"
}
```

## Error Handling

All errors follow this format:

```json
{
  "success": false,
  "error": "Error message here",
  "statusCode": 400
}
```

### Common Status Codes

- `200`: Success
- `201`: Created
- `400`: Bad Request
- `401`: Unauthorized (invalid token or session expired)
- `403`: Forbidden (insufficient permissions)
- `404`: Not Found
- `500`: Internal Server Error

### Error Handling in App

Use the `ErrorHandler` utility:

```dart
import 'package:suresend/utils/error_handler.dart';

try {
  final result = await apiService.get('transactions');
  // Handle success
} catch (error) {
  ErrorHandler.showError(context, error);
  ErrorHandler.logError(error, stackTrace: stackTrace);
}
```

## Testing Backend Integration

### 1. Mock Server Setup

For testing without a backend, you can use a mock server:

```dart
// In lib/services/api_service.dart, add:
static const bool useMockData = true;

if (useMockData) {
  return _getMockData(endpoint);
}
```

### 2. Test Credentials

For development/testing:
- Email: `test@suresend.com`
- Password: `Test123!`
- OTP: `123456`
- PIN: `1234`

### 3. Testing Checklist

#### Authentication Flow
- [ ] Login with valid credentials
- [ ] Login with invalid credentials (should show error)
- [ ] OTP verification
- [ ] Session persistence across app restarts
- [ ] Logout functionality

#### Transaction Flow
- [ ] Create buy transaction
- [ ] Create sell transaction
- [ ] View transaction list
- [ ] View transaction details
- [ ] Confirm transaction with PIN
- [ ] Raise dispute
- [ ] Transaction status updates

#### Wallet Flow
- [ ] View wallet balance
- [ ] Fund wallet with different payment methods
- [ ] Withdraw funds
- [ ] View wallet transaction history

#### Profile & Settings
- [ ] View profile information
- [ ] Update profile details
- [ ] Change password
- [ ] Update settings preferences

#### Navigation
- [ ] All routes work correctly
- [ ] Back navigation maintains state
- [ ] Deep linking to specific screens

#### Error Handling
- [ ] Network errors show appropriate messages
- [ ] API errors display user-friendly messages
- [ ] Offline mode handling
- [ ] Session expiry handling

## Integration with Existing Providers

### AuthProvider

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

// Login
await authProvider.login(email, password);

// Check auth state
if (authProvider.isAuthenticated) {
  // User is logged in
}

// Logout
await authProvider.logout();
```

### TransactionProvider

```dart
final transactionProvider = Provider.of<TransactionProvider>(context);

// Fetch transactions
await transactionProvider.fetchTransactions();

// Access transactions
final transactions = transactionProvider.transactions;

// Create transaction
await transactionProvider.createTransaction(data);
```

### WalletProvider

```dart
final walletProvider = Provider.of<WalletProvider>(context);

// Get balance
await walletProvider.fetchBalance();

// Fund wallet
await walletProvider.fundWallet(amount, method);

// Withdraw
await walletProvider.withdraw(amount, details);
```

## Production Deployment

### Environment Variables

Create a `.env` file:

```
API_BASE_URL=https://api.suresend.com/api/v1
ENVIRONMENT=production
```

### Security Considerations

1. **Token Storage**: Use `flutter_secure_storage` for auth tokens
2. **SSL Pinning**: Implement certificate pinning for API calls
3. **API Key**: Include API key in headers if required
4. **Rate Limiting**: Handle rate limit errors gracefully
5. **Data Encryption**: Encrypt sensitive data before storage

### Monitoring

- Implement error tracking (e.g., Sentry)
- Add analytics for user actions
- Monitor API response times
- Track failed requests

## Troubleshooting

### Common Issues

#### "Network Error" on all API calls
- Check `apiBaseUrl` in `app_config.dart`
- Verify backend is running
- Check device/emulator internet connection

#### "Unauthorized" errors
- Token may have expired
- Clear app data and login again
- Check token storage in SharedPreferences

#### Transactions not loading
- Verify API endpoint format
- Check authentication token
- Ensure backend returns correct data structure

#### Navigation not working
- Check route names in `routes.dart`
- Verify arguments are passed correctly
- Check `onGenerateRoute` in `main.dart`

## Support

For backend API issues:
- Backend repository: [Link to backend repo]
- API documentation: [Link to API docs]
- Support email: support@suresend.com
