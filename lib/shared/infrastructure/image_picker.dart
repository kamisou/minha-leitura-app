import 'dart:io';

import 'package:image_picker/image_picker.dart' as picker;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_picker.g.dart';

@riverpod
ImagePicker imagePicker(ImagePickerRef ref) {
  return ImagePickerImpl();
}

class ImagePickerImpl with ImagePicker {
  @override
  Future<File?> pickImage({
    double? maxWidth,
    double? maxHeight,
    int? quality,
  }) async {
    final imagePicker = picker.ImagePicker();
    final image = await imagePicker.pickImage(
      source: picker.ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: quality,
    );

    if (image == null) {
      return null;
    }

    return File(image.path);
  }
}

mixin ImagePicker {
  Future<File?> pickImage({
    double? maxWidth,
    double? maxHeight,
    int? quality,
  });
}
