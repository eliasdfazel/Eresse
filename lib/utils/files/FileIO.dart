import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<File?> copyImageInternal(File inputFile, String inputFileName) async {

  if (inputFile.existsSync()) {

    Directory documentsDirectory = await getApplicationSupportDirectory();

    String documentsPath = documentsDirectory.path;

    String filePath = '$documentsPath/$inputFileName';

    File targetFile = File(filePath)
      ..writeAsBytesSync(inputFile.readAsBytesSync());

    return targetFile;

  }

  return null;

}

Future<File> createImageInternal(Uint8List imageBytes) async {

  Directory documentsDirectory = await getApplicationSupportDirectory();

  String documentsPath = documentsDirectory.path;

  File targetFile = File(documentsPath)
    ..writeAsBytesSync(imageBytes);

  return targetFile;

}

Future<File?> prepareImageFile(String dialogueId) async {

  Directory documentsDirectory = await getApplicationSupportDirectory();

  String documentsPath = documentsDirectory.path;

  String filePath = '$documentsPath/$dialogueId';

  File imageFile = File(filePath);

  if (imageFile.existsSync()) {

    return File(filePath);

  }

  return null;
}