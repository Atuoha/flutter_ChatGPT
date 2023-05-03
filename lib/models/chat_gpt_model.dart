import 'package:equatable/equatable.dart';

class ChatGPTModel extends Equatable {
  final String id;
  final String root;
  final int created;

  const ChatGPTModel(
      {required this.id, required this.root, required this.created});

  @override
  List<Object?> get props => [id, root, created];

  factory ChatGPTModel.fromJson(Map<String, dynamic> data) {
    // var data = json['data'];

    return ChatGPTModel(
      id: data['id'],
      root: data['root'],
      created: data['created'],
    );
  }

  static List<ChatGPTModel> toModelList(List models){
    return models.map((data) => ChatGPTModel.fromJson(data)).toList();
  }
}
