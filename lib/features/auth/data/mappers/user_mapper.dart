import '../../domain/entities/user.dart';
import '../models/login_response.dart';

extension UserMapper on UserData {
  User toEntity() {
    return User(
      id: id.toString(), // แปลง int เป็น String
      email: email,
      firstName: firstName ?? '', // ใช้ empty string ถ้าเป็น null
      lastName: lastName ?? '', // ใช้ empty string ถ้าเป็น null
      phoneNumber: phoneNumber,
      studentId: studentId,
      faculty: faculty,
      department: department,
      major: major,
      curriculum: curriculum,
      educationLevel: educationLevel,
      campus: campus,
      profileImage: profileImageUrl, // เปลี่ยนจาก profileImage เป็น profileImageUrl
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : DateTime.now(), // handle nullable
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : DateTime.now(), // handle nullable
    );
  }
}
