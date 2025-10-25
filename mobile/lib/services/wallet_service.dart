import '../models/wallet.dart';
import 'api_service.dart';

class WalletService {
  static final WalletService _instance = WalletService._internal();
  factory WalletService() => _instance;
  WalletService._internal();

  final ApiService _apiService = ApiService();

  /// Get wallet details
  Future<Map<String, dynamic>> getWallet() async {
    try {
      final result = await _apiService.get(
        'wallet',
        requiresAuth: true,
      );

      if (result['success']) {
        final backendData = result['data']['data'] ?? result['data'];
        final wallet = Wallet.fromJson(backendData['wallet']);

        return {
          'success': true,
          'data': {'wallet': wallet},
        };
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get wallet transaction history
  Future<Map<String, dynamic>> getWalletTransactions({
    int limit = 20,
    int offset = 0,
    String? type,
    String? startDate,
    String? endDate,
  }) async {
    try {
      String url = 'wallet/transactions?limit=$limit&offset=$offset';
      if (type != null) url += '&type=$type';
      if (startDate != null) url += '&startDate=$startDate';
      if (endDate != null) url += '&endDate=$endDate';

      final result = await _apiService.get(url, requiresAuth: true);

      if (result['success']) {
        final backendData = result['data']['data'] ?? result['data'];
        final transactionsList = backendData['transactions'] as List;
        final transactions = transactionsList
            .map((json) => WalletTransaction.fromJson(json))
            .toList();

        return {
          'success': true,
          'data': {
            'transactions': transactions,
            'pagination': backendData['pagination'],
          },
        };
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Fund wallet
  Future<Map<String, dynamic>> fundWallet({
    required double amount,
    required String paymentMethod,
  }) async {
    try {
      final result = await _apiService.post(
        'wallet/fund',
        requiresAuth: true,
        body: {
          'amount': amount,
          'paymentMethod': paymentMethod,
        },
      );

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Withdraw funds
  Future<Map<String, dynamic>> withdrawFunds({
    required double amount,
    required String withdrawalMethod,
    required Map<String, dynamic> accountDetails,
  }) async {
    try {
      final result = await _apiService.post(
        'wallet/withdraw',
        requiresAuth: true,
        body: {
          'amount': amount,
          'withdrawalMethod': withdrawalMethod,
          'accountDetails': accountDetails,
        },
      );

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Transfer funds to another user
  Future<Map<String, dynamic>> transferFunds({
    required String recipientUsername,
    required double amount,
    String? description,
  }) async {
    try {
      final result = await _apiService.post(
        'wallet/transfer',
        requiresAuth: true,
        body: {
          'recipientUsername': recipientUsername,
          'amount': amount,
          if (description != null && description.isNotEmpty)
            'description': description,
        },
      );

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
