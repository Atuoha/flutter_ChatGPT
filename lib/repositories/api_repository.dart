import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/api_urls.dart';
import '../models/exports.dart';

class APIRepository {
  // fetch OpenAIModels
  Future<List<OpenAIModel>> getModels() async {
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
      return OpenAIModel.toModelList(models);
    } on CustomError catch (e) {
      throw CustomError(errorMsg: e.errorMsg, code: e.code, plugin: e.plugin);
    }
  }

  // fetch OpenAICompletion
  Future<OpenAICompletion> getCompletion({
    required String text,
    required OpenAIModel model,
  }) async {
    try {
      var response =
          await http.post(Uri.parse(APIUrls.completionUrl), headers: {
        'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
        'Content-Type': "application/json",
      }, body: {
        "model": model.id,
        "prompt": text,
        "max_tokens": 100,
        "temperature": 0
      });
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['error'] != null) {
        throw http.ClientException(jsonResponse['error']['message']);
      }
      print(jsonResponse);
      return OpenAICompletion.fromJson(jsonResponse);
    } on CustomError catch (e) {
      throw CustomError(errorMsg: e.errorMsg, code: e.code, plugin: e.plugin);
    }
  }
}
