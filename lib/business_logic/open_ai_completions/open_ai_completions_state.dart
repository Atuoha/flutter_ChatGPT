part of 'open_ai_completions_cubit.dart';

class OpenAiCompletionsState extends Equatable {
  final String currentMessage;
  List<OpenAICompletion> completions;
  List<OpenAICompletion> chats;

  OpenAiCompletionsState({
    required this.currentMessage,
    required this.completions,
    required this.chats,
  });

  // props
  @override
  List<Object> get props => [completions, currentMessage,chats];

  // initial
  factory OpenAiCompletionsState.initial() => OpenAiCompletionsState(
        currentMessage: '',
        completions:  [],
        chats:  [],
      );

  // toString()
  @override
  String toString() {
    return 'OpenAiCompletionsState{completions: $completions,chats: $chats,currentMessage:$currentMessage}';
  }

  // copyWith()
  OpenAiCompletionsState copyWith({
    String? currentMessage,
    List<OpenAICompletion>? completions,
    List<OpenAICompletion>? chats,
  }) {
    return OpenAiCompletionsState(
      completions: completions ?? this.completions,
      chats: completions ?? this.chats,
      currentMessage: currentMessage ?? this.currentMessage,
    );
  }
}
