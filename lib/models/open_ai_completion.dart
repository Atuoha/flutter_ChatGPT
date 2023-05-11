import 'package:equatable/equatable.dart';

import 'open_ai_model.dart';

class OpenAICompletion extends Equatable {
  final String id;
  final String text;
  bool isLiked;

  OpenAICompletion({
    required this.id,
    required this.text,
    this.isLiked = false,
  });

  @override
  List<Object?> get props => [id, text, isLiked];

  factory OpenAICompletion.fromJson(Map<String, dynamic> data) =>
      OpenAICompletion(
        id: data['id'],
        text: data['choices'][0]['text'],
      );

  factory OpenAICompletion.initial()=>OpenAICompletion(id: '', text: '');

  static List<OpenAICompletion> toListCompletions(List completions) {
    return completions.map((data) => OpenAICompletion.fromJson(data)).toList();
  }

  void toggleIsLiked(bool value) {
    isLiked = value;
  }
}
