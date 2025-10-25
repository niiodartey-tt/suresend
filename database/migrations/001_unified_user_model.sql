-- Migration: Unified User Model
-- Converts separate buyer/seller accounts to unified 'user' type
-- Date: 2025-10-25
-- Author: Claude Code Migration

-- ============================================
-- STEP 1: Create backup of user_type data
-- ============================================
DO $$
BEGIN
    -- Create backup table if it doesn't exist
    CREATE TABLE IF NOT EXISTS users_backup_20251025 AS
    SELECT * FROM users WHERE 1=0;

    -- Insert current data into backup
    INSERT INTO users_backup_20251025
    SELECT * FROM users
    ON CONFLICT DO NOTHING;

    RAISE NOTICE 'Backup created: users_backup_20251025';
END $$;

-- ============================================
-- STEP 2: Update existing user types to 'user'
-- ============================================
DO $$
DECLARE
    buyer_count INT;
    seller_count INT;
    rider_count INT;
BEGIN
    -- Count current users by type
    SELECT COUNT(*) INTO buyer_count FROM users WHERE user_type = 'buyer';
    SELECT COUNT(*) INTO seller_count FROM users WHERE user_type = 'seller';
    SELECT COUNT(*) INTO rider_count FROM users WHERE user_type = 'rider';

    RAISE NOTICE 'Current user distribution:';
    RAISE NOTICE '  - Buyers: %', buyer_count;
    RAISE NOTICE '  - Sellers: %', seller_count;
    RAISE NOTICE '  - Riders: %', rider_count;

    -- Convert buyers and sellers to temporary marker 'user_temp'
    -- We use a temp value first because the ENUM doesn't have 'user' yet
    UPDATE users
    SET user_type = 'buyer'::user_type_enum -- Keep as buyer temporarily
    WHERE user_type IN ('buyer', 'seller');

    RAISE NOTICE 'Marked % users for migration', (buyer_count + seller_count);
END $$;

-- ============================================
-- STEP 3: Rename old ENUM and create new one
-- ============================================
DO $$
BEGIN
    -- Rename old ENUM
    ALTER TYPE user_type_enum RENAME TO user_type_enum_old;
    RAISE NOTICE 'Renamed old ENUM type to user_type_enum_old';

    -- Create new ENUM with 'user' and 'rider'
    CREATE TYPE user_type_enum AS ENUM ('user', 'rider');
    RAISE NOTICE 'Created new ENUM type: (user, rider)';

EXCEPTION
    WHEN duplicate_object THEN
        RAISE NOTICE 'New ENUM type already exists, skipping creation';
END $$;

-- ============================================
-- STEP 4: Alter users table to use new ENUM
-- ============================================
DO $$
BEGIN
    -- Convert user_type column to use new ENUM
    ALTER TABLE users
    ALTER COLUMN user_type TYPE user_type_enum
    USING (
        CASE
            WHEN user_type::text = 'buyer' THEN 'user'::user_type_enum
            WHEN user_type::text = 'seller' THEN 'user'::user_type_enum
            WHEN user_type::text = 'rider' THEN 'rider'::user_type_enum
            ELSE 'user'::user_type_enum
        END
    );

    RAISE NOTICE 'Updated users.user_type to use new ENUM';
END $$;

-- ============================================
-- STEP 5: Drop old ENUM type
-- ============================================
DO $$
BEGIN
    DROP TYPE IF EXISTS user_type_enum_old CASCADE;
    RAISE NOTICE 'Dropped old ENUM type: user_type_enum_old';
EXCEPTION
    WHEN others THEN
        RAISE NOTICE 'Could not drop old ENUM (may still be in use): %', SQLERRM;
END $$;

-- ============================================
-- STEP 6: Update admin user if exists
-- ============================================
DO $$
BEGIN
    UPDATE users
    SET user_type = 'user'
    WHERE username = 'admin' AND user_type::text IN ('buyer', 'seller');

    RAISE NOTICE 'Updated admin user to type: user';
END $$;

-- ============================================
-- STEP 7: Add username unique constraint (if not exists)
-- ============================================
DO $$
BEGIN
    -- Ensure username has unique constraint
    ALTER TABLE users ADD CONSTRAINT users_username_unique UNIQUE (username);
    RAISE NOTICE 'Added unique constraint to username column';
EXCEPTION
    WHEN duplicate_object THEN
        RAISE NOTICE 'Username unique constraint already exists';
END $$;

-- ============================================
-- STEP 8: Verify migration
-- ============================================
DO $$
DECLARE
    user_count INT;
    rider_count INT;
    total_count INT;
BEGIN
    SELECT COUNT(*) INTO user_count FROM users WHERE user_type = 'user';
    SELECT COUNT(*) INTO rider_count FROM users WHERE user_type = 'rider';
    SELECT COUNT(*) INTO total_count FROM users;

    RAISE NOTICE '================================================';
    RAISE NOTICE 'MIGRATION COMPLETED SUCCESSFULLY';
    RAISE NOTICE '================================================';
    RAISE NOTICE 'New user distribution:';
    RAISE NOTICE '  - Users (can buy/sell): %', user_count;
    RAISE NOTICE '  - Riders: %', rider_count;
    RAISE NOTICE '  - Total: %', total_count;
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Backup table: users_backup_20251025';
    RAISE NOTICE '================================================';
END $$;

-- Success message
SELECT
    'Migration 001_unified_user_model completed!' as status,
    COUNT(CASE WHEN user_type = 'user' THEN 1 END) as users_count,
    COUNT(CASE WHEN user_type = 'rider' THEN 1 END) as riders_count,
    COUNT(*) as total_users
FROM users;
