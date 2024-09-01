import 'package:im_mottu_mobile/index.dart';

class StoryRepository implements IStoryRepository {
  final IStoryRemote _storyRemote;
  final String _publicApiKey;
  final String _privateApiKey;

  StoryRepository({
    required String publicApiKey,
    required String privateApiKey,
    required IStoryRemote storyRemote,
  })  : _publicApiKey = publicApiKey,
        _privateApiKey = privateApiKey,
        _storyRemote = storyRemote;

  @override
  Future<StoryDataWrapper> fetchStories({
    String? title,
    String? titleStartsWith,
    String? comics,
    String? series,
    String? creators,
    String? events,
    String? characters,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return await _storyRemote.fetchStories(
      title: title,
      titleStartsWith: titleStartsWith,
      comics: comics,
      series: series,
      creators: creators,
      events: events,
      characters: characters,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<StoryDataWrapper> fetchStoryById(int storyId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return await _storyRemote.fetchStoryById(
      storyId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<StoryDataWrapper> fetchStoriesByComic(int comicId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return await _storyRemote.fetchStoriesByComic(
      comicId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<StoryDataWrapper> fetchStoriesBySeries(int seriesId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return await _storyRemote.fetchStoriesBySeries(
      seriesId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<StoryDataWrapper> fetchStoriesByCreator(int creatorId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return await _storyRemote.fetchStoriesByCreator(
      creatorId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<StoryDataWrapper> fetchStoriesByEvent(int eventId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return await _storyRemote.fetchStoriesByEvent(
      eventId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<StoryDataWrapper> fetchStoriesByCharacter(int characterId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return await _storyRemote.fetchStoriesByCharacter(
      characterId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }
}
