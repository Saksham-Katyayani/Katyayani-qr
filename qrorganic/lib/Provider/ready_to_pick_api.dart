import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReadyToPickProvider with ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get orders => _orders;
  bool get isLoading => _isLoading;

  final String _baseUrl =
      'https://inventory-management-backend-s37u.onrender.com';

  Future<Map<String, dynamic>> fetchReadyToPickOrders() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('$_baseUrl/orders?orderStatus=4');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InNha3NoYW0uZGV2QGthdHlheWFuaW9yZ2FuaWNzLmNvbSIsImlkIjoiNjZjNTc5ZGJmNTA1YTA0OWE4YjVjMzA3IiwiaWF0IjoxNzI5NTk4MzgwLCJleHAiOjE3Mjk2NDE1ODB9.bT9Q3pUhaHJu-e6OZJ_1n2eQ_ifsj4pNZk1m7_TPQW8',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('orders')) {
          _orders = List<Map<String, dynamic>>.from(data["orders"]);
          print("Divyansh Patidar: ${data["currentPage"]} ${data["totalPages"]}");
          return {'success': true, 'data': _orders};
        } else {
          print('Unexpected response format: $data');
          return {'success': false, 'message': 'Unexpected response format'};
        }
      } else {
        return {
          'success': false,
          'message':
              'Failed to fetch orders with status code: ${response.statusCode}'
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
