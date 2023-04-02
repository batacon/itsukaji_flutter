import 'dart:convert';
import 'dart:math';

const codeLength = 64;

class InvitationCode {
  static String generate() {
    final random = Random.secure();
    final values = List<int>.generate(codeLength, (final i) => random.nextInt(256));
    return base64Url.encode(values);
  }
}
