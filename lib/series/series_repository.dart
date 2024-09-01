import 'package:im_mottu_mobile/index.dart';

class SeriesRepository implements ISeriesRepository {
  final ISeriesRemote _seriesRemote;
  final String _publicApiKey;
  final String _privateApiKey;

  SeriesRepository({
    required String publicApiKey,
    required String privateApiKey,
    required ISeriesRemote seriesRemote,
  })  : _publicApiKey = publicApiKey,
        _privateApiKey = privateApiKey,
        _seriesRemote = seriesRemote;

  @override
  Future<SeriesDataWrapper> fetchSeries({
    String? title,
    String? titleStartsWith,
    String? comics,
    String? events,
    String? creators,
    String? stories,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return await _seriesRemote.fetchSeries(
      title: title,
      titleStartsWith: titleStartsWith,
      comics: comics,
      events: events,
      creators: creators,
      stories: stories,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<SeriesDataWrapper> fetchSeriesById(int seriesId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return await _seriesRemote.fetchSeriesById(
      seriesId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<SeriesDataWrapper> fetchSeriesByComic(int comicId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return await _seriesRemote.fetchSeriesByComic(
      comicId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<SeriesDataWrapper> fetchSeriesByEvent(int eventId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return await _seriesRemote.fetchSeriesByEvent(
      eventId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<SeriesDataWrapper> fetchSeriesByCreator(int creatorId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return await _seriesRemote.fetchSeriesByCreator(
      creatorId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<SeriesDataWrapper> fetchSeriesByStory(int storyId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return await _seriesRemote.fetchSeriesByStory(
      storyId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }
}
