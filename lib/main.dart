import "package:im_mottu_mobile/index.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();
}

Future<void> loadEnv() async {
  try {
    await dotenv.load(fileName: '.env').then((_) => runApp(const MarvelApp()));
  } catch (e) {
    if (kDebugMode) {
      print('Failed to load .env file: $e');
    }
  }
}
