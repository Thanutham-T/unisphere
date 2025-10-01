// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SectionModel _$SectionModelFromJson(Map<String, dynamic> json) =>
    _SectionModel(
      sectionId: (json['sectionId'] as num).toInt(),
      courseId: (json['courseId'] as num).toInt(),
      sectionCode: json['sectionCode'] as String,
      studentLimit: (json['studentLimit'] as num).toInt(),
      status: json['status'] as String? ?? 'active',
      archivedAt: json['archivedAt'] == null
          ? null
          : DateTime.parse(json['archivedAt'] as String),
    );

Map<String, dynamic> _$SectionModelToJson(_SectionModel instance) =>
    <String, dynamic>{
      'sectionId': instance.sectionId,
      'courseId': instance.courseId,
      'sectionCode': instance.sectionCode,
      'studentLimit': instance.studentLimit,
      'status': instance.status,
      'archivedAt': instance.archivedAt?.toIso8601String(),
    };
