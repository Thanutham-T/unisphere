import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
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
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
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
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        phoneNumber,
        studentId,
        faculty,
        department,
        major,
        curriculum,
        educationLevel,
        campus,
        profileImage,
        createdAt,
        updatedAt,
      ];
}
