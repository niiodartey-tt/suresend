import 'package:flutter/foundation.dart';
import '../models/wallet.dart';
import '../services/wallet_service.dart';

class WalletProvider with ChangeNotifier {
  final WalletService _walletService = WalletService();

  Wallet? _wallet;
  List<WalletTransaction> _transactions = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  // Getters
  Wallet? get wallet => _wallet;
  List<WalletTransaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;
  double get balance => _wallet?.balance ?? 0.0;

  /// Fetch wallet details
  Future<void> fetchWallet() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _walletService.getWallet();

      if (result['success']) {
        _wallet = result['data']['wallet'];
      } else {
        _error = result['error'] ?? 'Failed to fetch wallet';
      }
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  /// Fetch wallet transactions
  Future<void> fetchTransactions({
    bool refresh = false,
    String? type,
    String? startDate,
    String? endDate,
  }) async {
    if (_isLoading) return;

    if (refresh) {
      _transactions = [];
      _hasMore = true;
    }

    _setLoading(true);
    _clearError();

    try {
      final result = await _walletService.getWalletTransactions(
        limit: 20,
        offset: refresh ? 0 : _transactions.length,
        type: type,
        startDate: startDate,
        endDate: endDate,
      );

      if (result['success']) {
        final data = result['data'];
        final newTransactions = data['transactions'] as List<WalletTransaction>;

        if (refresh) {
          _transactions = newTransactions;
        } else {
          _transactions.addAll(newTransactions);
        }

        _hasMore = data['pagination']['hasMore'] ?? false;
      } else {
        _error = result['error'] ?? 'Failed to fetch transactions';
      }
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  /// Fund wallet
  Future<Map<String, dynamic>> fundWallet({
    required double amount,
    required String paymentMethod,
  }) async {
    _clearError();

    try {
      final result = await _walletService.fundWallet(
        amount: amount,
        paymentMethod: paymentMethod,
      );

      if (result['success']) {
        // Refresh wallet after funding is initiated
        await fetchWallet();
      } else {
        _error = result['error'] ?? 'Failed to initiate funding';
      }

      return result;
    } catch (e) {
      _error = e.toString();
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
    _clearError();

    try {
      final result = await _walletService.withdrawFunds(
        amount: amount,
        withdrawalMethod: withdrawalMethod,
        accountDetails: accountDetails,
      );

      if (result['success']) {
        // Refresh wallet and transactions after withdrawal
        await Future.wait([
          fetchWallet(),
          fetchTransactions(refresh: true),
        ]);
      } else {
        _error = result['error'] ?? 'Failed to process withdrawal';
      }

      return result;
    } catch (e) {
      _error = e.toString();
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
    _clearError();

    try {
      final result = await _walletService.transferFunds(
        recipientUsername: recipientUsername,
        amount: amount,
        description: description,
      );

      if (result['success']) {
        // Refresh wallet and transactions after transfer
        await Future.wait([
          fetchWallet(),
          fetchTransactions(refresh: true),
        ]);
      } else {
        _error = result['error'] ?? 'Failed to transfer funds';
      }

      return result;
    } catch (e) {
      _error = e.toString();
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Clear all wallet data
  void clearWallet() {
    _wallet = null;
    _transactions = [];
    _hasMore = true;
    _error = null;
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
