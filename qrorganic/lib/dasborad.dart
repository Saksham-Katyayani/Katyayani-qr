import 'package:flutter/material.dart';
import 'package:qrorganic/ready-to-pack.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const Color primaryBlue = Color.fromRGBO(6, 90, 216, 1);
  static const Color primaryBlueLight = Color.fromRGBO(6, 90, 216, 0.7);

  // List of labels for the bottom navigation bar
  final List<String> _labels = [
    'Ready to Pack',
    'Ready to Check',
    'Ready to Racked',
    'Ready to Manifest'
  ];

  // List of icons for each item
  final List<IconData> _icons = [
    Icons.shopping_bag,      // For "Ready to Pack"
    Icons.check_circle, // For "Ready to Check"
    Icons.storage,      // For "Ready to Racked"
    Icons.assignment,    // For "Ready to Manifest"
  ];
  final List<Widget> content = [
    ReadyToPackPage(),      // For "Ready to Pack"
   const Center(child:Text("Ready to Check"),), // For "Ready to Check"
   const Center(child:Text("Ready to Check"),),      // For "Ready to Racked"
   const Center(child:Text("Ready to Manifes"),),    // For "Ready to Manifest"
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Dashboard'),
        backgroundColor: primaryBlue,
      ),
      body:content[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: List.generate(_labels.length, (index) {
          return BottomNavigationBarItem(
            icon: Icon(_icons[index], color: _selectedIndex == index ? primaryBlue : primaryBlueLight),
            label: _labels[index],
          );
        }),
        currentIndex: _selectedIndex,
        selectedItemColor: primaryBlue,
        unselectedItemColor: primaryBlueLight,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
      ),
    );
  }
}