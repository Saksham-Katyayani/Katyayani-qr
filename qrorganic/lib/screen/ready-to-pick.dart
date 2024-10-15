import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
    var readyToPackProvider = Provider.of<ReadyToPackProvider>(context, listen: false);
    await readyToPackProvider.fetchReadyToPickOrders();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReadyToPackProvider>(
        builder: (context, provider, child) => provider.pickOrder.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: provider.pickOrder.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Order ID: ${provider.pickOrder[index].orderId}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  provider.pickOrder[index].isPickerFullyScanned ? "Approved" : "Not Approved",
                                  style: TextStyle(
                                    color: provider.pickOrder[index].isPickerFullyScanned ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Displaying each item as a separate card
                            Column(
                              children: List.generate(provider.pickOrder[index].items!.length, (i) {
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: InkWell(
                                      onTap: () {
                                        // Navigate to details page
                                        _navigateToDetails(provider, index);
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Image.network(provider.pickOrder[index].items![i].product.shopifyImage.isNotEmpty?provider.pickOrder[index].items![i].product.shopifyImage:
                                      "https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-6.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  provider.pickOrder[index].items![i].product.displayName,
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "SKU: ${provider.pickOrder[index].items![i].product.sku}",
                                                  style: const TextStyle(fontSize: 14, color: Colors.blue),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "Order Time: ${DateFormat('dd-MM-yyyy hh:mm a').format(provider.pickOrder[index].items![i].product.upDatedAt)}",
                                                  style: const TextStyle(fontSize: 14, color: Colors.blue),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Quantity: ${provider.pickOrder[index].items![i].quantity}",
                                                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                                                    ),
                                                
                                                    provider.pickOrder[index].picker!.length > i &&
                                                            provider.pickOrder[index].picker![i].isFullyScanned
                                                        ? const FaIcon(FontAwesomeIcons.check, size: 25, color: Colors.green)
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                                     Text(
                                          "Scanned Qty: ${provider.pickOrder[index].picker!.length>i?provider.pickOrder[index].picker![i].scannedQty:0}",
                                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                                        ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const Divider(thickness: 1),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _navigateToDetails(ReadyToPackProvider provider, int index) {
    List<String> title = [];
    List<int> quantity = [];
    List<int> scannedQty = [];
    int sumQty = 0;
    int totalQtyi = 0;

    for (int val = 0; val < provider.pickOrder[index].items!.length; val++) {
      title.add(provider.pickOrder[index].items![val].product.sku);
      quantity.add((provider.pickOrder[index].items![val].quantity).toInt());
      sumQty += provider.pickOrder[index].picker!.length > val ? provider.pickOrder[index].picker![val].scannedQty : 0;
      scannedQty.add(provider.pickOrder[index].picker!.length > val ? provider.pickOrder[index].picker![val].scannedQty : 0);
      totalQtyi += (provider.pickOrder[index].items![val].quantity).toInt();
    }

    provider.setDetailsOfProducts(title, scannedQty, scannedQty);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowDetailsOfOrderItem(
          numberOfItme: quantity,
          title: title,
          oredrId: provider.pickOrder[index].orderId,
          scannedQty: sumQty,
          totalQty: totalQtyi,
          scannedQ: scannedQty,
          isPicker: true,
        ),
      ),
    );
  }
}
