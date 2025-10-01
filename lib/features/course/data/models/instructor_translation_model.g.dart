// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_translation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InstructorTranslationModel _$InstructorTranslationModelFromJson(
  Map<String, dynamic> json,
) => _InstructorTranslationModel(
  instructorId: (json['instructorId'] as num).toInt(),
  languageCode: json['languageCode'] as String,
  instructorName: json['instructorName'] as String,
);

Map<String, dynamic> _$InstructorTranslationModelToJson(
  _InstructorTranslationModel instance,
) => <String, dynamic>{
  'instructorId': instance.instructorId,
  'languageCode': instance.languageCode,
  'instructorName': instance.instructorName,
};
