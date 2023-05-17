import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config {
  static Future<String?> fetchApiKey() async {
    String key = '';
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 10),
        ),
      );
      await remoteConfig.fetchAndActivate();
      key = remoteConfig.getString('API_KEY');
    } catch (e) {
      print(e);
    }

   

    const storage = FlutterSecureStorage();
    await storage.write(key: 'API_KEY', value: key);
    String? apiKey = await storage.read(key: 'API_KEY');
    return apiKey;
  }
}
