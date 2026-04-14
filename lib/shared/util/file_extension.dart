import 'dart:convert';
import 'dart:io';

extension FileExtension on File {
  String readAsBase64() {
    final bytes = readAsBytesSync();
    return base64.encode(bytes);
  }
}
