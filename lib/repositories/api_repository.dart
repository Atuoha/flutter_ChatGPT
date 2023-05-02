import 'package:flutter_chatgpt/models/custom_error.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../constants/api_urls.dart';

class APIRepository {
  Future<void> getModel() async {
    try {
      http.get(Uri.parse(APIUrls.modelUrl), headers: {
        'Authorization': '${dotenv.env['API_KEY']}',
      }).whenComplete(() => null);
    } on CustomError catch (e) {
      throw CustomError(errorMsg: e.errorMsg, code: e.code, plugin: e.plugin);
    }
  }
}
