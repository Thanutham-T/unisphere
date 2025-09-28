import 'package:dartz/dartz.dart';

import '../repositories/auth_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../../data/models/register_request.dart';

class RegisterParams {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? studentId;
  final String? faculty;
  final String? department;
  final String? major;
  final String? curriculum;
  final String? educationLevel;
  final String? campus;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.studentId,
    this.faculty,
    this.department,
    this.major,
    this.curriculum,
    this.educationLevel,
    this.campus,
  });
}

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    final request = RegisterRequest.create(
      email: params.email,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
      phoneNumber: params.phoneNumber,
      studentId: params.studentId,
      faculty: params.faculty,
      department: params.department,
      major: params.major,
      curriculum: params.curriculum,
      educationLevel: params.educationLevel,
      campus: params.campus,
    );
    
    return await repository.register(request);
  }
}