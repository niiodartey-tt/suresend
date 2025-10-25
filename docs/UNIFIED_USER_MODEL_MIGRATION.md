# Unified User Model Migration Guide

## Overview
This document describes the migration from separate buyer/seller accounts to a unified user model where each account can perform both buying and selling functions.

**Migration Date:** October 25, 2025
**Version:** 2.0.0
**Breaking Changes:** Yes

---

## Summary of Changes

### Before (v1.x)
- **User Types:** `buyer`, `seller`, `rider`
- **Dashboards:** Separate dashboards for buyers and sellers
- **Account Limitation:** Users needed separate accounts to buy AND sell

### After (v2.0.0)
- **User Types:** `user`, `rider`
- **Dashboards:** Unified dashboard with role toggle (Buying/Selling tabs)
- **Account Flexibility:** Single account can buy AND sell

---

## Database Changes

### Schema Updates

#### 1. user_type ENUM Type
```sql
-- Old ENUM
CREATE TYPE user_type_enum AS ENUM ('buyer', 'seller', 'rider');

-- New ENUM
CREATE TYPE user_type_enum AS ENUM ('user', 'rider');
```

#### 2. Data Migration
All existing `buyer` and `seller` user types automatically converted to `user`:

```sql
UPDATE users
SET user_type = 'user'
WHERE user_type IN ('buyer', 'seller');
```

#### 3. Transactions Table
**No changes required** - buyer_id and seller_id columns remain unchanged, preserving all transaction history.

### Running the Migration

**Location:** `/database/migrations/001_unified_user_model.sql`

```bash
# Backup database first!
pg_dump suresend_db > backup_$(date +%Y%m%d).sql

# Run migration
psql -U postgres -d suresend_db -f database/migrations/001_unified_user_model.sql
```

**Rollback Available:** `/database/migrations/002_rollback_unified_model.sql`

```bash
# If migration fails, rollback
psql -U postgres -d suresend_db -f database/migrations/002_rollback_unified_model.sql
```

---

## Backend Changes

### Files Modified

| File | Changes | Status |
|------|---------|--------|
| `backend/src/utils/validation.js` | Updated `userType` validation to accept `['user', 'rider']` only | ✅ Updated |
| `backend/src/routes/escrow.js` | Changed authorization from `authorize('buyer')` to `authorize('user')` | ✅ Updated |
| `backend/src/controllers/escrowController.js` | Removed seller-only type check, now accepts any user (not rider) | ✅ Updated |
| `backend/src/controllers/transactionController.js` | Updated `searchUsers()` to search all users, not just by type | ✅ Updated |

### API Changes

#### Authentication Endpoints
**POST /api/v1/auth/register**

```json
// Old request body
{
  "userType": "buyer" | "seller" | "rider"
}

// New request body
{
  "userType": "user" | "rider"
}
```

#### Transaction Search
**GET /api/v1/transactions/search-users**

```
Old: ?search=john&userType=seller
New: ?search=john&excludeRiders=true
```

#### Escrow Routes
No breaking changes - `buyer_id` and `seller_id` remain in transaction records.

**Permissions Updated:**
- ✅ Creating escrow: `buyer` only → `user` (can act as buyer)
- ✅ Confirming delivery: `buyer` only → `user` (must be transaction buyer)
- ✅ Disputes: `buyer` OR `seller` → `user` (must be involved in transaction)
- ✅ Cancellation: `buyer` only → `user` (must be transaction buyer)

---

## Mobile App Changes

### Files Modified

| File | Changes | Status |
|------|---------|--------|
| `mobile/lib/screens/auth/register_screen.dart` | Updated to show "User" and "Rider" options only | ✅ Updated |
| `mobile/lib/screens/dashboard/unified_dashboard.dart` | **NEW** - Combined buyer/seller dashboard with tabs | ✅ Created |
| `mobile/lib/screens/splash_screen.dart` | Routes users to UnifiedDashboard, riders to RiderDashboard | ✅ Updated |
| `mobile/lib/screens/auth/otp_verification_screen.dart` | Updated routing after authentication | ✅ Updated |
| `mobile/lib/screens/transactions/transaction_list_screen.dart` | Added optional `role` parameter for filtering | ✅ Updated |
| `mobile/lib/models/user.dart` | Updated helper methods, added `isUser` getter | ✅ Updated |

### Files Deleted

