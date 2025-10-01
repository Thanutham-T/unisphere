// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faculty_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FacultyModel _$FacultyModelFromJson(Map<String, dynamic> json) =>
    _FacultyModel(
      facultyId: (json['facultyId'] as num).toInt(),
      facultyCode: json['facultyCode'] as String,
      status: json['status'] as String? ?? 'active',
      archivedAt: json['archivedAt'] == null
          ? null
          : DateTime.parse(json['archivedAt'] as String),
    );

Map<String, dynamic> _$FacultyModelToJson(_FacultyModel instance) =>
    <String, dynamic>{
      'facultyId': instance.facultyId,
      'facultyCode': instance.facultyCode,
      'status': instance.status,
      'archivedAt': instance.archivedAt?.toIso8601String(),
    };
