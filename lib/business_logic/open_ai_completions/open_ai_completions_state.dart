part of 'open_ai_completions_cubit.dart';

class OpenAiCompletionsState extends Equatable {
  final String currentCompletion;
  final String currentMessage;
  List<OpenAICompletion> completions;
  List<OpenAICompletion> chats;

  OpenAiCompletionsState({
    required this.currentCompletion,
    required this.currentMessage,
    required this.completions,
    required this.chats,
  });

  // props
  @override
  List<Object> get props => [currentCompletion, completions, currentMessage,chats];

  // initial
  factory OpenAiCompletionsState.initial() => OpenAiCompletionsState(
        currentCompletion: '',
        currentMessage: '',
        completions:  [],
        chats:  [],
      );

  // toString()
  @override
  String toString() {
    return 'OpenAiCompletionsState{currentCompletion: $currentCompletion, completions: $completions,chats: $chats,currentMessage:$currentMessage}';
  }

  // copyWith()
  OpenAiCompletionsState copyWith({
    String? currentCompletion,
    String? currentMessage,
    List<OpenAICompletion>? completions,
    List<OpenAICompletion>? chats,
  }) {
    return OpenAiCompletionsState(
      currentCompletion: currentCompletion ?? this.currentCompletion,
      completions: completions ?? this.completions,
      chats: completions ?? this.chats,
      currentMessage: currentMessage ?? this.currentMessage,
    );
  }
}
