import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/domain/entities/user.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/update_profile_request.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> updateProfile(UpdateProfileRequest request) async {
    return await remoteDataSource.updateProfile(request);
  }
}