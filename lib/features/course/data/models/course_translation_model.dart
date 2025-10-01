import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_translation_model.freezed.dart';
part 'course_translation_model.g.dart';


@freezed
abstract class CourseTranslationModel with _$CourseTranslationModel {
  const factory CourseTranslationModel({
    required int courseId,
    required String languageCode,
    required String subjectName,
    String? description,
  }) = _CourseTranslationModel;

  factory CourseTranslationModel.fromJson(Map<String, dynamic> json) => _$CourseTranslationModelFromJson(json);
}