| File | Reason |
|------|--------|
| `mobile/lib/screens/dashboard/buyer_dashboard.dart` | ❌ Replaced by unified_dashboard.dart |
| `mobile/lib/screens/dashboard/seller_dashboard.dart` | ❌ Replaced by unified_dashboard.dart |

### New Features (Mobile)

#### Unified Dashboard
- **Role Toggle Tabs:** Switch between "Buying" and "Selling" views
- **Context-Aware Stats:** Shows purchases or sales based on selected tab
- **Quick Actions:** Different actions for buying vs selling modes
- **Combined Transaction List:** Shows transactions with role badges (Buyer/Seller)

#### Registration Flow
- Simplified to 2 options: "User (Buy & Sell)" or "Rider (Delivery)"
- Clearer messaging about account capabilities

---

## Testing Guide

### Backend Tests

#### 1. **Registration**
```bash
# Test user registration
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "phoneNumber": "+233241234567",
    "password": "Test@1234",
    "fullName": "Test User",
    "userType": "user",
    "email": "test@example.com"
  }'

# Expected: Success with user type 'user'
```

#### 2. **Escrow Creation (User as Buyer)**
```bash
# User should be able to create escrow transaction
curl -X POST http://localhost:3000/api/v1/escrow/create \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "sellerId": "<seller_user_id>",
    "amount": 100.00,
    "description": "Test transaction",
    "paymentMethod": "wallet"
  }'

# Expected: Success (user can act as buyer)
```

#### 3. **Transaction Statistics**
```bash
# Get combined stats (purchases + sales)
curl -X GET http://localhost:3000/api/v1/transactions/stats \
  -H "Authorization: Bearer <token>"

# Expected: Both purchases and sales data returned
```

#### 4. **User Search**
```bash
# Search for users (excluding riders)
curl -X GET "http://localhost:3000/api/v1/transactions/search-users?search=john&excludeRiders=true" \
  -H "Authorization: Bearer <token>"

# Expected: Only users returned, no riders
```

### Mobile Tests

#### 1. **Registration Flow**
- [ ] Open app and navigate to registration
- [ ] Verify only "User" and "Rider" options shown
- [ ] Register as "User"
- [ ] Verify successful registration

#### 2. **Unified Dashboard**
- [ ] Login as user
- [ ] Verify UnifiedDashboard loads
- [ ] Verify role toggle tabs (Buying/Selling) present
- [ ] Switch between tabs
- [ ] Verify stats update based on selected tab
- [ ] Verify quick actions change based on tab

#### 3. **Transaction Creation**
- [ ] Create transaction as buyer
- [ ] Verify transaction appears in "Buying" tab
- [ ] Verify transaction appears with "Buyer" badge
- [ ] Have another user create transaction with you as seller
- [ ] Verify it appears in "Selling" tab with "Seller" badge

#### 4. **Transaction List**
- [ ] Navigate to "All Transactions"
- [ ] Verify filter options include "As Buyer", "As Seller", "As Rider"
- [ ] Apply "As Buyer" filter
- [ ] Verify only buying transactions shown
- [ ] Apply "As Seller" filter
- [ ] Verify only selling transactions shown

### Migration Validation

#### Check Existing Users
```sql
-- Verify all buyers/sellers migrated to 'user'
SELECT user_type, COUNT(*)
FROM users
GROUP BY user_type;

-- Expected output:
-- user  | <count>
-- rider | <count>
```

#### Check Transaction Integrity
```sql
-- Verify all transactions preserved
SELECT COUNT(*) FROM transactions;

-- Verify buyer_id and seller_id still valid
SELECT COUNT(*)
FROM transactions t
JOIN users buyer ON t.buyer_id = buyer.id
JOIN users seller ON t.seller_id = seller.id;

-- Expected: All transactions have valid buyer and seller references
```

---

## Deployment Checklist

### Pre-Deployment

- [ ] **Backup production database**
  ```bash
  pg_dump suresend_db > suresend_backup_$(date +%Y%m%d_%H%M%S).sql
  ```

- [ ] **Test migration in staging environment**
  ```bash
  # Restore staging DB from production backup
  psql -U postgres -d suresend_staging < suresend_backup.sql

  # Run migration
  psql -U postgres -d suresend_staging -f database/migrations/001_unified_user_model.sql
  ```

- [ ] **Verify staging functionality**
  - [ ] User registration works
  - [ ] Existing users can login
  - [ ] Transactions display correctly
  - [ ] Escrow creation works
  - [ ] API endpoints respond correctly

