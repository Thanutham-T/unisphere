// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => _CourseModel(
  courseId: (json['courseId'] as num).toInt(),
  courseCode: json['courseCode'] as String,
  branchId: (json['branchId'] as num).toInt(),
  semester: json['semester'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  status: json['status'] as String? ?? 'active',
  archivedAt: json['archivedAt'] == null
      ? null
      : DateTime.parse(json['archivedAt'] as String),
);

Map<String, dynamic> _$CourseModelToJson(_CourseModel instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'courseCode': instance.courseCode,
      'branchId': instance.branchId,
      'semester': instance.semester,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'status': instance.status,
      'archivedAt': instance.archivedAt?.toIso8601String(),
    };
