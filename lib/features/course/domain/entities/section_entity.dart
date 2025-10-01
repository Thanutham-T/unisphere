import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/schedule_entity.dart';
import '../entities/instructor_entity.dart';

part 'section_entity.freezed.dart';


@freezed
abstract class SectionEntity with _$SectionEntity {
  const factory SectionEntity({
    required int sectionId,
    required String sectionCode,
    required int studentLimit,
    @Default('active') String status,
    @Default([]) List<ScheduleEntity>? schedules,
    @Default([]) List<InstructorEntity>? instructors,
    @Default(false) bool isSelected,
  }) = _SectionEntity;
}
