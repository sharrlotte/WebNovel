import 'package:dio/dio.dart';
import 'package:frontend/utils.dart';
import 'package:image_picker/image_picker.dart';

class Api {
  static Future<String> uploadImage(XFile file) async {
    FormData data =
        FormData.fromMap({'image': await MultipartFile.fromFile(file.path)});

    return catchError(() => getApi()
        .post("/cloudinary", data: data)
        .then((result) => (result.data as Map<String, dynamic>)['url']));
  }
}
