import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_entity.freezed.dart';

@freezed
abstract class ScheduleEntity with _$ScheduleEntity {
  const factory ScheduleEntity({
    required int dayId,
    required String dayName,
    required String startTime,
    required String endTime,
  }) = _ScheduleEntity;
}
