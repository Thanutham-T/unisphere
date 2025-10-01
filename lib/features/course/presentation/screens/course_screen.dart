import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisphere/core/logging/app_logger.dart';
import 'package:unisphere/features/course/domain/mapper/course_mapper.dart';

import 'package:unisphere/features/course/presentation/view_models/course_viewmodel.dart';
import 'package:unisphere/features/course/presentation/widgets/filter_sheet_widget.dart';

import '../blocs/course_bloc.dart';
import '../blocs/course_event.dart';
import '../blocs/course_filter_cubit.dart';
import '../blocs/course_filter_state.dart';
import '../blocs/course_state.dart';

import '../widgets/course_list_widget.dart';

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

class CourseScreen extends StatelessWidget {
  CourseScreen({super.key});

  final SearchController _searchController = SearchController();

  // Build list of search suggestions
  List<String> _allSearchableItem(List<CourseViewModel> courses) {
    final items = <String>{};
    for (var course in courses) {
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

    return BlocBuilder<CourseFilterCubit, CourseFilterState>(
      builder: (context, filterState) {
        final filterCubit = context.read<CourseFilterCubit>();

        return Scaffold(
          appBar: AppBar(
            title: Text('Courses', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
          ),
          body: BlocBuilder<CourseBloc, CourseState>(
            builder: (context, state) {
              if (state is CourseLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CourseLoaded) {
                AppLogger.debug('${state.courses[0]}');
                // Convert entities to ViewModels for the UI
                final courses = state.courses
                    .map((e) => e.toViewModel(sections: e.sections, schedules: e.sections.expand((s) => s.schedules).toList()))
                    .toList();

                final filteredCourses = _filteredCourses(courses, filterState);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 10.0),
                      child: SearchAnchor.bar(
                        searchController: _searchController,
                        barHintText: 'Search name or code...',
                        viewTrailing: [
                          IconButton(icon: const Icon(Icons.mic), tooltip: 'Voice Search', onPressed: () => _onVoiceSearch(context)),
                        ],
                        suggestionsBuilder: (context, controller) {
                          final query = controller.text.toLowerCase();
                          final suggestions = _allSearchableItem(
                            courses,
                          ).where((item) => item.toLowerCase().contains(query)).take(5).toList();

                          return suggestions.map((suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                              onTap: () {
                                controller.text = suggestion;
                                controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                                filterCubit.updateSearch(suggestion);
                                Navigator.pop(context);
                              },
                            );
                          }).toList();
                        },
                        onSubmitted: (query) => filterCubit.updateSearch(query),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SegmentedButton(
                          segments: const <ButtonSegment<bool>>[
                            ButtonSegment<bool>(value: true, label: Text('All course'), icon: Icon(Icons.calendar_view_day)),
                            ButtonSegment<bool>(value: false, label: Text('My course'), icon: Icon(Icons.calendar_view_week)),
                          ],
                          selected: <bool>{false},
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          tooltip: 'Filter',
                          onPressed: () => _openFilterSheet(context, filterCubit),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.onSecondary,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        padding: const EdgeInsets.only(top: 24.0, right: 4.0, left: 4.0, bottom: 2.0),
                        child: filteredCourses.isEmpty
                            ? Center(child: Text('No courses found', style: Theme.of(context).textTheme.headlineMedium))
                            : CourseListWidget(courses: filteredCourses),
                      ),
                    ),
                  ],
                );
              } else if (state is CourseError) {
                return Center(child: Text('Error: ${state.message}', style: Theme.of(context).textTheme.headlineMedium));
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
