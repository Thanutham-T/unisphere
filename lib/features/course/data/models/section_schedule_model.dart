import 'package:freezed_annotation/freezed_annotation.dart';

part 'section_schedule_model.freezed.dart';
part 'section_schedule_model.g.dart';


@freezed
abstract class SectionScheduleModel with _$SectionScheduleModel {
  const factory SectionScheduleModel({
    required int scheduleId,
    required int sectionId,
    required int dayId,
    required String startTime,
    required String endTime,
  }) = _SectionScheduleModel;

  factory SectionScheduleModel.fromJson(Map<String, dynamic> json) => _$SectionScheduleModelFromJson(json);
}
