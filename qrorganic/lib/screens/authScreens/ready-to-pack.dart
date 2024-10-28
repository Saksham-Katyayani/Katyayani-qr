// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:qrorganic/Provider/ready-to-pack-api.dart';

// class ReadyToPackPage extends StatefulWidget {
//   @override
//   _ReadyToPackPageState createState() => _ReadyToPackPageState();
// }

// class _ReadyToPackPageState extends State<ReadyToPackPage> {
//   List<bool> selectedProducts = [];
//   bool selectAll = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       getData();
//     });
//   }

//   void getData() async {
//     var readyToPackProvider = Provider.of<ReadyToPackProvider>(context, listen: false);
//     await readyToPackProvider.fetchReadyToPackOrders();
//     setState(() {
//       selectedProducts = List<bool>.filled(readyToPackProvider.orders.length, false);
//     });
//   }

//   void toggleSelectAll(bool? value) {
//     if (value != null) {
//       setState(() {
//         selectAll = value;
//         selectedProducts = List<bool>.filled(selectedProducts.length, value);
//       });
//     }
//   }

//   void toggleProductSelection(int index, bool? value) {
//     if (value != null) {
//       setState(() {
//         selectedProducts[index] = value;
//         selectAll = selectedProducts.every((element) => element);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ready to Pack', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.blueAccent,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () => getData(),
//           ),
//         ],
//       ),
//       body: Consumer<ReadyToPackProvider>(
//         builder: (context, provider, child) {
//           if (provider.orders.isEmpty) {
//             return Center(child: CircularProgressIndicator());
//           }
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Card(
//               elevation: 4,
//               child: ListView(
//                 children: [
//                   ListTile(
//                     leading: Transform.scale(
//                       scale: 1.5,
//                       child: Checkbox(
//                         value: selectAll,
//                         onChanged: toggleSelectAll,
//                         activeColor: Colors.blue,
//                       ),
//                     ),
//                     title: const Text('Select All', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   ),
//                   const Divider(thickness: 2),
//                   ...provider.orders.asMap().entries.map((entry) {
//                     final index = entry.key;
//                     final order = entry.value;
//                     final productNames = (order["items"] as List<dynamic>)
//                         .map((item) => item["product_id"]["displayName"] as String)
//                         .toList();

//                     return Column(
//                       children: [
//                         ListTile(
//                           leading: Transform.scale(
//                             scale: 1.5,
//                             child: Checkbox(
//                               value: selectedProducts[index],
//                               onChanged: (value) => toggleProductSelection(index, value),
//                               activeColor: Colors.blue,
//                             ),
//                           ),
//                           title: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text('ORDERS:', style: TextStyle(fontWeight: FontWeight.bold)),
//                               ...productNames.map((name) => Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 2.0),
//                                 child: Text(
//                                   name,
//                                   style: const TextStyle(fontSize: 16, color: Colors.black87),
//                                 ),
//                               )).toList(),
//                             ],
//                           ),
//                         ),
//                         if (index < provider.orders.length - 1) const Divider(thickness: 1),
//                       ],
//                     );
//                   }).toList(),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }