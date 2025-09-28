import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/logging/app_logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: ''); // ใส่ email จริงจาก database
  final _passwordController = TextEditingController(text: ''); // ใส่ password จริงจาก database
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'รูปแบบอีเมลไม่ถูกต้อง';
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    }
    
    if (value.length < 6) {
      return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
    }
    
    return null;
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  // ฟังก์ชันทดสอบ API Connection
  Future<void> _testApiConnection() async {
    AppLogger.debug('🧪 Testing API Connection...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('กำลังทดสอบการเชื่อมต่อ API...')),
    );

    try {
      final client = http.Client();
      
      AppLogger.debug('🌐 Step 1: Getting constants...');
      final baseUrl = ApiConstants.baseUrl;
      final loginEndpoint = ApiConstants.loginEndpoint;
      
      AppLogger.debug('🌐 Base URL: $baseUrl');
      AppLogger.debug('🌐 Login Endpoint: $loginEndpoint');
      
      final url = Uri.parse('$baseUrl$loginEndpoint');
      AppLogger.debug('🌐 Full URL: $url');
      
      final testData = {
        'email': 'user@example.com', // ใช้ email ตาม FastAPI spec
        'password': 'string'
      };

      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(testData),
      ).timeout(const Duration(seconds: 10));

      AppLogger.debug('📡 Response Status: ${response.statusCode}');
      AppLogger.debug('📡 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 422 || response.statusCode == 401) {
        // Status codes ที่คาดหวัง (422 = validation error, 401 = unauthorized)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ เชื่อมต่อ API สำเร็จ! เซิร์ฟเวอร์ทำงานปกติ'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ เซิร์ฟเวอร์ตอบกลับรหัส: ${response.statusCode}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      AppLogger.debug('❌ Connection Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ ไม่สามารถเชื่อมต่อ API ได้: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.debug('🏗️ Building LoginScreen');
    
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to dashboard on successful login
            context.goToDashboard();
          } else if (state is AuthError) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  
                  // Logo and Title
                  Column(
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // Subtle theme-aware border without affecting logo visibility
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).colorScheme.surface
                              : Colors.grey.shade50,
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).colorScheme.outline.withOpacity(0.2)
                                : Colors.grey.shade200,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 15,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: ClipOval(
                          child: Container(
                            width: 124,
                            height: 124,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // Use a consistent background that works for both themes
                              color: Colors.white,
                            ),
                            child: Image.asset(
                              'assets/icons/unisphere_icon.png',
                              width: 124,
                              height: 124,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback to icon if image fails to load
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).colorScheme.primary,
                                        Theme.of(context).colorScheme.secondary,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.school,
                                    size: 60,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'UNISPHERE',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'เข้าสู่ระบบเพื่อดำเนินการต่อ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Email Field
                  AuthTextField(
                    controller: _emailController,
                    labelText: 'อีเมล',
                    hintText: 'กรอกอีเมลของคุณ',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Password Field
                  AuthTextField(
                    controller: _passwordController,
                    labelText: 'รหัสผ่าน',
                    hintText: 'กรอกรหัสผ่านของคุณ',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_isPasswordVisible,
                    textInputAction: TextInputAction.done,
                    validator: _validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    onFieldSubmitted: (_) => _onLoginPressed(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Login Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      AppLogger.debug('🔄 Building login button - State: ${state.runtimeType}');
                      return Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AuthButton(
                          text: 'เข้าสู่ระบบ',
                          onPressed: state is AuthLoading ? null : _onLoginPressed,
                          isLoading: state is AuthLoading,
                        ),
                      );
                    },
                  ),
                  
                  // Test API Connection Button
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _testApiConnection,
                    icon: const Icon(Icons.wifi_tethering),
                    label: const Text('ทดสอบการเชื่อมต่อ API'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ยังไม่มีบัญชี? '),
                      TextButton(
                        onPressed: () {
                          context.goToRegister();
                        },
                        child: const Text('สร้างบัญชีใหม่'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}