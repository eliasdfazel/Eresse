import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<File?> copyImageInternal(File inputFile, String inputFileName) async {

  if (inputFile.existsSync()) {

    Directory documentsDirectory = await getApplicationSupportDirectory();

    String documentsPath = documentsDirectory.path;

    String fileExtension = p.extension(inputFile.path);

    String filePath = '$documentsPath/$inputFileName$fileExtension';

    File targetFile = File(filePath)
      ..writeAsBytesSync(inputFile.readAsBytesSync());

    return targetFile;

  }

  return null;

}