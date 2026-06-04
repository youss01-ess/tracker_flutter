import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tracker_flutter/data/services/maintenance_service.dart';
import 'package:tracker_flutter/domain/models/maintenance.dart';

class MaintenanceProvider extends ChangeNotifier {
  List<Maintenance> _maintenances = [];
  final MaintenanceService _maintenanceService = MaintenanceService();
  List<Maintenance> get maintenances => _maintenances;

  Future<void> fetchMaintenances() async {
    try {
      _maintenances = await _maintenanceService.getAllMaintenances();
    } catch (e) {
      log('Error fetching maintenances: $e');
    }
    notifyListeners();
  }

  Future<void> addMaintenance(Maintenance maintenance) async {
    try {
      await _maintenanceService.addMaintenance(maintenance);
      await fetchMaintenances();
    } catch (e) {
      log('Error adding maintenance: $e');
    }
  }
}
