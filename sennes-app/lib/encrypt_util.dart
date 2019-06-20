import 'package:pointycastle/stream/salsa20.dart';
import 'package:pointycastle/api.dart' show ParametersWithIV, KeyParameter;
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

String encrypt(String msg, String key) {
  final keyBytes = utf8.encode(key);

  final body = utf8.encode(msg);
  final rng = Random();
  final Uint8List iv = Uint8List(8);
  for (var i = 0; i < 8; i++) {
    iv[i] = rng.nextInt(255);
  }
  
  final cipher = Salsa20Engine();
  final params = ParametersWithIV<KeyParameter>(KeyParameter(keyBytes), iv);

  cipher
    ..reset()
    ..init(true, params);

  final encrypted = cipher.process(body);
  final bytes = List<int>.from(iv)..addAll(encrypted);

  return base64.encode(bytes);
}

String decrypt(String msg, String key) {
  final keyBytes = utf8.encode(key);

  final bytes = base64.decode(msg);
  final iv = bytes.sublist(0, 8);
  final body = bytes.sublist(8);
  
  final cipher = Salsa20Engine();
  final params = ParametersWithIV<KeyParameter>(KeyParameter(keyBytes), iv);

  cipher
    ..reset()
    ..init(false, params);

  final encrypted = cipher.process(body);
  return utf8.decode(encrypted);
}
