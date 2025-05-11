import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

imageUploadCamera() async {
  final file = await ImagePicker().pickImage(
    source: ImageSource.camera,
    imageQuality: 90,
  );
  if (file != null) {
    print("Image Path: ${file.path}");
    return File(file.path);
  } else {
    print("No image selected.");
    return null;
  }
}

Future<File?> fileUploadGallery([bool isSvg = false]) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions:
          isSvg ? ['svg', 'SVG'] : ['jpg', 'jpeg', 'png', 'gif', 'webp'],
    );

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      print("No file selected.");
      return null;
    }
  } catch (e) {
    print("Error picking file: $e");
    return null;
  }
}
