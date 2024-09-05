import "package:im_mottu_mobile/index.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadEnv().then(
    (_) => runApp(
      const MarvelApp(),
    ),
  );
}
