import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:qrorganic/Model/order-response-model.dart';
// import 'auth_provider.dart'; // Import your AuthProvider if it's in a separate file

class ReadyToPackProvider with ChangeNotifier {
  List<ModelByDipu> _orders = [];
  bool _isLoading = false;
  List<bool>_checkbox=[];

  List<ModelByDipu> get orders => _orders;
  bool get isLoading => _isLoading;
  List<bool> get checkBox => _checkbox;

  // Change this to your actual base URL if needed
  final String _baseUrl = 'https://inventory-management-backend-s37u.onrender.com';

  void generateNumberOfCheckBox(){
    _checkbox=List.generate(_orders.length, (index) =>false);
  }
    void updateCheckBoxStatus(int a){
    _checkbox[a]=!_checkbox[a];
    notifyListeners();
  }
  
  Future<Map<String, dynamic>> fetchReadyToPackOrders() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('$_baseUrl/orders?orderStatus=4');

    try {
      // final token = await AuthProvider().getToken(); // Get the token for authorization
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InByYXJ0aGkyNDc0QGdtYWlsLmNvbSIsImlkIjoiNjZjYjI3NDg0MjNjNmU0NmFjZDBhYjY1IiwiaWF0IjoxNzI4MjMxMTI2LCJleHAiOjE3MjgyNzQzMjZ9.eJXPvixitrlunTUj3PWQr8a6zdAb77ZhXO70VCnZQPU', // Include the token in the headers
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('orders')) {
            _orders=(data["orders"] as List)
      .map((orderJson) => ModelByDipu.fromJson(orderJson))
      .toList();
      generateNumberOfCheckBox();
      print("herec is length of data ${_orders[1].items![0].product.displayName}");
          return {'success': true, 'data': _orders}; // Return the data in structured format
        } else {
          print('Unexpected response format: $data');
          return {'success': false, 'message': 'Unexpected response format'};
        }
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch orders with status code: ${response.statusCode}'
        };
      }
    } catch (error) {
      return {'success': false, 'message': 'An error occurred: $error'};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
