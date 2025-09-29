import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

import 'package:unisphere/features/course/presentation/view_models/course_viewmodel.dart';
import 'package:unisphere/features/course/presentation/view_models/course_section_viewmodel.dart';
import 'package:unisphere/features/course/presentation/view_models/course_schedule_viewmodel.dart';
import 'package:unisphere/features/course/presentation/widgets/filter_sheet_widget.dart';

import '../blocs/course_filter_cubit.dart';
import '../blocs/course_filter_state.dart';
import '../widgets/course_list_widget.dart';

class CourseScreen extends StatelessWidget {
  CourseScreen({super.key});

  final SearchController _searchController = SearchController();

  final Random _random = Random();

  List<String> faculties = [
    'คณะการจัดการสิ่งแวดล้อม',
    'คณะการแพทย์แผนไทย',
    'คณะทรัพยากรธรรมชาติ',
    'คณะทันตแพทยศาสตร์',
    'คณะนิติศาสตร์',
    'คณะพยาบาลศาสตร์',
    'คณะวิทยาการจัดการ',
    'คณะวิทยาศาสตร์',
    'คณะวิศวกรรมศาสตร์',
    'คณะศิลปศาสตร์',
    'คณะสัตวแพทยศาสตร์',
    'คณะอุตสาหกรรมเกษตร',
    'คณะเทคนิคการแพทย์',
    'คณะเภสัชศาสตร์',
    'คณะเศรษฐศาสตร์',
    'คณะแพทยศาสตร์',
    'บัณฑิตวิทยาลัย',
    'วิทยาลัยนานาชาติ',
  ];

