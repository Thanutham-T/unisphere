import '../entities/course_entity.dart';


abstract class CourseRepository {
  Future<List<CourseEntity>> getCoursesBySemester({String? studentId, String semester, String languageCode});
}
