import 'package:freezed_annotation/freezed_annotation.dart';

part 'section_model.freezed.dart';
part 'section_model.g.dart';


@freezed
abstract class SectionModel with _$SectionModel {
  const factory SectionModel({
    required int sectionId,
    required int courseId,
    required String sectionCode,
    required int studentLimit,
    @Default('active') String status,
    DateTime? archivedAt,
  }) = _SectionModel;

  factory SectionModel.fromJson(Map<String, dynamic> json) => _$SectionModelFromJson(json);
}
