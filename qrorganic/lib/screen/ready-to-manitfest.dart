import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/custom/show-order-item-details.dart';
import 'package:qrorganic/screen/camera-screen.dart';


class ReadyToManiFest extends StatefulWidget {
  const ReadyToManiFest({super.key});

  @override
  State<ReadyToManiFest> createState() => _ReadyToManiFestState();
}

class _ReadyToManiFestState extends State<ReadyToManiFest> {
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
    await readyToPackProvider.fetchReadyToManiFestOrders();
    // List<bool>.filled(readyToPackProvider.orders.length, false);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Consumer<ReadyToPackProvider>(
        builder: (context, provider, child) => provider.manifestOrder.isNotEmpty
            ? Column(
                children: [
                  Row(
                    
                    children: [
                      Checkbox(value:provider.manifestOrder[0].isPickerFullyScanned, onChanged: (val) {}),
                      const Text("Select All Orders"),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.manifestOrder.length,
                      scrollDirection:Axis.vertical,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                          value: provider.rtmCheckBox[index],
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
                                  const SizedBox(height: 10),
                                  Column(
                                    children: List.generate(
                                        provider.manifestOrder[index].items!.length,
                                        (i) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: InkWell(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Image.network(
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTprI6-IHZrDj6tSyBRlbmUnRb6CuDfZYIQVoPNpHEBtjg1atSd-B_LlhBdT7fJpWqFQWM&usqp=CAU",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      provider
                                                          .manifestOrder[index]
                                                          .items![i]
                                                          .product
                                                          .displayName,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "SKU: ${provider.manifestOrder[index].items![i].product.sku}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "Quantity: ${provider.manifestOrder[index].items![i].quantity}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Scanned Qty: ${provider.manifestOrder[index].picker!.length > i ? provider.manifestOrder[index].picker![i].scannedQty : 0}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                           
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CameraScreen()
                                                        )
                                                        );
                                          },
                                        ),
                                      );
                                    }),
                                  ),
                                 const Divider(thickness: 1),
                                ],
                              ),
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
