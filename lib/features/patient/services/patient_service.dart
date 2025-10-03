import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:patientmanagementapp/core/services/api_client.dart';
import 'package:patientmanagementapp/features/patient/models/patient.dart';

class PatientService {
  final ApiClient _api;
  PatientService({ApiClient? api}) : _api = api ?? ApiClient();
  Future<List<Patient>> fetchPatients({String? token}) async {
    final headers = <String, String>{};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    Response resp;
    int attempt = 0;
    while (true) {
      try {
        resp = await _api.get(
          'PatientList',
          headers: headers.isEmpty ? null : headers,
        );
        break;
      } on DioException catch (e) {
        final isTimeout =
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout;
        if (isTimeout && attempt < 2) {
          attempt++;
          await Future.delayed(Duration(milliseconds: 400 * attempt));
          continue;
        }
        throw Exception('Network error: ${e.message ?? 'Request failed'}');
      }
    }

    try {
      final uri = resp.requestOptions.uri;
      final status = resp.statusCode;
      final pretty = (resp.data is String)
          ? resp.data as String
          : const JsonEncoder.withIndent('  ').convert(resp.data);
      debugPrint('[PatientList] GET $uri -> status: $status');
      debugPrint('[PatientList] Response:\n$pretty');
    } catch (_) {}

    final status = resp.statusCode ?? 0;
    if (status == 401) {
      throw Exception('Unauthorized (401). Please log in again.');
    }
    if (status < 200 || status >= 300) {
      String message = 'Request failed with status $status';
      final body = resp.data;
      if (body is Map<String, dynamic>) {
        message = (body['message'] ?? body['error'] ?? message).toString();
      }
      throw Exception(message);
    }

    final data = resp.data;
    List<dynamic> items;
    if (data is List) {
      items = data;
    } else if (data is Map<String, dynamic>) {
      items =
          (data['data'] ??
                  data['patients'] ??
                  data['list'] ??
                  data['results'] ??
                  [])
              as List<dynamic>;
      if (items.isEmpty) {
        for (final entry in data.entries) {
          final v = entry.value;
          if (v is List && v.isNotEmpty && v.first is Map) {
            items = v;
            break;
          }
        }
      }
    } else {
      items = const [];
    }

    final List<Patient> parsed = [];
    int skipped = 0;
    for (final e in items) {
      if (e is Map<String, dynamic>) {
        try {
          parsed.add(Patient.fromMap(e));
        } catch (_) {
          skipped++;
        }
      } else {
        skipped++;
      }
    }
    debugPrint(
      '[PatientService] parsed: ${parsed.length}, skipped: $skipped, total: ${items.length}',
    );
    return parsed;
  }
}
