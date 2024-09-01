import 'package:im_mottu_mobile/index.dart';

class ComicRepository implements IComicRepository {
  final IComicRemote _comicRemote;
  final String _publicApiKey;
  final String _privateApiKey;

  ComicRepository({
    required IComicRemote comicRemote,
    required String publicApiKey,
    required String privateApiKey,
  })  : _comicRemote = comicRemote,
        _publicApiKey = publicApiKey,
        _privateApiKey = privateApiKey;

  @override
  Future<ComicDataWrapper> fetchComics({
    String? title,
    String? titleStartsWith,
    String? series,
    String? events,
    String? characters,
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return _comicRemote.fetchComics(
      title: title,
      titleStartsWith: titleStartsWith,
      series: series,
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
  Future<ComicDataWrapper> fetchComicById(int comicId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return _comicRemote.fetchComicById(
      comicId: comicId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<ComicDataWrapper> fetchComicsByCharacter(int characterId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return _comicRemote.fetchComicsByCharacter(
      characterId: characterId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<ComicDataWrapper> fetchComicsBySeries(int seriesId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return _comicRemote.fetchComicsBySeries(
      seriesId: seriesId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<ComicDataWrapper> fetchComicsByEvent(int eventId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = generateHash(timestamp, _privateApiKey, _publicApiKey);

    return _comicRemote.fetchComicsByEvent(
      eventId: eventId,
      timestamp: timestamp,
      apiKey: _publicApiKey,
      hash: hash,
    );
  }
}
