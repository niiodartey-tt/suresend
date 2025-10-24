import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _transactionService = TransactionService();

  List<Transaction> _transactions = [];
  TransactionStats? _stats;
  Transaction? _currentTransaction;
  bool _isLoading = false;
  String? _error;

  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  // Getters
  List<Transaction> get transactions => _transactions;
  TransactionStats? get stats => _stats;
  Transaction? get currentTransaction => _currentTransaction;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  /// Create escrow transaction
  Future<Map<String, dynamic>> createEscrow({
    required String sellerId,
    required double amount,
    required String description,
    required String paymentMethod,
    String? riderId,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _transactionService.createEscrow(
        sellerId: sellerId,
        amount: amount,
        description: description,
        paymentMethod: paymentMethod,
        riderId: riderId,
      );

      if (result['success']) {
        // Refresh transactions list
        await fetchTransactions(refresh: true);
      } else {
        _error = result['error'] ?? 'Failed to create transaction';
      }

      _setLoading(false);
      return result;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Fetch transaction details
  Future<void> fetchTransactionDetails(String transactionId) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _transactionService.getTransactionDetails(transactionId);

      if (result['success']) {
        _currentTransaction = result['data'];
      } else {
        _error = result['error'] ?? 'Failed to fetch transaction details';
      }
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  /// Fetch transactions list
  Future<void> fetchTransactions({
    bool refresh = false,
    String? status,
    String? type,
    String? role,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _transactions = [];
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    _setLoading(true);
    _clearError();

    try {
      final result = await _transactionService.getTransactions(
        page: _currentPage,
        status: status,
        type: type,
        role: role,
      );

      if (result['success']) {
        final newTransactions = result['data']['transactions'] as List<Transaction>;

        if (refresh) {
          _transactions = newTransactions;
        } else {
          _transactions.addAll(newTransactions);
        }

        final pagination = result['data']['pagination'];
        _totalPages = pagination['totalPages'];
        _hasMore = _currentPage < _totalPages;

        if (_hasMore) {
          _currentPage++;
        }
      } else {
        _error = result['error'] ?? 'Failed to fetch transactions';
      }
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  /// Fetch transaction statistics
  Future<void> fetchStats() async {
    try {
      final result = await _transactionService.getTransactionStats();

      if (result['success']) {
        _stats = result['data'];
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    }
  }

  /// Confirm delivery
  Future<Map<String, dynamic>> confirmDelivery({
    required String transactionId,
    required bool confirmed,
    String? notes,
  }) async {
    _clearError();

    try {
      final result = await _transactionService.confirmDelivery(
        transactionId: transactionId,
        confirmed: confirmed,
        notes: notes,
      );

      if (result['success']) {
        // Refresh current transaction and list
        await fetchTransactionDetails(transactionId);
        await fetchTransactions(refresh: true);
        await fetchStats();
      } else {
        _error = result['error'] ?? 'Failed to confirm delivery';
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

  /// Raise dispute
  Future<Map<String, dynamic>> raiseDispute({
    required String transactionId,
    required String reason,
  }) async {
    _clearError();

    try {
      final result = await _transactionService.raiseDispute(
        transactionId: transactionId,
        reason: reason,
      );

      if (result['success']) {
        // Refresh current transaction and list
        await fetchTransactionDetails(transactionId);
        await fetchTransactions(refresh: true);
      } else {
        _error = result['error'] ?? 'Failed to raise dispute';
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

  /// Cancel transaction
  Future<Map<String, dynamic>> cancelTransaction({
    required String transactionId,
    String? reason,
  }) async {
    _clearError();

    try {
      final result = await _transactionService.cancelTransaction(
        transactionId: transactionId,
        reason: reason,
      );

      if (result['success']) {
        // Refresh transactions and stats
        await fetchTransactions(refresh: true);
        await fetchStats();
      } else {
        _error = result['error'] ?? 'Failed to cancel transaction';
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

  /// Search users
  Future<List<UserSearchResult>> searchUsers({
    required String query,
    String userType = 'seller',
  }) async {
    try {
      final result = await _transactionService.searchUsers(
        query: query,
        userType: userType,
      );

      if (result['success']) {
        return result['data'] as List<UserSearchResult>;
      }

      return [];
    } catch (e) {
      _error = e.toString();
      return [];
    }
  }

  /// Get transactions by role
  List<Transaction> getTransactionsByRole(String role) {
    switch (role) {
      case 'buyer':
        return _transactions;
      case 'seller':
        return _transactions;
      case 'rider':
        return _transactions;
      default:
        return _transactions;
    }
  }

  /// Get active transactions (in escrow)
  List<Transaction> get activeTransactions {
    return _transactions.where((t) => t.isInEscrow).toList();
  }

  /// Get completed transactions
  List<Transaction> get completedTransactions {
    return _transactions.where((t) => t.isCompleted).toList();
  }

  /// Clear current transaction
  void clearCurrentTransaction() {
    _currentTransaction = null;
    notifyListeners();
  }

  /// Clear all data
  void clearAll() {
    _transactions = [];
    _stats = null;
    _currentTransaction = null;
    _currentPage = 1;
    _totalPages = 1;
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
    notifyListeners();
  }
}
