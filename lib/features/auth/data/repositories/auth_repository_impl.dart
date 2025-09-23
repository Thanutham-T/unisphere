import 'package:dartz/dartz.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../mappers/user_mapper.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/key_value_storage_service.dart';

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
      await storageService.setString(ApiConstants.accessTokenKey, response.accessToken);
      await storageService.setString(ApiConstants.refreshTokenKey, response.refreshToken);
      await storageService.setString(ApiConstants.tokenTypeKey, response.tokenType);
      
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
  Future<Either<Failure, User>> register(String email, String password, String firstName, String lastName) async {
    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      final response = await remoteDataSource.register(request);
      
      // Convert to domain entity
      final user = response.user.toEntity();
      
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
      await storageService.remove(ApiConstants.accessTokenKey);
      await storageService.remove(ApiConstants.refreshTokenKey);
      await storageService.remove(ApiConstants.tokenTypeKey);
      
      // พยายามเรียก logout API (ถ้าล้มเหลวก็ไม่เป็นไร)
      try {
        await remoteDataSource.logout();
        print('✅ Logout API called successfully');
      } catch (e) {
        print('⚠️ Logout API failed (but local logout successful): $e');
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
      final token = await storageService.getString(ApiConstants.accessTokenKey);
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return Left(ServerFailure('เกิดข้อผิดพลาดในการตรวจสอบสถานะการเข้าสู่ระบบ'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // TODO: Implement get current user from API or cache
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('เกิดข้อผิดพลาดในการดึงข้อมูลผู้ใช้'));
    }
  }

  @override
  Future<Either<Failure, String?>> getAccessToken() async {
    try {
      final token = await storageService.getString(ApiConstants.accessTokenKey);
      return Right(token);
    } catch (e) {
      return Left(ServerFailure('เกิดข้อผิดพลาดในการดึง access token'));
    }
  }
}
