import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import '../logging/app_logger.dart';
import 'key_value_storage_service.dart';

class ApiService {
  final http.Client _client;
  final KeyValueStorageService? _storageService;
  
  ApiService({
    http.Client? client,
    KeyValueStorageService? storageService,
  }) : _client = client ?? http.Client(),
       _storageService = storageService;

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
    bool useFormData = false,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    // Debug logging
    AppLogger.debug('🌐 API POST Request:');
    AppLogger.debug('   URL: $url');
    AppLogger.debug('   Use Form Data: $useFormData');
    
    try {
      http.Response response;
      
      if (useFormData) {
        // ส่งเป็น form data สำหรับ OAuth2
        final formHeaders = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          if (headers != null) ...headers,
        };
        
        final formBody = data.entries
            .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
            .join('&');
            
        AppLogger.debug('   Headers: $formHeaders');
        AppLogger.debug('   Form Body: $formBody');
        
        response = await _client.post(
          url,
          headers: formHeaders,
          body: formBody,
        );
      } else {
        // ส่งเป็น JSON ปกติ
        final jsonHeaders = {
          ...ApiConstants.defaultHeaders,
          if (headers != null) ...headers,
        };
        
        AppLogger.debug('   Headers: $jsonHeaders');
        AppLogger.debug('   JSON Body: ${jsonEncode(data)}');
        
        response = await _client.post(
          url,
          headers: jsonHeaders,
          body: jsonEncode(data),
        );
      }

