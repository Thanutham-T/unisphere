// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_translation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BranchTranslationModel _$BranchTranslationModelFromJson(
  Map<String, dynamic> json,
) => _BranchTranslationModel(
  branchId: (json['branchId'] as num).toInt(),
  languageCode: json['languageCode'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$BranchTranslationModelToJson(
  _BranchTranslationModel instance,
) => <String, dynamic>{
  'branchId': instance.branchId,
  'languageCode': instance.languageCode,
  'name': instance.name,
  'description': instance.description,
};
