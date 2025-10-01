// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_translation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DayTranslationModel _$DayTranslationModelFromJson(Map<String, dynamic> json) =>
    _DayTranslationModel(
      dayId: (json['dayId'] as num).toInt(),
      languageCode: json['languageCode'] as String,
      dayName: json['dayName'] as String,
    );

Map<String, dynamic> _$DayTranslationModelToJson(
  _DayTranslationModel instance,
) => <String, dynamic>{
  'dayId': instance.dayId,
  'languageCode': instance.languageCode,
  'dayName': instance.dayName,
};
