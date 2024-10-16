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
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InByYXJ0aGkyNDc0QGdtYWlsLmNvbSIsImlkIjoiNjZjYjI3NDg0MjNjNmU0NmFjZDBhYjY1IiwiaWF0IjoxNzI3Nzg4MzA4LCJleHAiOjE3Mjc4MzE1MDh9.uZ6CnTG3TKdV-Nk0CZjuzMkKyQb8lLPLuev8nxQuF_4',
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
