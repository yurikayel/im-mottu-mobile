import 'package:dio/dio.dart';
import 'package:im_mottu_mobile/index.dart';

class MarvelBindings extends Bindings {
  // Private constructor to prevent external instantiation
  MarvelBindings._();

  // Singleton instance
  static final MarvelBindings _instance = MarvelBindings._();

  // Factory method to access the singleton instance
  factory MarvelBindings() => _instance;

  /// Gets the single instance of [MarvelBindings].
  static MarvelBindings get instance => _instance;

  @override
  void dependencies() {
    Get.put(IMarvelRemote(Dio()));

    Get.put<IMarvelRepository>(
      MarvelRepository(
        publicApiKey: dotenv.env['PUBLIC_API_KEY']!,
        privateApiKey: dotenv.env['PRIVATE_API_KEY']!,
        marvelRemote: Get.find<IMarvelRemote>(),
      ),
    );

    Get.put(CharacterViewModel(Get.find<IMarvelRepository>()));
    Get.put(ComicViewModel(Get.find<IMarvelRepository>()));
    Get.put(CreatorViewModel(Get.find<IMarvelRepository>()));
    Get.put(EventViewModel(Get.find<IMarvelRepository>()));
    Get.put(SeriesViewModel(Get.find<IMarvelRepository>()));
    Get.put(StoryViewModel(Get.find<IMarvelRepository>()));
  }
}
