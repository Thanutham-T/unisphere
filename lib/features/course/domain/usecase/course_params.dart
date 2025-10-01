import 'package:equatable/equatable.dart';


class GetCoursesParams extends Equatable {
  final String? studentId;
  final String semester;
  final String languageCode;

  const GetCoursesParams({required this.studentId, required this.semester, required this.languageCode});

  @override
  List<Object> get props => [?studentId, semester, languageCode];
}

class RegisterSectionParams extends Equatable {
  final String studentId;
  final int courseId;
  final int sectionId;

  const RegisterSectionParams({
    required this.studentId,
    required this.courseId,
    required this.sectionId,
  });

  @override
  List<Object> get props => [studentId, courseId, sectionId];
}
