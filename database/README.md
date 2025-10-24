# SureSend Database Setup

## Prerequisites
- PostgreSQL 14+ installed
- PostgreSQL running on localhost:5432
- Admin access to PostgreSQL

## Quick Setup

### Option 1: Automated Setup (Recommended)
```bash
# From the database directory
cd database

# Create database and setup tables (Linux/Mac)
psql -U postgres -f scripts/create_database.sql
psql -U postgres -d suresend_db -f scripts/setup.sql
```

### Option 2: Manual Setup
```bash
# Step 1: Create the database
psql -U postgres
CREATE DATABASE suresend_db;
\q

# Step 2: Run setup script
psql -U postgres -d suresend_db -f scripts/setup.sql
```

## Default Credentials
After setup, a default admin user is created:
- **Username**: `admin`
- **Phone**: `+233000000000`
- **Password**: `Admin@123`

**IMPORTANT**: Change this password immediately in production!

## Database Schema

### Tables Created
1. **users** - User accounts (buyers, sellers, riders)
2. **wallets** - User wallet balances
3. **transactions** - All payment transactions
4. **escrow_accounts** - Escrow holdings
5. **otp_verifications** - OTP codes for authentication
6. **kyc_documents** - KYC document uploads
7. **transaction_logs** - Transaction audit trail
8. **notifications** - User notifications
9. **wallet_transactions** - Wallet movement history
10. **disputes** - Transaction disputes

### User Types
- `buyer` - Can make purchases and pay into escrow
- `seller` - Can receive payments from escrow
- `rider` - Can handle deliveries

### Transaction Statuses
- `pending` - Payment initiated
- `in_escrow` - Funds held in escrow
- `completed` - Transaction successful
- `refunded` - Funds returned to buyer
- `disputed` - Under dispute resolution
- `cancelled` - Transaction cancelled

## Verification

### Check if database exists
```bash
psql -U postgres -l | grep suresend_db
```

### Check tables
```bash
psql -U postgres -d suresend_db -c "\dt"
```

### View admin user
```bash
psql -U postgres -d suresend_db -c "SELECT username, phone_number, user_type FROM users WHERE username='admin';"
```

## Troubleshooting

### Connection Issues
If you get connection errors:
```bash
# Check if PostgreSQL is running
sudo systemctl status postgresql

# Start PostgreSQL if not running
sudo systemctl start postgresql
```

### Permission Issues
```bash
# Grant all privileges to postgres user
psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'postgres';"
```

### Reset Database
```bash
# Drop and recreate everything
psql -U postgres -f scripts/create_database.sql
psql -U postgres -d suresend_db -f scripts/setup.sql
```

## Migrations (Future)
Migration scripts will be added in the `migrations/` directory as the schema evolves.

## Seeds (Future)
Test data scripts will be added in the `seeds/` directory for development testing.

## Backup & Restore

### Backup
```bash
pg_dump -U postgres suresend_db > backup_$(date +%Y%m%d).sql
```

### Restore
```bash
psql -U postgres -d suresend_db < backup_20240101.sql
```
