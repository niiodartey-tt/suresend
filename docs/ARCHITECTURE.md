# SureSend System Architecture

## System Overview
SureSend is built on a three-tier architecture:
1. **Presentation Layer**: Flutter mobile app
2. **Application Layer**: Node.js REST API
3. **Data Layer**: PostgreSQL database

## Architecture Diagram
```
┌─────────────────────────────────────────────────┐
│           Flutter Mobile App (iOS/Android)       │
│  ┌───────────────────┐        ┌──────────┐     │
│  │     Unified       │        │  Rider   │     │
│  │    Dashboard      │        │Dashboard │     │
│  │ (Buy/Sell Tabs)   │        │          │     │
│  └───────────────────┘        └──────────┘     │
└─────────────────────┬───────────────────────────┘
                      │ HTTPS/REST API
                      ▼
┌─────────────────────────────────────────────────┐
│          Node.js Express Backend API            │
│  ┌──────────────────────────────────────┐      │
│  │  Authentication Middleware (JWT)     │      │
│  └──────────────────────────────────────┘      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │   Auth   │  │  Escrow  │  │ Payment  │     │
│  │ Service  │  │ Service  │  │ Service  │     │
│  └──────────┘  └──────────┘  └──────────┘     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │   User   │  │  Wallet  │  │   SMS    │     │
│  │ Service  │  │ Service  │  │ Service  │     │
│  └──────────┘  └──────────┘  └──────────┘     │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│            PostgreSQL Database                   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │  users   │  │transactions│ │  escrow  │     │
│  └──────────┘  └──────────┘  └──────────┘     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ wallets  │  │  riders  │  │   kyc    │      │
│  └──────────┘  └──────────┘  └──────────┘     │
└─────────────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│          External Services                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ Paystack │  │  Twilio  │  │MobileMoney│     │
│  │   API    │  │   SMS    │  │   APIs    │     │
│  └──────────┘  └──────────┘  └──────────┘     │
└─────────────────────────────────────────────────┘
```

## Database Schema

### Users Table
```sql
users
├── id (UUID, PK)
├── username (VARCHAR, UNIQUE)
├── phone_number (VARCHAR, UNIQUE)
├── password_hash (VARCHAR)
├── full_name (VARCHAR)
├── user_type (ENUM: 'user', 'rider')  ← UPDATED v2.0.0
├── email (VARCHAR, NULLABLE)
├── is_verified (BOOLEAN)
├── kyc_status (ENUM: 'pending', 'approved', 'rejected')
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)

Note: v2.0.0 unified buyer and seller types into 'user'
All users can now both buy and sell with a single account.
```

### Wallets Table
```sql
wallets
├── id (UUID, PK)
├── user_id (UUID, FK -> users)
├── balance (DECIMAL)
├── currency (VARCHAR, default 'GHS')
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### Transactions Table
```sql
transactions
├── id (UUID, PK)
├── transaction_ref (VARCHAR, UNIQUE)
├── buyer_id (UUID, FK -> users)
├── seller_id (UUID, FK -> users)
├── rider_id (UUID, FK -> users, NULLABLE)
├── amount (DECIMAL)
├── commission (DECIMAL)
├── status (ENUM: 'pending', 'in_escrow', 'completed', 'refunded', 'disputed')
├── type (ENUM: 'escrow', 'direct')
├── description (TEXT)
├── payment_method (VARCHAR)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### Escrow Accounts Table
```sql
escrow_accounts
├── id (UUID, PK)
├── transaction_id (UUID, FK -> transactions)
├── amount (DECIMAL)
├── status (ENUM: 'held', 'released', 'refunded')
├── held_at (TIMESTAMP)
├── released_at (TIMESTAMP, NULLABLE)
└── notes (TEXT, NULLABLE)
```

### OTP Verification Table
```sql
otp_verifications
├── id (UUID, PK)
├── phone_number (VARCHAR)
├── otp_code (VARCHAR)
├── purpose (ENUM: 'registration', 'login', 'transaction')
├── expires_at (TIMESTAMP)
├── verified (BOOLEAN)
└── created_at (TIMESTAMP)
```

