import 'dart:convert';
import 'package:flutter_chatgpt/models/custom_error.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/api_urls.dart';
import '../models/chat_gpt_model.dart';

class APIRepository {
  static Future<List<ChatGPTModel>> getModels() async {
    try {
      var response = await http.get(Uri.parse(APIUrls.modelUrl), headers: {
        'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
      });

      Map jsonResponse = json.decode(response.body);
      if (jsonResponse['error'] != null) {
        throw http.ClientException(jsonResponse['error']['message']);
      }
      List models = [];
      for (var value in jsonResponse['data']) {
        models.add(value);
      }
      print(models);
      return ChatGPTModel.toModelList(models);
    } on CustomError catch (e) {
      throw CustomError(errorMsg: e.errorMsg, code: e.code, plugin: e.plugin);
    }
  }
}
