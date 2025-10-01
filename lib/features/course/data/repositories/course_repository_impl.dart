import 'package:unisphere/core/logging/app_logger.dart';
import 'package:unisphere/features/course/data/models/user_registration_model.dart';

import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/course_repository.dart';

import '../datasources/course_datasource.dart';
import '../models/course_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseDataSource dataSource;

  CourseRepositoryImpl({required this.dataSource});

  @override
  Future<List<CourseEntity>> getCoursesBySemester({String? studentId, required String semester, required String languageCode}) async {
    try {
      // 1. Fetch raw data from data source
      final List<CourseModel> courseModels = await dataSource.fetchCourses(semester: semester, languageCode: languageCode);

      // 2. Fetch student registrations if studentId is provided
      final List<UserRegistrationModel> registeredSections = studentId != null ? await dataSource.fetchStudentRegistrations(studentId) : [];

      // 3. Map models to entities
      final List<CourseEntity> courses = courseModels.map((courseModel) {
        // Find if the student has registered a section in this course
        int? selectedSectionId;
        if (studentId != null) {
          final registration = registeredSections.firstWhere((reg) => reg.courseId == courseModel.courseId, orElse: () => null);
          selectedSectionId = registration?.sectionId;
        }

        // Map sections
        final sections = courseModel.sections.map((sectionModel) {
          return SectionEntity(
            sectionId: sectionModel.sectionId,
            sectionCode: sectionModel.sectionCode,
            studentLimit: sectionModel.studentLimit,
            schedules: sectionModel.schedules
                .map(
                  (schedule) => SectionScheduleEntity(
                    scheduleId: schedule.scheduleId,
                    dayId: schedule.dayId,
                    startTime: schedule.startTime,
                    endTime: schedule.endTime,
                    note: schedule.note,
                  ),
                )
                .toList(),
            instructors: sectionModel.instructors
                .map(
                  (instructor) => SectionInstructorEntity(instructorId: instructor.instructorId, instructorName: instructor.instructorName),
                )
                .toList(),
          );
        }).toList();

        return CourseEntity(
          courseId: courseModel.courseId,
          courseCode: courseModel.courseCode,
          branchId: courseModel.branchId,
          semester: courseModel.semester,
          startDate: courseModel.startDate,
          endDate: courseModel.endDate,
          status: courseModel.status,
          sections: sections,
          selectedSectionId: selectedSectionId,
        );
      }).toList();

      return courses;
    } catch (e, stackTrace) {
      AppLogger.error("Failed to fetch courses for semester $semester", e, stackTrace);
      rethrow; // You can wrap it in Failure if you return Either<Failure, T>
    }
  }
}
