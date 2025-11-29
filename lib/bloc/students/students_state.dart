part of 'students_bloc.dart';

class StudentsState {
  final List<Student> students;

  const StudentsState({required this.students});

  const StudentsState.initial() : students = const [];
}

