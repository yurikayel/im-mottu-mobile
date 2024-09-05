import 'package:im_mottu_mobile/index.dart';

final apiKeys = _ApiKeys._instance;

class _ApiKeys {
  // Private constructor to prevent external instantiation
  _ApiKeys._();

  // Singleton instance
  static final _ApiKeys _instance = _ApiKeys._();

  // Getter for public API key
  String get publicApiKey => dotenv.env['PUBLIC_API_KEY']!;

  // Getter for private API key
  String get privateApiKey => dotenv.env['PRIVATE_API_KEY']!;
}

Future<void> loadEnv() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    if (kDebugMode) {
      print('Failed to load .env file: $e');
    }
  }
}
