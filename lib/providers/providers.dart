import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_flutter/providers/auth_provider.dart';
import 'package:tracker_flutter/providers/category_provider.dart';
import 'package:tracker_flutter/providers/fuel_provider.dart';
import 'package:tracker_flutter/providers/maintenance_provider.dart';
import 'package:tracker_flutter/providers/vehicle_provider.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

final vehicleProvider = ChangeNotifierProvider<VehicleProvider>((ref) {
  return VehicleProvider();
});

final fuelProvider = ChangeNotifierProvider<FuelProvider>((ref) {
  return FuelProvider();
});

final maintenanceProvider = ChangeNotifierProvider<MaintenanceProvider>((ref) {
  return MaintenanceProvider();
});

final categoryProvider = ChangeNotifierProvider<CategoryProvider>((ref) {
  return CategoryProvider();
});
