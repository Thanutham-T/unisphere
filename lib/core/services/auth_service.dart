import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../constants/api_constants.dart';
import '../logging/app_logger.dart';
import '../services/key_value_storage_service.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';

/// Service สำหรับจัดการ auto logout เมื่อ token หมดอายุ
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  KeyValueStorageService? _storageService;
  
  void initialize(KeyValueStorageService storageService) {
    _storageService = storageService;
  }

  /// ฟังก์ชันสำหรับ auto logout เมื่อได้รับ 401 Unauthorized
  /// ใช้เมื่อเกิด error ที่บ่งบอกว่า token หมดอายุ
  Future<void> handleUnauthorized(BuildContext context, {String? reason}) async {
    AppLogger.warning('🚪 Auto logout due to unauthorized access: ${reason ?? "Token expired"}');
    
    try {
      // Clear tokens from storage
      if (_storageService != null) {
        await _storageService!.removeEncrypted(ApiConstants.accessTokenKey);
        await _storageService!.removeEncrypted(ApiConstants.refreshTokenKey);
        await _storageService!.removeEncrypted(ApiConstants.tokenTypeKey);
        AppLogger.debug('✅ Auth tokens cleared from storage');
      }

      // Trigger logout event in AuthBloc
      if (context.mounted) {
        context.read<AuthBloc>().add(const LogoutRequested());
        
        // Navigate to login screen
        _navigateToLogin(context);
        
        // Show user-friendly message
        _showLogoutMessage(context, reason);
      }
    } catch (e) {
      AppLogger.error('❌ Error during auto logout', e);
      
      // Fallback: ถ้าเกิด error ให้พาไปหน้า login โดยตรง
      if (context.mounted) {
        _navigateToLogin(context);
      }
    }
  }

  /// Navigate to login screen (ใช้ pushReplacement เพื่อไม่ให้กลับมาได้)
  void _navigateToLogin(BuildContext context) {
    try {
      if (context.mounted) {
        // ใช้ go แทน pushReplacement เพื่อ clear navigation stack
        context.go('/login');
        AppLogger.debug('🔄 Navigated to login screen');
      }
    } catch (e) {
      AppLogger.error('❌ Navigation error', e);
    }
  }

  /// แสดงข้อความแจ้งเตือนผู้ใช้
  void _showLogoutMessage(BuildContext context, String? reason) {
    try {
      if (context.mounted) {
        String message;
        if (reason?.contains('401') == true || reason?.contains('Unauthorized') == true) {
          message = 'เซสชันหมดอายุ กรุณาเข้าสู่ระบบใหม่';
        } else {
          message = 'กรุณาเข้าสู่ระบบใหม่เพื่อใช้งานต่อ';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'เข้าสู่ระบบ',
              textColor: Colors.white,
              onPressed: () => _navigateToLogin(context),
            ),
          ),
        );
      }
    } catch (e) {
      AppLogger.error('❌ Error showing logout message', e);
    }
  }

  /// ตรวจสอบว่า token ยังใช้ได้อยู่หรือไม่
  Future<bool> isTokenValid() async {
    try {
      if (_storageService == null) return false;
      
      final token = await _storageService!.getEncryptedString(ApiConstants.accessTokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      AppLogger.error('❌ Error checking token validity', e);
      return false;
    }
  }

  /// ฟังก์ชันสำหรับ manual logout (เช่น จากปุ่ม logout)
  Future<void> manualLogout(BuildContext context) async {
    AppLogger.info('🚪 Manual logout requested');
    
    try {
      if (context.mounted) {
        context.read<AuthBloc>().add(const LogoutRequested());
        _showLogoutMessage(context, 'ออกจากระบบสำเร็จ');
      }
    } catch (e) {
      AppLogger.error('❌ Error during manual logout', e);
      
      // Fallback: clear tokens manually
      if (_storageService != null) {
        await _storageService!.removeEncrypted(ApiConstants.accessTokenKey);
        await _storageService!.removeEncrypted(ApiConstants.refreshTokenKey);
        await _storageService!.removeEncrypted(ApiConstants.tokenTypeKey);
      }
      
      if (context.mounted) {
        _navigateToLogin(context);
      }
    }
  }
}