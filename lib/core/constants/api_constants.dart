import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Base URL ของ FastAPI Backend - อ่านจาก .env file
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000';
  
  // API Version - ตรงกับ FastAPI backend ของคุณ
  static String get apiVersion => dotenv.env['API_VERSION'] ?? 'v1';
  
  // Auth endpoints - ตรงกับ FastAPI backend ของคุณ
  static String get loginEndpoint => '/$apiVersion/auth/login';
  static String get registerEndpoint => '/$apiVersion/auth/register';
  static String get refreshTokenEndpoint => '/$apiVersion/auth/refresh';
  static String get logoutEndpoint => '/$apiVersion/auth/logout';
  static String get getCurrentUserEndpoint => '/$apiVersion/auth/me';
  static String get updateProfileEndpoint => '/$apiVersion/auth/profile';
  
  // Event endpoints
  static String get eventsEndpoint => '/$apiVersion/events';
  static String eventByIdEndpoint(String eventId) => '/$apiVersion/events/$eventId';
  static String get userRegisteredEventsEndpoint => '/$apiVersion/events/user/registered';
  
  // Announcement endpoints
  static String get announcementsEndpoint => '/$apiVersion/announcements';
  static String announcementByIdEndpoint(String announcementId) => '/$apiVersion/announcements/$announcementId';
  
  // Upload endpoints
  static String get uploadImageEndpoint => '/$apiVersion/upload/image';
  static String uploadedImageEndpoint(String filename) => '/$apiVersion/upload/image/$filename';
  
  // Configuration
  static int get apiTimeout => int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30') ?? 30;
  static bool get enableApiLogging => dotenv.env['ENABLE_API_LOGGING']?.toLowerCase() == 'true';
  static bool get debugMode => dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
  static String get appEnvironment => dotenv.env['APP_ENV'] ?? 'development';
  
  // Storage Keys
  static String get accessTokenKey => dotenv.env['JWT_TOKEN_KEY'] ?? 'access_token';
  static String get refreshTokenKey => dotenv.env['JWT_REFRESH_TOKEN_KEY'] ?? 'refresh_token';
  static String get tokenTypeKey => dotenv.env['JWT_TOKEN_TYPE_KEY'] ?? 'token_type';
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Helper methods
  static bool get isProduction => appEnvironment == 'production';
  static bool get isDevelopment => appEnvironment == 'development';
  static bool get isStaging => appEnvironment == 'staging';
}
