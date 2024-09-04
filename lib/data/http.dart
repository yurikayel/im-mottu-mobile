import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:im_mottu_mobile/index.dart' hide Response;

class DioCacheManager {
  final Dio _dio = Dio();
  final BaseCacheManager _cacheManager = DefaultCacheManager();

  Future<Response> getWithCache(
    String url, {
    Options? options,
    Duration cacheDuration = const Duration(hours: 1),
    bool forceRefresh = false,
  }) async {
    final fileInfo = await _cacheManager.getFileFromCache(url);

    if (fileInfo != null) {
      final now = DateTime.now();
      final cachedTime = fileInfo.validTill;

      if (forceRefresh || now.isAfter(cachedTime)) {
        // If cache is stale or force refresh is enabled, fetch new data
        return await _fetchAndCache(url, options);
      } else {
        // Return cached data if it’s still valid
        final cachedFile = fileInfo.file;
        final fileBytes = await cachedFile.readAsBytes();
        return Response(
          data: fileBytes,
          requestOptions: RequestOptions(path: url),
          statusCode: 200,
        );
      }
    } else {
      // If no cache exists, fetch and cache the data
      return await _fetchAndCache(url, options);
    }
  }

  Future<Response> _fetchAndCache(String url, Options? options) async {
    try {
      final response = await _dio.get<Uint8List>(url,
          options: options?.copyWith(responseType: ResponseType.bytes) ??
              Options(responseType: ResponseType.bytes));

      if (response.statusCode == 200) {
        await _cacheManager.putFile(url, response.data!,
            maxAge: const Duration(days: 7)); // Set cache expiry duration
      }
      return response;
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        statusCode: 500,
        statusMessage: "Failed to fetch data",
      );
    }
  }
}

String generateHash(String timestamp, String privateKey, String publicKey) {
  final String input = '$timestamp$privateKey$publicKey';
  final bytes = utf8.encode(input);
  final digest = md5.convert(bytes);
  return digest.toString();
}

Dio createDio() {
  final dio = Dio();

  dio.interceptors.add(_createPrettyDioLogger());
  dio.interceptors.add(_createDioCacheInterceptor());

  return dio;
}

PrettyDioLogger _createPrettyDioLogger() {
  return PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
    compact: true,
  );
}

DioCacheInterceptor _createDioCacheInterceptor() {
  return DioCacheInterceptor(
    options: CacheOptions(
      store: MemCacheStore(),
      maxStale: const Duration(hours: 1),
    ),
  );
}
