import 'package:flutter/material.dart';
import 'package:qrorganic/screens/inboundScreens/binner_page.dart';
import 'package:qrorganic/screens/inboundScreens/in_bound_page.dart';
import 'package:qrorganic/screens/inboundScreens/qc_check_page.dart';

class InBoundDashboard extends StatelessWidget {
  const InBoundDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                side: BorderSide(color: Colors.black38),
                fixedSize: Size(150, 50),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => InBoundPage()));
              },
              child: Text(
                'InBound',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(150, 50),
                elevation: 4,
                backgroundColor: Colors.blueAccent,
                side: BorderSide(color: Colors.black38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => QcCheckPage()));
              },
              child: Text(
                'QcCheck',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(150, 50),
                elevation: 4,
                backgroundColor: Colors.blueAccent,
                side: BorderSide(color: Colors.black38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => BinnerPage()));
              },
              child: Text(
                'Binner',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
