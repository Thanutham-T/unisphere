import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:mime/mime.dart';
import '../services/key_value_storage_service.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import '../logging/app_logger.dart';

@lazySingleton
class NetworkClient {
  final String baseUrl;
  final KeyValueStorageService _storageService;
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
  };

  NetworkClient(this._storageService, {String? baseUrl}) 
    : baseUrl = baseUrl ?? ApiConstants.baseUrl;

  Future<Map<String, String>> get _headers async {
    final headers = Map<String, String>.from(_defaultHeaders);
    
    // Get access token from storage
    final accessToken = await _storageService.getEncryptedString(ApiConstants.accessTokenKey);
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    
    return headers;
  }

  Future<NetworkResponse> get(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = await _headers;
      
      AppLogger.debug('🌐 GET Request:');
      AppLogger.debug('   URL: $uri');
      AppLogger.debug('   Headers: ${headers.keys.toList()}');
      
      final response = await http.get(uri, headers: headers);
      
      AppLogger.debug('📡 GET Response:');
      AppLogger.debug('   Status: ${response.statusCode}');
      AppLogger.debug('   Body length: ${response.body.length}');
      
      return _handleResponse(response);
    } catch (e) {
      AppLogger.error('❌ GET request failed for $endpoint', e);
      throw NetworkException('GET request failed: $e');
    }
  }

  Future<NetworkResponse> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = await _headers;
      final body = data != null ? jsonEncode(data) : null;
      final response = await http.post(uri, headers: headers, body: body);
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('POST request failed: $e');
    }
  }

  Future<NetworkResponse> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = await _headers;
      final body = data != null ? jsonEncode(data) : null;
      final response = await http.put(uri, headers: headers, body: body);
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('PUT request failed: $e');
    }
  }

  Future<NetworkResponse> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = await _headers;
      final response = await http.delete(uri, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException('DELETE request failed: $e');
    }
  }

  Future<NetworkResponse> uploadFile(String endpoint, String filePath, {String fieldName = 'file'}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = await _headers;
      
      // Remove Content-Type for multipart requests
      final uploadHeaders = Map<String, String>.from(headers);
      uploadHeaders.remove('Content-Type');
      
      AppLogger.debug('📤 Upload Request:');
      AppLogger.debug('   URL: $uri');
      AppLogger.debug('   File: $filePath');
      AppLogger.debug('   Field: $fieldName');
      
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(uploadHeaders);
      
      // Detect MIME type from file extension
      final mimeType = lookupMimeType(filePath);
      AppLogger.debug('   MIME Type: $mimeType');
      
      // Add file with proper content type
      final file = await http.MultipartFile.fromPath(
        fieldName, 
        filePath,
        contentType: mimeType != null ? MediaType.parse(mimeType) : null,
      );
      request.files.add(file);
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      AppLogger.debug('📡 Upload Response:');
      AppLogger.debug('   Status: ${response.statusCode}');
      AppLogger.debug('   Body: ${response.body}');
      
      return _handleResponse(response);
    } catch (e) {
      AppLogger.error('❌ Upload request failed for $endpoint', e);
      throw NetworkException('Upload request failed: $e');
    }
  }

  NetworkResponse _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    if (statusCode >= 200 && statusCode < 300) {
      dynamic data;
      if (response.body.isNotEmpty) {
        try {
          data = jsonDecode(response.body);
        } catch (e) {
          data = response.body;
        }
      }
      return NetworkResponse(
        statusCode: statusCode,
        data: data,
        isSuccess: true,
      );
    } else {
      String? errorMessage;
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['detail'] ?? errorData['message'];
      } catch (e) {
        errorMessage = response.body;
      }
      
      if (statusCode == 401) {
        AppLogger.warning('🚨 401 Unauthorized detected - Token may be expired');
        throw UnauthorizedException(errorMessage ?? 'Token หมดอายุ กรุณาเข้าสู่ระบบใหม่');
      } else if (statusCode == 403) {
        throw NetworkException('Forbidden: Insufficient permissions');
      } else if (statusCode == 404) {
        throw NetworkException('Resource not found');
      } else if (statusCode == 409) {
        throw NetworkException('Conflict: ${errorMessage ?? 'Resource conflict'}');
      } else {
        throw NetworkException(errorMessage ?? 'Request failed with status: $statusCode');
      }
    }
  }
}

class NetworkResponse {
  final int statusCode;
  final dynamic data;
  final bool isSuccess;

  NetworkResponse({
    required this.statusCode,
    this.data,
    required this.isSuccess,
  });
}

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => 'NetworkException: $message (Status: $statusCode)';
}