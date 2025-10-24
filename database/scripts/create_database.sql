-- Create SureSend Database
-- Run this as postgres superuser: psql -U postgres -f create_database.sql

-- Terminate existing connections to the database (if exists)
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'suresend_db'
  AND pid <> pg_backend_pid();

-- Drop database if exists (for fresh install)
DROP DATABASE IF EXISTS suresend_db;

-- Create new database
CREATE DATABASE suresend_db
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE suresend_db TO postgres;

\echo 'Database suresend_db created successfully!'
\echo 'Next step: Run setup.sql to create tables'
\echo 'Command: psql -U postgres -d suresend_db -f setup.sql'
