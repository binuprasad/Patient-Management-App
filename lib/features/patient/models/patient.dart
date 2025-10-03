class Patient {
  final String id;
  final String name;
  final String? phone;
  final String? package;
  final String? date;
  final String? createdBy;

  const Patient({
    required this.id,
    required this.name,
    this.phone,
    this.package,
    this.date,
    this.createdBy,
  });

  factory Patient.fromMap(Map<String, dynamic> map) {
    String mapString(dynamic v) => v?.toString() ?? '';
    String? extractPackage(dynamic raw) {
      try {
        if (raw is List) {
          final names = raw
              .map(
                (e) => (e is Map<String, dynamic>)
                    ? (e['treatment_name']?.toString() ?? '')
                    : '',
              )
              .where((s) => s.isNotEmpty)
              .toList();
          if (names.isNotEmpty) return names.join(', ');
        }
      } catch (_) {}
      return null;
    }

    return Patient(
      id: mapString(map['id'] ?? map['patient_id'] ?? map['uid'] ?? ''),
      name: mapString(
        map['name'] ?? map['patient_name'] ?? map['full_name'] ?? 'Unknown',
      ),
      phone: (map['phone'] ?? map['mobile'] ?? map['contact'])?.toString(),
      package:
          (map['package'] ?? map['treatment'] ?? map['plan'])?.toString() ??
          extractPackage(map['patientdetails_set']),
      date:
          (map['date_nd_time'] ??
                  map['date'] ??
                  map['created_at'] ??
                  map['booking_date'])
              ?.toString(),
      createdBy: (map['user'] ?? map['by'] ?? map['created_by'] ?? map['staff'])
          ?.toString(),
    );
  }
}
