import 'package:equatable/equatable.dart';

class OpenAIModel extends Equatable {
  final String id;
  final String root;
  final int created;

  const OpenAIModel({
    required this.id,
    required this.root,
    required this.created,
  });


  factory OpenAIModel.initial()=> const OpenAIModel(id: '', root: '', created: 0);

  @override
  List<Object?> get props => [id, root, created];

  factory OpenAIModel.fromJson(Map<String, dynamic> data) {
    // var data = json['data'];

    return OpenAIModel(
      id: data['id'],
      root: data['root'],
      created: data['created'],
    );
  }

  static List<OpenAIModel> toModelList(List models) {
    return models.map((data) => OpenAIModel.fromJson(data)).toList();
  }
}
