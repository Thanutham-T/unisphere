import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_translation_model.freezed.dart';
part 'day_translation_model.g.dart';


@freezed
abstract class DayTranslationModel with _$DayTranslationModel {
  const factory DayTranslationModel({
    required int dayId,
    required String languageCode,
    required String dayName,
  }) = _DayTranslationModel;

  factory DayTranslationModel.fromJson(Map<String, dynamic> json) => _$DayTranslationModelFromJson(json);
}
