// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_instructor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SectionInstructorModel _$SectionInstructorModelFromJson(
  Map<String, dynamic> json,
) => _SectionInstructorModel(
  sectionId: (json['sectionId'] as num).toInt(),
  instructorId: (json['instructorId'] as num).toInt(),
);

Map<String, dynamic> _$SectionInstructorModelToJson(
  _SectionInstructorModel instance,
) => <String, dynamic>{
  'sectionId': instance.sectionId,
  'instructorId': instance.instructorId,
};
