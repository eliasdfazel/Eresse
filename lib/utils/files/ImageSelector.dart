import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> selectImage() async {

  final ImagePicker picker = ImagePicker();

  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {

    return File(image.path);

  }

  return null;
}