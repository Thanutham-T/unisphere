import '../view_models/course_schedule_viewmodel.dart';

class CourseSectionViewModel {
  final String sectionCode;
  final String enrolledText;     // e.g. "25 / 40"
  final List<String> instructors;
  final List<CourseScheduleViewModel> schedules;

  CourseSectionViewModel({
    required this.sectionCode,
    required this.enrolledText,
    required this.instructors,
    required this.schedules,
  });
}