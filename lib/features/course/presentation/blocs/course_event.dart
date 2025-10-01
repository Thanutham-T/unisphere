import 'package:equatable/equatable.dart';

import 'package:unisphere/core/usecase/usecase_base.dart';


abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object> get props => [];
}

class LoadCourses extends CourseEvent {
  final GetCourseParams semester;

  const LoadCourses({required this.semester});

  @override
  List<Object> get props => [semester];
}