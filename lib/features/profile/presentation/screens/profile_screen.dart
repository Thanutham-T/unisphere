import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../../config/routes/app_routes.dart';
import '../widgets/virtual_student_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/profile_bloc.dart';
import '../../data/models/update_profile_request.dart';
import '../../../../core/utils/global_error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/image_upload_service.dart';
import '../../../../injector.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  String? _uploadedImageUrl; // เก็บ URL ที่อัปโหลดแล้ว
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // โหลดข้อมูล user ปัจจุบันเมื่อเข้าหน้า profile
    context.read<AuthBloc>().add(const LoadCurrentUserRequested());
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    if (!mounted) return;
    
    setState(() {
      _isUploading = true;
    });

    try {
      final imageUploadService = getIt<ImageUploadService>();
      final imageUrl = await imageUploadService.uploadEventImage(imageFile);
      
      if (imageUrl.isNotEmpty && mounted) {
        print('✅ Image uploaded successfully: $imageUrl');
        
        // เก็บ URL ชั่วคราวเพื่อแสดงทันที
        setState(() {
          _uploadedImageUrl = imageUrl;
          _profileImage = null; // Clear local file
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('อัปโหลดรูปโปรไฟล์สำเร็จ'),
              backgroundColor: Colors.green,
            ),
          );
        }
        
        // อัปเดต profile ผ่าน API
        final currentUser = context.read<AuthBloc>().state;
        if (currentUser is AuthAuthenticated) {
          final updateRequest = UpdateProfileRequest(
            profileImageUrl: imageUrl,
          );
          
          context.read<ProfileBloc>().add(UpdateProfileRequested(updateRequest));
          print('📝 Profile update request sent to backend');
          
          // Refresh user data หลังจาก backend update
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              context.read<AuthBloc>().add(const LoadCurrentUserRequested());
              // Clear local URL เพื่อใช้จาก backend
              setState(() {
                _uploadedImageUrl = null;
              });
              print('🔄 Refreshing user data from backend');
            }
          });
        }
        
      } else {
        throw Exception('ไม่สามารถอัปโหลดรูปภาพได้');
      }
    } catch (e) {
      print('❌ Upload Profile Image Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการอัปโหลดรูปภาพ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
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
                  await _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('เลือกจากแกลลอรี่'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImageFromGallery();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (image != null && mounted) {
        await _uploadProfileImage(File(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการเลือกรูปภาพ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (image != null && mounted) {
        await _uploadProfileImage(File(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการถ่ายรูป: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                // นำทางไปหน้า login เมื่อ logout สำเร็จ
                context.goToLogin();
              }
              if (state is AuthError) {
                // Check if it's a token expiration error
                if (GlobalErrorHandler.isTokenExpiredError(state.message)) {
                  // Handle auto logout for token expiration
                  GlobalErrorHandler.handleUnauthorizedException(
                    context,
                    UnauthorizedException(state.message),
                  );
                } else {
                  // แสดง error message สำหรับ error อื่นๆ
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileUpdateSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('อัปเดตข้อมูลสำเร็จ'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Refresh current user data
                context.read<AuthBloc>().add(const LoadCurrentUserRequested());
                print('🔄 Profile updated, refreshing user data');
              } else if (state is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('เกิดข้อผิดพลาด: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
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
                        profileImageUrl: _uploadedImageUrl ?? user.profileImage, // ใช้รูปที่อัปโหลดใหม่ก่อน
                        onImageTap: _pickImage,
                        isUploading: _isUploading,
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
                                      currentData: {
                                        'firstName': user.firstName,
                                        'lastName': user.lastName,
                                        'email': user.email,
                                        'phoneNumber': user.phoneNumber ?? '',
                                      },
                                      currentUser: user,
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
                                      currentData: {
                                        'studentId': user.studentId ?? '',
                                        'faculty': user.faculty ?? '',
                                        'major': user.major ?? '',
                                        'department': user.department ?? '',
                                        'curriculum': user.curriculum ?? '',
                                        'campus': user.campus ?? '',
                                        'educationLevel': user.educationLevel ?? '',
                                      },
                                      currentUser: user,
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
  final User currentUser;

  const EditPersonalInfoModal({
    super.key,
    required this.currentData,
    required this.currentUser,
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
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'อีเมล',
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[100],
                              suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                            ),
                            style: TextStyle(color: Colors.grey[600]),
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
      // Debug: Print current user info
      print('🔍 Current User ID: ${widget.currentUser.id}');
      print('🔍 Current User Email: ${widget.currentUser.email}');
      
      // Create update request with personal info while preserving all existing data
      final updateRequest = UpdateProfileRequest(
        // Personal info updates
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim().isNotEmpty 
            ? _phoneController.text.trim() 
            : null,
        // Preserve existing education data
        studentId: widget.currentUser.studentId,
        faculty: widget.currentUser.faculty,
        major: widget.currentUser.major,
        department: widget.currentUser.department,
        curriculum: widget.currentUser.curriculum,
        campus: widget.currentUser.campus,
        educationLevel: widget.currentUser.educationLevel,
        // Preserve other data
        profileImageUrl: widget.currentUser.profileImage,
      );

      print('🔍 Personal Info Update Request: ${updateRequest.toJson()}');

      // Send update request via ProfileBloc
      context.read<ProfileBloc>().add(UpdateProfileRequested(updateRequest));
      Navigator.pop(context);
    }
  }
}

// Edit Education Info Modal
class EditEducationInfoModal extends StatefulWidget {
  final Map<String, String> currentData;
  final User currentUser;

  const EditEducationInfoModal({
    super.key,
    required this.currentData,
    required this.currentUser,
  });

  @override
  State<EditEducationInfoModal> createState() => _EditEducationInfoModalState();
}

class _EditEducationInfoModalState extends State<EditEducationInfoModal> {
  late TextEditingController _studentIdController;
  late TextEditingController _curriculumController;
  late TextEditingController _departmentController;
  String? _selectedFaculty;
  String? _selectedMajor;
  String? _selectedCampus;
  String? _selectedEducationLevel;
  final _formKey = GlobalKey<FormState>();

  // Faculty-major mapping (same as register screen)
  final Map<String, List<String>> _facultyMajors = {
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

  final List<String> _educationLevels = [
    'ปริญญาตรี',
    'ปริญญาโท',
    'ปริญญาเอก',
    'อื่น ๆ',
  ];

  final List<String> _campuses = [
    'วิทยาเขตหาดใหญ่',
    'วิทยาเขตปัตตานี',
    'วิทยาเขตภูเก็ต',
    'วิทยาเขตสุราษฎร์ธานี',
    'วิทยาเขตตรัง',
  ];

  @override
  void initState() {
    super.initState();
    _studentIdController = TextEditingController(text: widget.currentData['studentId']);
    _curriculumController = TextEditingController(text: widget.currentData['curriculum']);
    _departmentController = TextEditingController(text: widget.currentData['department']);
    
    // Safely initialize dropdowns with validation
    final faculty = widget.currentData['faculty'] ?? '';
    _selectedFaculty = _facultyMajors.keys.contains(faculty) ? faculty : null;
    
    final major = widget.currentData['major'] ?? '';
    _selectedMajor = (_selectedFaculty != null && _facultyMajors[_selectedFaculty]?.contains(major) == true) 
        ? major 
        : null;
    
    final campus = widget.currentData['campus'] ?? '';
    _selectedCampus = _campuses.contains(campus) ? campus : null;
    
    final educationLevel = widget.currentData['educationLevel'] ?? '';
    _selectedEducationLevel = _educationLevels.contains(educationLevel) ? educationLevel : null;
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _curriculumController.dispose();
    _departmentController.dispose();
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
                          
                          // Education Level Dropdown
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
                              setState(() {
                                _selectedEducationLevel = value;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Student ID
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
                          
                          // Campus Dropdown
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
                              setState(() {
                                _selectedCampus = value;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Faculty Dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedFaculty,
                            decoration: const InputDecoration(
                              labelText: 'คณะ',
                              border: OutlineInputBorder(),
                            ),
                            items: _facultyMajors.keys.map((faculty) {
                              return DropdownMenuItem(
                                value: faculty,
                                child: Text(faculty),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedFaculty = value;
                                // Reset major when faculty changes
                                _selectedMajor = null;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Major Dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedMajor,
                            decoration: const InputDecoration(
                              labelText: 'สาขาวิชา',
                              border: OutlineInputBorder(),
                            ),
                            items: _selectedFaculty != null
                                ? (_facultyMajors[_selectedFaculty] ?? []).map((major) {
                                    return DropdownMenuItem(
                                      value: major,
                                      child: Text(major),
                                    );
                                  }).toList()
                                : [],
                            onChanged: (value) {
                              setState(() {
                                _selectedMajor = value;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Curriculum Text Field
                          TextFormField(
                            controller: _curriculumController,
                            decoration: const InputDecoration(
                              labelText: 'หลักสูตร',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Department Text Field
                          TextFormField(
                            controller: _departmentController,
                            decoration: const InputDecoration(
                              labelText: 'ภาควิชา/หน่วยงาน',
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
      // Debug: Print current user info
      print('🔍 Current User ID: ${widget.currentUser.id}');
      print('🔍 Current User Email: ${widget.currentUser.email}');
      
      // Create update request with education info while preserving all existing data
      final updateRequest = UpdateProfileRequest(
        // Education info updates
        studentId: _studentIdController.text.trim().isNotEmpty 
            ? _studentIdController.text.trim() 
            : null,
        faculty: _selectedFaculty,
        major: _selectedMajor,
        department: _departmentController.text.trim().isNotEmpty 
            ? _departmentController.text.trim() 
            : null,
        curriculum: _curriculumController.text.trim().isNotEmpty 
            ? _curriculumController.text.trim() 
            : null,
        campus: _selectedCampus,
        educationLevel: _selectedEducationLevel,
        // Preserve existing personal data
        firstName: widget.currentUser.firstName,
        lastName: widget.currentUser.lastName,
        email: widget.currentUser.email,
        phoneNumber: widget.currentUser.phoneNumber,
        // Preserve other data
        profileImageUrl: widget.currentUser.profileImage,
      );

      print('🔍 Education Info Update Request: ${updateRequest.toJson()}');

      // Send update request via ProfileBloc
      context.read<ProfileBloc>().add(UpdateProfileRequested(updateRequest));
      Navigator.pop(context);
    }
  }
}