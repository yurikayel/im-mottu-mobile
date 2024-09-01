import 'package:im_mottu_mobile/index.dart';

class EventRepository implements IEventRepository {
  final String publicApiKey;
  final String privateApiKey;
  final IEventRemote eventRemote;

  EventRepository({
    required this.publicApiKey,
    required this.privateApiKey,
    required this.eventRemote,
  });

  @override
  Future<EventDataWrapper> fetchEvents({
    String? name,
    String? nameStartsWith,
    String? comics,
    String? series,
    String? creators,
    String? stories,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final timestamp = DateTime.now().toIso8601String();
    final hash = generateHash(timestamp, privateApiKey, publicApiKey);

    return await eventRemote.fetchEvents(
      name: name,
      nameStartsWith: nameStartsWith,
      comics: comics,
      series: series,
      creators: creators,
      stories: stories,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      timestamp: timestamp,
      apiKey: publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<EventDataWrapper> fetchEventById(int eventId) async {
    final timestamp = DateTime.now().toIso8601String();
    final hash = generateHash(timestamp, privateApiKey, publicApiKey);

    return await eventRemote.fetchEventById(
      eventId,
      timestamp: timestamp,
      apiKey: publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<EventDataWrapper> fetchEventsByComic(int comicId) async {
    final timestamp = DateTime.now().toIso8601String();
    final hash = generateHash(timestamp, privateApiKey, publicApiKey);

    return await eventRemote.fetchEventsByComic(
      comicId,
      timestamp: timestamp,
      apiKey: publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<EventDataWrapper> fetchEventsByCreator(int creatorId) async {
    final timestamp = DateTime.now().toIso8601String();
    final hash = generateHash(timestamp, privateApiKey, publicApiKey);

    return await eventRemote.fetchEventsByCreator(
      creatorId,
      timestamp: timestamp,
      apiKey: publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<EventDataWrapper> fetchEventsBySeries(int seriesId) async {
    final timestamp = DateTime.now().toIso8601String();
    final hash = generateHash(timestamp, privateApiKey, publicApiKey);

    return await eventRemote.fetchEventsBySeries(
      seriesId,
      timestamp: timestamp,
      apiKey: publicApiKey,
      hash: hash,
    );
  }

  @override
  Future<EventDataWrapper> fetchEventsByStory(int storyId) async {
    final timestamp = DateTime.now().toIso8601String();
    final hash = generateHash(timestamp, privateApiKey, publicApiKey);

    return await eventRemote.fetchEventsByStory(
      storyId,
      timestamp: timestamp,
      apiKey: publicApiKey,
      hash: hash,
    );
  }
}
