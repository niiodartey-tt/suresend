-- Rollback Migration: Unified User Model
-- Restores separate buyer/seller account types
-- Date: 2025-10-25
-- Author: Claude Code Migration
-- WARNING: This rollback is destructive and should only be used if migration fails

-- ============================================
-- STEP 1: Verify backup exists
-- ============================================
DO $$
DECLARE
    backup_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT FROM information_schema.tables
        WHERE table_name = 'users_backup_20251025'
    ) INTO backup_exists;

    IF NOT backup_exists THEN
        RAISE EXCEPTION 'ROLLBACK ABORTED: Backup table users_backup_20251025 not found!';
    END IF;

    RAISE NOTICE 'Backup table found. Proceeding with rollback...';
END $$;

-- ============================================
-- STEP 2: Rename current ENUM type
-- ============================================
DO $$
BEGIN
    ALTER TYPE user_type_enum RENAME TO user_type_enum_new;
    RAISE NOTICE 'Renamed current ENUM to user_type_enum_new';
EXCEPTION
    WHEN undefined_object THEN
        RAISE NOTICE 'Current ENUM not found, may already be rolled back';
END $$;

-- ============================================
-- STEP 3: Recreate original ENUM type
-- ============================================
DO $$
BEGIN
    -- Recreate original ENUM with buyer, seller, rider
    CREATE TYPE user_type_enum AS ENUM ('buyer', 'seller', 'rider');
    RAISE NOTICE 'Recreated original ENUM type: (buyer, seller, rider)';
EXCEPTION
    WHEN duplicate_object THEN
        RAISE NOTICE 'Original ENUM type already exists';
END $$;

-- ============================================
-- STEP 4: Restore data from backup
-- ============================================
DO $$
DECLARE
    restored_count INT;
BEGIN
    -- Clear current users table
    TRUNCATE TABLE users CASCADE;
    RAISE NOTICE 'Cleared current users table';

    -- Restore from backup
    INSERT INTO users
    SELECT * FROM users_backup_20251025;

    GET DIAGNOSTICS restored_count = ROW_COUNT;
    RAISE NOTICE 'Restored % users from backup', restored_count;
END $$;

-- ============================================
-- STEP 5: Drop new ENUM type
-- ============================================
DO $$
BEGIN
    DROP TYPE IF EXISTS user_type_enum_new CASCADE;
    RAISE NOTICE 'Dropped new ENUM type';
EXCEPTION
    WHEN others THEN
        RAISE NOTICE 'Could not drop new ENUM: %', SQLERRM;
END $$;

-- ============================================
-- STEP 6: Verify rollback
-- ============================================
DO $$
DECLARE
    buyer_count INT;
    seller_count INT;
    rider_count INT;
    total_count INT;
BEGIN
    SELECT COUNT(*) INTO buyer_count FROM users WHERE user_type = 'buyer';
    SELECT COUNT(*) INTO seller_count FROM users WHERE user_type = 'seller';
    SELECT COUNT(*) INTO rider_count FROM users WHERE user_type = 'rider';
    SELECT COUNT(*) INTO total_count FROM users;

    RAISE NOTICE '================================================';
    RAISE NOTICE 'ROLLBACK COMPLETED';
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Restored user distribution:';
    RAISE NOTICE '  - Buyers: %', buyer_count;
    RAISE NOTICE '  - Sellers: %', seller_count;
    RAISE NOTICE '  - Riders: %', rider_count;
    RAISE NOTICE '  - Total: %', total_count;
    RAISE NOTICE '================================================';
    RAISE NOTICE 'IMPORTANT: Review data integrity before continuing';
    RAISE NOTICE 'Backup table users_backup_20251025 still exists';
    RAISE NOTICE '================================================';
END $$;

-- Success message
SELECT
    'Rollback completed - Original buyer/seller model restored' as status,
    COUNT(CASE WHEN user_type = 'buyer' THEN 1 END) as buyers_count,
    COUNT(CASE WHEN user_type = 'seller' THEN 1 END) as sellers_count,
    COUNT(CASE WHEN user_type = 'rider' THEN 1 END) as riders_count,
    COUNT(*) as total_users
FROM users;

-- WARNING MESSAGE
DO $$
BEGIN
    RAISE WARNING '================================================';
    RAISE WARNING 'ROLLBACK COMPLETE - ACTION REQUIRED:';
    RAISE WARNING '1. Verify data integrity';
    RAISE WARNING '2. Restart backend services';
    RAISE WARNING '3. Test critical user flows';
    RAISE WARNING '4. Keep backup table until verified';
    RAISE WARNING '================================================';
END $$;
