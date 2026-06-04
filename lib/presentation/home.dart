import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker_flutter/presentation/dashboard.dart';
import 'package:tracker_flutter/presentation/fuel.dart';
import 'package:tracker_flutter/presentation/maintenance.dart';
import 'package:tracker_flutter/presentation/vehicles.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _Home();
}

class _Home extends ConsumerState<Home> {
  int _selectIndex = 0;

  final List<Widget> _pages = const [
    Dashboard(),
    Vehicles(),
    Fuel(),
    Maintenances(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        onTap: (value) => _handleNavigation(value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Vehicles'),
          BottomNavigationBarItem(icon: Icon(Icons.local_gas_station), label: 'Fuel'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Maintenance'),
        ],
      ),
    );
  }

  void _handleNavigation(int value) {
    setState(() {
      _selectIndex = value;
    });
  }
}
