import 'package:flutter/material.dart';

class AnnouncementFilterWidget extends StatefulWidget {
  final String? selectedCategory;
  final String? selectedPriority;
  final Function(String?) onCategoryChanged;
  final Function(String?) onPriorityChanged;

  const AnnouncementFilterWidget({
    super.key,
    this.selectedCategory,
    this.selectedPriority,
    required this.onCategoryChanged,
    required this.onPriorityChanged,
  });

  @override
  State<AnnouncementFilterWidget> createState() => _AnnouncementFilterWidgetState();
}

class _AnnouncementFilterWidgetState extends State<AnnouncementFilterWidget> {
  String? _selectedCategory;
  String? _selectedPriority;

  final List<String> _categories = [
    'general',
    'academic',
    'event',
    'maintenance',
  ];

  final List<String> _priorities = [
    'high',
    'medium',
    'low',
  ];

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
    _selectedCategory = widget.selectedCategory;
    _selectedPriority = widget.selectedPriority;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('กรองประกาศ'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category filter
          Text(
            'หมวดหมู่',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('ทั้งหมด'),
                selected: _selectedCategory == null,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedCategory = null;
                    });
                  }
                },
              ),
              ..._categories.map((category) => FilterChip(
                label: Text(_categoryDisplayNames[category] ?? category),
                selected: _selectedCategory == category,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? category : null;
                  });
                },
              )),
            ],
          ),
          const SizedBox(height: 16),
          
          // Priority filter
          Text(
            'ความสำคัญ',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('ทั้งหมด'),
                selected: _selectedPriority == null,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedPriority = null;
                    });
                  }
                },
              ),
              ..._priorities.map((priority) => FilterChip(
                label: Text(_priorityDisplayNames[priority] ?? priority),
                selected: _selectedPriority == priority,
                onSelected: (selected) {
                  setState(() {
                    _selectedPriority = selected ? priority : null;
                  });
                },
              )),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('ยกเลิก'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onCategoryChanged(_selectedCategory);
            widget.onPriorityChanged(_selectedPriority);
            Navigator.of(context).pop();
          },
          child: const Text('ใช้งาน'),
        ),
      ],
    );
  }
}