part of 'auth_bloc.dart';

class AuthState {
  final User? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.user,
    required this.isAuthenticated,
    required this.isLoading,
    required this.error,
  });

  const AuthState.initial()
      : user = null,
        isAuthenticated = false,
        isLoading = false,
        error = null;

  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

