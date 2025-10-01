import 'package:freezed_annotation/freezed_annotation.dart';

part 'faculty_translation_model.freezed.dart';
part 'faculty_translation_model.g.dart';


@freezed
abstract class FacultyTranslationModel with _$FacultyTranslationModel {
  const factory FacultyTranslationModel({
    required int facultyId,
    required String languageCode,
    required String name,
    String? description,
  }) = _FacultyTranslationModel;

  factory FacultyTranslationModel.fromJson(Map<String, dynamic> json) => _$FacultyTranslationModelFromJson(json);
}
