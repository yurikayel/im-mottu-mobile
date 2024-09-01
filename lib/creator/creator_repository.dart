import 'package:im_mottu_mobile/index.dart';

class CreatorRepository implements ICreatorRepository {
  final String publicApiKey;
  final String privateApiKey;
  final ICreatorRemote creatorRemote;

  CreatorRepository({
    required this.publicApiKey,
    required this.privateApiKey,
    required this.creatorRemote,
  });

  @override
  Future<CreatorDataWrapper> fetchCreators({
    String? name,
    String? nameStartsWith,
    String? comics,
    String? series,
    String? events,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final timestamp = DateTime.now().toIso8601String();
    final hash = generateHash(timestamp, privateApiKey, publicApiKey);

    return await creatorRemote.fetchCreators(
      name: name,
      nameStartsWith: nameStartsWith,
      comics: comics,
      series: series,
      events: events,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      timestamp: timestamp,
      apiKey: publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<CreatorDataWrapper> fetchCreatorById(int creatorId) async {
    final timestamp = DateTime.now().toIso8601String();
    final hash = generateHash(timestamp, privateApiKey, publicApiKey);

    return await creatorRemote.fetchCreatorById(
      creatorId: creatorId,
      timestamp: timestamp,
      apiKey: publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<CreatorDataWrapper> fetchCreatorsByComic(int comicId) async {
    final timestamp = DateTime.now().toIso8601String();
    final hash = generateHash(timestamp, privateApiKey, publicApiKey);

    return await creatorRemote.fetchCreatorsInComic(
      comicId: comicId,
      timestamp: timestamp,
      apiKey: publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<CreatorDataWrapper> fetchCreatorsBySeries(int seriesId) async {
    final timestamp = DateTime.now().toIso8601String();
    final hash = generateHash(timestamp, privateApiKey, publicApiKey);

    return await creatorRemote.fetchCreatorsInSeries(
      seriesId: seriesId,
      timestamp: timestamp,
      apiKey: publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<CreatorDataWrapper> fetchCreatorsByEvent(int eventId) async {
    final timestamp = DateTime.now().toIso8601String();
    final hash = generateHash(timestamp, privateApiKey, publicApiKey);

    return await creatorRemote.fetchCreatorsInEvent(
      eventId: eventId,
      timestamp: timestamp,
      apiKey: publicApiKey,
      hash: hash,
    );
  }
}
