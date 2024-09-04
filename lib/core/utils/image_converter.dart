import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

ImageProvider base64ToImageProvider(String base64String) {
  final bytes = base64Decode(base64String);
  return MemoryImage(Uint8List.fromList(bytes));
}

String imageToBase64Provider(String imagePath) {
  final bytes = File(imagePath).readAsBytesSync();
  return base64Encode(bytes);
}
