import 'package:im_mottu_mobile/index.dart';
import 'package:dio/dio.dart';

class MarvelBindings extends Bindings {
  MarvelBindings._();

  static final MarvelBindings _instance = MarvelBindings._();

  factory MarvelBindings() => _instance;

  static MarvelBindings get instance => _instance;

  @override
  void dependencies() async {
    final dio = Dio()..interceptors.add(CacheInterceptor());

    _initializeComicModule(dio);
    _initializeCreatorModule(dio);
    _initializeEventModule(dio);
    _initializeSeriesModule(dio);
    _initializeStoryModule(dio);
    _initializeCharacterModule(dio);
  }

  void _initializeComicModule(Dio dio) {
    _initializeModule<IComicRemote, IComicRepository, ComicRepository,
        ComicViewModel>(
      createRemote: () => IComicRemote(dio),
      createRepository: (remote) => ComicRepository(
        publicApiKey: apiKeys.publicApiKey,
        privateApiKey: apiKeys.privateApiKey,
        comicRemote: remote,
      ),
      createViewModel: (repo) => ComicViewModel(repo),
    );
  }

  void _initializeCreatorModule(Dio dio) {
    _initializeModule<ICreatorRemote, ICreatorRepository, CreatorRepository,
        CreatorViewModel>(
      createRemote: () => ICreatorRemote(dio),
      createRepository: (remote) => CreatorRepository(
        publicApiKey: apiKeys.publicApiKey,
        privateApiKey: apiKeys.privateApiKey,
        creatorRemote: remote,
      ),
      createViewModel: (repo) => CreatorViewModel(repo),
    );
  }

  void _initializeEventModule(Dio dio) {
    _initializeModule<IEventRemote, IEventRepository, EventRepository,
        EventViewModel>(
      createRemote: () => IEventRemote(dio),
      createRepository: (remote) => EventRepository(
        publicApiKey: apiKeys.publicApiKey,
        privateApiKey: apiKeys.privateApiKey,
        eventRemote: remote,
      ),
      createViewModel: (repo) => EventViewModel(repo),
    );
  }

  void _initializeSeriesModule(Dio dio) {
    _initializeModule<ISeriesRemote, ISeriesRepository, SeriesRepository,
        SeriesViewModel>(
      createRemote: () => ISeriesRemote(dio),
      createRepository: (remote) => SeriesRepository(
        publicApiKey: apiKeys.publicApiKey,
        privateApiKey: apiKeys.privateApiKey,
        seriesRemote: remote,
      ),
      createViewModel: (repo) => SeriesViewModel(repo),
    );
  }

  void _initializeStoryModule(Dio dio) {
    _initializeModule<IStoryRemote, IStoryRepository, StoryRepository,
        StoryViewModel>(
      createRemote: () => IStoryRemote(dio),
      createRepository: (remote) => StoryRepository(
        publicApiKey: apiKeys.publicApiKey,
        privateApiKey: apiKeys.privateApiKey,
        storyRemote: remote,
      ),
      createViewModel: (repo) => StoryViewModel(repo),
    );
  }

  void _initializeCharacterModule(Dio dio) {
    _initializeModule<ICharacterRemote, ICharacterRepository,
        CharacterRepository, CharacterViewModel>(
      createRemote: () => ICharacterRemote(dio),
      createRepository: (remote) => CharacterRepository(
        publicApiKey: apiKeys.publicApiKey,
        privateApiKey: apiKeys.privateApiKey,
        characterRemote: remote,
      ),
      createViewModel: (repo) => CharacterViewModel(
        repo,
        Get.find<IComicRepository>(),
        Get.find<IEventRepository>(),
        Get.find<ISeriesRepository>(),
        Get.find<IStoryRepository>(),
      ),
    );
  }

  void _initializeModule<TRemote, TRepository, TRepoImpl, TViewModel>({
    required TRemote Function() createRemote,
    required TRepository Function(TRemote remote) createRepository,
    required TViewModel Function(TRepository repo) createViewModel,
  }) {
    final remote = createRemote();
    Get.put(remote);
    final repository = createRepository(remote);
    Get.put(repository);
    Get.put(createViewModel(repository));
  }
}
