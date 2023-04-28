part of 'auth_bloc.dart';

@immutable
class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthStateChangeEvent extends AuthEvent {
  final fbauth.User? user;

  AuthStateChangeEvent({required this.user});

  @override
  List<Object?> get props => [user];
}


class SignOutEvent extends AuthEvent{

}
