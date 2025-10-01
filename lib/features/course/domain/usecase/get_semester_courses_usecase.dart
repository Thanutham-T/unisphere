import 'package:dartz/dartz.dart';

import 'package:unisphere/core/usecase/usecase_base.dart';
import 'package:unisphere/core/errors/failure.dart';

import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';
import '../usecase/course_params.dart';
import '../usecase/course_failures.dart';


class GetSemesterCoursesUsecase implements UseCaseBase<List<CourseEntity>, GetCoursesParams> {
  final CourseRepository repository;

  GetSemesterCoursesUsecase(this.repository);

  @override
  Future<Either<Failure, List<CourseEntity>>> call(
      GetCoursesParams params) async {
    try {
      // Validate params
      if (params.semester.isEmpty) {
        return Left(InvalidParamsFailure());
      }

      // Fetch data from repository
      final courses = await repository.getCoursesBySemester(
        studentId: params.studentId,
        semester: params.semester,
        languageCode: params.languageCode,
      );

      // Return successful result
      return Right(courses);
    } catch (e) {
      // Catch unexpected errors and wrap them in a Failure
      return Left(ServerFailure(e.toString()));
    }
  }
}
