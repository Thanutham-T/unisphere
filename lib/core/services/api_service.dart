import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
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
    print('🌐 API POST Request:');
    print('   URL: $url');
    print('   Use Form Data: $useFormData');
    
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
            
        print('   Headers: $formHeaders');
        print('   Form Body: $formBody');
        
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
        
        print('   Headers: $jsonHeaders');
        print('   JSON Body: ${jsonEncode(data)}');
        
        response = await _client.post(
          url,
          headers: jsonHeaders,
          body: jsonEncode(data),
        );
      }

      print('📡 API Response:');
      print('   Status Code: ${response.statusCode}');
      print('   Response Body: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      print('❌ Network Error: ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้');
      throw NetworkException('ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้');
    } catch (e) {
      print('❌ API Error: $e');
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
      accessToken = await _storageService.getString(ApiConstants.accessTokenKey);
    }

    final authHeaders = <String, String>{
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      if (headers != null) ...headers,
    };

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

  Map<String, dynamic> _handleResponse(http.Response response) {
    print('🔍 Handling Response: ${response.statusCode}');
    
    switch (response.statusCode) {
      case 200:
      case 201:
        print('✅ Success: ${response.statusCode}');
        return jsonDecode(response.body);
      case 400:
        print('❌ Bad Request (400): ${response.body}');
        throw BadRequestException('ข้อมูลที่ส่งไม่ถูกต้อง');
      case 401:
        print('❌ Unauthorized (401): ${response.body}');
        throw UnauthorizedException('ข้อมูลการเข้าสู่ระบบไม่ถูกต้อง');
      case 403:
        print('❌ Forbidden (403): ${response.body}');
        throw ForbiddenException('ไม่มีสิทธิ์เข้าถึง');
      case 404:
        print('❌ Not Found (404): ${response.body}');
        throw NotFoundException('ไม่พบข้อมูลที่ต้องการ');
      case 500:
        print('❌ Server Error (500): ${response.body}');
        throw ServerException('เซิร์ฟเวอร์เกิดข้อผิดพลาด');
      default:
        print('❌ Unknown Error (${response.statusCode}): ${response.body}');
        throw ServerException('เกิดข้อผิดพลาดที่ไม่คาดคิด (${response.statusCode})');
    }
  }

  void dispose() {
    _client.close();
  }
}
