import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_flutter/domain/models/fuel_entry.dart';
import 'package:tracker_flutter/providers/providers.dart';

class Fuel extends ConsumerStatefulWidget {
  const Fuel({super.key});

  @override
  ConsumerState<Fuel> createState() => _FuelState();
}

class _FuelState extends ConsumerState<Fuel> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(vehicleProvider).fetchVehicles();
    ref.read(fuelProvider).fetchEntries();
  }

  late TextEditingController _litersController;
  late TextEditingController _amountController;
  String? _selectedVehicleId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _litersController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _litersController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _handleAddEntry() {
    if (_selectedVehicleId == null) {
      return;
    }
    final entry = FuelEntry(
      vehicleId: _selectedVehicleId,
      date: _selectedDate,
      liters: double.tryParse(_litersController.text),
      amount: double.tryParse(_amountController.text),
    );
    ref.read(fuelProvider).addEntry(entry);
    _litersController.clear();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProv = ref.watch(vehicleProvider);
    final fuelProv = ref.watch(fuelProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton<String>(
                value: _selectedVehicleId,
                hint: const Text('Select Vehicle'),
                isExpanded: true,
                items: vehicleProv.vehicles.map((vehicle) {
                  return DropdownMenuItem<String>(
                    value: vehicle.id,
                    child: Text(vehicle.name ?? 'No Name'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVehicleId = value;
                  });
                },
              ),
              TextField(
                controller: _litersController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(label: Text('Liters')),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(label: Text('Amount')),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                  TextButton(
                    onPressed: () => _pickDate(),
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _handleAddEntry(),
                child: const Text('Save'),
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fuelProv.entries.length,
                itemBuilder: (context, index) {
                  final entry = fuelProv.entries[index];
                  return ListTile(
                    leading: const Icon(Icons.local_gas_station),
                    title: Text('${entry.liters ?? 0} L - ${entry.amount ?? 0}'),
                    subtitle: Text(entry.date != null
                        ? '${entry.date!.day}/${entry.date!.month}/${entry.date!.year}'
                        : ''),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
