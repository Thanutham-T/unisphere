import 'package:json_annotation/json_annotation.dart';
import 'login_response.dart'; // Reuse UserData and TokenData

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  @JsonKey(defaultValue: 'User registered successfully')
  final String? message;
  
  final UserData? user;
  final TokenData? token; // เพิ่ม token เหมือน LoginResponse
  
  // สำหรับ backward compatibility
  @JsonKey(name: 'access_token')
  final String? accessToken;
  
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  
  @JsonKey(name: 'token_type')
  final String? tokenType;

  const RegisterResponse({
    this.message,
    this.user,
    this.token,
    this.accessToken,
    this.refreshToken,
    this.tokenType,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => 
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
  
  // Helper methods เพื่อ access token
  String get effectiveAccessToken => token?.accessToken ?? accessToken ?? '';
  String get effectiveRefreshToken => token?.refreshToken ?? refreshToken ?? '';
  String get effectiveTokenType => token?.tokenType ?? tokenType ?? 'bearer';
}