import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'open_ai_model_state.dart';

class OpenAiModelCubit extends Cubit<OpenAiModelState> {
  OpenAiModelCubit() : super(OpenAiModelState.initial());

  void selectModel(String model) {
    emit(state.copyWith(selectedModel: model));
  }
}