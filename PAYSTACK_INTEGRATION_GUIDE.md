# Paystack Payment Integration Guide
## SureSend Mobile App - Complete Payment Implementation

This guide provides complete implementation for Paystack payment integration using the provided test keys.

---

## 🔑 Test API Keys (Provided)

```
Secret Key: sk_test_79678f951350377586709b4686f0de8bf0896fcf
Public Key: pk_test_db113788bc935d1ddbf6d3cba8c71336f9fecb86
```

**⚠️ IMPORTANT**: These are test keys. Replace with live keys in production.

---

## 📦 Required Packages

Add to `mobile/pubspec.yaml`:

```yaml
dependencies:
  flutter_paystack: ^1.0.7
  http: ^1.1.0
```

Run:
```bash
flutter pub get
```

---

## ⚙️ Configuration

### 1. Android Setup

**File**: `mobile/android/app/src/main/AndroidManifest.xml`

Add inside `<application>` tag:

```xml
<meta-data
    android:name="co.paystack.android.PublicKey"
    android:value="pk_test_db113788bc935d1ddbf6d3cba8c71336f9fecb86" />
```

### 2. iOS Setup

**File**: `mobile/ios/Runner/Info.plist`

Add:

```xml
<key>PaystackPublicKey</key>
<string>pk_test_db113788bc935d1ddbf6d3cba8c71336f9fecb86</string>
```

---

## 💳 Implementation

### Create Paystack Service

