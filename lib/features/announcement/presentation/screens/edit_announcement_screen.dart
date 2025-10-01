import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/announcement.dart';
import '../bloc/announcement_bloc.dart';

class EditAnnouncementScreen extends StatefulWidget {
  final Announcement announcement;

  const EditAnnouncementScreen({
    super.key,
    required this.announcement,
  });

  @override
  State<EditAnnouncementScreen> createState() => _EditAnnouncementScreenState();
}

class _EditAnnouncementScreenState extends State<EditAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  
  late String _selectedCategory;
  late String _selectedPriority;
  late DateTime _selectedDate;
  
  final Map<String, String> _categoryDisplayNames = {
    'general': 'ทั่วไป',
    'academic': 'วิชาการ',
    'event': 'กิจกรรม',
    'maintenance': 'การบำรุงรักษา',
  };

  final Map<String, String> _priorityDisplayNames = {
    'high': 'สำคัญมาก',
    'medium': 'สำคัญปานกลาง',
    'low': 'สำคัญน้อย',
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.announcement.title);
    _contentController = TextEditingController(text: widget.announcement.content);
    _selectedCategory = widget.announcement.category;
    _selectedPriority = widget.announcement.priority;
    _selectedDate = widget.announcement.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'แก้ไขประกาศ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF2E3192),
          ),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocListener<AnnouncementBloc, AnnouncementState>(
        listener: (context, state) {
          if (state is AnnouncementActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is AnnouncementError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Original info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ข้อมูลเดิม',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'สร้างเมื่อ: ${_formatDate(widget.announcement.createdAt)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (widget.announcement.creatorName != null)
                        Text(
                          'สร้างโดย: ${widget.announcement.creatorName}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Title field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'หัวข้อประกาศ',
                    border: OutlineInputBorder(),
                    hintText: 'กรอกหัวข้อประกาศ',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'กรุณากรอกหัวข้อประกาศ';
                    }
                    if (value.trim().length < 3) {
                      return 'หัวข้อประกาศต้องมีอย่างน้อย 3 ตัวอักษร';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Content field
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'เนื้อหาประกาศ',
                    border: OutlineInputBorder(),
                    hintText: 'กรอกเนื้อหาประกาศ',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'กรุณากรอกเนื้อหาประกาศ';
                    }
                    if (value.trim().length < 10) {
                      return 'เนื้อหาประกาศต้องมีอย่างน้อย 10 ตัวอักษร';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Category dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'หมวดหมู่',
                    border: OutlineInputBorder(),
                  ),
                  items: _categoryDisplayNames.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Priority dropdown
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'ความสำคัญ',
                    border: OutlineInputBorder(),
                  ),
                  items: _priorityDisplayNames.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getPriorityColor(entry.key),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(entry.value),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPriority = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Date picker
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'วันที่ประกาศ',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<AnnouncementBloc, AnnouncementState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is AnnouncementLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: state is AnnouncementLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'บันทึกการแก้ไข',
                                style: TextStyle(fontSize: 16),
                              ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                
                // Changes indicator
                if (_hasChanges())
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      border: Border.all(color: Colors.amber),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'คุณมีการเปลี่ยนแปลงข้อมูล',
                            style: TextStyle(color: Colors.amber[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Only send changed fields
      context.read<AnnouncementBloc>().add(
        UpdateAnnouncementEvent(
          announcementId: widget.announcement.id,
          title: _titleController.text.trim() != widget.announcement.title 
              ? _titleController.text.trim() 
              : null,
          content: _contentController.text.trim() != widget.announcement.content 
              ? _contentController.text.trim() 
              : null,
          category: _selectedCategory != widget.announcement.category 
              ? _selectedCategory 
              : null,
          priority: _selectedPriority != widget.announcement.priority 
              ? _selectedPriority 
              : null,
          date: _selectedDate != widget.announcement.date 
              ? _selectedDate 
              : null,
        ),
      );
    }
  }

  bool _hasChanges() {
    return _titleController.text.trim() != widget.announcement.title ||
           _contentController.text.trim() != widget.announcement.content ||
           _selectedCategory != widget.announcement.category ||
           _selectedPriority != widget.announcement.priority ||
           _selectedDate != widget.announcement.date;
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}