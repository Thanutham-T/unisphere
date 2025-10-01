import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../errors/exceptions.dart';
import '../logging/app_logger.dart';

/// Global error handler สำหรับจัดการ authentication errors
class GlobalErrorHandler {
  static final GlobalErrorHandler _instance = GlobalErrorHandler._internal();
  factory GlobalErrorHandler() => _instance;
  GlobalErrorHandler._internal();

  /// จัดการ UnauthorizedException และทำ auto logout
  static Future<void> handleUnauthorizedException(
    BuildContext context,
    UnauthorizedException exception,
  ) async {
    AppLogger.warning('🚨 UnauthorizedException caught: ${exception.message}');
    
    try {
      // ใช้ AuthService ทำ auto logout
      await AuthService().handleUnauthorized(
        context,
        reason: exception.message,
      );
    } catch (e) {
      AppLogger.error('❌ Error handling unauthorized exception', e);
    }
  }

  /// จัดการ error ทั่วไป และตรวจสอบว่าเป็น auth error หรือไม่
  static Future<void> handleError(
    BuildContext context,
    dynamic error,
  ) async {
    if (error is UnauthorizedException) {
      await handleUnauthorizedException(context, error);
    } else {
      // จัดการ error อื่นๆ ตามปกติ
      AppLogger.error('❌ General error occurred', error);
    }
  }

  /// Check if error message indicates token expiration
  static bool isTokenExpiredError(String errorMessage) {
    final lowerMessage = errorMessage.toLowerCase();
    return lowerMessage.contains('unauthorized') ||
           lowerMessage.contains('401') ||
           lowerMessage.contains('token') ||
           lowerMessage.contains('expired') ||
           lowerMessage.contains('invalid token');
  }
}