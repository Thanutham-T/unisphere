import 'package:freezed_annotation/freezed_annotation.dart';

part 'instructor_translation_model.freezed.dart';
part 'instructor_translation_model.g.dart';


@freezed
abstract class InstructorTranslationModel with _$InstructorTranslationModel {
  const factory InstructorTranslationModel({
    required int instructorId,
    required String languageCode,
    required String instructorName,
  }) = _InstructorTranslationModel;

  factory InstructorTranslationModel.fromJson(Map<String, dynamic> json) => _$InstructorTranslationModelFromJson(json);
}
