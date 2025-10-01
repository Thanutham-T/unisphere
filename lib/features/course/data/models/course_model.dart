import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';


@freezed
abstract class CourseModel with _$CourseModel {
  const factory CourseModel({
    required int courseId,
    required String courseCode,
    required int branchId,
    required String semester,
    required DateTime startDate,
    required DateTime endDate,
    @Default('active') String status,
    DateTime? archivedAt,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) => _$CourseModelFromJson(json);
}
