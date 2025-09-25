import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  const AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await apiService.post(
      ApiConstants.loginEndpoint,
      request.toJson(),
      useFormData: true, // ใช้ form data สำหรับ OAuth2
    );
    
    return LoginResponse.fromJson(response);
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await apiService.post(
      ApiConstants.registerEndpoint,
      request.toJson(),
    );
    
    return RegisterResponse.fromJson(response);
  }

  @override
  Future<void> logout() async {
    await apiService.postAuthenticated(
      ApiConstants.logoutEndpoint,
      {},
    );
  }
}
