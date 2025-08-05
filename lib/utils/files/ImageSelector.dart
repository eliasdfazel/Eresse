import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> selectImage() async {

  final ImagePicker imagePicker = ImagePicker();

  final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

  if (image != null) {

    return File(image.path);

  }

  return null;
}