import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../../config/routes/app_routes.dart';
import '../widgets/virtual_student_card.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // โหลดข้อมูล user ปัจจุบันเมื่อเข้าหน้า profile
    context.read<AuthBloc>().add(const LoadCurrentUserRequested());
  }

  Future<void> _pickImage() async {
    // Request permission
    if (Platform.isAndroid || Platform.isIOS) {
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('จำเป็นต้องมีสิทธิ์ในการเข้าถึงแกลลอรี่เพื่อเลือกรูปภาพ')),
          );
        }
        return;
      }
    }

    if (mounted) {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'เลือกรูปโปรไฟล์',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('ถ่ายภาพ'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null && mounted) {
                    setState(() {
                      _profileImage = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('เลือกจากแกลลอรี่'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null && mounted) {
                    setState(() {
                      _profileImage = File(image.path);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.menu_profile ?? 'โปรไฟล์'),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            // นำทางไปหน้า login เมื่อ logout สำเร็จ
            context.goToLogin();
          }
          if (state is AuthError) {
            // แสดง error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is AuthAuthenticated) {
              final user = state.user;
              
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Virtual Student Card
                    Center(
                      child: VirtualStudentCard(
                        name: '${user.firstName} ${user.lastName}',
                        studentId: user.studentId ?? 'ไม่ระบุ',
                        faculty: user.faculty ?? 'ไม่ระบุ',
                        major: user.major ?? 'ไม่ระบุ',
                        profileImage: _profileImage,
                        onImageTap: _pickImage,
                      ),
                    ),
                    const SizedBox(height: 24),

                  // Personal Information Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF2A2A2A).withOpacity(0.9)
                              : Colors.white,
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF3A4A7A).withOpacity(0.6)
                              : const Color(0xFF6B9DFF).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF6B9DFF).withOpacity(0.3)
                            : const Color(0xFF6B9DFF).withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.3)
                              : Colors.black.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 25,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: const Color(0xFF6B9DFF).withOpacity(0.15),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF6B9DFF), Color(0xFF9B59B6)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'ข้อมูลส่วนตัว',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : const Color(0xFF2D3748),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6B9DFF), Color(0xFF9B59B6)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6B9DFF).withOpacity(0.3),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => EditPersonalInfoModal(
                                      currentData: const {
                                        'firstName': 'Tanawan',
                                        'lastName': 'Wannata',
                                        'email': 'tanawan@example.com',
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoItem(context, 'ชื่อ-นามสกุล', '${user.firstName} ${user.lastName}'),
                        _buildInfoItem(context, 'อีเมล', user.email),
                        _buildInfoItem(context, 'เบอร์โทรศัพท์', user.phoneNumber ?? 'ไม่ระบุ'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Education Information Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF2A2A2A).withOpacity(0.9)
                              : Colors.white,
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF4A7A3A).withOpacity(0.6)
                              : const Color(0xFF7DFFB3).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF7DFFB3).withOpacity(0.3)
                            : const Color(0xFF7DFFB3).withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.3)
                              : Colors.black.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 25,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: const Color(0xFF7DFFB3).withOpacity(0.15),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF7DFFB3), Color(0xFF2ECC71)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.school_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'ข้อมูลการศึกษา',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : const Color(0xFF2D3748),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF7DFFB3), Color(0xFF2ECC71)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF7DFFB3).withOpacity(0.3),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => EditEducationInfoModal(
                                      currentData: const {
                                        'studentId': '67101103333',
                                        'faculty': 'วิศวกรรมศาสตร์',
                                        'major': 'วิศวกรรมคอมพิวเตอร์',
                                        'department': 'ภาควิชาวิศวกรรมคอมพิวเตอร์',
                                        'curriculum': 'วิศวกรรมศาสตรบัณฑิต',
                                        'campus': 'วิทยาเขตหลัก',
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoItem(context, 'รหัสนักศึกษา', user.studentId ?? 'ไม่ระบุ'),
                        _buildInfoItem(context, 'ระดับการศึกษา', user.educationLevel ?? 'ไม่ระบุ'),
                        _buildInfoItem(context, 'วิทยาเขต', user.campus ?? 'ไม่ระบุ'),
                        _buildInfoItem(context, 'คณะ', user.faculty ?? 'ไม่ระบุ'),
                        _buildInfoItem(context, 'สาขาวิชา', user.major ?? 'ไม่ระบุ'),
                        _buildInfoItem(context, 'หลักสูตร', user.curriculum ?? 'ไม่ระบุ'),
                        _buildInfoItem(context, 'ภาควิชา/หน่วยงาน', user.department ?? 'ไม่ระบุ'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Logout Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B6B).withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout_rounded, color: Colors.white),
                      label: const Text(
                        'ออกจากระบบ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // App Version
                  Center(
                    child: Text(
                      'Unisphere v1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            );
            }
            
            // กรณีที่ state ไม่ใช่ AuthAuthenticated
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'ไม่สามารถโหลดข้อมูลผู้ใช้ได้',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ออกจากระบบ'),
          content: const Text('คุณต้องการออกจากระบบหรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(const LogoutRequested());
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('ออกจากระบบ'),
            ),
          ],
        );
      },
    );
  }
}

