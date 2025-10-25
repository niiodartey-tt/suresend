# Changelog

All notable changes to the SureSend project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-10-25

### 🚨 BREAKING CHANGES

#### Unified User Model
- **User accounts** can now both buy and sell with a single account
- User type ENUM changed from `(buyer, seller, rider)` to `(user, rider)`
- Separate buyer and seller accounts merged into unified user accounts
- All existing buyers and sellers automatically migrated to 'user' type

### ✨ Added

#### Mobile App
- **Unified Dashboard** with role toggle tabs (Buying/Selling)
  - Dynamic stats display based on selected role
  - Context-aware quick actions
  - Combined transaction list with role indicators
- **Improved Registration** - Simplified to "User" or "Rider" account types
- **Role-based Transaction Filtering** - Filter transactions by your role (buyer/seller/rider)
- **Transaction Role Badges** - Visual indicators showing your role in each transaction

#### Backend
- **Username-based Payment Search** - Find users by username for payments
- **Flexible User Type Validation** - Updated to accept new user types
- **Enhanced Transaction Search** - Search all users with optional rider exclusion

#### Database
- **Migration Scripts**
  - Forward migration: `001_unified_user_model.sql`
  - Rollback migration: `002_rollback_unified_model.sql`
- **Automatic Backup** - Migration creates backup table before changes
- **Data Integrity Checks** - Built-in verification steps

### 🔄 Changed

#### Mobile App
- Dashboard routing: Users → UnifiedDashboard, Riders → RiderDashboard
- Registration flow: Removed buyer/seller distinction
- Transaction list: Added role parameter for initial filtering
- User model: Added `isUser` helper, updated `isBuyer`/`isSeller` for backward compatibility

#### Backend
- **API Endpoints**
  - `POST /api/v1/auth/register`: `userType` now accepts `['user', 'rider']`
  - `GET /api/v1/transactions/search-users`: New `excludeRiders` param replaces `userType`
  - `POST /api/v1/escrow/create`: Now open to all users (not just buyers)

- **Authorization**
  - Escrow routes: Changed from `authorize('buyer')` to `authorize('user')`
  - Business logic still enforces correct permissions (buyer confirms delivery, etc.)

- **Validation**
  - Updated Joi schemas to validate new user types
  - Removed seller-type checks in escrow creation

#### Database
- User type ENUM updated
- All buyer/seller records migrated to 'user'
- Transaction history fully preserved

### 🗑️ Removed

#### Mobile App
- **Deleted Files**:
  - `mobile/lib/screens/dashboard/buyer_dashboard.dart`
  - `mobile/lib/screens/dashboard/seller_dashboard.dart`
- Separate dashboards replaced with unified dashboard

### 📚 Documentation

#### Added
- **UNIFIED_USER_MODEL_MIGRATION.md** - Complete migration guide with:
  - Step-by-step migration instructions
  - Testing guide
  - Deployment checklist
  - Rollback procedures
  - Troubleshooting section

#### Updated
- **ARCHITECTURE.md** - Updated system diagrams and user model documentation
- **CHANGELOG.md** - This file

### 🔧 Technical Details

#### Files Modified (15 total)

**Backend (4 files)**:
- `backend/src/utils/validation.js`
- `backend/src/routes/escrow.js`
- `backend/src/controllers/escrowController.js`
- `backend/src/controllers/transactionController.js`

**Mobile (8 files)**:
- `mobile/lib/screens/auth/register_screen.dart`
- `mobile/lib/screens/auth/otp_verification_screen.dart`
- `mobile/lib/screens/splash_screen.dart`
- `mobile/lib/screens/dashboard/unified_dashboard.dart` (NEW)
- `mobile/lib/screens/transactions/transaction_list_screen.dart`
- `mobile/lib/models/user.dart`

**Database (2 files)**:
- `database/migrations/001_unified_user_model.sql` (NEW)
- `database/migrations/002_rollback_unified_model.sql` (NEW)

**Documentation (3 files)**:
- `docs/UNIFIED_USER_MODEL_MIGRATION.md` (NEW)
- `docs/ARCHITECTURE.md`
- `CHANGELOG.md` (NEW)

### 🛡️ Security & Compatibility

- ✅ **Backward Compatible**: All existing transactions preserved
- ✅ **Zero Data Loss**: Migration includes automatic backup
- ✅ **Rollback Ready**: Complete rollback script available
- ✅ **Permission Enforcement**: Business logic maintains proper authorization
- ✅ **API Versioning**: Changes maintain REST principles

### 🧪 Testing

See `docs/UNIFIED_USER_MODEL_MIGRATION.md` for complete testing guide including:
- Backend API tests
- Mobile UI tests
- Migration validation queries
- Rollback verification

### 📦 Migration

**Database Migration:**
```bash
psql -U postgres -d suresend_db -f database/migrations/001_unified_user_model.sql
```

**Rollback (if needed):**
```bash
psql -U postgres -d suresend_db -f database/migrations/002_rollback_unified_model.sql
```

**Mobile App:**
- Users must update to v2.0.0 to access new unified dashboard
- Old app versions will continue to work but with deprecated user types

---

## [1.0.0] - 2025-10-XX

### Initial Release

#### Features
- User registration with OTP verification
- Separate buyer, seller, and rider accounts
- Escrow transaction management
- Wallet integration
- KYC document upload
- Transaction history and statistics
- Real-time notifications
- Dispute management
- Payment integration (Paystack, Mobile Money)

---

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your-org/suresend/tags).

---

**Legend:**
- 🚨 Breaking Changes
- ✨ Added
- 🔄 Changed
- 🗑️ Removed
- 🐛 Fixed
- 📚 Documentation
- 🔒 Security
- 🔧 Technical
