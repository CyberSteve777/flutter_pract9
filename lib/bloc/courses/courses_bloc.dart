import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../models/models.dart';
import '../../services/auth_service.dart';
import '../../services/data_service.dart';

part 'courses_event.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  CoursesBloc() : super(const CoursesState.initial()) {
    on<CoursesLoad>(_onLoad);
    on<CourseAdded>(_onAdd);
    on<CourseDeleted>(_onDelete);
    on<StudentEnrolled>(_onEnroll);
  }

  List<Course> _computeVisible() {
    final auth = GetIt.I<AuthService>();
    final data = GetIt.I<DataService>();
    final role = auth.currentUser?.role;
    if (role == UserRole.admin) return data.courses;
    if (role == UserRole.teacher) {
      final teacherId = auth.currentUser?.linkedTeacherId;
      return data.courses.where((c) => c.teacherId == teacherId).toList();
    }
    if (role == UserRole.student) {
      final studentId = auth.currentUser?.linkedStudentId;
      final student = data.students.firstWhere(
        (s) => s.id == studentId,
        orElse: () => Student(id: '', name: '', email: '', enrolledCourses: const []),
      );
      return data.courses.where((c) => student.enrolledCourses.contains(c.id)).toList();
    }
    return [];
  }

  void _onLoad(CoursesLoad event, Emitter<CoursesState> emit) {
    emit(CoursesState(courses: _computeVisible()));
  }

  void _onAdd(CourseAdded event, Emitter<CoursesState> emit) {
    GetIt.I<DataService>().addCourse(event.course);
    emit(CoursesState(courses: _computeVisible()));
  }

  void _onDelete(CourseDeleted event, Emitter<CoursesState> emit) {
    GetIt.I<DataService>().deleteCourse(event.courseId);
    emit(CoursesState(courses: _computeVisible()));
  }

  void _onEnroll(StudentEnrolled event, Emitter<CoursesState> emit) {
    GetIt.I<DataService>().enrollStudentInCourse(event.courseId, event.studentId);
    emit(CoursesState(courses: _computeVisible()));
  }
}

