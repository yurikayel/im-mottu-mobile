import 'package:im_mottu_mobile/index.dart';

class MarvelApp extends StatelessWidget {
  const MarvelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Marvel Characters',
      theme: ThemeData(primarySwatch: Colors.red),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      initialBinding: MarvelBindings.instance,
    );
  }
}
