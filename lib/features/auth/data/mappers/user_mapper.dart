import '../../domain/entities/user.dart';
import '../models/login_response.dart';

extension UserMapper on UserData {
  User toEntity() {
    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      profileImage: profileImage,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
