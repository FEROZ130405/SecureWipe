import 'dart:convert';

import '../state/wipe_provider.dart';

class WipeCertificate {
  final OperatingSystemType os;
  final String diskName;
  final String diskPath;
  final DiskType diskType;
  final String method;
  final DateTime timestamp;
  final String status;

  WipeCertificate({
    required this.os,
    required this.diskName,
    required this.diskPath,
    required this.diskType,
    required this.method,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
    'os': os.name,
    'diskName': diskName,
    'diskPath': diskPath,
    'diskType': diskType.name,
    'method': method,
    'timestamp': timestamp.toIso8601String(),
    'status': status,
  };

  String toJson({bool pretty = true}) {
    final encoder = pretty ? const JsonEncoder.withIndent('  ') : const JsonEncoder();
    return encoder.convert(toMap());
  }
}
