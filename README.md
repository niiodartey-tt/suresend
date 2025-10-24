# SureSend - Mobile Escrow Payment Platform for Ghana

## Overview
SureSend is a secure escrow-based mobile payment platform that ensures safe transactions between buyers and sellers in Ghana. The platform holds funds in escrow until delivery confirmation, protecting both parties from fraud.

## Tech Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Node.js with Express
- **Database**: PostgreSQL
- **Authentication**: Custom Auth (Username/Phone + Password + OTP)
- **SMS**: Firebase (dev) / Twilio (production)
- **Payment**: Paystack, Mobile Money APIs (MTN, Vodafone, AirtelTigo)

## Project Structure
```
suresend/
├── backend/                 # Node.js Express API
│   ├── src/
│   │   ├── config/         # Configuration files
│   │   ├── controllers/    # Request handlers
│   │   ├── models/         # Database models
│   │   ├── routes/         # API routes
│   │   ├── middleware/     # Custom middleware
│   │   └── utils/          # Utility functions
│   ├── tests/              # Backend tests
│   └── package.json
├── mobile/                 # Flutter mobile app
│   ├── lib/
│   │   ├── models/         # Data models
│   │   ├── screens/        # UI screens
│   │   ├── services/       # API services
│   │   ├── widgets/        # Reusable widgets
│   │   └── utils/          # Helper functions
│   └── pubspec.yaml
├── database/               # Database setup
│   ├── migrations/         # Database migrations
│   ├── seeds/              # Seed data
│   └── scripts/            # DB utility scripts
└── docs/                   # Documentation

```

## User Types
1. **Buyer** - Initiates purchases and pays into escrow
2. **Seller** - Receives payment after delivery confirmation
3. **Rider** - Handles delivery between buyer and seller

## Core Features
- User registration with OTP verification
- Secure login with 2FA (OTP)
- Escrow payment system
- Wallet management
- Direct payments (non-escrow)
- KYC verification
- Real-time notifications (SMS + In-app)
- Transaction history
- Admin dashboard
- Dispute resolution

## Development Stages
- [x] Stage 1: System Architecture & Environment Setup
- [ ] Stage 2: Authentication & User Profiles
- [ ] Stage 3: Escrow Core Functionality
- [ ] Stage 4: Wallet & Payments
- [ ] Stage 5: UI Implementation
- [ ] Stage 6: Security & Fraud Layer
- [ ] Stage 7: Testing & Deployment

## Getting Started

### Prerequisites
- Node.js (v18+)
- PostgreSQL (v14+)
- Flutter SDK (v3.0+)
- npm or yarn

### Backend Setup
```bash
cd backend
npm install
npm run dev
```

### Mobile Setup
```bash
cd mobile
flutter pub get
flutter run
```

### Database Setup
```bash
cd database
psql -U postgres -f scripts/setup.sql
```

## Environment Variables
Create `.env` files in backend directory:
- `DATABASE_URL`
- `JWT_SECRET`
- `PAYSTACK_SECRET_KEY`
- `TWILIO_ACCOUNT_SID`
- `TWILIO_AUTH_TOKEN`

## License
Private - All Rights Reserved

## Contact
Project: SureSend Mobile Escrow Platform
