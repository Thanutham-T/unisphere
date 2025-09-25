import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => 
      _$LoginRequestFromJson(json);

  // FastAPI ปกติจะใช้ username field สำหรับ login
  Map<String, dynamic> toJson() => {
    'username': email, // ส่ง email เป็น username
    'password': password,
  };
}
