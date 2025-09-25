import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../../../../core/constants/api_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
    print('🧪 Testing API Connection...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('กำลังทดสอบการเชื่อมต่อ API...')),
    );

    try {
      final client = http.Client();
      final url = Uri.parse('${ApiConstants.baseUrl}/api/v1/auth/login');
      
      print('🌐 Testing connection to: $url');
      
      final testData = {
        'username': 'test@example.com', // เปลี่ยนจาก email เป็น username
        'password': 'test123'
      };

      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(testData),
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');

      if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ API Endpoint ไม่พบ - ตรวจสอบ FastAPI server'),
            backgroundColor: Colors.orange,
          ),
        );
      } else if (response.statusCode == 422) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ API ตอบสนอง - FastAPI server พร้อมใช้งาน'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📡 API Response: ${response.statusCode}'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      print('❌ Connection Error: $e');
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
    print('🏗️ Building LoginScreen');
    
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to dashboard on successful login
            context.go('/');
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
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(
                  Icons.school,
                  size: 60,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
                      const SizedBox(height: 24),
                      Text(
              'Unisphere',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
                      const SizedBox(height: 8),
                      Text(
                        'เข้าสู่ระบบเพื่อเริ่มต้นการใช้งาน',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
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
                      print('🔄 Building login button - State: ${state.runtimeType}');
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
                  
                  // Forgot Password
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to forgot password screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ฟีเจอร์ลืมรหัสผ่านจะเปิดใช้งานเร็ว ๆ นี้'),
                        ),
                      );
                    },
                    child: const Text('ลืมรหัสผ่าน?'),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ยังไม่มีบัญชี? '),
                      TextButton(
                        onPressed: () {
                          context.push('/register');
                        },
                        child: const Text('สมัครสมาชิก'),
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