  String randomTime() {
    int hour = 8 + _random.nextInt(10); // 8 to 17
    int minute = _random.nextBool() ? 0 : 30;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  List<CourseViewModel> generateCourses(int count) {
    List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

    List<String> branches = [
      // คณะวิศวกรรมศาสตร์
      'สาขาวิศวกรรมเคมี',
      'สาขาวิศวกรรมไฟฟ้า',
      'สาขาวิศวกรรมเครื่องกล',
      'สาขาวิศวกรรมโยธา',
      'สาขาวิศวกรรมคอมพิวเตอร์',
      'สาขาวิศวกรรมอุตสาหการ',
      'สาขาวิศวกรรมสิ่งแวดล้อม',

      // คณะวิทยาศาสตร์
      'สาขาวิชาคณิตศาสตร์',
      'สาขาวิชาฟิสิกส์',
      'สาขาวิชาเคมี',
      'สาขาวิชาชีววิทยา',
      'สาขาวิทยาศาสตร์สิ่งแวดล้อม',
      'สาขาวิทยาศาสตร์ข้อมูล',

      // คณะแพทยศาสตร์
      'สาขาแพทยศาสตร์',
      'สาขาการแพทย์ฉุกเฉิน',

      // คณะพยาบาลศาสตร์
      'สาขาพยาบาลศาสตร์',

      // คณะเภสัชศาสตร์
      'สาขาเภสัชศาสตร์',

      // คณะทันตแพทยศาสตร์
      'สาขาทันตแพทยศาสตร์',

      // คณะสัตวแพทยศาสตร์
      'สาขาสัตวแพทยศาสตร์',

      // คณะวิทยาการจัดการ
      'สาขาการจัดการ',
      'สาขาการบัญชี',
      'สาขาการตลาด',
      'สาขาการบริหารทรัพยากรมนุษย์',
      'สาขาการบริหารธุรกิจ',

      // คณะมนุษยศาสตร์และสังคมศาสตร์
      'สาขาภาษาอังกฤษ',
      'สาขาภาษาไทย',
      'สาขาภาษาจีน',
      'สาขาภาษาญี่ปุ่น',
      'สาขาภาษาฝรั่งเศส',
      'สาขาสังคมศาสตร์',
      'สาขารัฐศาสตร์',
      'สาขานิติศาสตร์',
      'สาขาจิตวิทยา',
      'สาขาสื่อสารมวลชน',

      // คณะการจัดการการท่องเที่ยวและการโรงแรม
      'สาขาการจัดการการท่องเที่ยว',
      'สาขาการจัดการการโรงแรม',

      // คณะสถาปัตยกรรมศาสตร์และการออกแบบ
      'สาขาสถาปัตยกรรมศาสตร์',
      'สาขาการออกแบบผลิตภัณฑ์',
      'สาขาการออกแบบสื่อสารการออกแบบ',

      // คณะศิลปกรรมศาสตร์
      'สาขาศิลปะการแสดง',
      'สาขาการออกแบบสื่อสารการแสดง',
      'สาขาการออกแบบผลิตภัณฑ์',

      // คณะศึกษาศาสตร์
      'สาขาการศึกษาปฐมวัย',
      'สาขาการประถมศึกษา',
      'สาขาคณิตศาสตร์',
      'สาขาวิทยาศาสตร์ทั่วไป',
      'สาขาเคมี',
      'สาขาชีววิทยา',
      'สาขาฟิสิกส์',
      'สาขาภาษาไทย',
      'สาขาภาษาอังกฤษ',
      'สาขาสังคมศึกษา',
      'สาขาศิลปศึกษา',
      'สาขาสุขศึกษา',
      'สาขาพลศึกษา',
      'สาขาวัดผล-เทคโนโลยีสารสนเทศ',
      'สาขาเทคโนโลยีดิจิทัลและสื่อสารการศึกษา',
      'สาขาจิตวิทยาคลินิก',
      'สาขาจิตวิทยาการศึกษาและการแนะแนว',

      // คณะวิทยาการเรียนรู้และศึกษาศาสตร์
      'สาขาการเรียนรู้และการสอน',
      'สาขาการพัฒนาหลักสูตร',
      'สาขาการประเมินผลการศึกษา',
      'สาขาการบริหารการศึกษา',

      // คณะวิทยาศาสตร์สุขภาพ
      'สาขากายภาพบำบัด',
      'สาขาการแพทย์แผนไทย',
      'สาขาการแพทย์แผนจีน',
      'สาขาการแพทย์แผนไทยประยุกต์',

      // คณะวิทยาศาสตร์และเทคโนโลยี
      'สาขาเทคโนโลยีชีวภาพ',
      'สาขาเทคโนโลยีสารสนเทศ',
      'สาขาวิทยาศาสตร์คอมพิวเตอร์',

      // วิทยาลัยนานาชาติ
      'สาขาดิจิทัลมีเดีย',
      'สาขาการจัดการธุรกิจระหว่างประเทศ',
      'สาขาการสื่อสารระหว่างประเทศ',
      'สาขาการบริหารธุรกิจนานาชาติ',
    ];

    List<String> instructors = ['สวัสดี วันจันทร์', 'สวัสดี วันอังคาร', 'สวัสดี วันพุธ', 'สวัสดี วันพฤหัส', 'สวัสดี วันศุกร์'];

    return List.generate(count, (index) {
      return CourseViewModel(
        code: '${100 + _random.nextInt(900)}-${100 + _random.nextInt(900)}',
        subjectName: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ${index + 1}',
        weight: '${_random.nextInt(10)}((6)-6-${_random.nextInt(20)})',
        faculty: faculties[_random.nextInt(faculties.length)],
        branch: branches[_random.nextInt(branches.length)],
        sections: List.generate(4, (secIndex) {
          return CourseSectionViewModel(
            sectionCode: (secIndex + 1).toString().padLeft(2, '0'),
            enrolledText: '${20 + _random.nextInt(30)}/${20 + _random.nextInt(30)}',
            instructors: List.generate(2, (_) => instructors[_random.nextInt(instructors.length)]),
            schedules: List.generate(3, (_) {
              String day = days[_random.nextInt(days.length)];
              String start = randomTime();
              int endHour = int.parse(start.split(':')[0]) + 3;
              String end = '${endHour.toString().padLeft(2, '0')}:${start.split(':')[1]}';
              return CourseScheduleViewModel(dayOfWeek: day, timeRange: '${start} - ${end}', room: 'R${100 + _random.nextInt(200)}');
            }),
          );
        }),
      );
    });
  }

  late final List<CourseViewModel> _courses = generateCourses(10);

  // Build list of search suggestions
  List<String> get _allSearchableItems {
    final items = <String>{};
    for (var course in _courses) {
      items.add('${course.code} ${course.subjectName}');
    }
    return items.toList();
  }

  // Filtering logic
  List<CourseViewModel> _filteredCourses(List<CourseViewModel> courses, CourseFilterState state) {
    final List<CourseViewModel> courseFiltered = [];

    for (var course in courses) {
      final String query = state.searchQuery.trim();
      final String fullName = '${course.code} ${course.subjectName}'.toLowerCase().trim();

      final matchesSearch = query.isEmpty || course.subjectName.contains(query) || course.code.contains(query) || fullName.contains(query);
      final matchesFilter = state.selectedFilter == 'All' || course.faculty == state.selectedFilter;

      if (matchesSearch && matchesFilter) {
        courseFiltered.add(course);
      }
    }
    return courseFiltered;
  }

  void _onVoiceSearch(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice search not implemented')));
  }

  void _openFilterSheet(BuildContext context, CourseFilterCubit cubit) {
    showFilterSheet(context, cubit, faculties);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => CourseFilterCubit(),
      child: BlocBuilder<CourseFilterCubit, CourseFilterState>(
        builder: (context, state) {
          final cubit = context.read<CourseFilterCubit>();
          final groupedCourses = _filteredCourses(_courses, state);

          return Scaffold(
            appBar: AppBar(
              title: Text('Courses', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
              leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
              actions: [IconButton(icon: Icon(Icons.filter_list), tooltip: 'Filter', onPressed: () => _openFilterSheet(context, cubit))],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 28.0, right: 16.0, left: 16.0, bottom: 24.0),
                  child: SearchAnchor.bar(
                    searchController: _searchController,
                    barHintText: 'Search name or code...',
                    viewTrailing: [
                      IconButton(icon: const Icon(Icons.mic), tooltip: 'Voice Search', onPressed: () => _onVoiceSearch(context)),
                    ],
                    suggestionsBuilder: (context, controller) {
                      final query = controller.text.toLowerCase();

                      final results = _allSearchableItems.where((item) => item.toLowerCase().contains(query)).take(5).toList();

                      return results.map((suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                          onTap: () {
                            controller.text = suggestion;
                            controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                            cubit.updateSearch(suggestion);
                            Navigator.pop(context);
                          },
                        );
                      }).toList();
                    },
                    onSubmitted: (query) => cubit.updateSearch(query),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.onSecondary,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.only(top: 24.0, right: 4.0, left: 4.0, bottom: 2.0),
                    child: groupedCourses.isEmpty
                        ? Center(child: Text('No courses found', style: Theme.of(context).textTheme.headlineMedium))
                        : CourseListWidget(courses: groupedCourses),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
