import 'package:flutter/material.dart';
import 'package:qrorganic/Model/manifest_model.dart';
import 'package:qrorganic/custom/pagination.dart';
import 'package:qrorganic/screens/camera-screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:qrorganic/custom/colors.dart';
import 'package:qrorganic/Model/order_model.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';

// no gallery, submit buttom pop, refersh

class ReadyToManiFest extends StatefulWidget {
  const ReadyToManiFest({super.key});

  @override
  State<ReadyToManiFest> createState() => _ReadyToManiFestState();
}

class _ReadyToManiFestState extends State<ReadyToManiFest> {
  int _totalPages = 1;
  int _currentPage = 1;
  bool _isLoading = true;
  List<Order> _orders = [];
  List<Manifest> _manifests = [];

  @override
  void initState() {
    super.initState();
    getData(1);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => getData(1),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (_manifests.isEmpty)
                  const Center(
                    child: Text(
                      'No Orders Found',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    itemCount: _manifests.length,
                    itemBuilder: (context, index) {
                      final manifest = _manifests[index];
                      log("manifest: ${manifest.orders}");
                      return Column(
                        children: [
                          _buildManifest(manifest),
                          const Divider(thickness: 1, color: Colors.grey),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
          PaginationWidget(title: "manifest"),
        ],
      ),
    );
  }

  Widget _buildManifest(Manifest manifest) {
    log("lengthhhhhhhh: ${manifest.orders.length}");
    log("order: ${manifest.orders[0].orderId}");

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: manifest.orders.length,
          itemBuilder: (context, index) {
            log("saksham");
            // return Text("rom rom bhaiyon");
            return _buildOrderCard(manifest.manifestId, manifest.orders[index]);
          },
        ),
        // const SizedBox(width: 20),
        // buildCell(
        //   Column(
        //     children: [
        //       Text(
        //         manifest.manifestId,
        //         style: const TextStyle(
        //           fontWeight: FontWeight.bold,
        //           fontSize: 16,
        //           color: Colors.blueAccent,
        //         ),
        //       ),
        //       // Text(
        //       //   "(${manifest.deliveryPartner})",
        //       //   style: const TextStyle(
        //       //     fontSize: 16,
        //       //   ),
        //       // ),
        //     ],
        //   ),
        //   flex: 1,
        // ),
      ],
    );
  }

  Widget _buildOrderCard(String manifestId, Order order) {
    log("Hi: $order");
    return Card(
      color: AppColors.white,
      elevation: 4, // Reduced elevation for less shadow
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12), // Slightly smaller rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 15,
                  child: SizedBox(
                    // height: 200, // Removed fixed height
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap:
                          true, // Allow ListView to take necessary height
                      itemCount: order.items.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CameraScreen(
                                  manifestId: manifestId,
                                ),
                              ),
                            );
                            if (result == true) {
                              getData(1);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(
                                  10), // Slightly smaller rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                      0.08), // Lighter shadow for smaller card
                                  offset: const Offset(0, 1),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  10.0), // Reduced padding inside product card
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: SizedBox(
                                          width: 60, // Smaller image size
                                          height: 60,
                                          child: order.items[index].product!
                                                          .shopifyImage !=
                                                      null &&
                                                  order.items[index].product!
                                                      .shopifyImage!.isNotEmpty
                                              ? Image.network(
                                                  '${order.items[index].product!.shopifyImage}',
                                                )
                                              : const Icon(
                                                  Icons.image_not_supported,
                                                  size:
                                                      40, // Fallback icon size
                                                  color: AppColors.grey,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              8.0), // Reduced spacing between image and text
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              order.items[index].product!
                                                  .displayName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                                height:
                                                    6.0), // Reduced spacing between text elements
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'SKU: ',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.blueAccent,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: order.items[index]
                                                            .product!.sku,
                                                        style: const TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                buildCell(
                  Text(
                    manifestId,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.blueAccent,
                    ),
                  ),
                  flex: 3,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                      text: "Updated on: ",
                      children: [
                        TextSpan(
                            text: DateFormat('dd-MM-yyyy\',\' hh:mm a').format(
                              DateTime.parse("${order.updatedAt}"),
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            )),
                      ],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCell(Widget content, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
        child: Center(child: content),
      ),
    );
  }

  Future<void> getData(int page) async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    var url =
        'https://inventory-management-backend-s37u.onrender.com/manifest?page=$page';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      log("Code: ${response.statusCode}");
      log("Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Manifest> manifests = (data['data']['manifest'] as List)
            .map((manifest) => Manifest.fromJson(manifest))
            .toList();
        log(manifests.toString());

        setState(() {
          _totalPages = data['data']['totalPages'];
          _currentPage =
              data['data']['currentPage']; // Get total pages from response
          _manifests = manifests; // Set the orders for the
        });
      } else {
        // Handle non-success responses
        setState(() {
          _manifests = [];
          _totalPages = 1;
        });
      }
    } catch (e) {
      // Handle errors
      log("catch data $e");
      setState(() {
        _orders = [];
        _totalPages = 1;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
