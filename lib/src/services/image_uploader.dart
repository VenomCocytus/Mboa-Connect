import 'dart:io';

import 'package:http/http.dart';

class ImageUploader {
  final String _url;

  ImageUploader(this._url);

  Future<String?> uploadImage(File imageFile) async {
    final uploadRequest = MultipartRequest('POST', Uri.parse(_url));

    uploadRequest.files.add(
      await MultipartFile.fromPath('picture', imageFile.path)
    );

    final requestResult = await uploadRequest.send();

    if(requestResult.statusCode != 200) return null;

    final response = await Response.fromStream(requestResult);

    return Uri.parse(_url).origin + response.body;
  }
}