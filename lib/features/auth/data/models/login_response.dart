import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

// Updated for FastAPI backend compatibility
@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;
  
  @JsonKey(name: 'refresh_token', defaultValue: '')
  final String refreshToken;
  
  @JsonKey(name: 'token_type', defaultValue: 'bearer')
  final String tokenType;
  
  final UserData? user; // Optional user data

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    this.user, // ทำให้เป็น optional
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => 
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class UserData {
  final String id;
  final String email;
  
  @JsonKey(name: 'first_name')
  final String firstName;
  
  @JsonKey(name: 'last_name')
  final String lastName;
  
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  
  @JsonKey(name: 'created_at')
  final String createdAt;
  
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const UserData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => 
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
