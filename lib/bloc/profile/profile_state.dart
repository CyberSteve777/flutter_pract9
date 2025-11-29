part of 'profile_bloc.dart';

enum ProfileStatus { initial, ready, saved, error }

class ProfileState {
  final String email;
  final String password;
  final UserRole? role;
  final ProfileStatus status;
  final bool isSaving;

  const ProfileState({
    required this.email,
    required this.password,
    required this.role,
    required this.status,
    required this.isSaving,
  });

  const ProfileState.initial()
    : email = '',
      password = '',
      role = null,
      status = ProfileStatus.initial,
      isSaving = false;

  ProfileState copyWith({
    String? email,
    String? password,
    UserRole? role,
    ProfileStatus? status,
    bool? isSaving,
  }) {
    return ProfileState(
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      status: status ?? this.status,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
