import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tracker_flutter/data/services/vehicle_service.dart';
import 'package:tracker_flutter/domain/models/vehicle.dart';

class VehicleProvider extends ChangeNotifier {
  List<Vehicle> _vehicles = [];
  final VehicleService _vehicleService = VehicleService();
  List<Vehicle> get vehicles => _vehicles;

  Future<void> fetchVehicles() async {
    try {
      _vehicles = await _vehicleService.getAllVehicles();
    } catch (e) {
      log('Error fetching vehicles: $e');
    }
    notifyListeners();
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      await _vehicleService.addVehicle(vehicle);
      await fetchVehicles();
    } catch (e) {
      log('Error adding vehicle: $e');
    }
  }
}
