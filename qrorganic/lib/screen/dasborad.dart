// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:qrorganic/screen/ready-to-check.dart';
import 'package:qrorganic/screen/ready-to-manitfest.dart';
import 'package:qrorganic/screen/ready-to-pack.dart';
import 'package:qrorganic/screen/ready-to-pick.dart';
import 'package:qrorganic/screen/ready-to-racked.dart';

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
    
    'Ready to Pick',
    'Ready to Pack',
    'Ready to Check',
    'Ready to Racked',
    'Ready to Manifest'
  ];

  // List of icons for each item
  final List<IconData> _icons = [
    Icons.shopping_bag, 
    Icons.done,     // For "Ready to Pack"
    Icons.check_circle, // For "Ready to Check"
    Icons.storage,      // For "Ready to Racked"
    Icons.assignment,    // For "Ready to Manifest"
  ];
  final List<Widget> content = [
     
  const ReadyToPickPage(),
  const ReadyToPackPage(),      // For "Ready to Pack"
   const ReadyToCheckPage(), // For "Ready to Check"
   const ReadyToRacked(),      // For "Ready to Racked"
   const ReadyToManiFest(),    // For "Ready to Manifest"
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
        title: Text(_labels[_selectedIndex]),
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