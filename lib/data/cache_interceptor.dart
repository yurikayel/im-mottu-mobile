import 'package:dio/dio.dart';
import 'package:im_mottu_mobile/index.dart' hide Response;

/// Interceptor for caching HTTP responses using SharedPreferences.
/// It filters out dynamic query parameters such as `ts`, `apikey`, and `hash`
/// to generate stable cache keys for consistent caching.
class CacheInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final filteredUri = _filterUri(options.uri);
    final cacheKey = filteredUri.toString();

    final cachedResponse = await _getCachedResponse(cacheKey);
    if (cachedResponse != null) {
      kDebugMode
          ? print('CacheInterceptor - Cache hit for key: $cacheKey')
          : null;
      return handler.resolve(cachedResponse);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final filteredUri = _filterUri(response.requestOptions.uri);
    final cacheKey = filteredUri.toString();

    await _saveResponseToCache(cacheKey, response);
    handler.next(response);
  }

  /// Filters out dynamic query parameters (`ts`, `apikey`, `hash`) from the URI.
  /// This is done to generate a stable cache key.
  Uri _filterUri(Uri uri) {
    final newQueryParameters = Map.of(uri.queryParameters)
      ..remove('ts')
      ..remove('apikey')
      ..remove('hash');
    return uri.replace(queryParameters: newQueryParameters);
  }

  /// Retrieves a cached response from SharedPreferences, if available.
  ///
  /// [cacheKey] is the key used to look up the cached response.
  /// Returns a [Response] object if found, otherwise null.
  Future<Response?> _getCachedResponse(String cacheKey) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(cacheKey);

    if (cachedData != null) {
      final Map<String, dynamic> jsonResponse = json.decode(cachedData);
      final cacheItem = _CacheItem.fromJson(jsonResponse);

      return Response(
        requestOptions: RequestOptions(path: cacheKey),
        data: cacheItem.data,
        statusCode: cacheItem.statusCode,
        statusMessage: cacheItem.statusMessage,
        headers: Headers.fromMap(cacheItem.headers),
      );
    }
  }

  /// Saves the HTTP response to the cache using SharedPreferences.
  ///
  /// [cacheKey] is the key under which the response is cached.
  /// [response] is the HTTP response to be cached.
  Future<void> _saveResponseToCache(String cacheKey, Response response) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheItem = _CacheItem(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      headers: response.headers.map,
    );

    final cachedData = json.encode(cacheItem.toJson());
    await prefs.setString(cacheKey, cachedData);
    kDebugMode
        ? print('CacheInterceptor - Response cached for key: $cacheKey')
        : null;
  }
}

/// Represents a cached HTTP response.
class _CacheItem {
  final dynamic data;
  final int? statusCode;
  final String? statusMessage;
  final Map<String, List<String>> headers;

  _CacheItem({
    required this.data,
    required this.statusCode,
    required this.statusMessage,
    required this.headers,
  });

  /// Converts the [CacheItem] to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'headers': headers,
    };
  }

  /// Creates a [CacheItem] from a JSON map.
  static _CacheItem fromJson(Map<String, dynamic> json) {
    return _CacheItem(
      data: json['data'],
      statusCode: json['statusCode'],
      statusMessage: json['statusMessage'],
      headers: (json['headers'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
    );
  }
}
