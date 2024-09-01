import 'package:dio/dio.dart';
import 'package:im_mottu_mobile/index.dart';

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
