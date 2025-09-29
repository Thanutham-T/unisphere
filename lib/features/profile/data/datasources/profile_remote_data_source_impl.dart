import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/data/mappers/user_mapper.dart';
import '../models/update_profile_request.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSourceImpl(this.apiService);

  @override
  Future<Either<Failure, User>> updateProfile(UpdateProfileRequest request) async {
    try {
      // Debug log the request
      print('🔍 Profile Update Request: ${request.toJson()}');
      
      final response = await apiService.put(
        ApiConstants.updateProfileEndpoint,
        request.toJson(),
        requiresAuth: true,
      );

      final user = UserMapper.fromMap(response);
      return Right(user);
    } catch (e) {
      print('❌ Profile Update Error: $e');
      if (e is UnauthorizedException) {
        return Left(AuthFailure('ไม่มีสิทธิ์เข้าถึง'));
      } else if (e is ServerException) {
        return Left(ServerFailure(e.toString()));
      } else {
        return Left(ServerFailure('เกิดข้อผิดพลาดในการอัปเดตข้อมูล: ${e.toString()}'));
      }
    }
  }
}