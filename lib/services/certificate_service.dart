import 'dart:convert';
import 'dart:io' show File;

import 'package:file_selector/file_selector.dart';

import '../models/certificate.dart';

class CertificateService {
  static Future<void> saveCertificate(WipeCertificate certificate) async {
    final String suggestedName = 'wipe_certificate_${certificate.os.name}_${certificate.timestamp.millisecondsSinceEpoch}.json';

    final FileSaveLocation? location = await getSaveLocation(
      suggestedName: suggestedName,
      acceptedTypeGroups: const [
        XTypeGroup(label: 'JSON', extensions: ['json']),
      ],
      confirmButtonText: 'Save',
    );

    if (location == null) return; // user cancelled

    final file = File(location.path);
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(certificate.toMap()));
  }
}
