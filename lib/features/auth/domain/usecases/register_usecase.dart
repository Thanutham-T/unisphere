import 'package:dartz/dartz.dart';

import '../repositories/auth_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';

class RegisterParams {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
}

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      params.email,
      params.password,
      params.firstName,
      params.lastName,
    );
  }
}