import 'package:json_annotation/json_annotation.dart';
import 'login_response.dart'; // Reuse UserData from login_response

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  @JsonKey(defaultValue: 'User registered successfully')
  final String message;
  final UserData user;

  const RegisterResponse({
    required this.message,
    required this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => 
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}