import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_translation_model.freezed.dart';
part 'branch_translation_model.g.dart';


@freezed
abstract class BranchTranslationModel with _$BranchTranslationModel {
  const factory BranchTranslationModel({
    required int branchId,
    required String languageCode,
    required String name,
    String? description,
  }) = _BranchTranslationModel;

  factory BranchTranslationModel.fromJson(Map<String, dynamic> json) => _$BranchTranslationModelFromJson(json);
}