### KYC Documents Table
```sql
kyc_documents
├── id (UUID, PK)
├── user_id (UUID, FK -> users)
├── document_type (ENUM: 'id_card', 'selfie')
├── document_url (VARCHAR)
├── status (ENUM: 'pending', 'approved', 'rejected')
├── uploaded_at (TIMESTAMP)
└── verified_at (TIMESTAMP, NULLABLE)
```

## API Endpoints Structure

### Authentication
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/verify-otp` - Verify OTP
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/logout` - User logout
- `POST /api/v1/auth/refresh-token` - Refresh JWT token

### Users
- `GET /api/v1/users/profile` - Get user profile
- `PUT /api/v1/users/profile` - Update user profile
- `POST /api/v1/users/kyc` - Submit KYC documents
- `GET /api/v1/users/kyc-status` - Get KYC status

### Wallet
- `GET /api/v1/wallet/balance` - Get wallet balance
- `POST /api/v1/wallet/fund` - Fund wallet
- `POST /api/v1/wallet/withdraw` - Withdraw from wallet
- `GET /api/v1/wallet/transactions` - Get wallet transactions

### Escrow
- `POST /api/v1/escrow/create` - Create escrow transaction
- `GET /api/v1/escrow/:id` - Get escrow details
- `POST /api/v1/escrow/:id/confirm-delivery` - Buyer confirms delivery
- `POST /api/v1/escrow/:id/dispute` - Raise dispute
- `POST /api/v1/escrow/:id/cancel` - Cancel escrow

### Transactions
- `GET /api/v1/transactions` - Get user transactions
- `GET /api/v1/transactions/:id` - Get transaction details
- `POST /api/v1/transactions/direct` - Create direct payment

### Riders (for rider users)
- `GET /api/v1/riders/available-deliveries` - Get available deliveries
- `POST /api/v1/riders/accept/:transactionId` - Accept delivery
- `POST /api/v1/riders/complete/:transactionId` - Mark delivery complete

## Security Measures
1. **Authentication**: JWT tokens with refresh mechanism
2. **Password**: Bcrypt hashing with salt
3. **Data**: AES-256 encryption for sensitive data
4. **Transport**: HTTPS/TLS 1.3
5. **OTP**: 6-digit codes with 5-minute expiry
6. **Rate Limiting**: API rate limiting per IP/user
7. **Input Validation**: Joi schema validation
8. **SQL Injection**: Parameterized queries
9. **CORS**: Configured for mobile app only

## Payment Flow

### Escrow Payment Flow
1. Buyer initiates transaction
2. Buyer pays into escrow (funds held in segregated account)
3. Seller notified of payment
4. Seller dispatches goods
5. Rider picks up (optional)
6. Buyer receives goods
7. Buyer confirms delivery
8. Funds released to seller (minus 2% commission)
9. Notifications sent to all parties

### Direct Payment Flow
1. User initiates direct payment
2. User enters recipient's SureSend ID
3. OTP verification
4. Payment processed immediately
5. Both parties notified

## Notification System
- **SMS**: Twilio (production), Firebase (dev)
- **In-App**: WebSocket/Push notifications
- **Events Triggering Notifications**:
  - Registration OTP
  - Login OTP
  - Payment received
  - Escrow status changes
  - Fund release/refund
  - Delivery updates

## Error Handling
- Standardized error response format
- HTTP status codes
- Error logging with stack traces
- User-friendly error messages

## Performance Considerations
- Database indexing on frequently queried fields
- Connection pooling for database
- Caching with Redis (future enhancement)
- Pagination for large data sets
- Background jobs for heavy operations

## Future Enhancements
- Blockchain-based escrow ledger
- Multi-currency support
- Escrow insurance
- Automated dispute resolution (AI)
- Analytics dashboard
- Mobile app for admin panel
