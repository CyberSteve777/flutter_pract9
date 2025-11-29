part of 'grades_bloc.dart';

class GradesState {
  final List<Grade> grades;

  const GradesState({required this.grades});

  const GradesState.initial() : grades = const [];
}

