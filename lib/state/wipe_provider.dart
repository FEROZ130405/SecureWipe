import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/certificate.dart';
import '../services/certificate_service.dart';
import '../services/wipe_service.dart';

enum OperatingSystemType { windows, linux }

enum WipeMethod { deleteAllFiles, purgeAllFiles }

enum AndroidWipeMethod { factoryReset, encryptAndReset }

enum DiskType { hdd, ssd, nvme }

class DiskInfo {
  final String name;
  final String path;
  final DiskType type;
  final int sizeGB;

  DiskInfo({
    required this.name,
    required this.path,
    required this.type,
    required this.sizeGB,
  });
}

class WipeProvider extends ChangeNotifier {
  final List<WipeCertificate> _certificates = <WipeCertificate>[];
  final List<DiskInfo> _availableDisks = <DiskInfo>[];
  bool _isWiping = false;
  String _logOutput = '';

  bool get isWiping => _isWiping;
  String get logOutput => _logOutput;
  List<WipeCertificate> get certificates => List.unmodifiable(_certificates);
  List<DiskInfo> get availableDisks => List.unmodifiable(_availableDisks);

  void clearLog() {
    _logOutput = '';
    notifyListeners();
  }

  void loadAvailableDisks() {
    // Simulate disk detection - replace with real disk enumeration later
    _availableDisks.clear();
    _availableDisks.addAll([
      DiskInfo(name: 'C: Drive (System)', path: 'C:', type: DiskType.ssd, sizeGB: 500),
      DiskInfo(name: 'D: Drive (Data)', path: 'D:', type: DiskType.hdd, sizeGB: 1000),
      DiskInfo(name: 'E: Drive (NVMe)', path: 'E:', type: DiskType.nvme, sizeGB: 2000),
    ]);
    notifyListeners();
  }

  Future<void> simulateWindowsWipe(DiskInfo disk, WipeMethod method) async {
    if (_isWiping) return;
    _isWiping = true;
    _logOutput = '';
    notifyListeners();

    final stream = WipeService.simulateWindowsWipe(disk, method);
    await for (final line in stream) {
      _logOutput += line + '\n';
      notifyListeners();
    }

    final cert = WipeCertificate(
      os: OperatingSystemType.windows,
      diskName: disk.name,
      diskPath: disk.path,
      diskType: disk.type,
      method: describeEnum(method),
      timestamp: DateTime.now(),
      status: 'Success (Simulated)'
    );
    _certificates.add(cert);
    _isWiping = false;
    notifyListeners();
  }

  Future<void> simulateLinuxWipe(DiskInfo disk, WipeMethod method) async {
    if (_isWiping) return;
    _isWiping = true;
    _logOutput = '';
    notifyListeners();

    final stream = WipeService.simulateLinuxWipe(disk, method);
    await for (final line in stream) {
      _logOutput += line + '\n';
      notifyListeners();
    }

    final cert = WipeCertificate(
      os: OperatingSystemType.linux,
      diskName: disk.name,
      diskPath: disk.path,
      diskType: disk.type,
      method: describeEnum(method),
      timestamp: DateTime.now(),
      status: 'Success (Simulated)'
    );
    _certificates.add(cert);
    _isWiping = false;
    notifyListeners();
  }

  Future<void> simulateAndroidWipe(AndroidWipeMethod method) async {
    if (_isWiping) return;
    _isWiping = true;
    _logOutput = '';
    notifyListeners();

    final stream = WipeService.simulateAndroidWipe(method);
    await for (final line in stream) {
      _logOutput += line + '\n';
      notifyListeners();
    }

    final cert = WipeCertificate(
      os: OperatingSystemType.windows, // Using windows as placeholder for Android
      diskName: 'Android Device',
      diskPath: '/android',
      diskType: DiskType.ssd, // Android devices typically use SSD-like storage
      method: describeEnum(method),
      timestamp: DateTime.now(),
      status: 'Success (Simulated)'
    );
    _certificates.add(cert);
    _isWiping = false;
    notifyListeners();
  }

  Future<void> downloadCertificate(WipeCertificate certificate) async {
    await CertificateService.saveCertificate(certificate);
  }
}
