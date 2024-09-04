// APP
export "home.dart";
export 'bindings.dart';
export "splash.dart";

import 'package:im_mottu_mobile/index.dart';

class MarvelApp extends GetMaterialApp {
  const MarvelApp({super.key});

  @override
  bool get debugShowCheckedModeBanner => false;

  @override
  String get title => 'Marvel Explorer';

  @override
  ThemeData? get theme => ThemeData(primarySwatch: Colors.red);

  @override
  Widget? get home => SplashScreen();

  @override
  Bindings? get initialBinding => MarvelBindings.instance;
}
