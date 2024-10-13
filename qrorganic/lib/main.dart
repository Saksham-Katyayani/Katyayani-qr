import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/Provider/show-order-item.dart';

import 'package:qrorganic/screen/dasborad.dart';

void main() => runApp(
  MultiProvider(
     providers: [
        ChangeNotifierProvider(create: (context) => ReadyToPackProvider()),
        ChangeNotifierProvider(create:(context)=> OrderItemProvider()),
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
