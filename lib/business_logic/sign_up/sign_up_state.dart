part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final ProcessStatus status;
  final CustomError error;

  const SignUpState({required this.status, required this.error});

  factory SignUpState.initial() =>
      SignUpState(status: ProcessStatus.initial, error: CustomError.initial());

  @override
  List<Object> get props => [status, error];

  @override
  String toString() {
    return 'SignUpState{status: $status, error: $error}';
  }

  SignUpState copyWith({
    ProcessStatus? status,
    CustomError? error,
  }) {
    return SignUpState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
