// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';

class WightEnter extends StatefulWidget {
  String orderId;
  WightEnter({super.key, required this.orderId});

  @override
  State<WightEnter> createState() => _WightEnterState();
}

class _WightEnterState extends State<WightEnter> {
  TextEditingController controller = TextEditingController();
  bool isLoading = false; // Track the loading state

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Weight"),
        elevation: 4,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Please enter the weight:",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Enter weight in kg",
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                prefixIcon: const Icon(Icons.monitor_weight, color: Colors.teal),
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator() // Show loader when loading
                : ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                controller.clear();
              },
              child: const Text(
                "Clear",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> onPressed() async {
    
    if (controller.text.isEmpty || double.tryParse(controller.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid weight."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('${ReadyToPackProvider().baseUrl}/orders/checker');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InByYXJ0aGkyNDc0QGdtYWlsLmNvbSIsImlkIjoiNjZjYjI3NDg0MjNjNmU0NmFjZDBhYjY1IiwiaWF0IjoxNzI4NTc3MTMyLCJleHAiOjE3Mjg2MjAzMzJ9.sCM6xurdP8TLKuigxVcgmU8vkpDBncGQbX2Nv8741FI',
        },
        body: jsonEncode({
          "orderId": widget.orderId,
          "enteredWeight": double.parse(controller.text)
        }),
      );
      final data=jsonDecode(response.body);
      if (data["checker"]["approved"]==true) {
        // print(response.body.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body.toString()),
            duration: const Duration(seconds: 2),
          ),
        );
        Provider.of<ReadyToPackProvider>(context,listen:false).fetchReadyToCheckOrders();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${jsonDecode(response.body)["message"]}"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed: $error"),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }
}
