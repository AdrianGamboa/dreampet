import 'dart:async';
import 'dart:io';

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('dns.google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
