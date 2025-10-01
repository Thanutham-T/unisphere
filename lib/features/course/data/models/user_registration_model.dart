import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_registration_model.freezed.dart';
part 'user_registration_model.g.dart';

@freezed
abstract class UserRegistrationModel with _$UserRegistrationModel {
  const factory UserRegistrationModel({
    required int registrationId,
    required int studentId,
    required int courseId,
    required int sectionId,
    DateTime? createdAt,
  }) = _UserRegistrationModel;

  factory UserRegistrationModel.fromJson(Map<String, dynamic> json) => _$UserRegistrationModelFromJson(json);
}