- [ ] **Build and test mobile app**
  ```bash
  cd mobile
  flutter pub get
  flutter build apk --release
  # Test on physical device
  ```

### Deployment Steps

#### 1. **Deploy Backend**

```bash
# 1. Pull latest code
git pull origin claude/explore-repo-structure-011CUTRcJrsHVvHMCuvir7Z1

# 2. Install dependencies
cd backend
npm install

# 3. Run database migration
psql -U postgres -d suresend_db -f ../database/migrations/001_unified_user_model.sql

# 4. Restart backend server
pm2 restart suresend-backend

# 5. Verify server health
curl http://localhost:3000/health
```

#### 2. **Deploy Mobile App**

```bash
# 1. Build release version
cd mobile
flutter clean
flutter pub get
flutter build apk --release

# 2. Test release build
flutter install

# 3. Deploy to Play Store
# (Upload to Google Play Console)

# 4. Update version number
# pubspec.yaml: version: 2.0.0+2
```

### Post-Deployment

- [ ] **Monitor error logs** (first 24-48 hours)
  ```bash
  # Backend logs
  pm2 logs suresend-backend

  # Database logs
  tail -f /var/log/postgresql/postgresql-14-main.log
  ```

- [ ] **Verify key metrics**
  - [ ] User login success rate
  - [ ] Transaction creation rate
  - [ ] API error rates
  - [ ] Mobile app crash reports

- [ ] **Support existing users**
  - [ ] Send notification about unified accounts
  - [ ] Update documentation/FAQ
  - [ ] Monitor support tickets

---

## Rollback Procedure

**If critical issues occur:**

### 1. **Stop Services**
```bash
pm2 stop suresend-backend
```

### 2. **Restore Database**
```bash
# Option A: Use rollback script
psql -U postgres -d suresend_db -f database/migrations/002_rollback_unified_model.sql

# Option B: Restore from backup
psql -U postgres -d suresend_db < suresend_backup_<timestamp>.sql
```

### 3. **Revert Code**
```bash
git checkout <previous-version-tag>
cd backend && npm install
pm2 restart suresend-backend
```

### 4. **Notify Users**
- Send push notification about temporary service disruption
- Update status page

---

## Support & Troubleshooting

### Common Issues

#### Issue: "User type must be either user or rider" error

**Cause:** Frontend still sending old user types (`buyer`/`seller`)

**Fix:** Clear app cache and reinstall mobile app

---

#### Issue: Existing users can't login

**Cause:** Database migration not completed

**Fix:**
```sql
-- Check user types
SELECT DISTINCT user_type FROM users;

-- If still seeing 'buyer'/'seller', rerun migration
\i database/migrations/001_unified_user_model.sql
```

---

#### Issue: Transactions missing

**Cause:** Never occurs - transactions table unchanged

**Verification:**
```sql
SELECT COUNT(*) FROM transactions;
-- Should match pre-migration count
```

---

## Contact

**Technical Issues:** GitHub Issues
**Migration Support:** dev@suresend.com
**Emergency:** <emergency-contact>

---

## Appendix

### Files Changed Summary

**Database:**
- ✅ `/database/migrations/001_unified_user_model.sql` (NEW)
- ✅ `/database/migrations/002_rollback_unified_model.sql` (NEW)

**Backend:**
- ✅ `/backend/src/utils/validation.js`
- ✅ `/backend/src/routes/escrow.js`
- ✅ `/backend/src/controllers/escrowController.js`
- ✅ `/backend/src/controllers/transactionController.js`

**Mobile:**
- ✅ `/mobile/lib/screens/dashboard/unified_dashboard.dart` (NEW)
- ❌ `/mobile/lib/screens/dashboard/buyer_dashboard.dart` (DELETED)
- ❌ `/mobile/lib/screens/dashboard/seller_dashboard.dart` (DELETED)
- ✅ `/mobile/lib/screens/auth/register_screen.dart`
- ✅ `/mobile/lib/screens/auth/otp_verification_screen.dart`
- ✅ `/mobile/lib/screens/splash_screen.dart`
- ✅ `/mobile/lib/screens/transactions/transaction_list_screen.dart`
- ✅ `/mobile/lib/models/user.dart`

**Total:** 4 backend files, 8 mobile files, 2 migration scripts

---

**End of Migration Guide**
