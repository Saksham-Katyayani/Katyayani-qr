// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'dart:convert';

import 'package:qrorganic/Provider/show-order-item.dart';

class ScannerWidget extends StatefulWidget {
  final String? oredrId;
   int scanned;
   int totalQty;
   int index;
  bool isPicker;
  bool isPacker;
   bool isRacker;
  final void Function(String value) onScan;

   ScannerWidget({super.key, required this.onScan,required this.scanned,required this.totalQty, this.oredrId,required this.index,this.isRacker=false,this.isPicker=false,this.isPacker=false});

  @override
  State<ScannerWidget> createState() => _ScannerState();
}

class _ScannerState extends State<ScannerWidget> with WidgetsBindingObserver {
  MobileScannerController? controller;
  StreamSubscription<Object?>? _subscription;
  
  String scannedValue = "";
  bool isScanning = true;
  // int scannedItem = 0;
  // int totalItems = 10;
  String message = '';
  bool progress = false;

  @override
  void initState() {
    super.initState();
    print('Scanned Item: ${widget.scanned} Total Items: ${widget.totalQty}');
    WidgetsBinding.instance.addObserver(this);
    _initializeScanner();
  }

  void _initializeScanner() {
    controller = MobileScannerController(
      autoStart: false,
      torchEnabled: false,
      useNewCameraSelector: true,
      facing: CameraFacing.back,
    );
    _subscription = controller?.barcodes.listen(_handleBarcode);
    _startScanner();
  }

  Future<void> _startScanner() async {
    try {
      await controller?.start();
    } catch (e) {
      print("Error starting scanner: $e");
      _disposeCurrentController();
      _initializeScanner();
    }
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (mounted) {
      final String? value = barcodes.barcodes.firstOrNull?.displayValue?.trim();
      if (value != null && isScanning) {
        var provider=Provider.of<ReadyToPackProvider>(context,listen:false);
        
       message= 'Scanned Item: ${provider.numberOfScannedProducts[widget.index]} Total Items: ${provider.numberOfProducts[widget.index]}';
        setState(() {
          scannedValue = value;
          isScanning = false;
        });
        await _scanAndFetchData(value);
      }
    }
  }

