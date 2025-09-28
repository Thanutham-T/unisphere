import 'package:flutter/material.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../injector.dart';
import '../../data/models/register_request.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Faculty-major mapping
  final Map<String, List<String>> facultyMajors = {
    'วิศวกรรมศาสตร์': [
      'วิศวกรรมคอมพิวเตอร์',
      'วิศวกรรมโยธา',
      'วิศวกรรมไฟฟ้า',
      'วิศวกรรมเครื่องกล',
    ],
    'วิทยาศาสตร์': [
      'ชีววิทยา',
      'เคมี',
      'ฟิสิกส์',
      'คณิตศาสตร์',
    ],
    'บริหารธุรกิจ': [
      'การตลาด',
      'การจัดการ',
      'บัญชี',
      'การเงิน',
    ],
    'นิติศาสตร์': [
      'กฎหมายมหาชน',
      'กฎหมายเอกชน',
      'กฎหมายระหว่างประเทศ',
    ],
    'สถาปัตยกรรมศาสตร์': [
      'สถาปัตยกรรม',
      'ภูมิสถาปัตยกรรม',
    ],
    'เศรษฐศาสตร์': [
      'เศรษฐศาสตร์ทั่วไป',
      'เศรษฐศาสตร์ธุรกิจ',
    ],
    'ศึกษาศาสตร์': [
      'การศึกษาปฐมวัย',
      'การศึกษาพิเศษ',
    ],
    'แพทยศาสตร์': [
      'แพทยศาสตร์',
    ],
    'ทันตแพทยศาสตร์': [
      'ทันตแพทยศาสตร์',
    ],
    'เภสัชศาสตร์': [
      'เภสัชศาสตร์',
    ],
    'อื่น ๆ': [
      'อื่น ๆ',
    ],
  };

  String? facultySelected;
  List<String> majorOptions = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Form keys
  final _personalFormKey = GlobalKey<FormState>();
  final _educationFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  
  // Personal Info Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Education Info Controllers
  final _studentIdController = TextEditingController();
  final _educationLevelController = TextEditingController();
  final _campusController = TextEditingController();
  final _facultyController = TextEditingController();
  final _majorController = TextEditingController();
  final _curriculumController = TextEditingController();
  final _departmentController = TextEditingController();
  
  // Password Controllers
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _pageController.dispose();
    // Personal Info Controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    // Education Info Controllers
    _studentIdController.dispose();
    _educationLevelController.dispose();
    _campusController.dispose();
    _facultyController.dispose();
    _majorController.dispose();
    _curriculumController.dispose();
    _departmentController.dispose();
    // Password Controllers
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextPage() {
    // Validate current form before proceeding
    bool isValid = false;
    
    if (_currentPage == 0) {
      // Personal Info validation
      isValid = _personalFormKey.currentState!.validate();
    } else if (_currentPage == 1) {
      // Education Info validation - always pass since it's optional
      isValid = true;
    } else if (_currentPage == 2) {
      // Password validation
      isValid = _passwordFormKey.currentState!.validate();
    }
    
    if (isValid) {
      if (_currentPage < 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // Final page - submit registration
        _submitRegistration();
      }
    } else {
      // Show error message if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบถ้วนและถูกต้อง'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitRegistration() async {
    print('🔧 [RegisterScreen] Starting registration process...');
    
    try {
      // Create register request
      final request = RegisterRequest.create(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        studentId: _studentIdController.text.trim().isEmpty ? null : _studentIdController.text.trim(),
        faculty: facultySelected,
        department: _departmentController.text.trim().isEmpty ? null : _departmentController.text.trim(),
        major: _majorController.text.trim().isEmpty ? null : _majorController.text.trim(),
        curriculum: _curriculumController.text.trim().isEmpty ? null : _curriculumController.text.trim(),
        educationLevel: _educationLevelController.text.trim().isEmpty ? null : _educationLevelController.text.trim(),
        campus: _campusController.text.trim().isEmpty ? null : _campusController.text.trim(),
      );
      
      print('🔧 [RegisterScreen] Register request: ${request.toJson()}');
      
      // Get repository
      final authRepository = getIt<AuthRepository>();
      
      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                SizedBox(width: 16),
                Text('กำลังสมัครสมาชิก...'),
              ],
            ),
            duration: Duration(seconds: 30),
            backgroundColor: Colors.blue,
          ),
        );
      }
      
      // Call register API
      final result = await authRepository.register(request);
      
      // Hide loading
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
      
      result.fold(
        (failure) {
          print('🔧 [RegisterScreen] Registration failed: ${failure.message}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('การสมัครสมาชิกไม่สำเร็จ: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (user) {
          print('🔧 [RegisterScreen] Registration successful for user: ${user.email}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('สมัครสมาชิกสำเร็จ! กำลังเข้าสู่ระบบ...'),
                backgroundColor: Colors.green,
              ),
            );
            
            // Navigate to home after successful registration
            // The token should already be saved by the repository
            context.goToHome();
          }
        },
      );
    } catch (e, stackTrace) {
      print('🔧 [RegisterScreen] Exception during registration: $e');
      print('🔧 [RegisterScreen] Stack trace: $stackTrace');
      
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอก$fieldName';
    }
    return null;
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

  String? _validatePhone(String? value) {
    // Phone is optional, so return null if empty
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 10) {
      return 'เบอร์โทรศัพท์ต้องมีอย่างน้อย 10 หลัก';
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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณายืนยันรหัสผ่าน';
    }
    if (value != _passwordController.text) {
      return 'รหัสผ่านไม่ตรงกัน';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สร้างบัญชีใหม่'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentPage > 0) {
              _previousPage();
            } else {
              // Go back to login screen (force route)
              context.goToLogin();
            }
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildStepIndicator(0, 'ข้อมูลส่วนตัว'),
                  Expanded(child: Container(height: 2, color: Colors.grey.shade300)),
                  _buildStepIndicator(1, 'ข้อมูลการศึกษา'),
                  Expanded(child: Container(height: 2, color: Colors.grey.shade300)),
                  _buildStepIndicator(2, 'ยืนยัน'),
                ],
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPersonalInfoPage(),
                  _buildEducationInfoPage(),
                  _buildPasswordPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String title) {
    final isActive = step <= _currentPage;
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
          ),
          child: Center(
            child: step < _currentPage
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 18,
                  )
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: isActive
                          ? Theme.of(context).colorScheme.onPrimary
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _personalFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            Text(
              'ข้อมูลส่วนตัว',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'สร้างบัญชีเพื่อเข้าใช้งานแอปพลิเคชัน',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 32),

            // Personal Info Form Container
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // First Name
                  AuthTextField(
                    controller: _firstNameController,
                    labelText: 'ชื่อ',
                    hintText: 'กรอกชื่อของคุณ',
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: (value) => _validateRequired(value, 'ชื่อ'),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Last Name
                  AuthTextField(
                    controller: _lastNameController,
                    labelText: 'นามสกุล',
                    hintText: 'กรอกนามสกุลของคุณ',
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: (value) => _validateRequired(value, 'นามสกุล'),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  AuthTextField(
                    controller: _phoneController,
                    labelText: 'เบอร์โทรศัพท์ (ไม่บังคับ)',
                    hintText: 'กรอกเบอร์โทรศัพท์ของคุณ',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    validator: _validatePhone,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  AuthButton(
                    text: 'ต่อไป',
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _educationFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            Text(
              'ข้อมูลการศึกษา (ไม่บังคับ)',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'กรอกข้อมูลการศึกษาของคุณ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 32),

            // Education Info Form Container
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Dropdown for Education Level
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'ระดับการศึกษา',
                      prefixIcon: const Icon(Icons.school_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      'ปริญญาตรี',
                      'ปริญญาโท',
                      'ปริญญาเอก',
                      'อื่น ๆ',
                    ].map((level) => DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    )).toList(),
                    onChanged: (value) {
                      _educationLevelController.text = value ?? '';
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  AuthTextField(
                    controller: _studentIdController,
                    labelText: 'รหัสนักศึกษา',
                    hintText: 'กรอกรหัสนักศึกษา',
                    prefixIcon: Icons.badge_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'วิทยาเขต',
                      prefixIcon: const Icon(Icons.location_city_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: [
                      'วิทยาเขตหาดใหญ่',
                      'วิทยาเขตปัตตานี',
                      'วิทยาเขตภูเก็ต',
                      'วิทยาเขตสุราษฎร์ธานี',
                      'วิทยาเขตตรัง'
                    ].map((campus) => DropdownMenuItem(
                      value: campus,
                      child: Text(campus),
                    )).toList(),
                    onChanged: (value) {
                      _campusController.text = value ?? '';
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'คณะ',
                      prefixIcon: const Icon(Icons.account_balance_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    value: facultySelected,
                    items: facultyMajors.keys.map((faculty) => DropdownMenuItem(
                      value: faculty,
                      child: Text(faculty),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        facultySelected = value;
                        _facultyController.text = value ?? '';
                        majorOptions = value != null ? facultyMajors[value]! : [];
                        _majorController.text = '';
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'สาขาวิชา',
                      prefixIcon: const Icon(Icons.book_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    value: majorOptions.contains(_majorController.text) ? _majorController.text : null,
                    items: majorOptions.map((major) => DropdownMenuItem(
                      value: major,
                      child: Text(major),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _majorController.text = value ?? '';
                      });
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  AuthTextField(
                    controller: _curriculumController,
                    labelText: 'หลักสูตร',
                    hintText: 'กรอกหลักสูตร',
                    prefixIcon: Icons.list_alt_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  AuthTextField(
                    controller: _departmentController,
                    labelText: 'ภาควิชา/หน่วยงาน',
                    hintText: 'กรอกภาควิชาหรือหน่วยงาน',
                    prefixIcon: Icons.business_outlined,
                    textInputAction: TextInputAction.done,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Navigation Buttons
                  Row(
                    children: [
                      Expanded(
                        child: AuthButton(
                          text: 'ย้อนกลับ',
                          isSecondary: true,
                          onPressed: _previousPage,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AuthButton(
                          text: 'ต่อไป',
                          onPressed: _nextPage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _passwordFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            Text(
              'ยืนยันข้อมูล',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'กำหนดอีเมลและรหัสผ่านสำหรับบัญชีของคุณ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 32),

            // Password Form Container
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  AuthTextField(
                    controller: _emailController,
                    labelText: 'อีเมล',
                    hintText: 'กรอกอีเมลของคุณ',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  AuthTextField(
                    controller: _passwordController,
                    labelText: 'รหัสผ่าน',
                    hintText: 'กรอกรหัสผ่านของคุณ',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_isPasswordVisible,
                    textInputAction: TextInputAction.next,
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
                  ),
                  
                  const SizedBox(height: 20),
                  
                  AuthTextField(
                    controller: _confirmPasswordController,
                    labelText: 'ยืนยันรหัสผ่าน',
                    hintText: 'กรอกรหัสผ่านอีกครั้ง',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_isConfirmPasswordVisible,
                    textInputAction: TextInputAction.done,
                    validator: _validateConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Navigation Buttons
                  Row(
                    children: [
                      Expanded(
                        child: AuthButton(
                          text: 'ย้อนกลับ',
                          isSecondary: true,
                          onPressed: _previousPage,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AuthButton(
                          text: 'สร้างบัญชี',
                          onPressed: _nextPage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}