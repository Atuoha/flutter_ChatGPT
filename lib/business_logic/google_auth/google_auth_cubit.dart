import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chatgpt/constants/enums/auth_status.dart';
import 'package:flutter_chatgpt/constants/enums/process_status.dart';
import 'package:flutter_chatgpt/models/custom_error.dart';

import '../../repositories/auth_repository.dart';

part 'google_auth_state.dart';

class GoogleAuthCubit extends Cubit<GoogleAuthState> {
  final AuthRepository authRepository;

  GoogleAuthCubit({required this.authRepository})
      : super(GoogleAuthState.initial());

  void handleGoogleAuth() async {
    emit(state.copyWith(status: ProcessStatus.loading));
    try {
      await authRepository.googleAuth();
      emit(state.copyWith(status: ProcessStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(status: ProcessStatus.error));
    }
  }
}