      AppLogger.debug('📡 API Response:');
      AppLogger.debug('   Status Code: ${response.statusCode}');
      AppLogger.debug('   Response Body: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      AppLogger.debug('❌ Network Error: ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้');
      throw NetworkException('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้');
    } catch (e) {
      AppLogger.debug('❌ API Error: $e');
      throw ServerException('เกิดข้อผิดพลาดในการเชื่อมต่อ: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> postAuthenticated(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
    bool useFormData = false,
  }) async {
    // Get access token from storage
    String? accessToken;
    if (_storageService != null) {
      accessToken = await _storageService.getEncryptedString(ApiConstants.accessTokenKey);
      AppLogger.debug('🔑 Retrieved access token: ${accessToken?.substring(0, 20)}...'); // Show first 20 chars
    } else {
      AppLogger.debug('❌ No storage service available for auth');
    }

    final authHeaders = <String, String>{
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      if (headers != null) ...headers,
    };
    
    AppLogger.debug('🔐 Auth Headers: ${authHeaders.keys.toList()}');

    return post(endpoint, data, headers: authHeaders, useFormData: useFormData);
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    try {
      final response = await _client.get(
        url,
        headers: {
          ...ApiConstants.defaultHeaders,
          if (headers != null) ...headers,
        },
      );

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้');
    } catch (e) {
      throw ServerException('เกิดข้อผิดพลาดในการเชื่อมต่อ: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getAuthenticated(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    // Get access token from storage
    String? accessToken;
    if (_storageService != null) {
      accessToken = await _storageService.getEncryptedString(ApiConstants.accessTokenKey);
      AppLogger.debug('🔑 Retrieved access token for GET: ${accessToken?.substring(0, 20)}...'); // Show first 20 chars
    } else {
      AppLogger.debug('❌ No storage service available for auth');
    }

    final authHeaders = <String, String>{
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      if (headers != null) ...headers,
    };
    
    AppLogger.debug('🔐 Auth Headers for GET: ${authHeaders.keys.toList()}');

    return get(endpoint, headers: authHeaders);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    AppLogger.debug('🔍 Handling Response: ${response.statusCode}');
    
    switch (response.statusCode) {
      case 200:
      case 201:
        AppLogger.debug('✅ Success: ${response.statusCode}');
        AppLogger.debug('📄 Raw Response Body: ${response.body}');
        try {
          final decoded = jsonDecode(response.body);
          AppLogger.debug('📋 Parsed JSON: $decoded');
          return decoded;
        } catch (e) {
          AppLogger.debug('❌ JSON Parse Error: $e');
          throw ServerException('ข้อมูลจากเซิร์ฟเวอร์ไม่ถูกต้อง: $e');
        }
      case 400:
        AppLogger.debug('❌ Bad Request (400): ${response.body}');
        throw BadRequestException('ข้อมูลที่ส่งไม่ถูกต้อง');
      case 401:
        AppLogger.debug('❌ Unauthorized (401): ${response.body}');
        throw UnauthorizedException('ข้อมูลการเข้าสู่ระบบไม่ถูกต้อง');
      case 403:
        AppLogger.debug('❌ Forbidden (403): ${response.body}');
        throw ForbiddenException('ไม่มีสิทธิ์เข้าถึง');
      case 404:
        AppLogger.debug('❌ Not Found (404): ${response.body}');
        throw NotFoundException('ไม่พบข้อมูลที่ต้องการ');
      case 500:
        AppLogger.debug('❌ Server Error (500): ${response.body}');
        throw ServerException('เซิร์ฟเวอร์เกิดข้อผิดพลาด');
      default:
        AppLogger.debug('❌ Unknown Error (${response.statusCode}): ${response.body}');
        throw ServerException('เกิดข้อผิดพลาดที่ไม่คาดคิด (${response.statusCode})');
    }
  }

  /// PATCH request with authentication support  
  Future<Map<String, dynamic>> patch(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      AppLogger.debug('🔄 PATCH Request: $url');

      Map<String, String> requestHeaders = Map.from(ApiConstants.defaultHeaders);
      if (headers != null) {
        requestHeaders.addAll(headers);
      }

      // Add authorization header if required
      if (requiresAuth && _storageService != null) {
        final accessToken = await _storageService.getEncryptedString(ApiConstants.accessTokenKey);
        if (accessToken != null) {
          requestHeaders['Authorization'] = 'Bearer $accessToken';
          AppLogger.debug('🔑 Added Bearer token to PATCH request');
        } else {
          AppLogger.debug('❌ No access token available for authenticated PATCH request');
          throw UnauthorizedException('ไม่พบ token สำหรับการเข้าถึง');
        }
      }

      final response = await _client.patch(
        url,
        headers: requestHeaders,
        body: jsonEncode(data),
      ).timeout(Duration(seconds: ApiConstants.apiTimeout));

      AppLogger.debug('📨 PATCH Response: ${response.statusCode}');

      if (ApiConstants.enableApiLogging) {
        AppLogger.debug('📄 PATCH Response Body: ${response.body}');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body.isNotEmpty 
            ? jsonDecode(response.body) as Map<String, dynamic>
            : <String, dynamic>{};
      } else {
        // Handle HTTP errors
        switch (response.statusCode) {
          case 401:
            throw UnauthorizedException('ไม่มีสิทธิ์เข้าถึง');
          case 403:
            throw ForbiddenException('ไม่มีสิทธิ์เข้าถึง');
          case 404:
            throw NotFoundException('ไม่พบข้อมูลที่ต้องการ');
          case 500:
            throw ServerException('เซิร์ฟเวอร์เกิดข้อผิดพลาด');
          default:
            throw ServerException('เกิดข้อผิดพลาดที่ไม่คาดคิด (${response.statusCode})');
        }
      }
    } on SocketException {
      AppLogger.debug('📡 PATCH Network error');
      throw NetworkException('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้');
    } catch (e) {
      AppLogger.debug('❌ PATCH API Error: $e');
      throw ServerException('เกิดข้อผิดพลาดในการเชื่อมต่อ: ${e.toString()}');
    }
  }

  /// PUT request with authentication support  
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      AppLogger.debug('🔄 PUT Request: $url');

      Map<String, String> requestHeaders = Map.from(ApiConstants.defaultHeaders);
      if (headers != null) {
        requestHeaders.addAll(headers);
      }

      // Add authorization header if required
      if (requiresAuth && _storageService != null) {
        final accessToken = await _storageService.getEncryptedString(ApiConstants.accessTokenKey);
        if (accessToken != null) {
          requestHeaders['Authorization'] = 'Bearer $accessToken';
          AppLogger.debug('🔑 Added Bearer token to PUT request');
        } else {
          AppLogger.debug('❌ No access token available for authenticated PUT request');
          throw UnauthorizedException('ไม่พบ token สำหรับการเข้าถึง');
        }
      }

      final response = await _client.put(
        url,
        headers: requestHeaders,
        body: jsonEncode(data),
      ).timeout(Duration(seconds: ApiConstants.apiTimeout));

      AppLogger.debug('📨 PUT Response: ${response.statusCode}');

      if (ApiConstants.enableApiLogging) {
        AppLogger.debug('📄 PUT Response Body: ${response.body}');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body.isNotEmpty 
            ? jsonDecode(response.body) as Map<String, dynamic>
            : <String, dynamic>{};
      } else {
        // Handle HTTP errors
        switch (response.statusCode) {
          case 401:
            throw UnauthorizedException('ไม่มีสิทธิ์เข้าถึง');
          case 403:
            throw ForbiddenException('ไม่มีสิทธิ์เข้าถึง');
          case 404:
            throw NotFoundException('ไม่พบข้อมูลที่ต้องการ');
          case 500:
            throw ServerException('เซิร์ฟเวอร์เกิดข้อผิดพลาด');
          default:
            throw ServerException('เกิดข้อผิดพลาดที่ไม่คาดคิด (${response.statusCode})');
        }
      }
    } on SocketException {
      AppLogger.debug('📡 PUT Network error');
      throw NetworkException('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้');
    } catch (e) {
      AppLogger.debug('❌ PUT API Error: $e');
      throw ServerException('เกิดข้อผิดพลาดในการเชื่อมต่อ: ${e.toString()}');
    }
  }

  void dispose() {
    _client.close();
  }
}
