import '../../domain/entities/user.dart';
import '../models/login_response.dart';

extension UserMapper on UserData {
  User toEntity() {
    return User(
      id: id.toString(), // แปลง int เป็ String
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
  
  static User fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber: json['phone_number'],
      studentId: json['student_id'],
      faculty: json['faculty'],
      department: json['department'],
      major: json['major'],
      curriculum: json['curriculum'],
      educationLevel: json['education_level'],
      campus: json['campus'],
      profileImage: json['profile_image_url'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }
}
