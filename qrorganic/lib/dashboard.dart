import 'package:flutter/material.dart';
import 'package:qrorganic/custom/colors.dart';
import 'package:qrorganic/screens/ready-to-check.dart';
import 'package:qrorganic/screens/ready-to-manitfest.dart';
// import 'package:qrorganic/const.dart';
import 'package:qrorganic/screens/ready-to-pack.dart';
import 'package:qrorganic/screens/ready-to-pick.dart';
import 'package:qrorganic/screens/ready-to-racked.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // List of labels for the bottom navigation bar
  final List<String> _labels = [
    "Ready to Pick",
    'Ready to Pack',
    'Ready to Check',
    'Ready to Racked',
    'Ready to Manifest'
  ];

  // List of icons for each item
  final List<IconData> _icons = [
    Icons.shop,
    Icons.shopping_bag, // For "Ready to Pack"
    Icons.check_circle, // For "Ready to Check"
    Icons.storage, // For "Ready to Racked"
    Icons.assignment, // For "Ready to Manifest"
  ];
  final List<Widget> content =const [
    ReadyToPickPage(),
    ReadyToPackPage(), // For "Ready to Pack"
    ReadyToCheckPage(),
    ReadyToRacked(),
    ReadyToManiFest(),
   // For "Ready to Manifest"
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: List.generate(_labels.length, (index) {
          return BottomNavigationBarItem(
            icon: Icon(_icons[index],
                color: _selectedIndex == index
                    ? AppColors.primaryBlue
                    : AppColors.primaryBlue),
            label: _labels[index],
          );
        }),
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.primaryBlue,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
      ),
    );
  }
}
