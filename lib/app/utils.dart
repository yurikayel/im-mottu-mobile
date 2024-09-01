import 'package:im_mottu_mobile/index.dart';

String generateHash(String timestamp, String privateKey, String publicKey) {
  final String input = '$timestamp$privateKey$publicKey';
  final bytes = utf8.encode(input);
  final digest = md5.convert(bytes);
  return digest.toString();
}
