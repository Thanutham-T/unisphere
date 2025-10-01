import 'package:equatable/equatable.dart';

import '../../domain/entities/course_entity.dart';


abstract class CourseState extends Equatable {
  @override
  List<Object> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<CourseEntity> courses;

  CourseLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}

class CourseError extends CourseState {
  final String message;

  CourseError(this.message);

  @override
  List<Object> get props => [message];
}
