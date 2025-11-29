part of 'teachers_bloc.dart';

class TeachersState {
  final List<Teacher> teachers;

  const TeachersState({required this.teachers});

  const TeachersState.initial() : teachers = const [];
}

