import 'package:freezed_annotation/freezed_annotation.dart';

part 'section_instructor_model.freezed.dart';
part 'section_instructor_model.g.dart';


@freezed
abstract class SectionInstructorModel with _$SectionInstructorModel {
  const factory SectionInstructorModel({
    required int sectionId,
    required int instructorId,
  }) = _SectionInstructorModel;

  factory SectionInstructorModel.fromJson(Map<String, dynamic> json) => _$SectionInstructorModelFromJson(json);
}
