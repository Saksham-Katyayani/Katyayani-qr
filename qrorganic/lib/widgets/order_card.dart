// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:qrorganic/custom/colors.dart'; // Adjust the import based on your project structure
// // import 'package:qrorganic/edit_order_page.dart';
// import 'package:qrorganic/Model/order_model.dart';
// import 'package:provider/provider.dart';

// // import '../provider/orders_provider.dart'; // Adjust the import based on your project structure

// class OrderCard extends StatelessWidget {
//   final Order order;
//   final bool isBookPage;
//   final Widget? checkboxWidget;

//   const OrderCard(
//       {super.key,
//       required this.order,
//       this.isBookPage = false,
//       this.checkboxWidget});

//   @override
//   Widget build(BuildContext context) {
//     // final provider = Provider.of<OrdersProvider>(context, listen: false);
//     print('Building OrderCard for Order ID: ${order.id}');
//     return Card(
//       color: AppColors.white,
//       elevation: 4, // Reduced elevation for less shadow
//       shape: RoundedRectangleBorder(
//         borderRadius:
//             BorderRadius.circular(12), // Slightly smaller rounded corners
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//       child: Padding(
//         padding:
//             const EdgeInsets.all(12.0), // Reduced padding for a smaller card
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     if (isBookPage && checkboxWidget != null) checkboxWidget!,
//                     Text(
//                       'Order ID: ${order.orderId}',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                         color: Colors.blueAccent,
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (isBookPage)
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EditOrderPage(
//                             order: order,
//                             isBookPage: true,
//                           ),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 6.0, vertical: 2.0),
//                       foregroundColor: AppColors.white,
//                       backgroundColor: AppColors.orange,
//                       textStyle: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 10,
//                       ),
//                     ),
//                     child: const Text(
//                       'Edit Order',
//                       style: TextStyle(fontSize: 10),
//                     ),
//                   ),

//                 //Text('Tracking Status: ${order.trackingStatus}'),
//               ],
//             ),
//             if (isBookPage) ...[
//               Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Flexible(
//                           flex: 2,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               buildLabelValueRow(
//                                   'Date', provider.formatDate(order.date!)),
//                               buildLabelValueRow('Total Amount',
//                                   'Rs. ${order.totalAmount ?? ''}'),
//                               buildLabelValueRow('Total Items',
//                                   '${order.items.fold(0, (total, item) => total + item.qty!)}'),
//                               buildLabelValueRow(
//                                   'Total Weight', '${order.totalWeight ?? ''}'),
//                               buildLabelValueRow(
//                                   'Payment Mode', order.paymentMode ?? ''),
//                               buildLabelValueRow(
//                                   'Currency Code', order.currencyCode ?? ''),
//                               buildLabelValueRow('COD Amount',
//                                   order.codAmount.toString() ?? ''),
//                               buildLabelValueRow(
//                                   'AWB No.', order.awbNumber.toString() ?? ''),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 8.0),
//                         Flexible(
//                           flex: 2,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               buildLabelValueRow('Discount Amount',
//                                   order.discountAmount.toString() ?? ''),
//                               buildLabelValueRow('Discount Scheme',
//                                   order.discountScheme ?? ''),
//                               buildLabelValueRow('Agent', order.agent ?? ''),
//                               buildLabelValueRow('Notes', order.notes ?? ''),
//                               buildLabelValueRow(
//                                   'Marketplace', order.marketplace?.name ?? ''),
//                               buildLabelValueRow('Filter', order.filter ?? ''),
//                               buildLabelValueRow(
//                                 'Expected Delivery Date',
//                                 order.expectedDeliveryDate != null
//                                     ? provider
//                                         .formatDate(order.expectedDeliveryDate!)
//                                     : '',
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 8.0),
//                         Flexible(
//                           flex: 2,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               buildLabelValueRow(
//                                   'Delivery Term', order.deliveryTerm ?? ''),
//                               buildLabelValueRow('Transaction Number',
//                                   order.transactionNumber ?? ''),
//                               buildLabelValueRow('Micro Dealer Order',
//                                   order.microDealerOrder ?? ''),
//                               buildLabelValueRow('Fulfillment Type',
//                                   order.fulfillmentType ?? ''),
//                               buildLabelValueRow('No. of Boxes',
//                                   order.numberOfBoxes.toString() ?? ''),
//                               buildLabelValueRow('Total Quantity',
//                                   order.totalQuantity.toString() ?? ''),
//                               buildLabelValueRow(
//                                   'SKU Qty', order.skuQty.toString() ?? ''),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 8.0),
//                         Flexible(
//                           flex: 2,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               buildLabelValueRow(
//                                 'Dimensions',
//                                 '${order.length.toString() ?? ''} x ${order.breadth.toString() ?? ''} x ${order.height.toString() ?? ''}',
//                               ),
//                               buildLabelValueRow('Tracking Status',
//                                   order.trackingStatus ?? ''),
//                               const SizedBox(
//                                 height: 7,
//                               ),
//                               buildLabelValueRow('Tax Percent',
//                                   '${order.taxPercent.toString() ?? ''}%'),
//                               buildLabelValueRow(
//                                   'Courier Name', order.courierName ?? ''),
//                               buildLabelValueRow(
//                                   'Order Type', order.orderType ?? ''),
//                               buildLabelValueRow(
//                                   'Payment Bank', order.paymentBank ?? ''),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 8.0),
//                         Flexible(
//                           flex: 2,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               buildLabelValueRow('Prepaid Amount',
//                                   order.prepaidAmount.toString() ?? ''),
//                               buildLabelValueRow(
//                                   'Coin', order.coin.toString() ?? ''),
//                               buildLabelValueRow('Preferred Courier',
//                                   order.preferredCourier ?? ''),
//                               buildLabelValueRow(
//                                 'Payment Date Time',
//                                 order.paymentDateTime != null
//                                     ? provider
//                                         .formatDateTime(order.paymentDateTime!)
//                                     : '',
//                               ),
//                               buildLabelValueRow('Calc Entry No.',
//                                   order.calcEntryNumber ?? ''),
//                               buildLabelValueRow(
//                                   'Currency', order.currency ?? ''),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(
//                       thickness: 1,
//                       color: AppColors.grey,
//                     ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Flexible(
//                           flex: 3,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Customer Details:',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 11.0,
//                                     color: AppColors.primaryBlue),
//                               ),
//                               buildLabelValueRow(
//                                 'Customer ID',
//                                 order.customer?.customerId ?? '',
//                               ),
//                               buildLabelValueRow(
//                                   'Full Name',
//                                   order.customer?.firstName !=
//                                           order.customer?.lastName
//                                       ? '${order.customer?.firstName ?? ''} ${order.customer?.lastName ?? ''}'
//                                           .trim()
//                                       : order.customer?.firstName ?? ''),
//                               buildLabelValueRow(
//                                 'Email',
//                                 order.customer?.email ?? '',
//                               ),
//                               buildLabelValueRow(
//                                 'Phone',
//                                 order.customer?.phone?.toString() ?? '',
//                               ),
//                               buildLabelValueRow(
//                                 'GSTIN',
//                                 order.customer?.customerGstin ?? '',
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 8.0),
//                         Flexible(
//                           flex: 3,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Shipping Address:',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 11.0,
//                                     color: AppColors.primaryBlue),
//                               ),
//                               buildLabelValueRow(
//                                 'Address',
//                                 [
//                                   order.shippingAddress?.address1,
//                                   order.shippingAddress?.address2,
//                                   order.shippingAddress?.city,
//                                   order.shippingAddress?.state,
//                                   order.shippingAddress?.country,
//                                   order.shippingAddress?.pincode?.toString(),
//                                 ]
//                                     .where((element) =>
//                                         element != null && element.isNotEmpty)
//                                     .join(', '),
//                               ),
//                               buildLabelValueRow(
//                                 'Name',
//                                 order.shippingAddress?.firstName !=
//                                         order.shippingAddress?.lastName
//                                     ? '${order.shippingAddress?.firstName ?? ''} ${order.shippingAddress?.lastName ?? ''}'
//                                         .trim()
//                                     : order.shippingAddress?.firstName ?? '',
//                               ),
//                               buildLabelValueRow(
//                                   'Phone',
//                                   order.shippingAddress?.phone?.toString() ??
//                                       ''),
//                               buildLabelValueRow(
//                                   'Email', order.shippingAddress?.email ?? ''),
//                               buildLabelValueRow('Country Code',
//                                   order.shippingAddress?.countryCode ?? ''),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 8.0),
//                         Flexible(
//                           flex: 3,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Billing Address:',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 11.0,
//                                     color: AppColors.primaryBlue),
//                               ),
//                               buildLabelValueRow(
//                                 'Address',
//                                 [
//                                   order.billingAddress?.address1,
//                                   order.billingAddress?.address2,
//                                   order.billingAddress?.city,
//                                   order.billingAddress?.state,
//                                   order.billingAddress?.country,
//                                   order.billingAddress?.pincode?.toString(),
//                                 ]
//                                     .where((element) =>
//                                         element != null && element.isNotEmpty)
//                                     .join(', '),
//                               ),
//                               buildLabelValueRow(
//                                 'Name',
//                                 order.billingAddress?.firstName !=
//                                         order.billingAddress?.lastName
//                                     ? '${order.billingAddress?.firstName ?? ''} ${order.billingAddress?.lastName ?? ''}'
//                                         .trim()
//                                     : order.billingAddress?.firstName ?? '',
//                               ),
//                               buildLabelValueRow(
//                                   'Phone',
//                                   order.billingAddress?.phone?.toString() ??
//                                       ''),
//                               buildLabelValueRow(
//                                   'Email', order.billingAddress?.email ?? ''),
//                               buildLabelValueRow('Country Code',
//                                   order.billingAddress?.countryCode ?? ''),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//             // Text.rich(
//             //   TextSpan(
//             //       text: "Updated on: ",
//             //       children: [
//             //         TextSpan(
//             //             text: DateFormat('dd-MM-yyyy\',\' hh:mm a').format(
//             //               DateTime.parse("${order.updatedAt}"),
//             //             ),
//             //             style: const TextStyle(
//             //               fontWeight: FontWeight.normal,
//             //             )),
//             //       ],
//             //       style: const TextStyle(
//             //         fontWeight: FontWeight.bold,
//             //       )),
//             // ),
//             // const SizedBox(
//             //   height: 8,
//             // ),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: order.items.length,
//               itemBuilder: (context, itemIndex) {
//                 final item = order.items[itemIndex];
//                 print(
//                     'Item $itemIndex: ${item.product?.displayName.toString() ?? ''}, Quantity: ${item.qty ?? 0}');
//                 return _buildProductDetails(item);
//               },
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text.rich(
//                   TextSpan(
//                       text: "Updated on: ",
//                       children: [
//                         TextSpan(
//                             text: DateFormat('dd-MM-yyyy\',\' hh:mm a').format(
//                               DateTime.parse("${order.updatedAt}"),
//                             ),
//                             style: const TextStyle(
//                               fontWeight: FontWeight.normal,
//                             )),
//                       ],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       )),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductDetails(Item item) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.lightGrey,
//         borderRadius:
//             BorderRadius.circular(10), // Slightly smaller rounded corners
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black
//                 .withOpacity(0.08), // Lighter shadow for smaller card
//             offset: const Offset(0, 1),
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Padding(
//         padding:
//             const EdgeInsets.all(10.0), // Reduced padding inside product card
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildProductImage(item),
//             const SizedBox(
//                 width: 8.0), // Reduced spacing between image and text
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildProductName(item),
//                   const SizedBox(
//                       height: 6.0), // Reduced spacing between text elements
//                   Row(
//                     mainAxisAlignment:
//                         MainAxisAlignment.spaceBetween, // Space between widgets
//                     children: [
//                       // SKU at the extreme left
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             const TextSpan(
//                               text: 'SKU: ',
//                               style: TextStyle(
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13, // Reduced font size
//                               ),
//                             ),
//                             TextSpan(
//                               text: item.product?.sku ?? 'N/A',
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 13, // Reduced font size
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Qty in the center
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             const TextSpan(
//                               text: 'Qty: ',
//                               style: TextStyle(
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13, // Reduced font size
//                               ),
//                             ),
//                             TextSpan(
//                               text: item.qty?.toString() ?? '0',
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 13, // Reduced font size
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Rate
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             const TextSpan(
//                               text: 'Rate: ',
//                               style: TextStyle(
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13, // Reduced font size
//                               ),
//                             ),
//                             TextSpan(
//                               text:
//                                   'Rs.${(item.amount! / item.qty!).toStringAsFixed(1)}',
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 13, // Reduced font size
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Amount at the extreme right
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             const TextSpan(
//                               text: 'Amount: ',
//                               style: TextStyle(
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13, // Reduced font size
//                               ),
//                             ),
//                             TextSpan(
//                               text: 'Rs.${item.amount.toString()}',
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 13, // Reduced font size
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildLabelValueRow(
//     String label,
//     String? value, {
//     Color labelColor = Colors.black,
//     Color valueColor = AppColors.primaryBlue,
//     double fontSize = 10,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '$label: ',
//           style: TextStyle(
//             fontSize: fontSize,
//             color: labelColor,
//           ),
//         ),
//         Flexible(
//           child: Text(
//             value ?? '',
//             softWrap: true,
//             maxLines: null,
//             style: TextStyle(
//               fontSize: fontSize,
//               color: valueColor,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildProductImage(Item item) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(6),
//       child: SizedBox(
//         width: 60, // Smaller image size
//         height: 60,
//         child: item.product?.shopifyImage != null &&
//                 item.product!.shopifyImage!.isNotEmpty
//             ? Image.network(
//                 item.product!.shopifyImage!,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Icon(
//                     Icons.image_not_supported,
//                     size: 40, // Smaller fallback icon size
//                     color: AppColors.grey,
//                   );
//                 },
//               )
//             : const Icon(
//                 Icons.image_not_supported,
//                 size: 40, // Smaller fallback icon size
//                 color: AppColors.grey,
//               ),
//       ),
//     );
//   }

//   Widget _buildProductName(Item item) {
//     return Text(
//       item.product?.displayName ?? 'No Name',
//       style: const TextStyle(
//         fontWeight: FontWeight.w600,
//         fontSize: 14, // Reduced font size
//         color: Colors.black87,
//       ),
//       maxLines: 2,
//       overflow: TextOverflow.ellipsis,
//     );
//   }
// }
