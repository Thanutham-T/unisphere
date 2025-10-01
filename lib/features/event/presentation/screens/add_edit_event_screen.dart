import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/services/image_upload_service.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../../domain/entities/event.dart';

class AddEditEventScreen extends StatefulWidget {
  final Event? event;

  const AddEditEventScreen({super.key, this.event});

  @override
  State<AddEditEventScreen> createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _maxCapacityController;
  
  String _selectedCategory = 'วิชาการ';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  
  // Image picker
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _currentImageUrl; // For existing event images
  
  final List<String> _categories = [
    'วิชาการ',
    'จิตอาสา',
    'กีฬา',
    'ศิลปวัฒนธรรม',
    'พัฒนาผู้นำ',
    'สันทนา',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController = TextEditingController(text: widget.event?.description ?? '');
    _locationController = TextEditingController(text: widget.event?.location ?? '');
    _maxCapacityController = TextEditingController(
      text: widget.event?.maxCapacity?.toString() ?? '50',
    );
    
    if (widget.event != null) {
      final eventCategory = widget.event!.category ?? 'วิชาการ';
      // ตรวจสอบว่า category ที่มาจาก database มีอยู่ใน dropdown list หรือไม่
      _selectedCategory = _categories.contains(eventCategory) ? eventCategory : 'วิชาการ';
      _selectedDate = widget.event!.date;
      _currentImageUrl = widget.event!.imageUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxCapacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.event != null;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          isEditing ? 'แก้ไขกิจกรรม' : 'เพิ่มกิจกรรม',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF2E3192),
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : const Color(0xFF2E3192),
        ),
      ),
      body: BlocConsumer<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            
            // Navigate back only if shouldNavigate is true
            if (state.shouldNavigate) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  Navigator.of(context).pop(true); // ส่ง result = true กลับไป
                }
              });
            }
          } else if (state is EventError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: _titleController,
                  label: 'ชื่อกิจกรรม',
                  icon: Icons.event,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อกิจกรรม';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'รายละเอียด',
                  icon: Icons.description,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรายละเอียด';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildImagePicker(),
                const SizedBox(height: 16),
                _buildCategoryDropdown(),
                const SizedBox(height: 16),
                _buildDateTimePicker(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _locationController,
                  label: 'สถานที่',
                  icon: Icons.location_on,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกสถานที่';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _maxCapacityController,
                  label: 'จำนวนที่นั่งสูงสุด',
                  icon: Icons.people,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกจำนวนที่นั่งสูงสุด';
                    }
                    final capacity = int.tryParse(value);
                    if (capacity == null || capacity <= 0) {
                      return 'กรุณากรอกจำนวนที่นั่งให้ถูกต้อง';
                    }
                    // ถ้าเป็นการแก้ไข ต้องเช็คว่าไม่น้อยกว่าจำนวนคนที่ลงทะเบียนแล้ว
                    if (widget.event != null) {
                      final currentRegistrations = widget.event!.registrationCount;
                      if (capacity < currentRegistrations) {
                        return 'จำนวนที่นั่งต้องไม่น้อยกว่าจำนวนผู้ลงทะเบียนปัจจุบัน ($currentRegistrations คน)';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                BlocBuilder<EventBloc, EventState>(
                  builder: (context, state) {
                    final isLoading = state is EventLoading;
                    
                    return ElevatedButton(
                      onPressed: isLoading ? null : _saveEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E3192),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              isEditing ? 'อัปเดตกิจกรรม' : 'สร้างกิจกรรม',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'หมวดหมู่',
        prefixIcon: const Icon(Icons.category),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      ),
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedCategory = value;
          });
        }
      },
    );
  }

  Widget _buildDateTimePicker() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(_selectedDate),
          );
          
          if (time != null) {
            setState(() {
              _selectedDate = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
            });
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        ),
        child: Row(
          children: [
            const Icon(Icons.event),
            const SizedBox(width: 12),
            Text(
              'วันที่และเวลา: ${_formatDateTime(_selectedDate)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'รูปภาพกิจกรรม',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showImageSourceDialog,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[50],
            ),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : _currentImageUrl != null && _currentImageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: _currentImageUrl!.startsWith('file://')
                            ? Image.file(
                                File(_currentImageUrl!.substring(7)), // Remove 'file://' prefix
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildImagePlaceholder(isDarkMode);
                                },
                              )
                            : Image.network(
                                _currentImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildImagePlaceholder(isDarkMode);
                                },
                              ),
                      )
                    : _buildImagePlaceholder(isDarkMode),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(bool isDarkMode) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate,
          size: 64,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(height: 8),
        Text(
          'แตะเพื่อเลือกรูปภาพ',
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'แนะนำขนาด 1024x1024 พิกเซล',
          style: TextStyle(
            color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    const months = [
      'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
    ];
    final time = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year + 543} เวลา $time น.';
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เลือกรูปภาพ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('เลือกจากแกลลอรี่'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('ถ่ายรูป'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
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
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
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

  Future<String?> _getImageUrl() async {
    if (_selectedImage != null) {
      try {
        // Upload image and get URL
        final imageUploadService = GetIt.instance<ImageUploadService>();
        final imageUrl = await imageUploadService.uploadEventImage(_selectedImage!);
        return imageUrl;
      } catch (e) {
        // Fallback to placeholder if upload fails
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ไม่สามารถอัปโหลดรูปภาพได้: $e'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return null; // Return null instead of placeholder URL
      }
    } else if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
      return _currentImageUrl!;
    } else {
      return null; // Return null instead of placeholder URL
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final isEditing = widget.event != null;
    final imageUrl = await _getImageUrl();
    
    if (isEditing) {
      // Update existing event
      context.read<EventBloc>().add(
        UpdateEvent(
          eventId: widget.event!.id.toString(),
          title: _titleController.text,
          description: _descriptionController.text,
          category: _selectedCategory,
          imageUrl: imageUrl ?? widget.event!.imageUrl, // Use existing if no new image
          location: _locationController.text,
          status: widget.event!.status,
          date: _selectedDate,
          maxCapacity: int.tryParse(_maxCapacityController.text),
        ),
      );
    } else {
      // Create new event
      context.read<EventBloc>().add(
        CreateEvent(
          title: _titleController.text,
          description: _descriptionController.text,
          category: _selectedCategory,
          imageUrl: imageUrl, // Can be null for new events
          date: _selectedDate,
          location: _locationController.text,
          maxCapacity: int.tryParse(_maxCapacityController.text),
        ),
      );
    }
  }
}