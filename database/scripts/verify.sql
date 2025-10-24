-- SureSend Database Verification Script
-- This script checks if the database is set up correctly

\echo '========================================='
\echo '  SureSend Database Verification'
\echo '========================================='
\echo ''

-- Check if database exists
\echo '1. Checking database connection...'
SELECT current_database() as connected_database;
\echo ''

-- Count tables
\echo '2. Checking tables...'
SELECT COUNT(*) as table_count FROM information_schema.tables
WHERE table_schema = 'public';
\echo ''

-- List all tables
\echo '3. Listing all tables:'
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
\echo ''

-- Check users table
\echo '4. Checking users table...'
SELECT COUNT(*) as total_users FROM users;
\echo ''

-- List all users
\echo '5. Current users in system:'
SELECT username, phone_number, user_type, is_verified, kyc_status
FROM users;
\echo ''

-- Check wallets
\echo '6. Checking wallets...'
SELECT COUNT(*) as total_wallets FROM wallets;
\echo ''

-- Check OTP verifications
\echo '7. Recent OTP verifications (last 10):'
SELECT phone_number, purpose, verified, created_at
FROM otp_verifications
ORDER BY created_at DESC
LIMIT 10;
\echo ''

-- Check transactions
\echo '8. Checking transactions...'
SELECT COUNT(*) as total_transactions FROM transactions;
\echo ''

-- Check escrow accounts
\echo '9. Checking escrow accounts...'
SELECT COUNT(*) as total_escrow_accounts FROM escrow_accounts;
\echo ''

-- Verify indexes
\echo '10. Checking indexes...'
SELECT COUNT(*) as index_count
FROM pg_indexes
WHERE schemaname = 'public';
\echo ''

\echo '========================================='
\echo '  Verification Complete!'
\echo '========================================='
\echo ''
\echo 'Expected results:'
\echo '- Table count: 10'
\echo '- At least 1 user (admin)'
\echo '- At least 1 wallet'
\echo '- Multiple indexes'
\echo ''
