import 'package:flutter/material.dart';
import 'package:qrorganic/utils/const.dart';

class ReadyToPickPage extends StatefulWidget {
  const ReadyToPickPage({super.key});

  @override
  State<ReadyToPickPage> createState() => _ReadyToPickPageState();
}

class _ReadyToPickPageState extends State<ReadyToPickPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().primaryBlue.withOpacity(0.1),
      appBar: AppBar(
        title: const Text("Packer"),
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(10),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Order Id : "),
                            Text(
                              "KO-123",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text("Products : "),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Text(
                                  "sku - K-123,  qty-4",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "sku - K-123,  qty-4",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "sku - K-123,  qty-4",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "sku - K-123,  qty-4",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "sku - K-123,  qty-4",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "24-4-2024 at 4:30 am",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
