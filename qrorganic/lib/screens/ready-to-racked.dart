import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/custom/pagination.dart';
import 'package:qrorganic/widgets/qr_scanner.dart';

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReadyToPackProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.rackedOrder.isEmpty) {
            return const Center(child: Text('No Data Available'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.restart_alt),
                ),
                onTap: () async {
                  getData();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: provider.rackedOrder.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                                      "Order ID: ${provider.rackedOrder[index].orderId}",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (provider
                                      .rackedOrder[index].racker.approved)
                                    const FaIcon(FontAwesomeIcons.check,
                                        color: Colors.green),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Order Time: ${DateFormat('dd-MM-yyyy hh:mm a').format(provider.rackedOrder[index].updatedAt)}",
                                style: const TextStyle(
                                    fontSize: 8, color: Colors.blue),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "awb: ${provider.rackedOrder[index].awb}",
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Display each item in a separate card
                              Column(
                                children: List.generate(
                                    provider.rackedOrder[index].items!.length,
                                    (i) {
                                  return Card(
                                    elevation: 2,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ScannerWidget(
                                                onScan: (String value) {},
                                                scanned: 0,
                                                totalQty: 0,
                                                index: 0,
                                                oredrId: provider
                                                    .rackedOrder[index].orderId,
                                                isPicker: false,
                                                isPacker: false,
                                                isRacker: true,
                                                // scanned: 0,
                                                // totalQty: 1,
                                                // index: i,
                                                // isRacker: true,
                                                // isPacker:false,
                                                // isPicker:false,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Image.network(
                                                provider
                                                        .rackedOrder[index]
                                                        .items![i]
                                                        .product
                                                        .shopifyImage
                                                        .isNotEmpty
                                                    ? provider
                                                        .rackedOrder[index]
                                                        .items![i]
                                                        .product
                                                        .shopifyImage
                                                    : "https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-6.png",
                                                fit: BoxFit.cover,
                                                height: 90,
                                                // width: 80,
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
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "SKU: ${provider.rackedOrder[index].items![i].product.sku}",
                                                    style: const TextStyle(
                                                        fontSize: 8,
                                                        color: Colors.blue),
                                                  ),

                                                  // const SizedBox(height: 4),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "Quantity: ${provider.rackedOrder[index].items![i].quantity}",
                                                    style: const TextStyle(
                                                        fontSize: 8,
                                                        color: Colors.blue),
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              PaginationWidget(title: 'rack')
            ],
          );
        },
      ),
    );
  }
}
