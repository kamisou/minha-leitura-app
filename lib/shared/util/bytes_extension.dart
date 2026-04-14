import 'dart:typed_data';

import 'package:flutter/material.dart';

extension BytesExtension on Uint8List {
  MemoryImage toImage() => MemoryImage(this);
}
