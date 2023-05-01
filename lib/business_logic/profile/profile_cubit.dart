import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chatgpt/constants/enums/process_status.dart';
import 'package:flutter_chatgpt/repositories/profile_repository.dart';

import '../../models/custom_error.dart';
import '../../models/user.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileCubit({required this.profileRepository})
      : super(ProfileState.initial());

  Future<void> getProfile({required String userId}) async {
    emit(state.copyWith(status: ProcessStatus.loading));
    try {
      final user = await profileRepository.fetchProfile(userId: userId);
      emit(state.copyWith(user: user, status: ProcessStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(status: ProcessStatus.error, error: e));
    }
  }
}
