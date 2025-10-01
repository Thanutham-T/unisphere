import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_model.freezed.dart';
part 'branch_model.g.dart';


@freezed
abstract class BranchModel with _$BranchModel {
  const factory BranchModel({
    required int branchId,
    required int facultyId,
    required String branchCode,
    @Default('active') String status,
    DateTime? archivedAt,
  }) = _BranchModel;

  factory BranchModel.fromJson(Map<String, dynamic> json) => _$BranchModelFromJson(json);
}
