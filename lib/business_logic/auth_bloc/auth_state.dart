part of 'auth_bloc.dart';

@immutable
class AuthState extends Equatable {
  final fbauth.User? user;
  final AuthStatus authStatus;

  const AuthState({
     this.user,
    required this.authStatus,
  });

  factory AuthState.initial() => const AuthState(
        authStatus: AuthStatus.unknown,
      );

  @override
  List<Object?> get props => [user, authStatus];

  @override
  String toString() {
    return 'AuthState{user: $user, authStatus: $authStatus}';
  }

  AuthState copyWith({
    fbauth.User? user,
    AuthStatus? authStatus,
  }) {
    return AuthState(
      user: user ?? this.user,
      authStatus: authStatus ?? this.authStatus,
    );
  }
}
