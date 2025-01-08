import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

String formatDate(DateTime date) {
  return _dateFormat.format(date.toLocal());
}

Future<T> catchError<T>(Function() fn) async {
  try {
    return await fn();
  } catch (exception) {
    return Future.error(StateError("Lỗi không tải được dữ liệu: $exception"));
  }
}

final Dio _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] as String));

Dio getApi() => _dio;

const defaultImageLink =
    "https://stock.adobe.com/search/images?k=default+avatar";