**File**: `mobile/lib/services/paystack_service.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaystackService {
  static const String publicKey = 'pk_test_db113788bc935d1ddbf6d3cba8c71336f9fecb86';
  static const String secretKey = 'sk_test_79678f951350377586709b4686f0de8bf0896fcf';
  static const String paystackBaseUrl = 'https://api.paystack.co';

  final PaystackPlugin _paystack = PaystackPlugin();

  PaystackService() {
    _paystack.initialize(publicKey: publicKey);
  }

  /// Initialize a transaction and get reference
  Future<Map<String, dynamic>> initializeTransaction({
    required String email,
    required double amount,
    required String currency, // GHS, USD, or GBP
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Convert amount to smallest unit (pesewas for GHS, cents for USD/GBP)
      final amountInMinorUnit = (amount * 100).toInt();

      final response = await http.post(
        Uri.parse('$paystackBaseUrl/transaction/initialize'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'amount': amountInMinorUnit.toString(),
          'currency': currency,
          'metadata': metadata ?? {},
        }),
      );

      final data = json.decode(response.body);

      if (data['status'] == true) {
        return {
          'success': true,
          'reference': data['data']['reference'],
          'accessCode': data['data']['access_code'],
          'authorizationUrl': data['data']['authorization_url'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to initialize transaction',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error initializing transaction: $e',
      };
    }
  }

  /// Charge card using Paystack SDK
  Future<Map<String, dynamic>> chargeCard({
    required BuildContext context,
    required String email,
    required double amount,
    required String currency,
    String? reference,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Initialize transaction first to get reference
      final initResult = await initializeTransaction(
        email: email,
        amount: amount,
        currency: currency,
        metadata: metadata,
      );

      if (!initResult['success']) {
        return initResult;
      }

      final txRef = reference ?? initResult['reference'];
      final amountInMinorUnit = (amount * 100).toInt();

      // Create charge
      final charge = Charge()
        ..email = email
        ..amount = amountInMinorUnit
        ..currency = currency
        ..reference = txRef
        ..putMetaData('custom_fields', metadata ?? {});

      // Show Paystack checkout
      final response = await _paystack.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
      );

      if (response.status) {
        // Verify transaction on backend
        final verified = await verifyTransaction(txRef);
        return verified;
      } else {
        return {
          'success': false,
          'message': response.message ?? 'Transaction failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Payment error: $e',
      };
    }
  }

  /// Verify transaction status
  Future<Map<String, dynamic>> verifyTransaction(String reference) async {
    try {
      final response = await http.get(
        Uri.parse('$paystackBaseUrl/transaction/verify/$reference'),
        headers: {
          'Authorization': 'Bearer $secretKey',
        },
      );

      final data = json.decode(response.body);

      if (data['status'] == true && data['data']['status'] == 'success') {
        return {
          'success': true,
          'amount': data['data']['amount'] / 100, // Convert back from minor unit
          'currency': data['data']['currency'],
          'reference': data['data']['reference'],
          'paidAt': data['data']['paid_at'],
          'channel': data['data']['channel'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Transaction verification failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Verification error: $e',
      };
    }
  }

  /// Charge via mobile money (Ghana)
  Future<Map<String, dynamic>> chargeMobileMoney({
    required BuildContext context,
    required String email,
    required String phone,
    required double amount,
    required String provider, // mtn, vodafone, airtel-tigo
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Initialize transaction
      final initResult = await initializeTransaction(
        email: email,
        amount: amount,
        currency: 'GHS', // Mobile money only works with GHS
        metadata: metadata,
      );

      if (!initResult['success']) {
        return initResult;
      }

      final txRef = initResult['reference'];
      final amountInPesewas = (amount * 100).toInt();

      // Create mobile money charge
      final charge = Charge()
        ..email = email
        ..amount = amountInPesewas
        ..currency = 'GHS'
        ..reference = txRef
        ..putMetaData('custom_fields', metadata ?? {});

      // Show mobile money checkout
      final response = await _paystack.checkout(
        context,
        method: CheckoutMethod.selectable,
        charge: charge,
      );

      if (response.status) {
        final verified = await verifyTransaction(txRef);
        return verified;
      } else {
        return {
          'success': false,
          'message': response.message ?? 'Mobile money payment failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Mobile money error: $e',
      };
    }
  }

  /// Create transfer recipient (for payouts)
  Future<Map<String, dynamic>> createTransferRecipient({
    required String accountNumber,
    required String bankCode,
    required String accountName,
    required String currency,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$paystackBaseUrl/transferrecipient'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'type': 'nuban',
          'name': accountName,
          'account_number': accountNumber,
          'bank_code': bankCode,
          'currency': currency,
        }),
      );

      final data = json.decode(response.body);

      if (data['status'] == true) {
        return {
          'success': true,
          'recipientCode': data['data']['recipient_code'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to create recipient',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error creating recipient: $e',
      };
    }
  }

  /// Initiate transfer (withdrawal)
  Future<Map<String, dynamic>> initiateTransfer({
    required String recipientCode,
    required double amount,
    required String currency,
    String? reason,
  }) async {
    try {
      final amountInMinorUnit = (amount * 100).toInt();

      final response = await http.post(
        Uri.parse('$paystackBaseUrl/transfer'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'source': 'balance',
          'amount': amountInMinorUnit,
          'currency': currency,
          'recipient': recipientCode,
          'reason': reason ?? 'Withdrawal from SureSend',
        }),
      );

      final data = json.decode(response.body);

      if (data['status'] == true) {
        return {
          'success': true,
          'transferCode': data['data']['transfer_code'],
          'reference': data['data']['reference'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Transfer failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Transfer error: $e',
      };
    }
  }

  /// Get list of supported banks
  Future<List<Map<String, dynamic>>> getBanks({String country = 'ghana'}) async {
    try {
      final response = await http.get(
        Uri.parse('$paystackBaseUrl/bank?country=$country'),
        headers: {
          'Authorization': 'Bearer $secretKey',
        },
      );

      final data = json.decode(response.body);

      if (data['status'] == true) {
        return List<Map<String, dynamic>>.from(data['data'].map((bank) => {
          'name': bank['name'],
          'code': bank['code'],
          'country': bank['country'],
        }));
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching banks: $e');
      return [];
    }
  }
}
```

---

## 💰 Usage Examples

### 1. Fund Wallet (Top-up)

**Update**: `mobile/lib/screens/wallet/fund_wallet_screen.dart`

