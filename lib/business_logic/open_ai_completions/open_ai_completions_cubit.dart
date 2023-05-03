import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'open_ai_completions_state.dart';

class OpenAiCompletionsCubit extends Cubit<OpenAiCompletionsState> {
  OpenAiCompletionsCubit() : super(OpenAiCompletionsInitial());
}
