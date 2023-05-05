part of 'open_ai_model_cubit.dart';

class OpenAiModelState extends Equatable {
  final String selectedModel;
  final List<OpenAIModel> models;

  const OpenAiModelState({required this.selectedModel, required this.models});


  // initial()
  factory OpenAiModelState.initial() =>
      const OpenAiModelState(selectedModel: 'text-davinci-001', models: [],);

  // props
  @override
  List<Object> get props => [selectedModel,models];


  // toString()
  @override
  String toString() {
    return 'OpenAiModelState{selectedModel: $selectedModel,models:$models}';
  }

  // copyWith()
  OpenAiModelState copyWith({
    String? selectedModel,
    List<OpenAIModel>? models,
  }) {
    return OpenAiModelState(
      selectedModel: selectedModel ?? this.selectedModel,
      models: models ?? this.models,
    );
  }
}
