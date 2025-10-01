import 'package:freezed_annotation/freezed_annotation.dart';

part 'faculty_model.freezed.dart';
part 'faculty_model.g.dart';


@freezed
abstract class FacultyModel with _$FacultyModel {
  const factory FacultyModel({
    required int facultyId,
    required String facultyCode,
    @Default('active') String status,
    DateTime? archivedAt,
  }) = _FacultyModel;

  factory FacultyModel.fromJson(Map<String, dynamic> json) => _$FacultyModelFromJson(json);
}
