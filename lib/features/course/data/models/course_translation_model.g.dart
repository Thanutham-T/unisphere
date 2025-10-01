// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_translation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseTranslationModel _$CourseTranslationModelFromJson(
  Map<String, dynamic> json,
) => _CourseTranslationModel(
  courseId: (json['courseId'] as num).toInt(),
  languageCode: json['languageCode'] as String,
  subjectName: json['subjectName'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$CourseTranslationModelToJson(
  _CourseTranslationModel instance,
) => <String, dynamic>{
  'courseId': instance.courseId,
  'languageCode': instance.languageCode,
  'subjectName': instance.subjectName,
  'description': instance.description,
};
