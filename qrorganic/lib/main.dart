import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/auth_provider.dart';
import 'package:qrorganic/Provider/qc_List_provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/Provider/show-order-item.dart';
// import 'package:provider/prov/ider.dart';
// import 'package:qrorganic/dashboard.dart';
import 'package:qrorganic/screens/dasborad.dart';
// import 'package:qrorganic/screens/dasborad.dart';
import 'package:qrorganic/screens/login_page.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ReadyToPackProvider()),
      ChangeNotifierProvider(create: (context) => OrderItemProvider()),
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => QcListProvider()),
    ], child: const App()));

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Sora',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff09254A),
          primary: const Color(0xff09254A),
        ),
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthProvider? authprovider;
  @override
  void initState() {
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authprovider, child) => FutureBuilder<String?>(
          future: authprovider.getToken(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snap.hasData) {
              if (authprovider.isAuthenticated) {
                return DashboardScreen();
              } else {
                return const LoginPage();
              }
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}
