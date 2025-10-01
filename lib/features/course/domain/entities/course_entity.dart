import 'package:freezed_annotation/freezed_annotation.dart';

import '../entities/section_entity.dart';

part 'course_entity.freezed.dart';

@freezed
abstract class CourseEntity with _$CourseEntity {
  const factory CourseEntity({
    required int courseId,
    required String courseCode,
    required String subjectName,
    String? description,
    required int branchId,
    required String semester,
    required DateTime startDate,
    required DateTime endDate,
    int? selectedSectionId,
    @Default(false) bool isEnrolled,
    @Default([]) List<SectionEntity>? sections,
    required String status,
  }) = _CourseEntity;
}
