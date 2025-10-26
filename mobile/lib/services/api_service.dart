import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  String? _authToken;

  // Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Clear authentication token
  void clearAuthToken() {
    _authToken = null;
  }

  // Get common headers
  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  // Health check endpoint
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await _client
          .get(
            Uri.parse(
                '${AppConfig.apiBaseUrl.replaceAll('/api/v1', '')}/health'),
            headers: _getHeaders(),
          )
          .timeout(AppConfig.connectionTimeout);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Server returned status ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Connection failed: ${e.toString()}',
      };
    }
  }

  // GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = false,
  }) async {
    try {
      var uri = Uri.parse('${AppConfig.apiBaseUrl}/$endpoint');

      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await _client
          .get(
            uri,
            headers: _getHeaders(includeAuth: requiresAuth),
          )
          .timeout(AppConfig.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('${AppConfig.apiBaseUrl}/$endpoint'),
            headers: _getHeaders(includeAuth: requiresAuth),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(AppConfig.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final response = await _client
          .put(
            Uri.parse('${AppConfig.apiBaseUrl}/$endpoint'),
            headers: _getHeaders(includeAuth: requiresAuth),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(AppConfig.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    try {
      final response = await _client
          .delete(
            Uri.parse('${AppConfig.apiBaseUrl}/$endpoint'),
            headers: _getHeaders(includeAuth: requiresAuth),
          )
          .timeout(AppConfig.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? json.decode(response.body) : {};

    if (statusCode >= 200 && statusCode < 300) {
      return {
        'success': true,
        'data': body,
        'statusCode': statusCode,
      };
    } else {
      return {
        'success': false,
        'error': body['message'] ?? 'Request failed',
        'statusCode': statusCode,
      };
    }
  }

  // Handle errors
  Map<String, dynamic> _handleError(dynamic error) {
    return {
      'success': false,
      'error': error.toString(),
    };
  }

  // Dispose
  void dispose() {
    _client.close();
  }
}
