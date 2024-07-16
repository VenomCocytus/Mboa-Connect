import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureCubit extends Cubit<File?> {
  final _imagePicker = ImagePicker();

  ProfilePictureCubit() : super(null);

  Future<void> getImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      emit(File(pickedFile.path));
    } else {
      emit(null);
    }
  }
}