import '../models/transaction.dart';
import 'api_service.dart';

class TransactionService {
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal();

  final ApiService _apiService = ApiService();

  /// Create a new escrow transaction
  Future<Map<String, dynamic>> createEscrow({
    required String sellerId,
    required double amount,
    required String description,
    required String paymentMethod,
    String? riderId,
  }) async {
    try {
      final result = await _apiService.post(
        'escrow/create',
        requiresAuth: true,
        body: {
          'sellerId': sellerId,
          'amount': amount,
          'description': description,
          'paymentMethod': paymentMethod,
          if (riderId != null && riderId.isNotEmpty) 'riderId': riderId,
        },
      );

      if (result['success']) {
        return {
          'success': true,
          'data': result['data'],
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

  /// Get transaction details
  Future<Map<String, dynamic>> getTransactionDetails(String transactionId) async {
    try {
      final result = await _apiService.get(
        'escrow/$transactionId',
        requiresAuth: true,
      );

      if (result['success']) {
        final backendData = result['data'];
        if (backendData['status'] == 'success' && backendData['data'] != null) {
          final transaction = Transaction.fromJson(backendData['data']['transaction']);
          return {
            'success': true,
            'data': transaction,
          };
        }
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Confirm delivery (buyer confirms receipt)
  Future<Map<String, dynamic>> confirmDelivery({
    required String transactionId,
    required bool confirmed,
    String? notes,
  }) async {
    try {
      final result = await _apiService.post(
        'escrow/$transactionId/confirm-delivery',
        requiresAuth: true,
        body: {
          'confirmed': confirmed,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
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

  /// Raise a dispute
  Future<Map<String, dynamic>> raiseDispute({
    required String transactionId,
    required String reason,
  }) async {
    try {
      final result = await _apiService.post(
        'escrow/$transactionId/dispute',
        requiresAuth: true,
        body: {
          'reason': reason,
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

  /// Cancel transaction
  Future<Map<String, dynamic>> cancelTransaction({
    required String transactionId,
    String? reason,
  }) async {
    try {
      final result = await _apiService.post(
        'escrow/$transactionId/cancel',
        requiresAuth: true,
        body: {
          if (reason != null && reason.isNotEmpty) 'reason': reason,
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

  /// Get transactions list
  Future<Map<String, dynamic>> getTransactions({
    int page = 1,
    int limit = 20,
    String? status,
    String? type,
    String? role,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (status != null) queryParams['status'] = status;
      if (type != null) queryParams['type'] = type;
      if (role != null) queryParams['role'] = role;

      final result = await _apiService.get(
        'transactions',
        requiresAuth: true,
        queryParams: queryParams,
      );

      if (result['success']) {
        final backendData = result['data'];
        if (backendData['status'] == 'success' && backendData['data'] != null) {
          final transactions = (backendData['data']['transactions'] as List)
              .map((t) => Transaction.fromJson(t))
              .toList();

          return {
            'success': true,
            'data': {
              'transactions': transactions,
              'pagination': backendData['data']['pagination'],
            },
          };
        }
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get transaction statistics
  Future<Map<String, dynamic>> getTransactionStats() async {
    try {
      final result = await _apiService.get(
        'transactions/stats',
        requiresAuth: true,
      );

      if (result['success']) {
        final backendData = result['data'];
        if (backendData['status'] == 'success' && backendData['data'] != null) {
          final stats = TransactionStats.fromJson(backendData['data']['stats']);
          return {
            'success': true,
            'data': stats,
          };
        }
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Search users (find sellers/buyers)
  Future<Map<String, dynamic>> searchUsers({
    required String query,
    String userType = 'seller',
    int limit = 10,
  }) async {
    try {
      final result = await _apiService.get(
        'transactions/search-users',
        requiresAuth: true,
        queryParams: {
          'search': query,
          'userType': userType,
          'limit': limit.toString(),
        },
      );

      if (result['success']) {
        // ApiService wraps the response, so result['data'] contains the backend response
        // Backend returns: { status: 'success', data: { users: [...] } }
        // So we need to access result['data']['data']['users']
        final backendData = result['data'];

        if (backendData['status'] == 'success' && backendData['data'] != null) {
          final usersData = backendData['data']['users'] as List;
          final users = usersData
              .map((u) => UserSearchResult.fromJson(u))
              .toList();

          return {
            'success': true,
            'data': users,
          };
        } else {
          return {
            'success': false,
            'error': 'Invalid response structure',
          };
        }
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
