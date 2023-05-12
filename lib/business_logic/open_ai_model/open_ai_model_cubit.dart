import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/open_ai_model.dart';
import '../../repositories/api_repository.dart';

part 'open_ai_model_state.dart';

class OpenAiModelCubit extends Cubit<OpenAiModelState> {
  final APIRepository apiRepository;

  OpenAiModelCubit({required this.apiRepository})
      : super(OpenAiModelState.initial());

  Future<List<OpenAIModel>> fetchAllModels() async {
    var models = await apiRepository.getModels();
    emit(state.copyWith(models: models));
    return models;
  }

  void setModel(String model) {
    emit(state.copyWith(selectedModel: model));
  }
}
