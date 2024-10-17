import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/custom/pagination.dart';
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
    var readyToPackProvider = Provider.of<ReadyToPackProvider>(context, listen: false);
    await readyToPackProvider.fetchReadyToCheckOrders();
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

          if (provider.checkOrder.isEmpty) {
            return const Center(child: Text('No Data Available'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.checkOrder.length,
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
                                      "Order ID: ${provider.checkOrder[index].orderId}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (provider.checkOrder[index].checker.approved)
                                    const FaIcon(FontAwesomeIcons.check, color: Colors.green),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Displaying each item as a separate card
                              Column(
                                children: List.generate(provider.checkOrder[index].items!.length, (i) {
                                  return Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => WightEnter(orderId: provider.checkOrder[index].orderId),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Image.network(provider.checkOrder[index].items![i].product.shopifyImage.isNotEmpty?provider.checkOrder[index].items![i].product.shopifyImage:
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
                                                    provider.checkOrder[index].items![i].product.displayName,
                                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "SKU: ${provider.checkOrder[index].items![i].product.sku}",
                                                    style: const TextStyle(fontSize: 14, color: Colors.blue),
                                                  ),
                                                  const SizedBox(height: 4),
                                                   Text(
                                                        "Order Time: ${DateFormat('dd-MM-yyyy hh:mm a').format(provider.checkOrder[index].items![i].product.upDatedAt)}",
                                                        style: const TextStyle(fontSize: 14, color: Colors.blue),
                                                      ),
                                                      const SizedBox(height: 4),
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
                PaginationWidget(title:'check')
              ],
            ),
          );
        },
      ),
    );
  }
}
