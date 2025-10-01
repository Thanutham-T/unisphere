import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/domain/entities/user.dart';
import '../models/update_profile_request.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, User>> updateProfile(UpdateProfileRequest request);
}