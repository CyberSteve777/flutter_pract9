import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../models/models.dart';
import '../../services/auth_service.dart';
import '../../services/data_service.dart';

part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  StudentsBloc() : super(const StudentsState.initial()) {
    on<StudentsLoad>(_onLoad);
    on<StudentAdded>(_onAdd);
    on<StudentUpdated>(_onUpdate);
    on<StudentDeleted>(_onDelete);
  }

  List<Student> _computeVisible() {
    final auth = GetIt.I<AuthService>();
    final data = GetIt.I<DataService>();
    final role = auth.currentUser?.role;
    if (role == UserRole.admin) return data.students;
    if (role == UserRole.teacher) {
      final teacherId = auth.currentUser?.linkedTeacherId;
      if (teacherId == null) return [];
      final teacherCourses = data.courses
          .where((c) => c.teacherId == teacherId)
          .map((c) => c.id)
          .toSet();
      return data.students
          .where((s) => s.enrolledCourses.any(teacherCourses.contains))
          .toList();
    }
    if (role == UserRole.student) {
      final studentId = auth.currentUser?.linkedStudentId;
      return data.students.where((s) => s.id == studentId).toList();
    }
    return [];
  }

  void _onLoad(StudentsLoad event, Emitter<StudentsState> emit) {
    emit(StudentsState(students: _computeVisible()));
  }

  void _onAdd(StudentAdded event, Emitter<StudentsState> emit) {
    GetIt.I<DataService>().addStudent(event.student);
    emit(StudentsState(students: _computeVisible()));
  }

  void _onUpdate(StudentUpdated event, Emitter<StudentsState> emit) {
    GetIt.I<DataService>().updateStudent(event.student);
    emit(StudentsState(students: _computeVisible()));
  }

  void _onDelete(StudentDeleted event, Emitter<StudentsState> emit) {
    GetIt.I<DataService>().deleteStudent(event.studentId);
    emit(StudentsState(students: _computeVisible()));
  }
}

