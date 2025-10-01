// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserRegistrationModel _$UserRegistrationModelFromJson(
  Map<String, dynamic> json,
) => _UserRegistrationModel(
  registrationId: (json['registrationId'] as num).toInt(),
  studentId: (json['studentId'] as num).toInt(),
  courseId: (json['courseId'] as num).toInt(),
  sectionId: (json['sectionId'] as num).toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserRegistrationModelToJson(
  _UserRegistrationModel instance,
) => <String, dynamic>{
  'registrationId': instance.registrationId,
  'studentId': instance.studentId,
  'courseId': instance.courseId,
  'sectionId': instance.sectionId,
  'createdAt': instance.createdAt?.toIso8601String(),
};
