import 'package:im_mottu_mobile/index.dart';

/// A repository for interacting with the Marvel API.
///
/// This repository provides methods to fetch data from the Marvel API with support
/// for caching and logging. It includes methods to fetch characters, comics,
/// creators, events, series, and stories with various filtering options.
class MarvelRepository implements IMarvelRepository {
  final String publicApiKey;
  final String privateApiKey;
  final IMarvelRemote _marvelRemote;

  /// Creates an instance of [MarvelRepository].
  ///
  /// The [publicApiKey] and [privateApiKey] are used for API authentication,
  /// and the [marvelRemote] is used for making HTTP requests to the Marvel API.
  MarvelRepository({
    required this.publicApiKey,
    required this.privateApiKey,
    required IMarvelRemote marvelRemote,
  }) : _marvelRemote = marvelRemote;

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

  /// Fetches comics from the Marvel API.
  @override
  Future<ComicDataWrapper> fetchComics({
    String? title,
    String? titleStartsWith,
    DateTime? modifiedSince,
    List<int>? format,
    List<int>? formatType,
    bool? noVariants,
    List<int>? dateDescriptor,
    DateTime? dateRangeStart,
    DateTime? dateRangeEnd,
    bool? hasDigitalIssue,
    List<int>? characters,
    List<int>? series,
    List<int>? events,
    List<int>? creators,
    List<int>? stories,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final hash = generateHash(timestamp.toString());

    final response = await _marvelRemote.fetchComics(
      title: title,
      titleStartsWith: titleStartsWith,
      modifiedSince: modifiedSince?.toIso8601String(),
      format: format?.where((id) => id > 0).join(','),
      formatType: formatType?.where((id) => id > 0).join(','),
      noVariants: noVariants,
      dateDescriptor: dateDescriptor?.where((id) => id > 0).join(','),
      dateRangeStart: dateRangeStart?.toIso8601String(),
      dateRangeEnd: dateRangeEnd?.toIso8601String(),
      hasDigitalIssue: hasDigitalIssue,
      characters: characters?.where((id) => id > 0).join(','),
      series: series?.where((id) => id > 0).join(','),
      events: events?.where((id) => id > 0).join(','),
      creators: creators?.where((id) => id > 0).join(','),
      stories: stories?.where((id) => id > 0).join(','),
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      timestamp: timestamp.toString(),
      apiKey: publicApiKey,
      hash: hash,
    );

    return response;
  }

  /// Fetches creators from the Marvel API.
  @override
  Future<CreatorDataWrapper> fetchCreators({
    String? firstName,
    String? middleName,
    String? lastName,
    String? suffix,
    DateTime? modifiedSince,
    List<int>? comics,
    List<int>? series,
    List<int>? events,
    List<int>? stories,
    String? orderBy,
    int? limit,
    int? offset,
    String? nameStartsWith,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final hash = generateHash(timestamp.toString());

    final response = await _marvelRemote.fetchCreators(
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      suffix: suffix,
      modifiedSince: modifiedSince?.toIso8601String(),
      comics: comics?.where((id) => id > 0).join(','),
      series: series?.where((id) => id > 0).join(','),
      events: events?.where((id) => id > 0).join(','),
      stories: stories?.where((id) => id > 0).join(','),
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      nameStartsWith: nameStartsWith,
      timestamp: timestamp.toString(),
      apiKey: publicApiKey,
      hash: hash,
    );

    return response;
  }

  /// Fetches events from the Marvel API.
  @override
  Future<EventDataWrapper> fetchEvents({
    String? name,
    String? nameStartsWith,
    DateTime? modifiedSince,
    List<int>? creators,
    List<int>? characters,
    List<int>? comics,
    List<int>? series,
    List<int>? stories,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final hash = generateHash(timestamp.toString());

    final response = await _marvelRemote.fetchEvents(
      name: name,
      nameStartsWith: nameStartsWith,
      modifiedSince: modifiedSince?.toIso8601String(),
      creators: creators?.where((id) => id > 0).join(','),
      characters: characters?.where((id) => id > 0).join(','),
      comics: comics?.where((id) => id > 0).join(','),
      series: series?.where((id) => id > 0).join(','),
      stories: stories?.where((id) => id > 0).join(','),
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      timestamp: timestamp.toString(),
      apiKey: publicApiKey,
      hash: hash,
    );

    return response;
  }

  /// Fetches series from the Marvel API.
  @override
  Future<SeriesDataWrapper> fetchSeries({
    String? title,
    String? titleStartsWith,
    DateTime? modifiedSince,
    List<int>? comics,
    List<int>? stories,
    List<int>? events,
    List<int>? creators,
    List<int>? characters,
    String? seriesType,
    String? contains,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final hash = generateHash(timestamp.toString());

    final response = await _marvelRemote.fetchSeries(
      title: title,
      titleStartsWith: titleStartsWith,
      modifiedSince: modifiedSince?.toIso8601String(),
      comics: comics?.where((id) => id > 0).join(','),
      stories: stories?.where((id) => id > 0).join(','),
      events: events?.where((id) => id > 0).join(','),
      creators: creators?.where((id) => id > 0).join(','),
      characters: characters?.where((id) => id > 0).join(','),
      seriesType: seriesType,
      contains: contains,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      timestamp: timestamp.toString(),
      apiKey: publicApiKey,
      hash: hash,
    );

    return response;
  }

  /// Fetches stories from the Marvel API.
  @override
  Future<StoryDataWrapper> fetchStories({
    DateTime? modifiedSince,
    List<int>? comics,
    List<int>? series,
    List<int>? events,
    List<int>? characters,
    List<int>? creators,
    String? titleStartsWith,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final hash = generateHash(timestamp.toString());

    final response = await _marvelRemote.fetchStories(
      modifiedSince: modifiedSince?.toIso8601String(),
      comics: comics?.where((id) => id > 0).join(','),
      series: series?.where((id) => id > 0).join(','),
      events: events?.where((id) => id > 0).join(','),
      characters: characters?.where((id) => id > 0).join(','),
      creators: creators?.where((id) => id > 0).join(','),
      titleStartsWith: titleStartsWith,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      timestamp: timestamp.toString(),
      apiKey: publicApiKey,
      hash: hash,
    );

    return response;
  }
}
