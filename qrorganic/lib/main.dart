import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/dasborad.dart';
import 'package:qrorganic/qr_scanner.dart';

void main() => runApp(
  MultiProvider(
     providers: [
        ChangeNotifierProvider(create: (context) => ReadyToPackProvider()),
      ],
  child: const App()));

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}
