part of 'students_bloc.dart';

abstract class StudentsEvent {}

class StudentsLoad extends StudentsEvent {}

class StudentAdded extends StudentsEvent {
  final Student student;
  StudentAdded(this.student);
}

class StudentUpdated extends StudentsEvent {
  final Student student;
  StudentUpdated(this.student);
}

class StudentDeleted extends StudentsEvent {
  final String studentId;
  StudentDeleted(this.studentId);
}

