import 'package:json_annotation/json_annotation.dart';

part 'profile_response.g.dart';
// part 'profile_response.freezed.dart'; // disabled temporarily due to freezed formatting issues

@JsonSerializable()
class ProfileResponse {
  final String id;
  final String email;
  final String name;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? educationLevel;
  final String? educationInstitution;
  final String? educationMajor;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  @JsonKey(defaultValue: true)
  final bool isActive;
  @JsonKey(defaultValue: false)
  final bool isVerified;

  const ProfileResponse({
    required this.id,
    required this.email,
    required this.name,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.educationLevel,
    this.educationInstitution,
    this.educationMajor,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.isVerified = false,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}

@JsonSerializable()
class UpdateProfileRequest {
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? educationLevel;
  final String? educationInstitution;
  final String? educationMajor;

  const UpdateProfileRequest({
    this.name,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.educationLevel,
    this.educationInstitution,
    this.educationMajor,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}
