import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/custom/show-order-item-details.dart';


class ReadyToRacked extends StatefulWidget {
  const ReadyToRacked({super.key});

  @override
  State<ReadyToRacked> createState() => _ReadyToRackedState();
}

class _ReadyToRackedState extends State<ReadyToRacked> {
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
    await readyToPackProvider.fetchReadyToRackedOrders();
    // List<bool>.filled(readyToPackProvider.orders.length, false);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Consumer<ReadyToPackProvider>(
        builder: (context, provider, child) => provider.rackedOrder.isNotEmpty
            ? Column(
                children: [
                  Row(
                    
                    children: [
                      Checkbox(value:provider.rackedOrder[0].isPickerFullyScanned, onChanged: (val) {}),
                      const Text("Select All Orders"),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.rackedOrder.length,
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
                                          value: provider.rtrcheckbox[index],
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
                                        provider.rackedOrder[index].items!.length,
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
                                                          .rackedOrder[index]
                                                          .items![i]
                                                          .product
                                                          .displayName,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "SKU: ${provider.rackedOrder[index].items![i].product.sku}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "Quantity: ${provider.rackedOrder[index].items![i].quantity}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Scanned Qty: ${provider.rackedOrder[index].picker!.length > i ? provider.rackedOrder[index].picker![i].scannedQty : 0}",
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
                                            List<String> title = [];
                                            List<int> quantity = [];
                                            List<int> scannedQty = [];
                                            int sumQty=0;
                                            int totalQtyi=0;
                                            
                                            for (int val = 0;
                                                val <
                                                    provider.rackedOrder[index]
                                                        .items!.length;
                                                val++) {
                                              title.add(provider.rackedOrder[index]
                                                  .items![val].product.sku);
                                              quantity.add((provider
                                                      .rackedOrder[index]
                                                      .items![val]
                                                      .quantity)
                                                  .toInt());
                                              sumQty=sumQty+(provider.rackedOrder[index].picker!.length > val ? provider.rackedOrder[index].picker![val].scannedQty : 0);
                                              scannedQty.add(provider.rackedOrder[index].picker!.length > val ? provider.rackedOrder[index].picker![val].scannedQty : 0);
                                              totalQtyi=totalQtyi+(provider.rackedOrder[index].items![val].quantity).toInt();
                                             
                                            }
                                            provider.setDetailsOfProducts(title,scannedQty,scannedQty);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShowDetailsOfOrderItem(
                                                          numberOfItme:
                                                              quantity,
                                                          title: title,
                                                          oredrId: provider
                                                              .rackedOrder[index]
                                                              .orderId, scannedQty:sumQty, totalQty:totalQtyi,
                                                              scannedQ:scannedQty,
                                                        )
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
