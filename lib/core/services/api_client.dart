import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 20), receiveTimeout: const Duration(seconds: 20)));

  static const String baseUrl = 'https://flutter-amr.noviindus.in/api/';
  final Dio _dio;

  Dio get client => _dio;

  Future<Response<dynamic>> postFormData(
    String path, {
    required Map<String, dynamic> fields,
    Map<String, String>? headers,
  }) async {
    final form = FormData.fromMap(fields);
    return _dio.post(
      path,
      data: form,
      options: Options(headers: headers),
    );
  }
}
