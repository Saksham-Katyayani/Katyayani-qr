// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:qrorganic/screens/authScreens/auth/login_screen.dart';
import 'package:qrorganic/screens/inboundScreens/in_bound_page.dart';
import 'package:qrorganic/screens/inboundScreens/status_check_screen.dart';
import 'package:qrorganic/screens/login_page.dart';
import 'package:qrorganic/screens/ready-to-check.dart';
import 'package:qrorganic/screens/ready-to-manitfest.dart';
import 'package:qrorganic/screens/ready-to-pack.dart';
import 'package:qrorganic/screens/ready-to-pick.dart';
import 'package:qrorganic/screens/ready-to-racked.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    'Ready to Manifest',
    "Inbound Dashboard"
  ];

  // List of icons for each item
  final List<IconData> _icons = [
    Icons.shopping_bag,
    Icons.done, // For "Ready to Pack"
    Icons.check_circle, // For "Ready to Check"
    Icons.storage, // For "Ready to Racked"
    Icons.assignment,
    Icons.inbox_outlined, // For "Ready to Manifest"
  ];
  final List<Widget> content = [
    const ReadyToPickPage(),
    const ReadyToPackPage(), // For "Ready to Pack"
    const ReadyToCheckPage(), // For "Ready to Check"
    const ReadyToRacked(), // For "Ready to Racked"
    const ReadyToManiFest(),
    const InBoundDashboard(),
  ];

  void _onItemTapped(int index) {
    print("heree ${_labels.length}");
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _confirmLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _logout(); // Call the logout function
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken'); // Remove the token
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Navigate to login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_labels[_selectedIndex]),
        backgroundColor: primaryBlue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryBlue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('Ready to Pick'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.done),
              title: Text('Ready to Pack'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Ready to Check'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.storage),
              title: Text('Ready to Racked'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(3);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Ready to Manifest'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(4);
              },
            ),
            ListTile(
              leading: Icon(Icons.inbox_outlined),
              title: Text('Inbound Dashboard'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(5);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _confirmLogout, // Use the confirm logout method
            ),
          ],
        ),
      ),
      body: content[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: List.generate(_labels.length, (index) {
          return BottomNavigationBarItem(
            icon: Icon(_icons[index],
                color:
                    _selectedIndex == index ? primaryBlue : primaryBlueLight),
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
