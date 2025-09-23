// Updated for FastAPI backend compatibility
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final UserData? user; // Optional user data

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    this.user, // ทำให้เป็น optional
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] as String? ?? '',
    tokenType: json['token_type'] as String? ?? 'bearer',
    user: json['user'] != null 
        ? UserData.fromJson(json['user'] as Map<String, dynamic>)
        : null, // ถ้าไม่มี user data ให้เป็น null
  );

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'token_type': tokenType,
    if (user != null) 'user': user!.toJson(),
  };
}

class UserData {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? profileImage;
  final String createdAt;
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

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json['id']?.toString() ?? '',
    email: json['email'] as String,
    firstName: json['first_name'] as String? ?? json['firstName'] as String? ?? '',
    lastName: json['last_name'] as String? ?? json['lastName'] as String? ?? '',
    profileImage: json['profile_image'] as String? ?? json['profileImage'] as String?,
    createdAt: json['created_at'] as String? ?? json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    updatedAt: json['updated_at'] as String? ?? json['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'profile_image': profileImage,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
