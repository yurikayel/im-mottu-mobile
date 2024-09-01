import "package:im_mottu_mobile/index.dart";

void main() async {
  // Ensures that the Flutter framework is fully initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  try {
    await dotenv.load(fileName: '.env').then((_) => runApp(const MarvelApp()));
  } catch (e) {
    print('Failed to load .env file: $e');
  }
}