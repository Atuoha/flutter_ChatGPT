import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chatgpt/models/exports.dart';
import '../../repositories/api_repository.dart';

part 'open_ai_completions_state.dart';

class OpenAiCompletionsCubit extends Cubit<OpenAiCompletionsState> {
  final APIRepository apiRepository;

  OpenAiCompletionsCubit({required this.apiRepository})
      : super(OpenAiCompletionsState.initial());

  // fetch completion
  // Future<OpenAICompletion> fetchCompletion({
  //   required String text,
  //   required OpenAIModel model,
  // }) async {
  //   var completion =
  //       await apiRepository.getCompletion(text: text, model: model);
  //
  //   var newCompletions = [...state.completions, completion];
  //   emit(state.copyWith(completions: newCompletions));
  //   setCurrentCompletion(completion.text);
  //   setCurrentMessage(completion.text);
  //   return completion;
  // }

  // set current completion
  void setCurrentCompletion(String text) {
    emit(state.copyWith(currentCompletion: text));
  }

  // set current message
  void setCurrentMessage(String text) {
    emit(state.copyWith(currentMessage: text));
  }

  // toggle isLiked
  void toggleCompletionIsLike({
    required String completionId,
    required bool value,
  }) {
    final newCompletions = state.completions.map((OpenAICompletion completion) {
      if (completion.id == completionId) {
        return OpenAICompletion(
          id: completion.id,
          text: completion.text,
          isLiked: value,
        );
      }
      return completion;
    }).toList();

    // OpenAICompletion completion = state.completions
    //     .firstWhere((completion) => completion.id == completionId);
    //
    // completion.toggleIsLiked(value);

    emit(state.copyWith(completions: newCompletions));
  }
}
