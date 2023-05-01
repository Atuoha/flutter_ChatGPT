part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final User user;
  final ProcessStatus status;
  final CustomError error;

  const ProfileState({
    required this.user,
    required this.status,
    required this.error,
  });

  factory ProfileState.initial() => ProfileState(
        user: User.initial(),
        status: ProcessStatus.initial,
        error: CustomError.initial(),
      );

  @override
  List<Object> get props => [user, status,error];

  @override
  String toString() {
    return 'ProfileState{user: $user, status: $status, error: $error}';
  }

  ProfileState copyWith({
    User? user,
    ProcessStatus? status,
    CustomError? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
