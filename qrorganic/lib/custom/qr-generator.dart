// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http; // Import the http package
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'dart:convert'; // For jsonEncode

// class ScannerWidget extends StatefulWidget {
//   final String? title;
//   final void Function(String value) onScan;

//   const ScannerWidget({super.key, required this.onScan, this.title});

//   @override
//   State<ScannerWidget> createState() => _ScannerState();
// }

// class _ScannerState extends State<ScannerWidget> with WidgetsBindingObserver {
//   final MobileScannerController controller = MobileScannerController(
//     autoStart: true,
//     torchEnabled: false,
//     useNewCameraSelector: true,
//     facing: CameraFacing.back,
//   );

//   StreamSubscription<Object?>? _subscription;
//   String scannedValue = "";
//   bool isScanning = true;
//   int scannedItem = 0;
//   int totalItems = 10; // Assume a total items count; update this as needed
//   String message = 'Scanned Item: 0 \nTotal Items: 10';

//   void _handleBarcode(BarcodeCapture barcodes) async {
//     if (mounted) {
//       final String? value = barcodes.barcodes.firstOrNull?.displayValue?.trim();
//       if (value != null && isScanning) {
//         setState(() {
//           scannedValue = value;
//           isScanning = false; 
//         });
//         await _scanAndFetchData(value);
//       }
//     }
//   }

//   Future<void> _scanAndFetchData(String qrCode) async {
//     // Make the API call here
//     final response = await http.get(Uri.parse('https://example.com/api/items?code=$qrCode'));

//     if (response.statusCode == 200) {
//       // Assuming the response is a JSON object with the scanned item count
//       final data = jsonDecode(response.body);
//       int scannedCount = data['scannedCount']; // Adjust according to your API response

//       setState(() {
//         scannedItem = scannedCount; // Update scanned item count
//         message = 'Scanned Item: $scannedItem \nTotal Items: $totalItems';
//         isScanning = true; // Ready for another scan
//         scannedValue = ""; // Reset scanned value
//       });
//     } else {
//       // Handle the error accordingly
//       print('Failed to fetch data: ${response.reasonPhrase}');
//       setState(() {
//         isScanning = true; // Reset scanning state
//         scannedValue = ""; // Reset scanned value
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _subscription = controller.barcodes.listen(_handleBarcode);
//     unawaited(controller.start());
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (!controller.value.isInitialized) {
//       return;
//     }

//     switch (state) {
//       case AppLifecycleState.resumed:
//         _subscription = controller.barcodes.listen(_handleBarcode);
//         unawaited(controller.start());
//         break;
//       case AppLifecycleState.inactive:
//       case AppLifecycleState.paused:
//         unawaited(_subscription?.cancel());
//         _subscription = null;
//         unawaited(controller.stop());
//         break;
//       default:
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String title = widget.title ?? 'Scan Your Badge';

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.blueGrey[900],
//         appBar: AppBar(
//           title: const Text("Scan QR", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
//           backgroundColor: Colors.black.withOpacity(0.01),
//           elevation: 0,
//         ),
//         body: Stack(
//           children: [
//             Center(
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 width: 300,
//                 height: 300,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10.0,
//                       spreadRadius: 2.0,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: MobileScanner(
//                   controller: controller,
//                   errorBuilder: (context, error, child) {
//                     return Center(child: Text(error.toString()));
//                   },
//                   placeholderBuilder: (context, val) {
//                     return Center(child: Text(val.toString()));
//                   },
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 80,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: AnimatedOpacity(
//                   opacity: scannedValue.isNotEmpty ? 1.0 : 0.0,
//                   duration: Duration(milliseconds: 300),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(30),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 8.0,
//                           spreadRadius: 2.0,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Text(
//                       message,
//                       style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff1a5441)),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: 80,
//                 color: Colors.black.withOpacity(0.6),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ToggleFlashlightButton(controller: controller),
//                     IconButton(
//                       icon: const Icon(Icons.switch_camera, color: Colors.white, size: 32),
//                       onPressed: () async {
//                         await controller.stop();
//                         await controller.switchCamera();
//                         await controller.start();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Future<void> dispose() async {
//     WidgetsBinding.instance.removeObserver(this);
//     unawaited(_subscription?.cancel());
//     _subscription = null;
//     super.dispose();
//     await controller.dispose();
//   }
// }

// class ToggleFlashlightButton extends StatelessWidget {
//   const ToggleFlashlightButton({required this.controller, super.key});

//   final MobileScannerController controller;

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: controller,
//       builder: (context, state, child) {
//         if (!state.isInitialized || !state.isRunning) {
//           return const SizedBox.shrink();
//         }

//         Icon icon;
//         switch (state.torchState) {
//           case TorchState.auto:
//             icon = const Icon(Icons.flash_auto, color: Colors.white, size: 32);
//             break;
//           case TorchState.off:
//             icon = const Icon(Icons.flash_off, color: Colors.white, size: 32);
//             break;
//           case TorchState.on:
//             icon = const Icon(Icons.flash_on, color: Colors.white, size: 32);
//             break;
//           case TorchState.unavailable:
//             return const Icon(Icons.no_flash, color: Colors.grey);
//         }

//         return IconButton(
//           icon: icon,
//           onPressed: () async {
//             await controller.toggleTorch();
//           },
//         );
//       },
//     );
//   }
// }
