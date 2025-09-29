import 'package:flutter_bloc/flutter_bloc.dart';

import 'course_filter_state.dart';


class CourseFilterCubit extends Cubit<CourseFilterState> {
  CourseFilterCubit() : super(CourseFilterState());

  void updateSearch(String query) => emit(state.copyWith(searchQuery: query.toLowerCase()));

  void updateFilter(String filter) => emit(state.copyWith(selectedFilter: filter));
}