part of 'api_work_cubit.dart';

class ApiWorkState extends Equatable {
  final String selectedModel;

  const ApiWorkState({required this.selectedModel});

  factory ApiWorkState.initial() =>
      const ApiWorkState(selectedModel: 'text-davinci-001');

  @override
  List<Object> get props => [selectedModel];


  @override
  String toString() {
    return 'ApiWorkState{selectedModel: $selectedModel}';
  }

  ApiWorkState copyWith({
    String? selectedModel,
  }) {
    return ApiWorkState(
      selectedModel: selectedModel ?? this.selectedModel,
    );
  }
}
