part of 'sign_in_cubit.dart';

class SignInState extends Equatable {
  final ProcessStatus status;
  final CustomError error;
  const SignInState({required this.status, required this.error});

  factory SignInState.initial()=> SignInState(status: ProcessStatus.initial, error: CustomError.initial());

  @override
  List<Object> get props => [status,error];

  @override
  String toString() {
    return 'SignInState{status: $status, error: $error}';
  }

  SignInState copyWith({
    ProcessStatus? status,
    CustomError? error,
  }) {
    return SignInState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}


