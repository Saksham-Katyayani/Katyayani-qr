import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/custom/colors.dart';
import 'package:qrorganic/custom/pagination.dart';
import 'package:qrorganic/custom/show-order-item-details.dart';
import 'package:qrorganic/screens/inboundScreens/status_check_screen.dart';

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
    setState(() {}); // Ensure UI updates after data fetch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReadyToPackProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.pickOrder.isEmpty) {
          return const Center(child: Text('No Orders Available'));
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () async {
              getData();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Order ID: ${provider.pickOrder[index].orderId}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    provider.pickOrder[index]
                                            .isPickerFullyScanned
                                        ? "Approved"
                                        : "Not Approved",
                                    style: TextStyle(
                                      color: provider.pickOrder[index]
                                              .isPickerFullyScanned
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Order Time: ${DateFormat('dd-MM-yyyy hh:mm a').format(provider.pickOrder[index].updatedAt)}",
                                style: const TextStyle(
                                    fontSize: 8, color: AppColors.primaryBlue),
                              ),
                              const SizedBox(height: 2),
                              // Displaying each item as a separate card
                              Column(
                                children: List.generate(
                                    provider.pickOrder[index].items!.length,
                                    (i) {
                                  return Card(
                                    elevation: 2,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
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
                                              child: provider
                                                      .pickOrder[index]
                                                      .items![i]
                                                      .product
                                                      .shopifyImage
                                                      .isNotEmpty
                                                  ? Image.network(
                                                      provider
                                                          .pickOrder[index]
                                                          .items![i]
                                                          .product
                                                          .shopifyImage,
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
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "SKU: ${provider.pickOrder[index].items![i].product.sku}",
                                                    style: const TextStyle(
                                                        fontSize: 8,
                                                        color: AppColors
                                                            .primaryBlue),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Quantity: ${provider.pickOrder[index].items![i].quantity}",
                                                        style: const TextStyle(
                                                            fontSize: 8,
                                                            color: Colors.grey),
                                                      ),
                                                      provider
                                                                      .pickOrder[
                                                                          index]
                                                                      .picker!
                                                                      .length >
                                                                  i &&
                                                              provider
                                                                  .pickOrder[
                                                                      index]
                                                                  .picker![i]
                                                                  .isFullyScanned
                                                          ? const FaIcon(
                                                              FontAwesomeIcons
                                                                  .check,
                                                              size: 25,
                                                              color:
                                                                  Colors.green)
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                  Text(
                                                    "Scanned Qty: ${provider.pickOrder[index].picker!.length > i ? provider.pickOrder[index].picker![i].scannedQty : 0}",
                                                    style: const TextStyle(
                                                        fontSize: 8,
                                                        color: Colors.grey),
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
                ),
                PaginationWidget(title: 'pick')
              ],
            ),
          ),
        );
      }),
    );
  }

  void _navigateToDetails(ReadyToPackProvider provider, int index) {
    List<String> title = [];
    List<String> productName = [];
    List<int> quantity = [];
    List<int> scannedQty = [];
    int sumQty = 0;
    int totalQtyi = 0;
    int itemQty = 0;

    for (int val = 0; val < provider.pickOrder[index].items!.length; val++) {
      title.add(provider.pickOrder[index].items![val].product.parentSku);
      productName
          .add(provider.pickOrder[index].items![val].product.displayName);
      quantity.add((provider.pickOrder[index].items![val].quantity).toInt());
      sumQty += provider.pickOrder[index].picker!.length > val
          ? provider.pickOrder[index].picker![val].scannedQty
          : 0;
      scannedQty.add(provider.pickOrder[index].picker!.length > val
          ? provider.pickOrder[index].picker![val].scannedQty
          : 0);
      totalQtyi += (provider.pickOrder[index].items![val].quantity).toInt();
      itemQty += provider.pickOrder[index].items![val].product.itemQty;
    }

    provider.setDetailsOfProducts(
      productName,
      title,
      scannedQty,
      quantity,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowDetailsOfOrderItem(
          productName: productName,
          numberOfItme: quantity,
          title: title,
          oredrId: provider.pickOrder[index].orderId,
          scannedQty: sumQty,
          totalQty: totalQtyi,
          scannedQ: scannedQty,
          itemQty: itemQty,
          isPicker: true,
        ),
      ),
    );
  }
}
