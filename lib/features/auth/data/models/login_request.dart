class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  // FastAPI ปกติจะใช้ username field สำหรับ login
  Map<String, dynamic> toJson() => {
    'username': email, // ส่ง email เป็น username
    'password': password,
  };
}
