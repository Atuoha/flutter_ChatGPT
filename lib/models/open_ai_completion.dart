import 'package:equatable/equatable.dart';

import 'open_ai_model.dart';

class OpenAICompletion extends Equatable {
  final String id;
  final String text;
  bool isUser;
  bool isLiked;

  OpenAICompletion({
    required this.id,
    required this.text,
    this.isUser = false,
    this.isLiked = false,
  });

  @override
  List<Object?> get props => [id, text, isLiked,isUser,];

  factory OpenAICompletion.fromJson(Map<String, dynamic> data) =>
      OpenAICompletion(
        id: data['id'],
        text: data['text'],
      );

  factory OpenAICompletion.initial()=>OpenAICompletion(id: '', text: '');

  static List<OpenAICompletion> toListCompletions(List completions) {
    return completions.map((data) => OpenAICompletion.fromJson(data)).toList();
  }

  void toggleIsLiked(bool value) {
    isLiked = value;
  }
}
