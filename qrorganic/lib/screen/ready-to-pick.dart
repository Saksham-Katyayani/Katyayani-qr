import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/custom/show-order-item-details.dart';


class ReadyToPickPage extends StatefulWidget {
  const ReadyToPickPage({super.key});

  @override
  State<ReadyToPickPage> createState() => _ReadyToPickPageState();
}

class _ReadyToPickPageState extends State<ReadyToPickPage> {
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
    await readyToPackProvider.fetchReadyToPickOrders();
    // List<bool>.filled(readyToPackProvider.orders.length, false);
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Consumer<ReadyToPackProvider>(
        builder: (context, provider, child) => provider.pickOrder.isNotEmpty
            ? Column(
                children: [
                  Row(
                    children: [
                      Checkbox(value:provider.pickOrder[0].isPickerFullyScanned, onChanged: (val) {}),
                      const Text("Select All Orders"),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.pickOrder.length,
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
                                          value: provider.pickCheckBox[index],
                                          onChanged: (val) {
                                            // provider
                                            //     .updateCheckBoxStatus(index);
                                          }),
                                      Expanded(
                                        child: Text(
                                          "Order ID: ${provider.pickOrder[index].orderId} ",
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
                                        provider.pickOrder[index].items!.length,
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
                                                          .pickOrder[index]
                                                          .items![i]
                                                          .product
                                                          .displayName,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "SKU: ${provider.pickOrder[index].items![i].product.sku}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "Quantity: ${provider.pickOrder[index].items![i].quantity}",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Scanned Qty: ${provider.pickOrder[index].picker!.length > i ? provider.pickOrder[index].picker![i].scannedQty : 0}",
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
                                                    provider.pickOrder[index]
                                                        .items!.length;
                                                val++) {
                                              title.add(provider.pickOrder[index]
                                                  .items![val].product.sku);
                                              quantity.add((provider
                                                      .pickOrder[index]
                                                      .items![val]
                                                      .quantity)
                                                  .toInt());
                                              sumQty=sumQty+(provider.pickOrder[index].picker!.length > val ? provider.pickOrder[index].picker![val].scannedQty : 0);
                                              scannedQty.add(provider.pickOrder[index].picker!.length > val ? provider.pickOrder[index].picker![val].scannedQty : 0);
                                              totalQtyi=totalQtyi+(provider.pickOrder[index].items![val].quantity).toInt();
                                             
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
                                                              .pickOrder[index]
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
            : const Text("Wait"),
      ),
    );
  }
}