// Edit Personal Info Modal
class EditPersonalInfoModal extends StatefulWidget {
  final Map<String, String> currentData;

  const EditPersonalInfoModal({
    super.key,
    required this.currentData,
  });

  @override
  State<EditPersonalInfoModal> createState() => _EditPersonalInfoModalState();
}

class _EditPersonalInfoModalState extends State<EditPersonalInfoModal> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.currentData['firstName']);
    _lastNameController = TextEditingController(text: widget.currentData['lastName']);
    _emailController = TextEditingController(text: widget.currentData['email']);
    _phoneController = TextEditingController(text: '081-234-5678');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'แก้ไขข้อมูลส่วนตัว',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'ชื่อ',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'กรุณากรอกชื่อ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'นามสกุล',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'กรุณากรอกนามสกุล';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'อีเมล',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'กรุณากรอกอีเมล';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                                return 'รูปแบบอีเมลไม่ถูกต้อง';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'เบอร์โทรศัพท์',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'บันทึกการเปลี่ยนแปลง',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement save logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('บันทึกข้อมูลส่วนตัวเรียบร้อย'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          action: SnackBarAction(
            label: 'ตกลง',
            textColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {},
          ),
        ),
      );
      Navigator.pop(context);
    }
  }
}

// Edit Education Info Modal
class EditEducationInfoModal extends StatefulWidget {
  final Map<String, String> currentData;

  const EditEducationInfoModal({
    super.key,
    required this.currentData,
  });

  @override
  State<EditEducationInfoModal> createState() => _EditEducationInfoModalState();
}

class _EditEducationInfoModalState extends State<EditEducationInfoModal> {
  late TextEditingController _studentIdController;
  String _selectedFaculty = 'วิศวกรรมศาสตร์';
  String _selectedMajor = 'วิศวกรรมคอมพิวเตอร์';
  String _selectedDepartment = 'ภาควิชาวิศวกรรมคอมพิวเตอร์';
  String _selectedCurriculum = 'วิศวกรรมศาสตรบัณฑิต';
  String _selectedCampus = 'วิทยาเขตหลัก';
  String _selectedEducationLevel = 'ปริญญาตรี';
  final _formKey = GlobalKey<FormState>();

  final List<String> _faculties = [
    'วิศวกรรมศาสตร์',
    'วิทยาศาสตร์',
    'ครุศาสตร์',
    'มนุษยศาสตร์และสังคมศาสตร์',
    'บริหารธุรกิจ',
  ];

  final Map<String, List<String>> _majorsByFaculty = {
    'วิศวกรรมศาสตร์': [
      'วิศวกรรมคอมพิวเตอร์',
      'วิศวกรรมไฟฟ้า',
      'วิศวกรรมเครื่องกล',
      'วิศวกรรมโยธา',
    ],
    'วิทยาศาสตร์': [
      'คณิตศาสตร์',
      'ฟิสิกส์',
      'เคมี',
      'ชีววิทยา',
    ],
    'ครุศาสตร์': [
      'การศึกษาปฐมวัย',
      'การศึกษาพิเศษ',
      'หลักสูตรและการสอน',
    ],
    'มนุษยศาสตร์และสังคมศาสตร์': [
      'ภาษาอังกฤษ',
      'ภาษาไทย',
      'ประวัติศาสตร์',
      'ภูมิศาสตร์',
    ],
    'บริหารธุรกิจ': [
      'การจัดการ',
      'การตลาด',
      'การบัญชี',
      'การเงิน',
    ],
  };

  final List<String> _educationLevels = [
    'ปริญญาตรี',
    'ปริญญาโท',
    'ปริญญาเอก',
  ];

