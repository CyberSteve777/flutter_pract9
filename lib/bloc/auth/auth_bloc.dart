import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.initial()) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthCheck>(_onCheck);
  }

  void _onLogin(AuthLoginRequested event, Emitter<AuthState> emit) {
    emit(state.copyWith(isLoading: true, error: null));
    final ok = GetIt.I<AuthService>().login(event.email, event.password);
    if (ok) {
      emit(AuthState(
        user: GetIt.I<AuthService>().currentUser,
        isAuthenticated: true,
        isLoading: false,
        error: null,
      ));
    } else {
      emit(state.copyWith(isLoading: false, error: 'Неверная почта или пароль'));
    }
  }

  void _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) {
    GetIt.I<AuthService>().logout();
    emit(const AuthState.initial());
  }

  void _onCheck(AuthCheck event, Emitter<AuthState> emit) {
    final user = GetIt.I<AuthService>().currentUser;
    emit(state.copyWith(user: user, isAuthenticated: user != null));
  }
}

