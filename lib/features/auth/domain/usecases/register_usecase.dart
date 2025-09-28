import 'package:dartz/dartz.dart';

import '../repositories/auth_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../../data/models/register_request.dart';

class RegisterUseCase implements UseCase<User, RegisterRequest> {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterRequest params) async {
    return await repository.register(params);
  }
}