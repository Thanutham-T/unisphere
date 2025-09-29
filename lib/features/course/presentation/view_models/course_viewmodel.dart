import 'course_section_viewmodel.dart';

class CourseViewModel {
  final String code;
  final String subjectName;
  final String weight;
  final String faculty;
  final String branch;
  final List<CourseSectionViewModel> sections;

  CourseViewModel({
    required this.code,
    required this.subjectName,
    required this.weight,
    required this.faculty,
    required this.branch,
    required this.sections,
  });
}