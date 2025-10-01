import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<EventBloc>(),
      child: const _CreateEventContent(),
    );
  }
}

class _CreateEventContent extends StatefulWidget {
  const _CreateEventContent();

  @override
  State<_CreateEventContent> createState() => _CreateEventContentState();
}

class _CreateEventContentState extends State<_CreateEventContent> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _locationController = TextEditingController();
  
  String _selectedCategory = 'วิชาการ'; // Set default value
  DateTime? _selectedDate;
  
  // TODO: Add image picker functionality like in add_edit_event_screen.dart
  
  final List<String> _categories = [
    'วิชาการ',
    'กีฬา',
    'ศิลปกรรม', 
    'workshop',
    'sport',
    'career',
    'อื่นๆ',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'สร้างกิจกรรมใหม่',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF2E3192),
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
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
            Navigator.of(context).pop();
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
          final isLoading = state is EventActionLoading && state.action == 'create';
          
          return Stack(
            children: [
              _buildForm(isDarkMode),
              if (isLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildForm(bool isDarkMode) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Field
            _buildTextField(
              controller: _titleController,
              label: 'ชื่อกิจกรรม',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'กรุณากรอกชื่อกิจกรรม';
                }
                return null;
              },
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 16),
            
            // Description Field
            _buildTextField(
              controller: _descriptionController,
              label: 'รายละเอียด',
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'กรุณากรอกรายละเอียดกิจกรรม';
                }
                return null;
              },
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 16),
            
            // Category Dropdown
            _buildDropdownField(
              value: _selectedCategory,
              items: _categories,
              label: 'หมวดหมู่',
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value ?? 'วิชาการ';
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'กรุณาเลือกหมวดหมู่';
                }
                return null;
              },
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 16),
            
            // Image URL Field
            _buildTextField(
              controller: _imageUrlController,
              label: 'URL รูปภาพ',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'กรุณากรอก URL รูปภาพ';
                }
                final uri = Uri.tryParse(value.trim());
                if (uri == null || !uri.hasAbsolutePath) {
                  return 'กรุณากรอก URL ที่ถูกต้อง';
                }
                return null;
              },
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 16),
            
            // Date Field
            _buildDateField(isDarkMode),
            const SizedBox(height: 16),
            
            // Location Field
            _buildTextField(
              controller: _locationController,
              label: 'สถานที่',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'กรุณากรอกสถานที่';
                }
                return null;
              },
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 32),
            
            // Submit Button
            _buildSubmitButton(isDarkMode),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isDarkMode,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.grey[700],
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? const Color(0xFF8B8FFF) : const Color(0xFF2E3192),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String label,
    required void Function(String?) onChanged,
    required bool isDarkMode,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      validator: validator,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      dropdownColor: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.grey[700],
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? const Color(0xFF8B8FFF) : const Color(0xFF2E3192),
            width: 2,
          ),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateField(bool isDarkMode) {
    return TextFormField(
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: isDarkMode
                  ? const ColorScheme.dark(
                      primary: Color(0xFF8B8FFF),
                      onPrimary: Colors.white,
                      surface: Color(0xFF2D2D2D),
                      onSurface: Colors.white,
                    )
                  : const ColorScheme.light(
                      primary: Color(0xFF2E3192),
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
              ),
              child: child!,
            );
          },
        );
        
        if (date != null) {
          setState(() {
            _selectedDate = date;
          });
        }
      },
      validator: (value) {
        if (_selectedDate == null) {
          return 'กรุณาเลือกวันที่';
        }
        return null;
      },
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: 'วันที่จัดงาน',
        hintText: _selectedDate != null 
          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
          : 'เลือกวันที่',
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.grey[600],
        ),
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.grey[700],
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        suffixIcon: Icon(
          Icons.calendar_today,
          color: isDarkMode ? Colors.white70 : Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDarkMode ? const Color(0xFF8B8FFF) : const Color(0xFF2E3192),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isDarkMode) {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? const Color(0xFF8B8FFF) : const Color(0xFF2E3192),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'สร้างกิจกรรม',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<EventBloc>().add(
        CreateEvent(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
          imageUrl: _imageUrlController.text.trim(),
          date: _selectedDate!,
          location: _locationController.text.trim(),
        ),
      );
    }
  }
}