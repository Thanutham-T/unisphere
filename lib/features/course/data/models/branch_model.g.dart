// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BranchModel _$BranchModelFromJson(Map<String, dynamic> json) => _BranchModel(
  branchId: (json['branchId'] as num).toInt(),
  facultyId: (json['facultyId'] as num).toInt(),
  branchCode: json['branchCode'] as String,
  status: json['status'] as String? ?? 'active',
  archivedAt: json['archivedAt'] == null
      ? null
      : DateTime.parse(json['archivedAt'] as String),
);

Map<String, dynamic> _$BranchModelToJson(_BranchModel instance) =>
    <String, dynamic>{
      'branchId': instance.branchId,
      'facultyId': instance.facultyId,
      'branchCode': instance.branchCode,
      'status': instance.status,
      'archivedAt': instance.archivedAt?.toIso8601String(),
    };
