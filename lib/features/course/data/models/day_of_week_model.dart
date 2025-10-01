import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_of_week_model.freezed.dart';
part 'day_of_week_model.g.dart';


@freezed
abstract class DayOfWeekModel with _$DayOfWeekModel {
  const factory DayOfWeekModel({
    required int dayId,
    required String dayCode,
  }) = _DayOfWeekModel;

  factory DayOfWeekModel.fromJson(Map<String, dynamic> json) => _$DayOfWeekModelFromJson(json);
}
