part of 'teachers_bloc.dart';

abstract class TeachersEvent {}

class TeachersLoad extends TeachersEvent {}

class TeacherAdded extends TeachersEvent {
  final Teacher teacher;
  TeacherAdded(this.teacher);
}

class TeacherUpdated extends TeachersEvent {
  final Teacher teacher;
  TeacherUpdated(this.teacher);
}

class TeacherDeleted extends TeachersEvent {
  final String teacherId;
  TeacherDeleted(this.teacherId);
}

