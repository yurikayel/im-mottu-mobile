import "package:im_mottu_mobile/index.dart";

/// A service for interacting with the Marvel API.
///
/// This service provides methods to fetch data from the Marvel API with support
/// for caching and logging. It includes methods to fetch characters, comics,
/// creators, events, series, and stories with various filtering options.
class MarvelService implements IMarvelService {
  final String publicApiKey = dotenv.env['PUBLIC_API_KEY']!;
  final String privateApiKey = dotenv.env['PRIVATE_API_KEY']!;
  final String baseUrl = 'https://gateway.marvel.com/v1/public/';
  late final Dio _dio;

  /// Cache options for the Dio instance.
  var cacheOptions = CacheOptions(
    maxStale: const Duration(hours: 1),
    policy: CachePolicy.request,
    priority: CachePriority.normal,
    hitCacheOnErrorExcept: const [],
    store: MemCacheStore(),
  );

  /// Constructs a [MarvelService] instance.
  MarvelService() {
    _dio = Dio();

    // Add cache interceptor to Dio instance
    _dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    // Add logger interceptor for debugging
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      ),
    );
  }

  @override
  String generateHash(String timestamp) {
    final message = '$timestamp$privateApiKey$publicApiKey';
    final bytes = utf8.encode(message);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// Fetches data from the Marvel API with caching support.
  ///
  /// [endpoint] is the API endpoint to fetch data from.
  /// [queryParameters] are the parameters to include in the request.
  /// [fromJson] is a function to parse the JSON response.
  ///
  /// Returns the parsed data of type [T].
  /// Fetch data from the Marvel API with caching support.
  ///
  /// [endpoint] is the API endpoint to fetch data from.
  /// [queryParameters] are the parameters to include in the request.
  /// [fromJson] is a function to parse the JSON response.
  Future<T> _fetchData<T>(
      String endpoint,
      Map<String, dynamic> queryParameters,
      T Function(Map<String, dynamic>) fromJson,
      ) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final hash = generateHash(timestamp.toString());
    queryParameters['ts'] = timestamp;
    queryParameters['apikey'] = publicApiKey;
    queryParameters['hash'] = hash;

    try {
      final response = await _dio.get(
        '$baseUrl$endpoint',
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.json,
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
          },
        )..copyWith(
          extra: cacheOptions.toExtra(),
        ),
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception('Connection Timeout: $e');
        case DioExceptionType.sendTimeout:
          throw Exception('Send Timeout: $e');
        case DioExceptionType.receiveTimeout:
          throw Exception('Receive Timeout: $e');
        case DioExceptionType.cancel:
          throw Exception('Request Cancelled: $e');
        default:
          throw Exception('Unknown Dio Error: $e');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }


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
    int? limit,
    int? offset,
  }) async {
    final queryParameters = <String, dynamic>{
      if (name != null && name.isNotEmpty) 'name': name,
      if (nameStartsWith != null && nameStartsWith.isNotEmpty) 'nameStartsWith': nameStartsWith,
      if (modifiedSince != null) 'modifiedSince': modifiedSince.toIso8601String(),
      if (comics != null && comics.isNotEmpty) 'comics': comics.where((id) => id > 0).join(','),
      if (series != null && series.isNotEmpty) 'series': series.where((id) => id > 0).join(','),
      if (events != null && events.isNotEmpty) 'events': events.where((id) => id > 0).join(','),
      if (stories != null && stories.isNotEmpty) 'stories': stories.where((id) => id > 0).join(','),
      if (orderBy != null && ['name', '-name', 'modified', '-modified'].contains(orderBy)) 'orderBy': orderBy,
      if (limit != null && limit > 0 && limit <= 100) 'limit': limit,
      if (offset != null) 'offset': offset,
    };

    return _fetchData(
      'characters',
      queryParameters,
          (json) => CharacterDataWrapper.fromJson(json),
    );
  }

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
    final queryParameters = <String, dynamic>{
      if (title != null && title.isNotEmpty) 'title': title,
      if (titleStartsWith != null && titleStartsWith.isNotEmpty) 'titleStartsWith': titleStartsWith,
      if (modifiedSince != null) 'modifiedSince': modifiedSince.toIso8601String(),
      if (format != null && format.isNotEmpty) 'format': format.where((id) => id > 0).join(','),
      if (formatType != null && formatType.isNotEmpty) 'formatType': formatType.where((id) => id > 0).join(','),
      if (noVariants != null) 'noVariants': noVariants,
      if (dateDescriptor != null && dateDescriptor.isNotEmpty) 'dateDescriptor': dateDescriptor.where((id) => id > 0).join(','),
      if (dateRangeStart != null) 'dateRangeStart': dateRangeStart.toIso8601String(),
      if (dateRangeEnd != null) 'dateRangeEnd': dateRangeEnd.toIso8601String(),
      if (hasDigitalIssue != null) 'hasDigitalIssue': hasDigitalIssue,
      if (characters != null && characters.isNotEmpty) 'characters': characters.where((id) => id > 0).join(','),
      if (series != null && series.isNotEmpty) 'series': series.where((id) => id > 0).join(','),
      if (events != null && events.isNotEmpty) 'events': events.where((id) => id > 0).join(','),
      if (creators != null && creators.isNotEmpty) 'creators': creators.where((id) => id > 0).join(','),
      if (stories != null && stories.isNotEmpty) 'stories': stories.where((id) => id > 0).join(','),
      if (orderBy != null && ['name', '-name', 'modified', '-modified'].contains(orderBy)) 'orderBy': orderBy,
      if (limit != null && limit > 0 && limit <= 100) 'limit': limit,
      if (offset != null) 'offset': offset,
    };

    return _fetchData(
      'comics',
      queryParameters,
          (json) => ComicDataWrapper.fromJson(json),
    );
  }

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
  }) async {
    final queryParameters = <String, dynamic>{
      if (firstName != null && firstName.isNotEmpty) 'firstName': firstName,
      if (middleName != null && middleName.isNotEmpty) 'middleName': middleName,
      if (lastName != null && lastName.isNotEmpty) 'lastName': lastName,
      if (suffix != null && suffix.isNotEmpty) 'suffix': suffix,
      if (modifiedSince != null) 'modifiedSince': modifiedSince.toIso8601String(),
      if (comics != null && comics.isNotEmpty) 'comics': comics.where((id) => id > 0).join(','),
      if (series != null && series.isNotEmpty) 'series': series.where((id) => id > 0).join(','),
      if (events != null && events.isNotEmpty) 'events': events.where((id) => id > 0).join(','),
      if (stories != null && stories.isNotEmpty) 'stories': stories.where((id) => id > 0).join(','),
      if (orderBy != null && ['name', '-name', 'modified', '-modified'].contains(orderBy)) 'orderBy': orderBy,
      if (limit != null && limit > 0 && limit <= 100) 'limit': limit,
      if (offset != null) 'offset': offset,
    };

    return _fetchData(
      'creators',
      queryParameters,
          (json) => CreatorDataWrapper.fromJson(json),
    );
  }

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
    final queryParameters = <String, dynamic>{
      if (name != null && name.isNotEmpty) 'name': name,
      if (nameStartsWith != null && nameStartsWith.isNotEmpty) 'nameStartsWith': nameStartsWith,
      if (modifiedSince != null) 'modifiedSince': modifiedSince.toIso8601String(),
      if (creators != null && creators.isNotEmpty) 'creators': creators.where((id) => id > 0).join(','),
      if (characters != null && characters.isNotEmpty) 'characters': characters.where((id) => id > 0).join(','),
      if (comics != null && comics.isNotEmpty) 'comics': comics.where((id) => id > 0).join(','),
      if (series != null && series.isNotEmpty) 'series': series.where((id) => id > 0).join(','),
      if (stories != null && stories.isNotEmpty) 'stories': stories.where((id) => id > 0).join(','),
      if (orderBy != null && ['name', '-name', 'modified', '-modified'].contains(orderBy)) 'orderBy': orderBy,
      if (limit != null && limit > 0 && limit <= 100) 'limit': limit,
      if (offset != null) 'offset': offset,
    };

    return _fetchData(
      'events',
      queryParameters,
          (json) => EventDataWrapper.fromJson(json),
    );
  }

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
    final queryParameters = <String, dynamic>{
      if (title != null && title.isNotEmpty) 'title': title,
      if (titleStartsWith != null && titleStartsWith.isNotEmpty) 'titleStartsWith': titleStartsWith,
      if (modifiedSince != null) 'modifiedSince': modifiedSince.toIso8601String(),
      if (comics != null && comics.isNotEmpty) 'comics': comics.where((id) => id > 0).join(','),
      if (stories != null && stories.isNotEmpty) 'stories': stories.where((id) => id > 0).join(','),
      if (events != null && events.isNotEmpty) 'events': events.where((id) => id > 0).join(','),
      if (creators != null && creators.isNotEmpty) 'creators': creators.where((id) => id > 0).join(','),
      if (characters != null && characters.isNotEmpty) 'characters': characters.where((id) => id > 0).join(','),
      if (seriesType != null && ['collection', 'limited', 'one-shot'].contains(seriesType)) 'seriesType': seriesType,
      if (contains != null && contains.isNotEmpty) 'contains': contains,
      if (orderBy != null && ['title', '-title', 'modified', '-modified'].contains(orderBy)) 'orderBy': orderBy,
      if (limit != null && limit > 0 && limit <= 100) 'limit': limit,
      if (offset != null) 'offset': offset,
    };

    return _fetchData(
      'series',
      queryParameters,
          (json) => SeriesDataWrapper.fromJson(json),
    );
  }

  @override
  Future<StoryDataWrapper> fetchStories({
    DateTime? modifiedSince,
    List<int>? comics,
    List<int>? series,
    List<int>? events,
    List<int>? creators,
    List<int>? characters,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final queryParameters = <String, dynamic>{
      if (modifiedSince != null) 'modifiedSince': modifiedSince.toIso8601String(),
      if (comics != null && comics.isNotEmpty) 'comics': comics.where((id) => id > 0).join(','),
      if (series != null && series.isNotEmpty) 'series': series.where((id) => id > 0).join(','),
      if (events != null && events.isNotEmpty) 'events': events.where((id) => id > 0).join(','),
      if (creators != null && creators.isNotEmpty) 'creators': creators.where((id) => id > 0).join(','),
      if (characters != null && characters.isNotEmpty) 'characters': characters.where((id) => id > 0).join(','),
      if (orderBy != null && ['title', '-title', 'modified', '-modified'].contains(orderBy)) 'orderBy': orderBy,
      if (limit != null && limit > 0 && limit <= 100) 'limit': limit,
      if (offset != null) 'offset': offset,
    };

    return _fetchData(
      'stories',
      queryParameters,
          (json) => StoryDataWrapper.fromJson(json),
    );
  }
}
