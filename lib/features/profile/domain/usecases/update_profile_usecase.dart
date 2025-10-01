import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';
import '../../data/models/update_profile_request.dart';

class UpdateProfileUseCase implements UseCase<User, UpdateProfileRequest> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateProfileRequest params) async {
    return await repository.updateProfile(params);
  }
}