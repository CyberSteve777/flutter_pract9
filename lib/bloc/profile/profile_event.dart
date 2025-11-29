part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class ProfileLoad extends ProfileEvent {}

class ProfileEmailChanged extends ProfileEvent {
  final String email;
  ProfileEmailChanged(this.email);
}

class ProfilePasswordChanged extends ProfileEvent {
  final String password;
  ProfilePasswordChanged(this.password);
}

class ProfileSaveRequested extends ProfileEvent {}

