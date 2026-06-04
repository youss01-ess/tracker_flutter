import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tracker_flutter/data/services/fuel_service.dart';
import 'package:tracker_flutter/domain/models/fuel_entry.dart';

class FuelProvider extends ChangeNotifier {
  List<FuelEntry> _entries = [];
  final FuelService _fuelService = FuelService();
  List<FuelEntry> get entries => _entries;

  Future<void> fetchEntries() async {
    try {
      _entries = await _fuelService.getAllFuelEntries();
    } catch (e) {
      log('Error fetching fuel entries: $e');
    }
    notifyListeners();
  }

  Future<void> addEntry(FuelEntry entry) async {
    try {
      await _fuelService.addFuelEntry(entry);
      await fetchEntries();
    } catch (e) {
      log('Error adding fuel entry: $e');
    }
  }
}
