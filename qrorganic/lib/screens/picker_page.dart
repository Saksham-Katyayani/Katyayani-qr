import 'package:flutter/material.dart';
import 'package:qrorganic/custom/pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:qrorganic/custom/colors.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';

class PickerPage extends StatefulWidget {
  const PickerPage({super.key});

  @override
  State<PickerPage> createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  int _totalPages = 1;
  bool _isLoading = false;
  bool _isPicking = false;
  List<dynamic> _extractedOrders = [];
  String? _currentlyPickedOrderId;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => getData(),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _extractedOrders.length,
              itemBuilder: (context, index) {
                final extractedOrders = _extractedOrders[index];
                return Column(
                  children: [
                    _buildOrderCard(extractedOrders),
                    const Divider(thickness: 1, color: Colors.grey),
                  ],
                );
              },
            ),
          ),
          PaginationWidget(title: 'pick')
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    Map<String, dynamic> order,
  ) {
    // order['items][index]['product_id'][]
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
                      itemCount: order['items'].length,
                      itemBuilder: (context, index) {
                        return Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: SizedBox(
                                        width: 60, // Smaller image size
                                        height: 60,
                                        child: order['items'][index]
                                                            ['product_id']
                                                        ['shopifyImage'] !=
                                                    null &&
                                                order['items'][index]
                                                            ['product_id']
                                                        ['shopifyImage']
                                                    .isNotEmpty
                                            ? Image.network(
                                                '${order['items'][index]['product_id']['shopifyImage']}',
                                              )
                                            : const Icon(
                                                Icons.image_not_supported,
                                                size: 40, // Fallback icon size
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
                                            order['items'][index]['product_id']
                                                ['displayName'],
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
                                                      text: order['items']
                                                                  [index]
                                                              ['product_id']
                                                          ['parentSku'],
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
                                              // const SizedBox(width: 20),
                                              // RichText(
                                              //   text: TextSpan(
                                              //     children: [
                                              //       const TextSpan(
                                              //         text: 'Amount: ',
                                              //         style: TextStyle(
                                              //           color:
                                              //               Colors.blueAccent,
                                              //           fontWeight:
                                              //               FontWeight.bold,
                                              //           fontSize: 12,
                                              //         ),
                                              //       ),
                                              //       TextSpan(
                                              //         text: order['items']
                                              //                         [index]
                                              //                     ['product_id']
                                              //                 ['mrp']
                                              //             .toString(),
                                              //         style: const TextStyle(
                                              //           color: Colors.black87,
                                              //           fontWeight:
                                              //               FontWeight.w500,
                                              //           fontSize: 12,
                                              //         ),
                                              // ),
                                              // ],
                                              // ),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // const Spacer(), // Ensures `qty` is aligned to the right end
                                    const Text(
                                      "x",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    // const Spacer(), // Ensures `qty` is aligned to the right end
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 2.0),
                                      child: Center(
                                        child: Text(
                                          (order['items'][index]['product_id']
                                                      ['itemQty'] *
                                                  order['items'][index]['qty'])
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                buildCell(
                  Text(
                    "${order['picklistId']}",
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
                      text: "Created on: ",
                      children: [
                        TextSpan(
                          text: DateFormat('dd-MM-yyyy, hh:mm a').format(
                            DateTime.parse("${order['createdAt']}").toLocal(),
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      )),
                ),
                ElevatedButton(
                  onPressed: () {
                    final formattedDate = DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(order['createdAt']).toLocal());
                    pickOrder(order['picklistId'], formattedDate);
                  },
                  child: _currentlyPickedOrderId == order['picklistId'] &&
                          _isPicking
                      ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Picked"),
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

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    const url =
        'https://inventory-management-backend-s37u.onrender.com/order-picker?isConfirmed=false';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        log(data['data'].runtimeType.toString());

        setState(() {
          _extractedOrders = data['data'];
        });

        log("_extractedOrders: $_extractedOrders");
        log("${_extractedOrders.length}");
      } else {
        // Handle non-success responses
      }
    } catch (e) {
      // Handle errors
      log(e.toString());
      setState(() {
        _extractedOrders = [];
        _totalPages = 1;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> pickOrder(String picklistId, String createdAt) async {
    setState(() {
      _isPicking = true;
      _currentlyPickedOrderId = picklistId;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    var url =
        'https://inventory-management-backend-s37u.onrender.com/order-picker/confirm?picklistId=$picklistId&date=$createdAt';

    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      final data = json.decode(response.body);
      String msg = data['error']['message'];
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show success snackbar with green background
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Handle non-success responses with red background
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle errors with red background
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isPicking = false;
        _currentlyPickedOrderId = null;
      });
    }
  }
}
