import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../constants/enums/process_status.dart';
import '../../models/custom_error.dart';
import '../../repositories/auth_repository.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository authRepository;

  SignInCubit({required this.authRepository})
      : super(SignInState.initial());

  void handleSignIn({required String email, required String password,}) async {
    emit(state.copyWith(status: ProcessStatus.loading));
    try {
      await authRepository.signIn(email: email, password: password);
      emit(state.copyWith(status: ProcessStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(status: ProcessStatus.error, error: e));
    }
  }
}