part of 'open_ai_model_cubit.dart';

 class OpenAiModelState extends Equatable {
   final String selectedModel;

   const OpenAiModelState({required this.selectedModel});

   factory OpenAiModelState.initial() =>
       const OpenAiModelState(selectedModel: 'text-davinci-001');

   @override
   List<Object> get props => [selectedModel];


   @override
   String toString() {
     return 'OpenAiModelState{selectedModel: $selectedModel}';
   }

   OpenAiModelState copyWith({
     String? selectedModel,
   }) {
     return OpenAiModelState(
       selectedModel: selectedModel ?? this.selectedModel,
     );
   }
 }