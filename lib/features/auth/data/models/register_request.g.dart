// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalInfo _$PersonalInfoFromJson(Map<String, dynamic> json) => PersonalInfo(
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  phoneNumber: json['phone_number'] as String?,
);

Map<String, dynamic> _$PersonalInfoToJson(PersonalInfo instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone_number': instance.phoneNumber,
    };

EducationInfo _$EducationInfoFromJson(Map<String, dynamic> json) =>
    EducationInfo(
      studentId: json['student_id'] as String?,
      faculty: json['faculty'] as String?,
      department: json['department'] as String?,
      major: json['major'] as String?,
      curriculum: json['curriculum'] as String?,
      educationLevel: json['education_level'] as String?,
      campus: json['campus'] as String?,
    );

Map<String, dynamic> _$EducationInfoToJson(EducationInfo instance) =>
    <String, dynamic>{
      'student_id': instance.studentId,
      'faculty': instance.faculty,
      'department': instance.department,
      'major': instance.major,
      'curriculum': instance.curriculum,
      'education_level': instance.educationLevel,
      'campus': instance.campus,
    };

AccountInfo _$AccountInfoFromJson(Map<String, dynamic> json) => AccountInfo(
  email: json['email'] as String,
  password: json['password'] as String,
  confirmPassword: json['confirm_password'] as String,
);

Map<String, dynamic> _$AccountInfoToJson(AccountInfo instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'confirm_password': instance.confirmPassword,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      personalInfo: PersonalInfo.fromJson(
        json['personal_info'] as Map<String, dynamic>,
      ),
      educationInfo: EducationInfo.fromJson(
        json['education_info'] as Map<String, dynamic>,
      ),
      accountInfo: AccountInfo.fromJson(
        json['account_info'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'personal_info': instance.personalInfo,
      'education_info': instance.educationInfo,
      'account_info': instance.accountInfo,
    };
