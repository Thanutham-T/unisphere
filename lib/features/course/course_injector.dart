import 'package:get_it/get_it.dart';

import 'data/datasources/local/mock_course_datasource.dart';
import 'data/repositories/course_repository_impl.dart';
import 'domain/repositories/course_repository.dart';
import 'domain/usecase/get_semester_courses_usecase.dart';

final getIt = GetIt.instance;

Future<void> courseInjector(GetIt getIt) async {
  // Datasource
  getIt.registerLazySingleton<MockCourseDataSource>(() => MockCourseDataSource());

  // Repositories
  getIt.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(dataSource: getIt<MockCourseDataSource>()),
  );
  // Use cases
  getIt.registerLazySingleton<GetCoursesUseCase>(
    () => GetCoursesUseCase(getIt<CourseRepository>()),
  );
}
