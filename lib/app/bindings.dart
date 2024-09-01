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
    _initCharacter();
    _initComic();
    _initCreator();
    _initEvent();
    _initSeries();
    _initStory();
  }

  void _initCharacter() {
    Get.put<ICharacterRemote>(ICharacterRemote(Dio()));
    Get.put<ICharacterRepository>(
      CharacterRepository(
        publicApiKey: dotenv.env['PUBLIC_API_KEY']!,
        privateApiKey: dotenv.env['PRIVATE_API_KEY']!,
        characterRemote: Get.find<ICharacterRemote>(),
      ),
    );
    Get.put(CharacterViewModel(Get.find<ICharacterRepository>()));
  }

  void _initComic() {
    Get.put<IComicRemote>(IComicRemote(Dio()));
    Get.put<IComicRepository>(
      ComicRepository(
        publicApiKey: dotenv.env['PUBLIC_API_KEY']!,
        privateApiKey: dotenv.env['PRIVATE_API_KEY']!,
        comicRemote: Get.find<IComicRemote>(),
      ),
    );
    Get.put(ComicViewModel(Get.find<IComicRepository>()));
  }

  void _initCreator() {
    Get.put<ICreatorRemote>(ICreatorRemote(Dio()));
    Get.put<ICreatorRepository>(
      CreatorRepository(
        publicApiKey: dotenv.env['PUBLIC_API_KEY']!,
        privateApiKey: dotenv.env['PRIVATE_API_KEY']!,
        creatorRemote: Get.find<ICreatorRemote>(),
      ),
    );
    Get.put(CreatorViewModel(Get.find<ICreatorRepository>()));
  }

  void _initEvent() {
    Get.put<IEventRemote>(IEventRemote(Dio()));
    Get.put<IEventRepository>(
      EventRepository(
        publicApiKey: dotenv.env['PUBLIC_API_KEY']!,
        privateApiKey: dotenv.env['PRIVATE_API_KEY']!,
        eventRemote: Get.find<IEventRemote>(),
      ),
    );
    Get.put(EventViewModel(Get.find<IEventRepository>()));
  }

  void _initSeries() {
    Get.put<ISeriesRemote>(ISeriesRemote(Dio()));
    Get.put<ISeriesRepository>(
      SeriesRepository(
        publicApiKey: dotenv.env['PUBLIC_API_KEY']!,
        privateApiKey: dotenv.env['PRIVATE_API_KEY']!,
        seriesRemote: Get.find<ISeriesRemote>(),
      ),
    );
    Get.put(SeriesViewModel(Get.find<ISeriesRepository>()));
  }

  void _initStory() {
    Get.put<IStoryRemote>(IStoryRemote(Dio()));
    Get.put<IStoryRepository>(
      StoryRepository(
        publicApiKey: dotenv.env['PUBLIC_API_KEY']!,
        privateApiKey: dotenv.env['PRIVATE_API_KEY']!,
        storyRemote: Get.find<IStoryRemote>(),
      ),
    );
    Get.put(StoryViewModel(Get.find<IStoryRepository>()));
  }
}
