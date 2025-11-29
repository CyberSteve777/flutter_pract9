part of 'home_bloc.dart';

class HomeState {
  final int studentsCount;
  final int coursesCount;
  final int teachersCount;
  final int gradesCount;
  final UserRole? role;
  final String? email;

  const HomeState({
    required this.studentsCount,
    required this.coursesCount,
    required this.teachersCount,
    required this.gradesCount,
    required this.role,
    required this.email,
  });

  const HomeState.initial()
      : studentsCount = 0,
        coursesCount = 0,
        teachersCount = 0,
        gradesCount = 0,
        role = null,
        email = null;
}

