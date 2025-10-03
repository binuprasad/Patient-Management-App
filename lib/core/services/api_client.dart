import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 60),
                sendTimeout: const Duration(seconds: 30),
                validateStatus: (status) => true, // handle errors manually
              ),
            );

  static const String baseUrl = 'https://flutter-amr.noviindus.in/api/';
  final Dio _dio;

  Dio get client => _dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    return _dio.get(
      path,
      queryParameters: query,
      options: Options(headers: headers),
    );
  }

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
