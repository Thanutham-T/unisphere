import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

// Updated for FastAPI backend compatibility
@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'access_token')
  final String? accessToken;
  
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  
  @JsonKey(name: 'token_type')
  final String? tokenType;
  
  final UserData? user;
  final TokenData? token; // เพิ่ม token object

  const LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.user,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => 
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
  
  // Helper methods เพื่อ access token จาก nested object
  String get effectiveAccessToken => token?.accessToken ?? accessToken ?? '';
  String get effectiveRefreshToken => token?.refreshToken ?? refreshToken ?? '';
  String get effectiveTokenType => token?.tokenType ?? tokenType ?? 'bearer';
}

@JsonSerializable()
class TokenData {
  @JsonKey(name: 'access_token')
  final String accessToken;
  
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  
  @JsonKey(name: 'token_type')
  final String tokenType;

  const TokenData({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory TokenData.fromJson(Map<String, dynamic> json) => 
      _$TokenDataFromJson(json);

  Map<String, dynamic> toJson() => _$TokenDataToJson(this);
}

@JsonSerializable()
class UserData {
  final int id; // เปลี่ยนจาก String เป็น int ตาม response
  final String email;
  
  @JsonKey(name: 'first_name')
  final String? firstName; // เปลี่ยนเป็น nullable
  
  @JsonKey(name: 'last_name')
  final String? lastName; // เปลี่ยนเป็น nullable
  
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl; // รองรับ null
  
  @JsonKey(name: 'phone_number')
  final String? phoneNumber; // เพิ่มเพื่อรองรับ response
  
  final String? role;
  @JsonKey(name: 'student_id')
  final String? studentId;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  final String? faculty;
  final String? department;
  final String? major;
  final String? curriculum;
  @JsonKey(name: 'education_level')
  final String? educationLevel;
  final String? campus;
  
  @JsonKey(name: 'created_at')
  final String? createdAt; // เปลี่ยนเป็น nullable
  
  @JsonKey(name: 'updated_at')
  final String? updatedAt; // เปลี่ยนเป็น nullable

  const UserData({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.profileImageUrl,
    this.phoneNumber,
    this.role,
    this.studentId,
    this.isActive,
    this.faculty,
    this.department,
    this.major,
    this.curriculum,
    this.educationLevel,
    this.campus,
    this.createdAt,
    this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => 
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