  Future<void> _scanAndFetchData(String qrCode) async {
    setState(() {
      progress = true;
    });

    var url = Uri.parse('https://inventory-management-backend-s37u.onrender.com/orders/racker');
   
    try {
      http.Response response;
     print("heee;o i am dipu  ${widget.isRacker}  ${widget.isPacker}  ${widget.isPicker}");
      if(widget.isRacker){
        response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InByYXJ0aGkyNDc0QGdtYWlsLmNvbSIsImlkIjoiNjZjYjI3NDg0MjNjNmU0NmFjZDBhYjY1IiwiaWF0IjoxNzI4OTg4MTkxLCJleHAiOjE3MjkwMzEzOTF9.45bKpgKILJMs_64UZylOxAw-LV1pQeEOffYr44lYiLs',
        },
        body: jsonEncode({"orderId":widget.oredrId, "awbNumber":qrCode}),
      );

      }else if(widget.isPacker){
         url = Uri.parse('https://inventory-management-backend-s37u.onrender.com/orders/scan/packer');
         response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InByYXJ0aGkyNDc0QGdtYWlsLmNvbSIsImlkIjoiNjZjYjI3NDg0MjNjNmU0NmFjZDBhYjY1IiwiaWF0IjoxNzI4OTg4MTkxLCJleHAiOjE3MjkwMzEzOTF9.45bKpgKILJMs_64UZylOxAw-LV1pQeEOffYr44lYiLs',
        },
        body: jsonEncode({"orderId":widget.oredrId, "sku":qrCode}),
      );

      }else{
        url = Uri.parse('https://inventory-management-backend-s37u.onrender.com/orders/scan');
         response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InByYXJ0aGkyNDc0QGdtYWlsLmNvbSIsImlkIjoiNjZjYjI3NDg0MjNjNmU0NmFjZDBhYjY1IiwiaWF0IjoxNzI4OTg4MTkxLCJleHAiOjE3MjkwMzEzOTF9.45bKpgKILJMs_64UZylOxAw-LV1pQeEOffYr44lYiLs',
        },
        body: jsonEncode({"orderId":widget.oredrId, "sku":qrCode}),
      );
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // print("here response data ${data.toString()}");
         var provider=Provider.of<ReadyToPackProvider>(context,listen:false);
        if(!widget.isRacker){
        int scannedCount = data['scannedCount'];
        widget.scanned++;
          provider.upDateScannedProducts(widget.index);
         provider.updateCheckBoxValue(widget.index,widget.scanned);
        }
        
       provider=Provider.of<ReadyToPackProvider>(context,listen:false);
        message = 'Scanned Item: ${provider.numberOfScannedProducts[widget.index]} Total Items: ${provider.numberOfProducts[widget.index]}';
        setState(() {

          
          isScanning = true;
          scannedValue = "";
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Scanned Succesfully}")));
      } else {
       
        
        setState(() {
          isScanning = true;
          scannedValue = "";
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Failed to fetch data: ${response.reasonPhrase}")));
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isScanning = true;
        scannedValue = "";
      });
    } finally {
      setState(() {
        progress = false;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        _startScanner();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _stopScanner();
        break;
      default:
        break;
    }
  }

  Future<void> _stopScanner() async {
    await _subscription?.cancel();
    _subscription = null;
    await controller?.stop();
  }

  void _disposeCurrentController() {
    _stopScanner();
    controller?.dispose();
    controller = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        appBar: AppBar(
          title: const Text("Scan QR", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Colors.black.withOpacity(0.01),
          elevation: 0,
          leading:InkWell(
            child:const Icon(Icons.arrow_back),
            onTap:()async{
              var provider= Provider.of<ReadyToPackProvider>(context,listen:false);
              if(widget.isPicker){
                // print("heeelooo i am dipu");
                provider.fetchReadyToPickOrders();
              }else if(widget.isRacker){
                 provider.fetchReadyToCheckOrders(); 
              }else{
                 provider.fetchReadyToPackOrders();
              }
                Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
           !widget.isRacker?Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 30,
                width: double.infinity,
                color: Colors.white,
                child: Center(child:  Text("Scanned : ${widget.scanned} total ${widget.totalQty}")),
              ),
            ):const Text(''),
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: progress
                    ? const Center(child: CircularProgressIndicator())
                    : MobileScanner(
                        controller: controller!,
                        errorBuilder: (context, error, child) {
                          return Center(child: Text(error.toString()));
                        },
                        placeholderBuilder: (context, val) {
                          return Center(child: Text(val.toString()));
                        },
                      ),
              ),
            ),
            
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                color: Colors.black.withOpacity(0.6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ToggleFlashlightButton(controller: controller!),
                    IconButton(
                      icon: const Icon(Icons.switch_camera, color: Colors.white, size: 32),
                      onPressed: () async {
                        await _stopScanner();
                        await controller?.switchCamera();
                        await _startScanner();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    _disposeCurrentController();
    super.dispose();
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        Icon icon;
        switch (state.torchState) {
          case TorchState.auto:
            icon = const Icon(Icons.flash_auto, color: Colors.white, size: 32);
            break;
          case TorchState.off:
            icon = const Icon(Icons.flash_off, color: Colors.white, size: 32);
            break;
          case TorchState.on:
            icon = const Icon(Icons.flash_on, color: Colors.white, size: 32);
            break;
          case TorchState.unavailable:
            return const Icon(Icons.no_flash, color: Colors.grey);
        }

        return IconButton(
          icon: icon,
          onPressed: () async {
            await controller.toggleTorch();
          },
        );
      },
    );
  }
}