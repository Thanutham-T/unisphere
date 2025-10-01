// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SectionScheduleModel _$SectionScheduleModelFromJson(
  Map<String, dynamic> json,
) => _SectionScheduleModel(
  scheduleId: (json['scheduleId'] as num).toInt(),
  sectionId: (json['sectionId'] as num).toInt(),
  dayId: (json['dayId'] as num).toInt(),
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  note: json['note'] as String?,
);

Map<String, dynamic> _$SectionScheduleModelToJson(
  _SectionScheduleModel instance,
) => <String, dynamic>{
  'scheduleId': instance.scheduleId,
  'sectionId': instance.sectionId,
  'dayId': instance.dayId,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'note': instance.note,
};
