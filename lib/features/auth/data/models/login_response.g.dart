// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String?,
      user: json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] == null
          ? null
          : TokenData.fromJson(json['token'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'user': instance.user,
      'token': instance.token,
    };

TokenData _$TokenDataFromJson(Map<String, dynamic> json) => TokenData(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  tokenType: json['token_type'] as String,
);

Map<String, dynamic> _$TokenDataToJson(TokenData instance) => <String, dynamic>{
  'access_token': instance.accessToken,
  'refresh_token': instance.refreshToken,
  'token_type': instance.tokenType,
};

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  profileImageUrl: json['profile_image_url'] as String?,
  phoneNumber: json['phone_number'] as String?,
  role: json['role'] as String?,
  studentId: json['student_id'] as String?,
  isActive: json['is_active'] as bool?,
  faculty: json['faculty'] as String?,
  department: json['department'] as String?,
  major: json['major'] as String?,
  curriculum: json['curriculum'] as String?,
  educationLevel: json['education_level'] as String?,
  campus: json['campus'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'profile_image_url': instance.profileImageUrl,
  'phone_number': instance.phoneNumber,
  'role': instance.role,
  'student_id': instance.studentId,
  'is_active': instance.isActive,
  'faculty': instance.faculty,
  'department': instance.department,
  'major': instance.major,
  'curriculum': instance.curriculum,
  'education_level': instance.educationLevel,
  'campus': instance.campus,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
