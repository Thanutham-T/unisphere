import 'package:dartz/dartz.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../mappers/user_mapper.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/services/key_value_storage_service.dart';
import '../../../../core/errors/exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final KeyValueStorageService storageService;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await remoteDataSource.login(request);
      
      // Save tokens to secure storage
      AppLogger.debug('💾 Saving tokens...');
      AppLogger.debug('   Access Token: ${response.effectiveAccessToken.substring(0, 20)}...');
      AppLogger.debug('   Refresh Token: ${response.effectiveRefreshToken.substring(0, 20)}...');
      AppLogger.debug('   Token Type: ${response.effectiveTokenType}');
      
      await storageService.setEncryptedString(ApiConstants.accessTokenKey, response.effectiveAccessToken);
      await storageService.setEncryptedString(ApiConstants.refreshTokenKey, response.effectiveRefreshToken);
      await storageService.setEncryptedString(ApiConstants.tokenTypeKey, response.effectiveTokenType);
      
      AppLogger.debug('✅ Tokens saved successfully');
      
      // ถ้าไม่มี user data ให้สร้าง user จาก email ที่ใช้ login
      User user;
      if (response.user != null) {
        user = response.user!.toEntity();
      } else {
        // สร้าง user entity จาก email ที่ใช้ login
        user = User(
          id: '1', // temporary ID - ในอนาคตอาจต้องเรียก API อีกครั้งเพื่อดึง user profile
          email: email,
          firstName: email.split('@')[0], // ใช้ส่วนแรกของ email เป็น firstName ชั่วคราว
          lastName: '',
          profileImage: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
      
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('เกิดข้อผิดพลาดที่ไม่คาดคิด: ${e.toString()}'));
    }
  }

  @override
  @override
  Future<Either<Failure, User>> register(RegisterRequest request) async {
    try {
      final response = await remoteDataSource.register(request);
      
      // ถ้า register สำเร็จและได้ token ให้เก็บไว้ (auto-login หลัง register)
      if (response.effectiveAccessToken.isNotEmpty) {
        AppLogger.debug('💾 Saving tokens after register...');
        AppLogger.debug('   Access Token: ${response.effectiveAccessToken.substring(0, 20)}...');
        
        await storageService.setEncryptedString(ApiConstants.accessTokenKey, response.effectiveAccessToken);
        await storageService.setEncryptedString(ApiConstants.refreshTokenKey, response.effectiveRefreshToken);
        await storageService.setEncryptedString(ApiConstants.tokenTypeKey, response.effectiveTokenType);
        
        AppLogger.debug('✅ Register tokens saved successfully');
      }
      
      // Convert to domain entity
      User user;
      if (response.user != null) {
        user = response.user!.toEntity();
      } else {
        // สร้าง user entity จาก request data
        user = User(
          id: '0', // จะได้ ID จริงจาก backend
          email: request.accountInfo.email,
          firstName: request.personalInfo.firstName,
          lastName: request.personalInfo.lastName,
          profileImage: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
      
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on BadRequestException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('เกิดข้อผิดพลาดในการสมัครสมาชิก: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Clear tokens from storage first (มีความสำคัญมากกว่า API call)
      await storageService.removeEncrypted(ApiConstants.accessTokenKey);
      await storageService.removeEncrypted(ApiConstants.refreshTokenKey);
      await storageService.removeEncrypted(ApiConstants.tokenTypeKey);
      
      // พยายามเรียก logout API (ถ้าล้มเหลวก็ไม่เป็นไร)
      try {
        await remoteDataSource.logout();
        AppLogger.debug('✅ Logout API called successfully');
      } catch (e) {
        AppLogger.debug('⚠️ Logout API failed (but local logout successful): $e');
        // ไม่ throw error เพราะ local logout สำเร็จแล้ว
      }
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('เกิดข้อผิดพลาดในการออกจากระบบ: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = await storageService.getEncryptedString(ApiConstants.accessTokenKey);
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return Left(ServerFailure('เกิดข้อผิดพลาดในการตรวจสอบสถานะการเข้าสู่ระบบ'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      AppLogger.debug('🔍 Getting current user from API...');
      
      final response = await remoteDataSource.getCurrentUser();
      
      User? user;
      if (response.user != null) {
        user = response.user!.toEntity();
        AppLogger.debug('✅ Got current user: ${user.email}');
      } else {
        AppLogger.debug('⚠️ No user data in response');
        user = null;
      }
      
      return Right(user);
    } on NetworkException catch (e) {
      AppLogger.debug('❌ Network error getting current user: ${e.message}');
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      AppLogger.debug('❌ Unauthorized getting current user: ${e.message}');
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      AppLogger.debug('❌ Server error getting current user: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      AppLogger.debug('❌ Unknown error getting current user: $e');
      return Left(ServerFailure('เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String?>> getAccessToken() async {
    try {
      final token = await storageService.getEncryptedString(ApiConstants.accessTokenKey);
      return Right(token);
    } catch (e) {
      return Left(ServerFailure('เกิดข้อผิดพลาดในการดึง access token'));
    }
  }
}