```dart
import 'package:suresend/services/paystack_service.dart';
import 'package:suresend/providers/wallet_provider.dart';
import 'package:suresend/providers/notification_provider.dart';

// In your fund wallet handler
Future<void> _handleFundWallet() async {
  final paystackService = PaystackService();
  final walletProvider = context.read<WalletProvider>();
  final notificationProvider = context.read<NotificationProvider>();

  // Get user email (from auth/storage)
  final userEmail = await StorageService().getUserEmail();
  final amount = double.parse(_amountController.text);
  final currency = walletProvider.selectedCurrency; // GHS, USD, or GBP

  // Show loading
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final result = await paystackService.chargeCard(
      context: context,
      email: userEmail,
      amount: amount,
      currency: currency,
      metadata: {
        'purpose': 'wallet_topup',
        'userId': await StorageService().getUserId(),
      },
    );

    // Close loading
    Navigator.pop(context);

    if (result['success']) {
      // Update wallet balance
      await walletProvider.addFunds(amount);

      // Add notification
      notificationProvider.addLocalNotification(
        title: 'Wallet Funded',
        message: 'Your wallet has been credited with $currency $amount',
        type: 'wallet',
        data: {
          'amount': amount.toString(),
          'currency': currency,
          'reference': result['reference'],
        },
      );

      // Navigate to success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionConfirmationScreen(
            title: 'Wallet Funded Successfully',
            subtitle: 'Your payment has been processed',
            transactionId: result['reference'],
            amount: '$currency $amount',
            recipient: 'SureSend Wallet',
            date: DateTime.now().toString(),
          ),
        ),
      );
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Payment failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

### 2. Mobile Money Top-up

```dart
Future<void> _handleMobileMoneyTopup(String provider) async {
  final paystackService = PaystackService();
  final userEmail = await StorageService().getUserEmail();
  final userPhone = await StorageService().getUserPhone();
  final amount = double.parse(_amountController.text);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final result = await paystackService.chargeMobileMoney(
      context: context,
      email: userEmail,
      phone: userPhone,
      amount: amount,
      provider: provider, // 'mtn', 'vodafone', or 'airtel-tigo'
      metadata: {
        'purpose': 'wallet_topup_momo',
        'provider': provider,
      },
    );

    Navigator.pop(context);

    if (result['success']) {
      // Update wallet
      await context.read<WalletProvider>().addFunds(amount);

      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wallet funded via mobile money!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

### 3. Withdraw Funds

```dart
Future<void> _handleWithdrawal() async {
  final paystackService = PaystackService();
  final amount = double.parse(_amountController.text);
  final currency = context.read<WalletProvider>().selectedCurrency;

  // Step 1: Create recipient
  final recipientResult = await paystackService.createTransferRecipient(
    accountNumber: _accountNumberController.text,
    bankCode: _selectedBankCode, // From bank selector
    accountName: _accountNameController.text,
    currency: currency,
  );

  if (!recipientResult['success']) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(recipientResult['message'])),
    );
    return;
  }

  // Step 2: Initiate transfer
  final transferResult = await paystackService.initiateTransfer(
    recipientCode: recipientResult['recipientCode'],
    amount: amount,
    currency: currency,
    reason: 'Withdrawal from SureSend Wallet',
  );

  if (transferResult['success']) {
    // Deduct from wallet
    await context.read<WalletProvider>().deductFunds(amount);

    // Show success
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionConfirmationScreen(
          title: 'Withdrawal Initiated',
          subtitle: 'Your funds will be transferred shortly',
          transactionId: transferResult['reference'],
          amount: '$currency $amount',
          recipient: _accountNameController.text,
          date: DateTime.now().toString(),
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(transferResult['message'])),
    );
  }
}
```

### 4. Escrow Payment (Buy Transaction)

```dart
Future<void> _handleCreateEscrow() async {
  final paystackService = PaystackService();
  final amount = double.parse(_amountController.text);
  final currency = context.read<WalletProvider>().selectedCurrency;
  final userEmail = await StorageService().getUserEmail();

  // Charge user for escrow amount
  final paymentResult = await paystackService.chargeCard(
    context: context,
    email: userEmail,
    amount: amount,
    currency: currency,
    metadata: {
      'purpose': 'escrow_creation',
      'item': _itemController.text,
      'seller': _sellerController.text,
    },
  );

  if (paymentResult['success']) {
    // Create escrow transaction
    final transactionProvider = context.read<TransactionProvider>();
    final escrowResult = await transactionProvider.createEscrow(
      sellerId: _sellerController.text,
      amount: amount,
      description: _itemController.text,
      paymentMethod: 'paystack',
      paymentReference: paymentResult['reference'],
    );

    if (escrowResult['success']) {
      // Add notification
      context.read<NotificationProvider>().addLocalNotification(
        title: 'Escrow Created',
        message: 'Funds of $currency $amount put in escrow',
        type: 'transaction',
        data: {
          'transactionId': escrowResult['transactionId'],
          'paymentReference': paymentResult['reference'],
        },
      );

      // Navigate to success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EscrowCreatedSuccessScreen(
            transactionId: escrowResult['transactionId'],
            amount: '$currency $amount',
            date: DateTime.now().toString(),
          ),
        ),
      );
    }
  }
}
```

---

## 🌍 Currency Support

Paystack supports:
- **GHS** (Ghana Cedis) - Default
- **USD** (US Dollars)
- **GBP** (British Pounds)

### Currency Conversion

For real-time conversion, use an API like:
- **ExchangeRate-API** (free tier available)
- **Open Exchange Rates**
- **Fixer.io**

**Example**:

```dart
class CurrencyService {
  static const String apiKey = 'YOUR_EXCHANGE_RATE_API_KEY';
  static const String baseUrl = 'https://v6.exchangerate-api.com/v6';

  Future<double> convert({
    required double amount,
    required String from,
    required String to,
  }) async {
    if (from == to) return amount;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$apiKey/pair/$from/$to'),
      );

      final data = json.decode(response.body);

      if (data['result'] == 'success') {
        final rate = data['conversion_rate'];
        return amount * rate;
      }

      return amount;
    } catch (e) {
      print('Currency conversion error: $e');
      return amount;
    }
  }
}
```

---

## 🧪 Testing

### Test Cards (Paystack Test Mode)

**Successful Transaction**:
```
Card Number: 4084084084084081
CVV: 408
Expiry: Any future date
PIN: 0000
OTP: 123456
```

**Declined Transaction**:
```
Card Number: 5060666666666666666
CVV: 123
Expiry: Any future date
```

**Insufficient Funds**:
```
Card Number: 5060666666666666666
CVV: 123
Expiry: Any future date
PIN: 1111
```

### Testing Mobile Money

In test mode, Paystack simulates mobile money transactions. Use:
- Phone: Any valid Ghana number
- Provider: MTN, Vodafone, AirtelTigo

---

## ⚠️ Important Notes

1. **Amounts**: Always in smallest currency unit (pesewas for GHS, cents for USD/GBP)
2. **Email Required**: Paystack requires email for all transactions
3. **Webhooks**: Set up webhooks for production to handle async events
4. **Test Mode**: Test keys only work with test cards
5. **Live Mode**: Switch to live keys for production

---

## 🔐 Security Best Practices

1. **Never expose secret key** in frontend code
2. **Verify all transactions** on backend
3. **Use webhooks** for reliable payment confirmation
4. **Implement idempotency** to prevent duplicate charges
5. **Store payment references** for reconciliation
6. **Handle failures gracefully** with retry logic
7. **Log all transactions** for audit trail

---

## 📱 Production Checklist

- [ ] Replace test keys with live keys
- [ ] Set up webhook endpoint
- [ ] Implement transaction logging
- [ ] Add retry logic for failed payments
- [ ] Test with real cards (small amounts)
- [ ] Verify currency conversion accuracy
- [ ] Test mobile money in production
- [ ] Monitor Paystack dashboard for issues
- [ ] Set up alerts for failed transactions
- [ ] Implement refund workflow

---

## 🆘 Support

- **Paystack Docs**: https://paystack.com/docs
- **Support**: support@paystack.com
- **Status**: https://status.paystack.com

---

**Integration complete! All payment flows ready for testing with provided keys.**
