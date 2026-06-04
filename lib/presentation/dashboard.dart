import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_flutter/domain/models/maintenance.dart';
import 'package:tracker_flutter/providers/providers.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(vehicleProvider).fetchVehicles();
    ref.read(fuelProvider).fetchEntries();
    ref.read(maintenanceProvider).fetchMaintenances();
  }

  String? _filterVehicleId;
  DateTime? _filterDate;

  String _monthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  void _pickFilterDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _filterDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        _filterDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProv = ref.watch(vehicleProvider);
    final fuelProv = ref.watch(fuelProvider);
    final maintenanceProv = ref.watch(maintenanceProvider);

    // Depenses par mois (gasoil et maintenance)
    final Map<String, double> fuelByMonth = {};
    final Map<String, double> maintenanceByMonth = {};

    for (final entry in fuelProv.entries) {
      if (entry.date != null) {
        final key = _monthKey(entry.date!);
        fuelByMonth[key] = (fuelByMonth[key] ?? 0) + (entry.amount ?? 0);
      }
    }
    for (final maintenance in maintenanceProv.maintenances) {
      if (maintenance.date != null) {
        final key = _monthKey(maintenance.date!);
        maintenanceByMonth[key] =
            (maintenanceByMonth[key] ?? 0) + (maintenance.cost ?? 0);
      }
    }

    final months = <String>{...fuelByMonth.keys, ...maintenanceByMonth.keys}
        .toList()
      ..sort();

    // Consommation de gasoil par mois (litre/montant)
    final Map<String, double> litersByMonth = {};
    for (final entry in fuelProv.entries) {
      if (entry.date != null) {
        final key = _monthKey(entry.date!);
        litersByMonth[key] = (litersByMonth[key] ?? 0) + (entry.liters ?? 0);
      }
    }

    // Historique de maintenance filtre par vehicule et par date
    List<Maintenance> filteredMaintenances = maintenanceProv.maintenances;
    if (_filterVehicleId != null) {
      filteredMaintenances = filteredMaintenances
          .where((m) => m.vehicleId == _filterVehicleId)
          .toList();
    }
    if (_filterDate != null) {
      filteredMaintenances = filteredMaintenances
          .where((m) => m.date != null && !m.date!.isBefore(_filterDate!))
          .toList();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Liste des voitures
            const Text(
              'Vehicles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...vehicleProv.vehicles.map((vehicle) {
              return ListTile(
                leading: const Icon(Icons.directions_car),
                title: Text(vehicle.name ?? 'No Name'),
                subtitle: Text(vehicle.plate ?? ''),
              );
            }),
            const Divider(),

            // Depenses par mois plus repartition
            const Text(
              'Monthly Expenses (Fuel / Maintenance)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...months.map((month) {
              final fuel = fuelByMonth[month] ?? 0;
              final maintenance = maintenanceByMonth[month] ?? 0;
              final total = fuel + maintenance;
              final fuelPct = total > 0 ? (fuel / total * 100) : 0;
              final maintenancePct = total > 0 ? (maintenance / total * 100) : 0;
              return Card(
                child: ListTile(
                  title: Text('$month : Total $total'),
                  subtitle: Text(
                    'Fuel: $fuel (${fuelPct.toStringAsFixed(0)}%) - '
                    'Maintenance: $maintenance (${maintenancePct.toStringAsFixed(0)}%)',
                  ),
                ),
              );
            }),
            const Divider(),

            // Consommation de gasoil par mois (litre/montant)
            const Text(
              'Fuel Consumption per Month (Liters / Amount)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...months.map((month) {
              final liters = litersByMonth[month] ?? 0;
              final amount = fuelByMonth[month] ?? 0;
              return ListTile(
                leading: const Icon(Icons.local_gas_station),
                title: Text(month),
                subtitle: Text('$liters L - $amount'),
              );
            }),
            const Divider(),

            // Historique de maintenance par vehicule filtrage par date
            const Text(
              'Maintenance History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _filterVehicleId,
              hint: const Text('All Vehicles'),
              isExpanded: true,
              items: vehicleProv.vehicles.map((vehicle) {
                return DropdownMenuItem<String>(
                  value: vehicle.id,
                  child: Text(vehicle.name ?? 'No Name'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _filterVehicleId = value;
                });
              },
            ),
            Row(
              children: [
                Text(_filterDate != null
                    ? 'From: ${_filterDate!.day}/${_filterDate!.month}/${_filterDate!.year}'
                    : 'No date filter'),
                TextButton(
                  onPressed: () => _pickFilterDate(),
                  child: const Text('Pick Date'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filterDate = null;
                      _filterVehicleId = null;
                    });
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            ...filteredMaintenances.map((maintenance) {
              return ListTile(
                leading: const Icon(Icons.build),
                title: Text(maintenance.categoryName ?? 'No Category'),
                subtitle: Text(
                  '${maintenance.description ?? ''} - ${maintenance.cost ?? 0} - '
                  '${maintenance.date != null ? '${maintenance.date!.day}/${maintenance.date!.month}/${maintenance.date!.year}' : ''}',
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
