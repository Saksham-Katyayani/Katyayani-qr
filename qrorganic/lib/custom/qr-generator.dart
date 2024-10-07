// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerator extends StatefulWidget {
  @override
  State<QrGenerator> createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  @override
  Widget build(BuildContext context) {
    const String message = 'Scanned Item: 0 \nTotal Items: 10';

    // Get the available height of the screen
    double screenHeight = MediaQuery.of(context).size.height;
    double qrCodeSize = screenHeight * 0.4; // 40% of screen height, adjust as needed
    qrCodeSize = qrCodeSize < 200 ? 200 : qrCodeSize; // Minimum size of 200

    return Scaffold(
      appBar:AppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffc2e9fb),
              Color(0xffa1c4fd),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: qrCodeSize,
                      height: qrCodeSize, // Set dynamic height
                      child: QrImageView(
                        data: message,
                        version: QrVersions.auto,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xff128760),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xff1a5441),
                        ),
                        embeddedImage: AssetImage(
                          'assets/images/4.0x/logo_yakka_transparent.png',
                        ),
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: const Size.square(40),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(2, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1a5441),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Scan the QR code to retrieve the information',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Icon(
                          Icons.qr_code_2,
                          size: 40,
                          color: Color(0xff1a5441),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
