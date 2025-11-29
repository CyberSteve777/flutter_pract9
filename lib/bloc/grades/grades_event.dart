part of 'grades_bloc.dart';

abstract class GradesEvent {}

class GradesLoad extends GradesEvent {}

class GradeAdded extends GradesEvent {
  final Grade grade;
  GradeAdded(this.grade);
}

class GradeUpdated extends GradesEvent {
  final Grade grade;
  GradeUpdated(this.grade);
}

class GradeDeleted extends GradesEvent {
  final String gradeId;
  GradeDeleted(this.gradeId);
}

