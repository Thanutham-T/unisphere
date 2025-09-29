import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_filter_state.freezed.dart';

@freezed
abstract class CourseFilterState with _$CourseFilterState {
  const factory CourseFilterState({
    @Default('') String searchQuery,
    @Default('All') String selectedFilter,
  }) = _CourseFilterState;
}
