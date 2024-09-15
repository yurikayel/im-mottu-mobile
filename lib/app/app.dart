// APP
export "home.dart";
export 'bindings.dart';
export "splash.dart";
export 'app.dart';

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
  Widget? get home => const SplashScreen();

  @override
  Bindings? get initialBinding => MarvelBindings.instance;

  @override
  String? get initialRoute => AppRoutes.splash;

  @override
  List<GetPage>? get getPages => AppRoutes.routes;
}

class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  static const characterGraph = '/character-graph';
  static const characterList = '/character-list';
  static const comicList = '/comic-list';
  static const creatorList = '/creator-list';
  static const eventList = '/event-list';
  static const seriesList = '/series-list';
  static const storyList = '/story-list';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: characterList,
      page: () => CharacterListScreen(
        characterViewModel: Get.find<CharacterViewModel>(),
      ),
    ),
    GetPage(
      name: comicList,
      page: () => ComicListScreen(
        comicViewModel: Get.find<ComicViewModel>(),
      ),
    ),
    GetPage(
      name: creatorList,
      page: () => CreatorListScreen(
        creatorViewModel: Get.find<CreatorViewModel>(),
      ),
    ),
    GetPage(
      name: eventList,
      page: () => EventListScreen(
        eventViewModel: Get.find<EventViewModel>(),
      ),
    ),
    GetPage(
      name: seriesList,
      page: () => SeriesListScreen(
        seriesViewModel: Get.find<SeriesViewModel>(),
      ),
    ),
    GetPage(
      name: storyList,
      page: () => StoryListScreen(
        storyViewModel: Get.find<StoryViewModel>(),
      ),
    ),
  ];
}
