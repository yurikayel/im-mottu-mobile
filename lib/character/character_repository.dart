import 'package:im_mottu_mobile/index.dart';

/// A repository for interacting with character-related endpoints of the Marvel API.
///
/// This repository provides methods to fetch character data with various filtering options.
class CharacterRepository implements ICharacterRepository {
  final String publicApiKey;
  final String privateApiKey;
  final ICharacterRemote _marvelRemote;

  /// Creates an instance of [CharacterRepository].
  ///
  /// The [publicApiKey] and [privateApiKey] are used for API authentication,
  /// and the [marvelRemote] is used for making HTTP requests to the Marvel API.
  CharacterRepository({
    required this.publicApiKey,
    required this.privateApiKey,
    required ICharacterRemote characterRemote,
  }) : _marvelRemote = characterRemote;

  @override
  String generateHash(String timestamp) {
    final message = '$timestamp$privateApiKey$publicApiKey';
    final bytes = utf8.encode(message);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// Fetches characters from the Marvel API.
  @override
  Future<CharacterDataWrapper> fetchCharacters({
    String? name,
    String? nameStartsWith,
    DateTime? modifiedSince,
    List<int>? comics,
    List<int>? series,
    List<int>? events,
    List<int>? stories,
    String? orderBy,
    int? limit = 20,
    int? offset = 0,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final hash = generateHash(timestamp.toString());

    final response = await _marvelRemote.fetchCharacters(
      name: name,
      nameStartsWith: nameStartsWith,
      modifiedSince: modifiedSince?.toIso8601String(),
      comics: comics?.where((id) => id > 0).join(','),
      series: series?.where((id) => id > 0).join(','),
      events: events?.where((id) => id > 0).join(','),
      stories: stories?.where((id) => id > 0).join(','),
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      apiKey: publicApiKey,
      timestamp: timestamp.toString(),
      hash: hash,
    );

    return response;
  }

  /// Fetches a specific character by its ID.
  @override
  Future<CharacterDataWrapper> fetchCharacterById(int characterId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final hash = generateHash(timestamp.toString());

    final response = await _marvelRemote.fetchCharacterById(
      characterId: characterId,
      apiKey: publicApiKey,
      timestamp: timestamp.toString(),
      hash: hash,
    );

    return response;
  }

  /// Fetches a list of characters appearing in a specific comic.
  @override
  Future<CharacterDataWrapper> fetchCharactersInComic(int comicId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final hash = generateHash(timestamp.toString());

    final response = await _marvelRemote.fetchCharactersInComic(
      comicId: comicId,
      apiKey: publicApiKey,
      timestamp: timestamp.toString(),
      hash: hash,
    );

    return response;
  }

  /// Fetches a list of characters appearing in a specific series.
  @override
  Future<CharacterDataWrapper> fetchCharactersInSeries(int seriesId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final hash = generateHash(timestamp.toString());

    final response = await _marvelRemote.fetchCharactersInSeries(
      seriesId: seriesId,
      apiKey: publicApiKey,
      timestamp: timestamp.toString(),
      hash: hash,
    );

    return response;
  }

  /// Fetches a list of characters appearing in a specific event.
  @override
  Future<CharacterDataWrapper> fetchCharactersInEvent(int eventId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final hash = generateHash(timestamp.toString());

    final response = await _marvelRemote.fetchCharactersInEvent(
      eventId: eventId,
      apiKey: publicApiKey,
      timestamp: timestamp.toString(),
      hash: hash,
    );

    return response;
  }

  /// Fetches a list of characters appearing in a specific story.
  @override
  Future<CharacterDataWrapper> fetchCharactersInStory(int storyId) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final hash = generateHash(timestamp.toString());

    final response = await _marvelRemote.fetchCharactersInStory(
      storyId: storyId,
      apiKey: publicApiKey,
      timestamp: timestamp.toString(),
      hash: hash,
    );

    return response;
  }
}
