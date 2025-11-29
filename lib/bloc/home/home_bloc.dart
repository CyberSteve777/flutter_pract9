import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../services/data_service.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState.initial()) {
    on<HomeLoad>(_onLoad);
  }

  void _onLoad(HomeLoad event, Emitter<HomeState> emit) {
    final data = GetIt.I<DataService>();
    final auth = GetIt.I<AuthService>();
    emit(HomeState(
      studentsCount: data.students.length,
      coursesCount: data.courses.length,
      teachersCount: data.teachers.length,
      gradesCount: data.grades.length,
      role: auth.currentUser?.role,
      email: auth.currentUser?.email,
    ));
  }
}

