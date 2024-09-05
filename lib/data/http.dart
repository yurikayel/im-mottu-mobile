import 'package:im_mottu_mobile/index.dart' hide Response;

/// Generates the required hash for Marvel API authentication.
String generateHash(String timestamp, String privateKey, String publicKey) {
  final input = '$timestamp$privateKey$publicKey';
  final bytes = utf8.encode(input);
  final digest = md5.convert(bytes);
  return digest.toString();
}