part of 'open_ai_completions_cubit.dart';

class OpenAiCompletionsState extends Equatable {
  final String currentCompletion;
  final List<OpenAICompletion> completions;

  const OpenAiCompletionsState({
    required this.currentCompletion,
    required this.completions,
  });

  // props
  @override
  List<Object> get props => [currentCompletion, completions];

  // initial
  factory OpenAiCompletionsState.initial() => const OpenAiCompletionsState(
        currentCompletion: '',
    completions: [],
      );


  // toString()
  @override
  String toString() {
    return 'OpenAiCompletionsState{currentCompletion: $currentCompletion, completions: $completions}';
  }


  // copyWith()
  OpenAiCompletionsState copyWith({
    String? currentCompletion,
    List<OpenAICompletion>? completions,
  }) {
    return OpenAiCompletionsState(
      currentCompletion: currentCompletion ?? this.currentCompletion,
      completions: completions ?? this.completions,
    );
  }
}
