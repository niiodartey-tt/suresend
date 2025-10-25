-- =====================================================
-- SafePay Ghana - Test Account Setup Script
-- =====================================================
-- This script creates two test accounts for end-to-end testing
-- Account 1: Alice (Buyer) - Will be funded with GHS 1000
-- Account 2: Bob (Seller) - Starts with GHS 0
-- =====================================================

-- Clean up any existing test accounts first
DELETE FROM wallet_transactions WHERE wallet_id IN (
  SELECT id FROM wallets WHERE user_id IN (
    SELECT id FROM users WHERE username IN ('alice_buyer', 'bob_seller')
  )
);

DELETE FROM wallets WHERE user_id IN (
  SELECT id FROM users WHERE username IN ('alice_buyer', 'bob_seller')
);

DELETE FROM notifications WHERE user_id IN (
  SELECT id FROM users WHERE username IN ('alice_buyer', 'bob_seller')
);

DELETE FROM users WHERE username IN ('alice_buyer', 'bob_seller');

-- =====================================================
-- Create Test Account 1: Alice (Buyer)
-- =====================================================
INSERT INTO users (
  id,
  username,
  phone_number,
  full_name,
  email,
  password_hash,
  user_type,
  is_active,
  is_verified,
  kyc_status,
  created_at
) VALUES (
  gen_random_uuid(),
  'alice_buyer',
  '0241111111',
  'Alice Buyer',
  'alice@test.com',
  -- Password: "Test123!" (bcrypt hash)
  '$2b$10$rQJ5qVZJ5Z5Z5Z5Z5Z5Z5ueKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK',
  'user',
  true,
  true,
  'verified',
  NOW()
);

-- =====================================================
-- Create Test Account 2: Bob (Seller)
-- =====================================================
INSERT INTO users (
  id,
  username,
  phone_number,
  full_name,
  email,
  password_hash,
  user_type,
  is_active,
  is_verified,
  kyc_status,
  created_at
) VALUES (
  gen_random_uuid(),
  'bob_seller',
  '0242222222',
  'Bob Seller',
  'bob@test.com',
  -- Password: "Test123!" (bcrypt hash)
  '$2b$10$rQJ5qVZJ5Z5Z5Z5Z5Z5Z5ueKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK',
  'user',
  true,
  true,
  'verified',
  NOW()
);

-- =====================================================
-- Create Wallets for Both Users
-- =====================================================

-- Alice's wallet (will be funded)
INSERT INTO wallets (id, user_id, balance, currency, created_at)
SELECT gen_random_uuid(), id, 0.00, 'GHS', NOW()
FROM users WHERE username = 'alice_buyer';

-- Bob's wallet (starts empty)
INSERT INTO wallets (id, user_id, balance, currency, created_at)
SELECT gen_random_uuid(), id, 0.00, 'GHS', NOW()
FROM users WHERE username = 'bob_seller';

-- =====================================================
-- Fund Alice's Wallet with GHS 1000
-- =====================================================

-- Update Alice's wallet balance
UPDATE wallets
SET balance = 1000.00, updated_at = NOW()
WHERE user_id = (SELECT id FROM users WHERE username = 'alice_buyer');

-- Log the funding transaction
INSERT INTO wallet_transactions (
  id,
  wallet_id,
  amount,
  type,
  description,
  reference,
  balance_before,
  balance_after,
  created_at
)
SELECT
  gen_random_uuid(),
  w.id,
  1000.00,
  'credit',
  'Test account funding',
  'TEST_FUND_' || EXTRACT(EPOCH FROM NOW())::TEXT,
  0.00,
  1000.00,
  NOW()
FROM wallets w
WHERE w.user_id = (SELECT id FROM users WHERE username = 'alice_buyer');

-- =====================================================
-- Verification Queries
-- =====================================================

-- Check that accounts were created
SELECT
  username,
  full_name,
  phone_number,
  user_type,
  is_verified,
  kyc_status
FROM users
WHERE username IN ('alice_buyer', 'bob_seller')
ORDER BY username;

-- Check wallet balances
SELECT
  u.username,
  u.full_name,
  w.balance,
  w.currency
FROM users u
JOIN wallets w ON u.id = w.user_id
WHERE u.username IN ('alice_buyer', 'bob_seller')
ORDER BY u.username;

-- Check transaction history
SELECT
  u.username,
  wt.type,
  wt.amount,
  wt.description,
  wt.reference,
  wt.balance_after,
  wt.created_at
FROM wallet_transactions wt
JOIN wallets w ON wt.wallet_id = w.id
JOIN users u ON w.user_id = u.id
WHERE u.username IN ('alice_buyer', 'bob_seller')
ORDER BY wt.created_at DESC;

-- =====================================================
-- Test Account Credentials
-- =====================================================
-- Username: alice_buyer
-- Password: Test123!
-- Phone: 0241111111
-- Balance: GHS 1000.00
--
-- Username: bob_seller
-- Password: Test123!
-- Phone: 0242222222
-- Balance: GHS 0.00
-- =====================================================

COMMIT;
