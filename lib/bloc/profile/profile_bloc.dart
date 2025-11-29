import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState.initial()) {
    on<ProfileLoad>(_onLoad);
    on<ProfileEmailChanged>(_onEmailChanged);
    on<ProfilePasswordChanged>(_onPasswordChanged);
    on<ProfileSaveRequested>(_onSave);
  }

  void _onLoad(ProfileLoad event, Emitter<ProfileState> emit) {
    final auth = GetIt.I<AuthService>();
    final user = auth.currentUser;
    if (user == null) {
      emit(state.copyWith(status: ProfileStatus.error));
      return;
    }
    emit(
      ProfileState(
        email: user.email,
        password: user.password,
        role: user.role,
        status: ProfileStatus.ready,
        isSaving: false,
      ),
    );
  }

  void _onEmailChanged(ProfileEmailChanged event, Emitter<ProfileState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(
    ProfilePasswordChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onSave(
    ProfileSaveRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isSaving: true));
    final auth = GetIt.I<AuthService>();
    auth.updateCurrentUser(email: state.email, password: state.password);
    emit(state.copyWith(isSaving: false, status: ProfileStatus.saved));
  }
}
