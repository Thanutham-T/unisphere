import 'package:dartz/dartz.dart';

import '../entities/user.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/register_request.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(RegisterRequest request);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, String?>> getAccessToken();
}
