import 'package:freezed_annotation/freezed_annotation.dart';

part 'instructor_model.freezed.dart';
part 'instructor_model.g.dart';


@freezed
abstract class InstructorModel with _$InstructorModel {
  const factory InstructorModel({
    required int instructorId,
    @Default('active') String status,
    DateTime? archivedAt,
  }) = _InstructorModel;

  factory InstructorModel.fromJson(Map<String, dynamic> json) => _$InstructorModelFromJson(json);
}
