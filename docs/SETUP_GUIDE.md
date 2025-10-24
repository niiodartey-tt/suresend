# SureSend - Complete Setup Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Backend Setup](#backend-setup)
3. [Database Setup](#database-setup)
4. [Mobile App Setup](#mobile-app-setup)
5. [Testing the Setup](#testing-the-setup)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software
- **Node.js** v18+ and npm v9+ ([Download](https://nodejs.org/))
- **PostgreSQL** v14+ ([Download](https://www.postgresql.org/download/))
- **Flutter SDK** v3.0+ ([Download](https://flutter.dev/docs/get-started/install))
- **Git** ([Download](https://git-scm.com/downloads))

### Verify Installations
```bash
node --version    # Should show v18.x.x or higher
npm --version     # Should show v9.x.x or higher
psql --version    # Should show v14.x or higher
flutter --version # Should show v3.x.x or higher
git --version     # Should show v2.x.x or higher
```

---

## Backend Setup

### 1. Navigate to Backend Directory
```bash
cd backend
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Configure Environment Variables
The `.env` file has been created with default development values. For production, update these values:

```bash
# View current configuration
cat .env

# Edit if needed
nano .env  # or use your preferred editor
```

**Important Variables to Update for Production:**
- `JWT_SECRET` - Change to a secure random string
- `JWT_REFRESH_SECRET` - Change to a different secure random string
- `DB_PASSWORD` - Your PostgreSQL password
- `PAYSTACK_SECRET_KEY` - Your Paystack secret key
- `TWILIO_ACCOUNT_SID` - Your Twilio account SID
- `TWILIO_AUTH_TOKEN` - Your Twilio auth token

### 4. Start the Backend Server

**Development Mode (with auto-reload):**
```bash
npm run dev
```

**Production Mode:**
```bash
npm start
```

**Expected Output:**
```
================================================
🚀 SureSend API Server Started Successfully
================================================
Environment: development
Port: 3000
API Version: v1
Health Check: http://localhost:3000/health
API Base: http://localhost:3000/api
================================================
```

### 5. Test Backend API
In a new terminal window:
```bash
curl http://localhost:3000/health
```

**Expected Response:**
```json
{
  "status": "success",
  "message": "SureSend API is running",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "environment": "development"
}
```

---

## Database Setup

### 1. Ensure PostgreSQL is Running
```bash
# Check status (Linux/Mac)
sudo systemctl status postgresql

# Start if not running (Linux)
sudo systemctl start postgresql

# Start if not running (Mac with Homebrew)
brew services start postgresql
```

### 2. Create Database
```bash
cd ../database

# Create the database
psql -U postgres -f scripts/create_database.sql
```

**You will be prompted for the PostgreSQL password.** Default is usually `postgres` for local installations.

### 3. Setup Database Schema
```bash
# Run setup script to create tables
psql -U postgres -d suresend_db -f scripts/setup.sql
```

**Expected Output:**
```
CREATE EXTENSION
CREATE TYPE
...
INSERT 0 1
          message
----------------------------------
 Database setup completed successfully!
```

### 4. Verify Database Setup
```bash
# List all tables
psql -U postgres -d suresend_db -c "\dt"

# Check if admin user exists
psql -U postgres -d suresend_db -c "SELECT username, phone_number, user_type FROM users WHERE username='admin';"
```

**Expected Output:**
```
 username | phone_number  | user_type
----------+---------------+-----------
 admin    | +233000000000 | buyer
```

---

## Mobile App Setup

### 1. Navigate to Mobile Directory
```bash
cd ../mobile
```

### 2. Install Flutter Dependencies
```bash
flutter pub get
```

**Expected Output:**
```
Running "flutter pub get" in mobile...
Resolving dependencies...
...
Got dependencies!
```

### 3. Verify Flutter Installation
```bash
flutter doctor
```

Fix any issues shown by `flutter doctor` before proceeding.

### 4. Configure API Endpoint

The API endpoint is already configured for localhost. If you need to change it:

```bash
# Edit the config file
nano lib/config/app_config.dart

# Update the apiBaseUrl if backend is running on a different host/port
```

### 5. Run the Mobile App

**For Android Emulator:**
```bash
# List available devices
flutter devices

# Run on Android
flutter run -d android
```

**For iOS Simulator (Mac only):**
```bash
flutter run -d ios
```

**For Chrome (Web):**
```bash
flutter run -d chrome
```

---

## Testing the Setup

### 1. Backend Health Check
```bash
curl http://localhost:3000/health
```

### 2. Database Connection Test
```bash
psql -U postgres -d suresend_db -c "SELECT COUNT(*) FROM users;"
```

### 3. Full Integration Test

**Terminal 1 - Backend:**
```bash
cd backend
npm run dev
```

**Terminal 2 - Test API:**
```bash
# Test health endpoint
curl http://localhost:3000/health

# Test API base
curl http://localhost:3000/api
```

**Terminal 3 - Mobile App:**
```bash
cd mobile
flutter run
```

---

## Troubleshooting

### Backend Issues

#### Port Already in Use
```bash
# Find process using port 3000
lsof -i :3000  # Mac/Linux
netstat -ano | findstr :3000  # Windows

# Kill the process
kill -9 <PID>  # Mac/Linux
```

#### Database Connection Failed
1. Check if PostgreSQL is running
2. Verify credentials in `.env` file
3. Test connection manually:
   ```bash
   psql -U postgres -d suresend_db
   ```

#### Module Not Found
```bash
cd backend
rm -rf node_modules package-lock.json
npm install
```

### Database Issues

#### Cannot Connect to PostgreSQL
```bash
# Reset PostgreSQL password
sudo -u postgres psql
ALTER USER postgres PASSWORD 'postgres';
\q
```

#### Database Already Exists
```bash
# Drop and recreate
psql -U postgres -c "DROP DATABASE IF EXISTS suresend_db;"
psql -U postgres -f database/scripts/create_database.sql
```

#### Permission Denied
```bash
# Grant privileges
psql -U postgres
GRANT ALL PRIVILEGES ON DATABASE suresend_db TO postgres;
\q
```

### Mobile App Issues

#### Flutter Dependencies Error
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

#### Android Build Failed
```bash
cd android
./gradlew clean
cd ..
flutter build apk
```

#### Connection to Backend Failed
1. Ensure backend is running on `http://localhost:3000`
2. For Android emulator, use `http://10.0.2.2:3000` instead
3. Update `app_config.dart` accordingly:
   ```dart
   // For Android Emulator
   static const String apiBaseUrl = 'http://10.0.2.2:3000/api/v1';
   ```

---

## Running Everything Together

### Option 1: Manual (Recommended for Development)

**Terminal 1 - Backend:**
```bash
cd backend
npm run dev
```

**Terminal 2 - Mobile:**
```bash
cd mobile
flutter run
```

### Option 2: Using Shell Scripts (Create if needed)

**start.sh:**
```bash
#!/bin/bash
echo "Starting SureSend Backend..."
cd backend && npm run dev &
echo "Backend started!"
```

**stop.sh:**
```bash
#!/bin/bash
echo "Stopping SureSend..."
pkill -f "node.*server.js"
echo "Stopped!"
```

---

## Next Steps

After successful setup:
1. Test the health endpoint: `http://localhost:3000/health`
2. Review the API documentation in `docs/ARCHITECTURE.md`
3. Proceed to **Stage 2: Authentication & User Profiles**

---

## Support

For issues or questions:
1. Check the `docs/` directory for additional documentation
2. Review error logs in `backend/logs/`
3. Run `flutter doctor` for mobile setup issues

---

## Security Reminders

- Change all default passwords before production
- Never commit `.env` file to version control
- Use HTTPS in production
- Enable rate limiting
- Implement proper authentication

---

**Setup Complete! Ready for Stage 2 Development.**
