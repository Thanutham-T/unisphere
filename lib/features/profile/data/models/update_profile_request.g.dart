// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileRequest _$UpdateProfileRequestFromJson(
  Map<String, dynamic> json,
) => UpdateProfileRequest(
  studentId: json['student_id'] as String?,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  email: json['email'] as String?,
  phoneNumber: json['phone_number'] as String?,
  profileImageUrl: json['profile_image_url'] as String?,
  faculty: json['faculty'] as String?,
  department: json['department'] as String?,
  major: json['major'] as String?,
  curriculum: json['curriculum'] as String?,
  educationLevel: json['education_level'] as String?,
  campus: json['campus'] as String?,
);

Map<String, dynamic> _$UpdateProfileRequestToJson(
  UpdateProfileRequest instance,
) => <String, dynamic>{
  'student_id': instance.studentId,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'email': instance.email,
  'phone_number': instance.phoneNumber,
  'profile_image_url': instance.profileImageUrl,
  'faculty': instance.faculty,
  'department': instance.department,
  'major': instance.major,
  'curriculum': instance.curriculum,
  'education_level': instance.educationLevel,
  'campus': instance.campus,
};
