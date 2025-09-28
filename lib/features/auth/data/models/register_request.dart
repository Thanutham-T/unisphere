import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class PersonalInfo {
  @JsonKey(name: 'first_name')
  final String firstName;
  
  @JsonKey(name: 'last_name')
  final String lastName;
  
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  const PersonalInfo({
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => 
      _$PersonalInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalInfoToJson(this);
}

@JsonSerializable()
class EducationInfo {
  @JsonKey(name: 'student_id')
  final String? studentId;
  
  final String? faculty;
  final String? department;
  final String? major;
  final String? curriculum;
  
  @JsonKey(name: 'education_level')
  final String? educationLevel;
  
  final String? campus;

  const EducationInfo({
    this.studentId,
    this.faculty,
    this.department,
    this.major,
    this.curriculum,
    this.educationLevel,
    this.campus,
  });

  factory EducationInfo.fromJson(Map<String, dynamic> json) => 
      _$EducationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$EducationInfoToJson(this);
}

@JsonSerializable()
class AccountInfo {
  final String email;
  final String password;
  @JsonKey(name: 'confirm_password')
  final String confirmPassword;

  const AccountInfo({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) => 
      _$AccountInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInfoToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  @JsonKey(name: 'personal_info')
  final PersonalInfo personalInfo;
  
  @JsonKey(name: 'education_info')
  final EducationInfo educationInfo;
  
  @JsonKey(name: 'account_info')
  final AccountInfo accountInfo;

  const RegisterRequest({
    required this.personalInfo,
    required this.educationInfo,
    required this.accountInfo,
  });

  // Convenience constructor with individual fields
  factory RegisterRequest.create({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? studentId,
    String? faculty,
    String? department,
    String? major,
    String? curriculum,
    String? educationLevel,
    String? campus,
  }) {
    return RegisterRequest(
      personalInfo: PersonalInfo(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      ),
      educationInfo: EducationInfo(
        studentId: studentId,
        faculty: faculty,
        department: department,
        major: major,
        curriculum: curriculum,
        educationLevel: educationLevel,
        campus: campus,
      ),
      accountInfo: AccountInfo(
        email: email,
        password: password,
        confirmPassword: password, // Use the same password for confirmation
      ),
    );
  }

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => 
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}