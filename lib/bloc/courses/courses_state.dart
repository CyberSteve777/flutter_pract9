part of 'courses_bloc.dart';

class CoursesState {
  final List<Course> courses;

  const CoursesState({required this.courses});

  const CoursesState.initial() : courses = const [];
}

