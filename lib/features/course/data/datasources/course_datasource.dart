import '../models/course_model.dart';
import '../models/section_instructor_model.dart';
import '../models/section_model.dart';
import '../models/section_schedule_model.dart';
import '../models/user_registration_model.dart';


abstract class CourseDataSource {
  /// Fetches all courses for a given semester and language
  Future<List<CourseModel>> fetchCourses({required String semester, required String languageCode});

  /// Fetches sections for a given course (optional, depending on how you structure your models)
  Future<List<SectionModel>> fetchSections({required int courseId, required String languageCode});

  /// Fetches student registrations: returns a map of sectionId -> courseId
  Future<List<UserRegistrationModel>> fetchStudentRegistrations(String studentId);

  /// Optional: Fetch instructors for a section
  Future<List<SectionInstructorModel>> fetchSectionInstructors(int sectionId);

  /// Optional: Fetch schedules for a section
  Future<List<SectionScheduleModel>> fetchSectionSchedules(int sectionId);
}
