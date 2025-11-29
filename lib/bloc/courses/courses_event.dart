part of 'courses_bloc.dart';

abstract class CoursesEvent {}

class CoursesLoad extends CoursesEvent {}

class CourseAdded extends CoursesEvent {
  final Course course;
  CourseAdded(this.course);
}

class CourseDeleted extends CoursesEvent {
  final String courseId;
  CourseDeleted(this.courseId);
}

class StudentEnrolled extends CoursesEvent {
  final String courseId;
  final String studentId;
  StudentEnrolled(this.courseId, this.studentId);
}

