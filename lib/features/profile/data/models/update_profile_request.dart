import 'package:json_annotation/json_annotation.dart';

part 'update_profile_request.g.dart';

@JsonSerializable()
class UpdateProfileRequest {
  @JsonKey(name: 'student_id')
  final String? studentId;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final String? email;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl;
  final String? faculty;
  final String? department;
  final String? major;
  final String? curriculum;
  @JsonKey(name: 'education_level')
  final String? educationLevel;
  final String? campus;

  const UpdateProfileRequest({
    this.studentId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.profileImageUrl,
    this.faculty,
    this.department,
    this.major,
    this.curriculum,
    this.educationLevel,
    this.campus,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}