  final List<String> _departments = [
    'ภาควิชาวิศวกรรมคอมพิวเตอร์',
    'ภาควิชาวิศวกรรมไฟฟ้า',
    'ภาควิชาวิศวกรรมเครื่องกล',
    'ภาควิชาวิศวกรรมโยธา',
    'ภาควิชาคณิตศาสตร์',
    'ภาควิชาฟิสิกส์',
    'ภาควิชาเคมี',
    'ภาควิชาชีววิทยา',
  ];

  final List<String> _curriculums = [
    'วิศวกรรมศาสตรบัณฑิต',
    'วิทยาศาสตรบัณฑิต',
    'ครุศาสตรบัณฑิต',
    'ศิลปศาสตรบัณฑิต',
    'บริหารธุรกิจบัณฑิต',
  ];

  final List<String> _campuses = [
    'วิทยาเขตหลัก',
    'วิทยาเขตสารสนเทศ',
    'วิทยาเขตเทคโนโลยี',
    'วิทยาเขตสาขาจังหวัด',
  ];

  @override
  void initState() {
    super.initState();
    _studentIdController = TextEditingController(text: widget.currentData['studentId']);
    _selectedFaculty = widget.currentData['faculty'] ?? 'วิศวกรรมศาสตร์';
    _selectedMajor = widget.currentData['major'] ?? 'วิศวกรรมคอมพิวเตอร์';
    _selectedDepartment = widget.currentData['department'] ?? 'ภาควิชาวิศวกรรมคอมพิวเตอร์';
    _selectedCurriculum = widget.currentData['curriculum'] ?? 'วิศวกรรมศาสตรบัณฑิต';
    _selectedCampus = widget.currentData['campus'] ?? 'วิทยาเขตหลัก';
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'แก้ไขข้อมูลการศึกษา',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _studentIdController,
                            decoration: const InputDecoration(
                              labelText: 'รหัสนักศึกษา',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'กรุณากรอกรหัสนักศึกษา';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedFaculty,
                            decoration: const InputDecoration(
                              labelText: 'คณะ',
                              border: OutlineInputBorder(),
                            ),
                            items: _faculties.map((faculty) {
                              return DropdownMenuItem(
                                value: faculty,
                                child: Text(faculty),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedFaculty = value;
                                  // Reset major when faculty changes
                                  _selectedMajor = _majorsByFaculty[value]?.first ?? '';
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _majorsByFaculty[_selectedFaculty]?.contains(_selectedMajor) ?? false
                                ? _selectedMajor
                                : _majorsByFaculty[_selectedFaculty]?.first,
                            decoration: const InputDecoration(
                              labelText: 'สาขาวิชา',
                              border: OutlineInputBorder(),
                            ),
                            items: (_majorsByFaculty[_selectedFaculty] ?? []).map((major) {
                              return DropdownMenuItem(
                                value: major,
                                child: Text(major),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedMajor = value;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedDepartment,
                            decoration: const InputDecoration(
                              labelText: 'ภาควิชา/หน่วยงาน',
                              border: OutlineInputBorder(),
                            ),
                            items: _departments.map((department) {
                              return DropdownMenuItem(
                                value: department,
                                child: Text(department),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedDepartment = value;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedCurriculum,
                            decoration: const InputDecoration(
                              labelText: 'หลักสูตร',
                              border: OutlineInputBorder(),
                            ),
                            items: _curriculums.map((curriculum) {
                              return DropdownMenuItem(
                                value: curriculum,
                                child: Text(curriculum),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedCurriculum = value;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedCampus,
                            decoration: const InputDecoration(
                              labelText: 'วิทยาเขต',
                              border: OutlineInputBorder(),
                            ),
                            items: _campuses.map((campus) {
                              return DropdownMenuItem(
                                value: campus,
                                child: Text(campus),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedCampus = value;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedEducationLevel,
                            decoration: const InputDecoration(
                              labelText: 'ระดับการศึกษา',
                              border: OutlineInputBorder(),
                            ),
                            items: _educationLevels.map((level) {
                              return DropdownMenuItem(
                                value: level,
                                child: Text(level),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedEducationLevel = value;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 32),
                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'บันทึกการเปลี่ยนแปลง',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement save logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('บันทึกข้อมูลการศึกษาเรียบร้อย'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          action: SnackBarAction(
            label: 'ตกลง',
            textColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {},
          ),
        ),
      );
      Navigator.pop(context);
    }
  }
}