import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<File> copyAssetToTemporaryFile(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final tempDir = await getTemporaryDirectory();
  final tempFile = File(path.join(
      tempDir.path,
      path.basename(
          assetPath))); // Use basename to avoid creating unnecessary directories
  await tempFile.create(recursive: true);
  await tempFile.writeAsBytes(byteData.buffer.asUint8List());
  return tempFile;
}
