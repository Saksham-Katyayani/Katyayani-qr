import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/custom/show-order-item-details.dart';

import 'weigth-enter.dart';


class ReadyToCheckPage extends StatefulWidget {
  const ReadyToCheckPage({super.key});

  @override
  State<ReadyToCheckPage> createState() => _ReadyToCheckPageState();
}

class _ReadyToCheckPageState extends State<ReadyToCheckPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  void getData() async {
    var readyToPackProvider =
        Provider.of<ReadyToPackProvider>(context, listen: false);
    await readyToPackProvider.fetchReadyToCheckOrders();
    // List<bool>.filled(readyToPackProvider.orders.length, false);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Consumer<ReadyToPackProvider>(
        builder: (context, provider, child) => provider.checkOrder.isNotEmpty
            ? Column(
                children: [
                  Row(
                    children: [
                      Checkbox(value:provider.checkOrder[0].isPickerFullyScanned, onChanged: (val) {}),
                      const Text("Select All Orders"),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.checkOrder.length,
                      scrollDirection:Axis.vertical,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                            value: provider.rtcCheckBox[index],
                                            onChanged: (val) {
                                              // provider
                                              //     .updateCheckBoxStatus(index);
                                            }),
                                        Expanded(
                                          child: Text(
                                            "Order ID: ${provider.orders[index].orderId} ",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                          
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                       WightEnter(orderId:provider.orders[index].orderId,)
                                                      )
                                                      );
                                        },
                                ),
                              
                               
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            :(provider.isLoading)?const Text("Wait"):Text('No Data'),
      ),
    );
  }
}
