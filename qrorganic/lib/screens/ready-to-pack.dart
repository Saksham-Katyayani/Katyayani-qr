import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/custom/colors.dart';
import 'package:qrorganic/custom/pagination.dart';
import 'package:qrorganic/custom/show-order-item-details.dart';

class ReadyToPackPage extends StatefulWidget {
  const ReadyToPackPage({super.key});

  @override
  State<ReadyToPackPage> createState() => _ReadyToPackPageState();
}

class _ReadyToPackPageState extends State<ReadyToPackPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async {
    var readyToPackProvider =
        Provider.of<ReadyToPackProvider>(context, listen: false);
    await readyToPackProvider.fetchReadyToPackOrders();
    setState(() {});
  }

  void _navigateToItemDetails(BuildContext context, order, int index) {
    List<String> titles = [];
    List<String> productName = [];
    List<int> quantities = [];
    List<int> scannedQuantities = [];
    int totalScannedQty = 0;
    int totalQty = 0;
    int itemQty = 0;

    for (int val = 0; val < order.items!.length; val++) {
      titles.add(order.items![val].product.parentSku);
      productName.add(order.items![val].product.displayName);
      quantities.add(order.items![val].quantity.toInt());

      int scannedQty =
          order.packer!.length > val ? order.packer![val].scannedQty : 0;
      scannedQuantities.add(scannedQty);

      totalScannedQty += scannedQty;
      totalQty +=
          (double.tryParse(order.items![val].quantity.toString()) ?? 0).toInt();
      itemQty +=
          (double.tryParse(order.items![val].product.itemQty.toString()) ?? 0)
              .toInt();
    }

    log("itemQty: $itemQty");
    log("totalQty: $totalQty");

    Provider.of<ReadyToPackProvider>(context, listen: false)
        .setDetailsOfProducts(
            productName, titles, scannedQuantities, scannedQuantities);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowDetailsOfOrderItem(
          itemQty: itemQty,
          productName: productName,
          numberOfItme: quantities,
          title: titles,
          oredrId: order.orderId,
          scannedQty: totalScannedQty,
          totalQty: totalQty,
          scannedQ: scannedQuantities,
          isPacker: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Ready to Pack Orders'),
      //   backgroundColor: AppColors.primaryBlueAccent,
      // ),
      body: Consumer<ReadyToPackProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.orders.isEmpty) {
            return const Center(child: Text('No Orders Available'));
          }

          return RefreshIndicator(
            onRefresh: () => getData(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.orders.length,
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      final order = provider.orders[index];
                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Order ID: ${order.orderId}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    order.isPackerFullyScanned
                                        ? 'Approved'
                                        : 'Not Approved',
                                    style: TextStyle(
                                      color: order.isPackerFullyScanned
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ...List.generate(order.items!.length, (i) {
                                final item = order.items![i];
                                final scannedQty = order.packer!.length > i
                                    ? order.packer![i].scannedQty
                                    : 0;

                                return GestureDetector(
                                  onTap: () {
                                    _navigateToItemDetails(context, order, i);
                                  },
                                  child: Card(
                                    elevation: 2,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: item.product.shopifyImage
                                                    .isNotEmpty
                                                ? Image.network(
                                                    item.product.shopifyImage,
                                                    fit: BoxFit.cover,
                                                  )
                                                : const Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                      size: 50,
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(width: 2),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.product.displayName,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "SKU: ${item.product.sku}",
                                                  style: const TextStyle(
                                                      fontSize: 8,
                                                      color: AppColors
                                                          .primaryBlue),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "Order Time: ${DateFormat('dd-MM-yyyy hh:mm a').format(item.product.upDatedAt)}",
                                                  style: const TextStyle(
                                                      fontSize: 8,
                                                      color: AppColors
                                                          .primaryBlue),
                                                ),
                                                // const SizedBox(height: 4),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "Quantity: ${item.quantity}",
                                                  style: const TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  "Scanned Qty: $scannedQty",
                                                  style: const TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (order.packer!.length > i)
                                            Icon(
                                              order.packer![i].isFullyScanned
                                                  ? FontAwesomeIcons.check
                                                  : Icons.clear,
                                              size: 25,
                                              color: order
                                                      .packer![i].isFullyScanned
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              const Divider(thickness: 1),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                PaginationWidget(title: 'pack')
              ],
            ),
          );
        },
      ),
    );
  }
}
