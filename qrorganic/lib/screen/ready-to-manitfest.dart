import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
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
    var readyToPackProvider = Provider.of<ReadyToPackProvider>(context, listen: false);
    await readyToPackProvider.fetchReadyToManiFestOrders();
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

          if (provider.manifestOrder.isEmpty) {
            return const Center(child: Text('No Data Available'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: provider.manifestOrder.length,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Order ID: ${provider.manifestOrder[index].orderId}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (provider.manifestOrder[index].mainFest.approved)
                              const FaIcon(FontAwesomeIcons.check, color: Colors.green),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Display each item in a separate card
                        Column(
                          children: List.generate(provider.manifestOrder[index].items!.length, (i) {
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
                                        builder: (context) => const CameraScreen(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTprI6-IHZrDj6tSyBRlbmUnRb6CuDfZYIQVoPNpHEBtjg1atSd-B_LlhBdT7fJpWqFQWM&usqp=CAU",
                                          fit: BoxFit.cover,
                                          height: 80,
                                          width: 80,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              provider.manifestOrder[index].items![i].product.displayName,
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "SKU: ${provider.manifestOrder[index].items![i].product.sku}",
                                              style: const TextStyle(fontSize: 14, color: Colors.blue),
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
                        // const Divider(thickness: 1),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
