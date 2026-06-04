import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_flutter/domain/models/vehicle.dart';
import 'package:tracker_flutter/providers/providers.dart';

class Vehicles extends ConsumerStatefulWidget {
  const Vehicles({super.key});

  @override
  ConsumerState<Vehicles> createState() => _VehiclesState();
}

class _VehiclesState extends ConsumerState<Vehicles> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(vehicleProvider).fetchVehicles();
  }

  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _plateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _brandController = TextEditingController();
    _plateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  void _handleAddVehicle() {
    final vehicle = Vehicle(
      name: _nameController.text,
      brand: _brandController.text,
      plate: _plateController.text,
    );
    ref.read(vehicleProvider).addVehicle(vehicle);
    _nameController.clear();
    _brandController.clear();
    _plateController.clear();
    Navigator.pop(context);
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Vehicle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(label: Text('Name')),
              ),
              TextField(
                controller: _brandController,
                decoration: const InputDecoration(label: Text('Brand')),
              ),
              TextField(
                controller: _plateController,
                decoration: const InputDecoration(label: Text('Plate')),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => _handleAddVehicle(),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProv = ref.watch(vehicleProvider);
    return Scaffold(
      body: ListView.builder(
        itemCount: vehicleProv.vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicleProv.vehicles[index];
          return ListTile(
            leading: const Icon(Icons.directions_car),
            title: Text(vehicle.name ?? 'No Name'),
            subtitle: Text('${vehicle.brand ?? ''} - ${vehicle.plate ?? ''}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
