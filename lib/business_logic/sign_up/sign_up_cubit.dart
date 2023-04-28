import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../constants/enums/process_status.dart';
import '../../models/custom_error.dart';
import '../../repositories/auth_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository authRepository;

  SignUpCubit({required this.authRepository})
      : super(SignUpState.initial());

  void handleSignUp(
      {required String email, required String password, required String username}) async {
    emit(state.copyWith(status: ProcessStatus.loading));
    try {
      await authRepository.signUp(
          email: email, password: password, username: username);
      emit(state.copyWith(status: ProcessStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(status: ProcessStatus.error, error: e));
    }
  }
}