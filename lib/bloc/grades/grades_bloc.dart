import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../models/models.dart';
import '../../services/auth_service.dart';
import '../../services/data_service.dart';

part 'grades_event.dart';
part 'grades_state.dart';

class GradesBloc extends Bloc<GradesEvent, GradesState> {
  GradesBloc() : super(const GradesState.initial()) {
    on<GradesLoad>(_onLoad);
    on<GradeAdded>(_onAdd);
    on<GradeUpdated>(_onUpdate);
    on<GradeDeleted>(_onDelete);
  }

  List<Grade> _computeVisible() {
    final auth = GetIt.I<AuthService>();
    final data = GetIt.I<DataService>();
    final role = auth.currentUser?.role;
    if (role == UserRole.admin) return data.grades;
    if (role == UserRole.teacher) {
      final teacherId = auth.currentUser?.linkedTeacherId;
      final teacherCourseIds = data.courses
          .where((c) => c.teacherId == teacherId)
          .map((c) => c.id)
          .toSet();
      return data.grades.where((g) => teacherCourseIds.contains(g.courseId)).toList();
    }
    if (role == UserRole.student) {
      final studentId = auth.currentUser?.linkedStudentId;
      return data.grades.where((g) => g.studentId == studentId).toList();
    }
    return [];
  }

  void _onLoad(GradesLoad event, Emitter<GradesState> emit) {
    emit(GradesState(grades: _computeVisible()));
  }

  void _onAdd(GradeAdded event, Emitter<GradesState> emit) {
    GetIt.I<DataService>().addGrade(event.grade);
    emit(GradesState(grades: _computeVisible()));
  }

  void _onUpdate(GradeUpdated event, Emitter<GradesState> emit) {
    GetIt.I<DataService>().updateGrade(event.grade);
    emit(GradesState(grades: _computeVisible()));
  }

  void _onDelete(GradeDeleted event, Emitter<GradesState> emit) {
    GetIt.I<DataService>().deleteGrade(event.gradeId);
    emit(GradesState(grades: _computeVisible()));
  }
}

