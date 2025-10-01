// presentation/bloc/course_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:unisphere/core/errors/failure.dart';
import 'package:unisphere/core/usecase/usecase_base.dart';

import '../../domain/entities/course_entity.dart';
import '../../domain/usecase/get_semester_courses_usecase.dart';

import '../blocs/course_event.dart';
import '../blocs/course_state.dart';


class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCoursesUseCase getCoursesUseCase;

  CourseBloc({required this.getCoursesUseCase}) : super(CourseInitial()) {
    on<LoadCourses>(_onLoadCourses);
  }

  Future<void> _onLoadCourses(LoadCourses event, Emitter<CourseState> emit) async {
    emit(CourseLoading());

    final Either<Failure, List<CourseEntity>> result = await getCoursesUseCase(event.semester);

    result.fold((failure) => emit(CourseError(failure.message)), (courses) => emit(CourseLoaded(courses)));
  }
}
