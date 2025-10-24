# SureSend Mobile App

Flutter-based mobile application for the SureSend escrow payment platform.

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / Xcode (for emulators)
- VS Code with Flutter extension (recommended)

### Installation

1. **Install dependencies**
   ```bash
   cd mobile
   flutter pub get
   ```

2. **Run the app**
   ```bash
   # On Android emulator/device
   flutter run

   # On iOS simulator/device (macOS only)
   flutter run -d ios

   # On Chrome (web)
   flutter run -d chrome
   ```

### Configuration

Edit `lib/config/app_config.dart` to change:
- API base URL
- Timeout durations
- App constants

### Project Structure

```
lib/
├── config/          # App configuration & theme
├── models/          # Data models
├── screens/         # UI screens
├── services/        # API & business logic
├── widgets/         # Reusable widgets
├── utils/           # Helper functions
├── providers/       # State management
└── main.dart        # App entry point
```

## Features to be Implemented

### Stage 2: Authentication & User Profiles
- Login screen
- Registration screen
- OTP verification
- User profile screens

### Stage 3: Escrow Core Functionality
- Create escrow transaction
- View escrow status
- Confirm delivery
- Dispute handling

### Stage 4: Wallet & Payments
- Wallet dashboard
- Fund wallet
- Withdraw funds
- Transaction history

### Stage 5: UI Implementation
- Complete UI from Figma design
- Animations
- Loading states
- Error handling

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release
```

## Dependencies

Key packages used:
- **provider**: State management
- **http/dio**: HTTP client
- **shared_preferences**: Local storage
- **flutter_secure_storage**: Secure storage
- **google_fonts**: Custom fonts
- **intl**: Internationalization
- **go_router**: Navigation

See `pubspec.yaml` for complete list.

## Troubleshooting

### Flutter version issues
```bash
flutter doctor
flutter upgrade
```

### Package conflicts
```bash
flutter pub cache repair
flutter clean
flutter pub get
```

### Android build issues
```bash
cd android
./gradlew clean
cd ..
flutter build apk
```

## Contributing

This is a private project. See main README for contribution guidelines.
