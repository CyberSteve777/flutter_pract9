import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../models/models.dart';
import '../../services/auth_service.dart';
import '../../services/data_service.dart';

part 'teachers_event.dart';
part 'teachers_state.dart';

class TeachersBloc extends Bloc<TeachersEvent, TeachersState> {
  TeachersBloc() : super(const TeachersState.initial()) {
    on<TeachersLoad>(_onLoad);
    on<TeacherAdded>(_onAdd);
    on<TeacherUpdated>(_onUpdate);
    on<TeacherDeleted>(_onDelete);
  }

  void _onLoad(TeachersLoad event, Emitter<TeachersState> emit) {
    emit(TeachersState(teachers: GetIt.I<DataService>().teachers));
  }

  void _onAdd(TeacherAdded event, Emitter<TeachersState> emit) {
    GetIt.I<DataService>().addTeacher(event.teacher);
    emit(TeachersState(teachers: GetIt.I<DataService>().teachers));
  }

  void _onUpdate(TeacherUpdated event, Emitter<TeachersState> emit) {
    GetIt.I<DataService>().updateTeacher(event.teacher);
    emit(TeachersState(teachers: GetIt.I<DataService>().teachers));
  }

  void _onDelete(TeacherDeleted event, Emitter<TeachersState> emit) {
    GetIt.I<DataService>().deleteTeacher(event.teacherId);
    emit(TeachersState(teachers: GetIt.I<DataService>().teachers));
  }
}

