import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_flutter/domain/models/category.dart';
import 'package:tracker_flutter/domain/models/maintenance.dart';
import 'package:tracker_flutter/providers/providers.dart';

class Maintenances extends ConsumerStatefulWidget {
  const Maintenances({super.key});

  @override
  ConsumerState<Maintenances> createState() => _MaintenancesState();
}

class _MaintenancesState extends ConsumerState<Maintenances> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(vehicleProvider).fetchVehicles();
    ref.read(categoryProvider).fetchCategories();
    ref.read(maintenanceProvider).fetchMaintenances();
  }

  late TextEditingController _descriptionController;
  late TextEditingController _costController;
  late TextEditingController _categoryNameController;
  String? _selectedVehicleId;
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _costController = TextEditingController();
    _categoryNameController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _costController.dispose();
    _categoryNameController.dispose();
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

  void _handleAddCategory() {
    final category = Category(name: _categoryNameController.text);
    ref.read(categoryProvider).addCategory(category);
    _categoryNameController.clear();
    Navigator.pop(context);
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: TextField(
            controller: _categoryNameController,
            decoration: const InputDecoration(label: Text('Category Name')),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => _handleAddCategory(),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _handleAddMaintenance() {
    if (_selectedVehicleId == null || _selectedCategoryId == null) {
      return;
    }
    final categories = ref.read(categoryProvider).categories;
    final category = categories.firstWhere((c) => c.id == _selectedCategoryId);
    final maintenance = Maintenance(
      vehicleId: _selectedVehicleId,
      categoryId: _selectedCategoryId,
      categoryName: category.name,
      description: _descriptionController.text,
      date: _selectedDate,
      cost: double.tryParse(_costController.text),
    );
    ref.read(maintenanceProvider).addMaintenance(maintenance);
    _descriptionController.clear();
    _costController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProv = ref.watch(vehicleProvider);
    final categoryProv = ref.watch(categoryProvider);
    final maintenanceProv = ref.watch(maintenanceProvider);
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
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _selectedCategoryId,
                      hint: const Text('Select Category'),
                      isExpanded: true,
                      items: categoryProv.categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.name ?? 'No Name'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showAddCategoryDialog(),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(label: Text('Description')),
              ),
              TextField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(label: Text('Cost')),
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
                onPressed: () => _handleAddMaintenance(),
                child: const Text('Save'),
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: maintenanceProv.maintenances.length,
                itemBuilder: (context, index) {
                  final maintenance = maintenanceProv.maintenances[index];
                  return ListTile(
                    leading: const Icon(Icons.build),
                    title: Text(maintenance.categoryName ?? 'No Category'),
                    subtitle: Text('${maintenance.description ?? ''} - ${maintenance.cost ?? 0}'),
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
