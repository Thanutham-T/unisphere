// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faculty_translation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FacultyTranslationModel _$FacultyTranslationModelFromJson(
  Map<String, dynamic> json,
) => _FacultyTranslationModel(
  facultyId: (json['facultyId'] as num).toInt(),
  languageCode: json['languageCode'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$FacultyTranslationModelToJson(
  _FacultyTranslationModel instance,
) => <String, dynamic>{
  'facultyId': instance.facultyId,
  'languageCode': instance.languageCode,
  'name': instance.name,
  'description': instance.description,
};
