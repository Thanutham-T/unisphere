class ApiConfig {
  // Base URL of your FastAPI backend
  static String baseUrl = 'http://localhost:8000';

  // The JWT access token to send with requests (set this after login)
  static String? accessToken;
}
