import 'package:flutter/foundation.dart';
import 'package:patientmanagementapp/features/patient/models/patient.dart';
import 'package:patientmanagementapp/features/patient/services/patient_service.dart';

class PatientProvider extends ChangeNotifier {
  final PatientService _service;
  PatientProvider({PatientService? service}) : _service = service ?? PatientService();

  String? _token;
  bool _loading = false;
  String? _error;
  List<Patient> _patients = const [];

  bool get loading => _loading;
  String? get error => _error;
  List<Patient> get patients => _patients;

  void updateAuthToken(String? token) {
    _token = token;
  }

  Future<void> fetchPatients() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _service.fetchPatients(token: _token);
      debugPrint('[PatientProvider] fetched patients: ${data.length}');
      _patients = data;
    } catch (e) {
      _error = e.toString();
      _patients = const [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchPatients();
  }
}
