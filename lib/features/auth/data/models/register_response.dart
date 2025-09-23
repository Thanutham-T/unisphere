import 'login_response.dart'; // Reuse UserData from login_response

class RegisterResponse {
  final String message;
  final UserData user;

  const RegisterResponse({
    required this.message,
    required this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
    message: json['message'] as String? ?? 'User registered successfully',
    user: UserData.fromJson(json['user'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'user': user.toJson(),
  };
}