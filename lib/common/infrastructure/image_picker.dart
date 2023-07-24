import 'dart:io';

import 'package:image_picker/image_picker.dart' as picker;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_picker.g.dart';

@riverpod
ImagePicker imagePicker(ImagePickerRef ref) {
  return ImagePicker();
}

class ImagePicker {
  Future<File?> pickImage() async {
    final imagePicker = picker.ImagePicker();
    final image =
        await imagePicker.pickImage(source: picker.ImageSource.gallery);

    if (image == null) {
      return null;
    }

    return File(image.path);
  }
}
