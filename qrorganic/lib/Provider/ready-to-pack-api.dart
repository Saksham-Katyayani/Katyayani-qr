// // ignore_for_file: prefer_final_fields

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:qrorganic/Model/order-response-model.dart';
// // import 'auth_provider.dart'; // Import your AuthProvider if it's in a separate file

// class ReadyToPackProvider with ChangeNotifier {
//   List<ModelByDipu> _orders = [];
//   List<ModelByDipu> _checkOrder = [];
//   List<ModelByDipu> _rackedOrder = [];
//   List<ModelByDipu> _manifestOrder = [];
//   List<ModelByDipu> _pickOrder = [];
//   bool _isLoading = false;
//   List<bool>_checkbox=[];
//   List<bool>_rtmcheckbox=[];
//   List<bool>_rtccheckbox=[];
//   List<bool>_rtrcheckbox=[];
//   List<bool>_pickcheckbox=[];
//   List<List<bool>>?_orderItemCheckBox;
//   bool _showData=true;
  
//   List<String>_productTitle=[];
//   List<int>_numberOfProducts=[];
//   List<int>_numberOfScannedProducts=[];

//   List<List<bool>>? get orderItemCheckBox =>_orderItemCheckBox;
//   bool get showData=>_showData;

//   List<ModelByDipu> get checkOrder =>_checkOrder;
  

//   List<ModelByDipu> get manifestOrder =>_manifestOrder;
//   bool get isLoading => _isLoading;
//   List<bool> get checkBox => _checkbox;
//   List<bool> get pickCheckBox => _pickcheckbox;
//   List<bool> get rtcCheckBox => _rtccheckbox;
//   List<bool> get rtmCheckBox =>_rtmcheckbox;
//   List<bool> get rtrcheckbox=> _rtrcheckbox;
  
//   List<String> get productTitle => _productTitle;
//   List<int> get numberOfProducts => _numberOfProducts;
//   List<int> get numberOfScannedProducts => _numberOfScannedProducts;

//   // Change this to your actual base URL if needed
//   final String baseUrl = 'https://inventory-management-backend-s37u.onrender.com';

//   void setDetailsOfProducts(List<String>title,List<int>productCount,List<int>scanCount){
//     _productTitle=title;
//     _numberOfScannedProducts=scanCount;
//     void upDateScannedProducts(int index){
//    _numberOfScannedProducts[index]=_numberOfScannedProducts[index]+1;
//     notifyListeners();
//   }



//   void generateNumberOfCheckBox(){
//     _checkbox=List.generate(_orders.length, (index) =>false);
//     try{
//     for(int i=0;i<_orders.length;i++){
//       bool value=true;

//       if(_pickOrder[i].picker!.isEmpty){
//           value=false;
//       }
//       for(int j=0;j<_orders[i].packer!.length;j++){
//         value=value && _orders[i].packer![j].isFullyScanned;
        
//       }
//       _checkbox[i]=value;
//     }
//     }catch(e){
//       // print("some error occured ${e.toString()}");
//     }

//   }

//     void generateRTMCheckBox(){
//     _rtmcheckbox=List.generate(_manifestOrder.length, (index) =>false);
//     try{
      
//     // for(int i=0;i<_manifestOrder.length;i++){
//     //   bool value=true;
//     //   for(int j=0;j<_manifestOrder[i].picker!.length;j++){
//     //     value=value && _manifestOrder[i].picker![j].isFullyScanned;
        
//     //   }
//     //   _rtmcheckbox[i]=value;
//     // }
//     }catch(e){
//       // print("some error occured ${e.toString()}");
//     }

//   }
//     void generateRTRCheckBox(){
//     _rtrcheckbox=List.generate(_rackedOrder.length, (index) =>false);
//     try{
//     // for(int i=0;i<_rackedOrder.length;i++){
//     //   bool value=true;
//     //   for(int j=0;j<_rackedOrder[i].picker!.length;j++){
//     //     value=value && _rackedOrder[i].picker![j].isFullyScanned;
        
//     //   }
//     //   _rtrcheckbox[i]=value;
//     // }
//     }catch(e){
//       // print("some error occured ${e.toString()}");
//     }

//   }
//     void generateRTCCheckBox(){
//     _rtccheckbox=List.generate(_checkOrder.length, (index) =>false);
//     try{
//     // for(int i=0;i<_rackedOrder.length;i++){
//     //   bool value=true;
//     //   for(int j=0;j<_rackedOrder[i].picker!.length;j++){
//     //     value=value && _rackedOrder[i].picker![j].isFullyScanned;
        
//     //   }
//     //   _rtccheckbox[i]=value;
//     // }
//     }catch(e){
//       // print("some error occured ${e.toString()}");
//     }

//   }

//   void generateRTPICKCheckBox(){
//     _pickcheckbox=List.generate(_pickOrder.length, (index) =>false);
//     try{
//     for(int i=0;i<_pickOrder.length;i++){

//       bool value=true;
//       if(_pickOrder[i].picker!.isEmpty){
//           value=false;
//       }
//       for(int j=0;j<_pickOrder[i].picker!.length;j++){
//         value=value && _pickOrder[i].picker![j].isFullyScanned;
        
//       }
//       _pickcheckbox[i]=value;
//     }
//     }catch(e){
//       // print("some error occured ${e.toString()}");
//     }

//   }
//     void updateCheckBoxStatus(int a){
//     _checkbox[a]=!_checkbox[a];
//     notifyListeners();
//   }
  
//   Future<Map<String, dynamic>> fetchReadyToPackOrders() async {
//     _isLoading = true;
//     notifyListeners();

//     final url = Uri.parse('$baseUrl/orders?orderStatus=4');

//     try {
//       // final token = await AuthProvider().getToken(); // Get the token for authorization
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InByYXJ0aGkyNDc0QGdtYWlsLmNvbSIsImlkIjoiNjZjYjI3NDg0MjNjNmU0NmFjZDBhYjY1IiwiaWF0IjoxNzI4NTc3MTMyLCJleHAiOjE3Mjg2MjAzMzJ9.sCM6xurdP8TLKuigxVcgmU8vkpDBncGQbX2Nv8741FI', // Include the token in the headers
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data.containsKey('orders')) {
//             _orders=(data["orders"] as List)
//       .map((orderJson) => ModelByDipu.fromJson(orderJson))
//       .toList();
//       generateNumberOfCheckBox();
//       // print("herec is length of data ${_orders[1].items![0].product.displayName}");
//           return {'success': true, 'data': _orders}; // Return the data in structured format
//         } else {
//           // print('Unexpected response format: $data');
//           return {'success': false, 'message': 'Unexpected response format'};
//         }
//       } else {
//         return {
//           'success': false,
//           'message': 'Failed to fetch orders with status code: ${response.statusCode}'
//         };
//       }
//     } catch (error) {
//       // print('Unexpected response format: ');
//       return {'success': false, 'message': 'An error occurred: $error'};
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//     Future<Map<String, dynamic>> fetchReadyToPickOrders() async {
//     _isLoading = true;
//     notifyListeners();

//     final url = Uri.parse('$baseUrl/orders?orderStatus=3');

//     try {
//       // final token = await AuthProvider().getToken(); // Get the token for authorization
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InByYXJ0aGkyNDc0QGdtYWlsLmNvbSIsImlkIjoiNjZjYjI3NDg0MjNjNmU0NmFjZDBhYjY1IiwiaWF0IjoxNzI4NTc3MTMyLCJleHAiOjE3Mjg2MjAzMzJ9.sCM6xurdP8TLKuigxVcgmU8vkpDBncGQbX2Nv8741FI', // Include the token in the headers
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data.containsKey('orders')) {
//             _pickOrder=(data["orders"] as List)
//       .map((orderJson) => ModelByDipu.fromJson(orderJson))
//       .toList();
//       generateRTPICKCheckBox();
//       // print("herec is length of data ${_pickOrder[1].items![0].product.displayName}");
//           return {'success': true, 'data': _pickOrder}; // Return the data in structured format
//         } else {
//           // print('Unexpected response format: $data');
//           return {'success': false, 'message': 'Unexpected response format'};
//         }
//       } else {
//         return {
//           'success': false,
//           'message': 'Failed to fetch orders with status code: ${response.statusCode}'
//         };
//       }
//     } catch (error) {
//       // print('Unexpected response format: ');
//       return {'success': false, 'message': 'An error occurred: $error'};
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//     Future<Map<String, dynamic>> fetchReadyToCheckOrders() async {
//     _isLoading = true;
//      notifyListeners();

//     final url = Uri.parse('$baseUrl/orders?orderStatus=5');

//     try {
      
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InByYXJ0aGkyNDc0QGdtYWlsLmNvbSIsImlkIjoiNjZjYjI3NDg0MjNjNmU0NmFjZDBhYjY1IiwiaWF0IjoxNzI4NTc3MTMyLCJleHAiOjE3Mjg2MjAzMzJ9.sCM6xurdP8TLKuigxVcgmU8vkpDBncGQbX2Nv8741FI', // Include the token in the headers
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data.containsKey('orders')) {
//             _checkOrder=(data["orders"] as List)
//       .map((orderJson) => ModelByDipu.fromJson(orderJson))
//       .toList();
//       generateRTCCheckBox();
     
//           return {'success': true, 'data': _orders}; // Return the data in structured format
//         } else {
//           // print('Unexpected response format: $data');
//           return {'success': false, 'message': 'Unexpected response format'};
//         }
//       } else {
//         return {
//           'success': false,
//           'message': 'Failed to fetch orders with status code: ${response.statusCode}'
//         };
//       }
//     } catch (error) {
//       // print('Unexpected response format: ');
//       return {'success': false, 'message': 'An error occurred: $error'};
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
 
  
  
//       Future<Map<String, dynamic>> fetchReadyToManiFestOrders() async {
//     _isLoading = true;
//     notifyListeners();

//     final url = Uri.parse('$baseUrl/orders?orderStatus=7');

//     try {
//       // final token = await AuthProvider().getToken(); // Get the token for authorization
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InByYXJ0aGkyNDc0QGdtYWlsLmNvbSIsImlkIjoiNjZjYjI3NDg0MjNjNmU0NmFjZDBhYjY1IiwiaWF0IjoxNzI4NTc3MTMyLCJleHAiOjE3Mjg2MjAzMzJ9.sCM6xurdP8TLKuigxVcgmU8vkpDBncGQbX2Nv8741FI', // Include the token in the headers
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data.containsKey('orders')) {
//             _manifestOrder=(data["orders"] as List)
//       .map((orderJson) => ModelByDipu.fromJson(orderJson))
//       .toList();
//       generateRTMCheckBox();
//       // print("herec is length of data ${_orders[1].items![0].product.displayName}");
//           return {'success': true, 'data': _orders}; // Return the data in structured format
//         } else {
//           // print('Unexpected response format: $data');
//           return {'success': false, 'message': 'Unexpected response format'};
//         }
//       } else {
//         return {
//           'success': false,
//           'message': 'Failed to fetch orders with status code: ${response.statusCode}'
//         };
//       }
//     } catch (error) {
//       // print('Unexpected response format: ');
//       return {'success': false, 'message': 'An error occurred: $error'};
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//       Future<Map<String, dynamic>> fetchReadyToRackedOrders() async {
//     _isLoading = true;
//     notifyListeners();

//     final url = Uri.parse('$baseUrl/orders?orderStatus=6');

//     try {
//       // final token = await AuthProvider().getToken(); // Get the token for authorization
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InByYXJ0aGkyNDc0QGdtYWlsLmNvbSIsImlkIjoiNjZjYjI3NDg0MjNjNmU0NmFjZDBhYjY1IiwiaWF0IjoxNzI4NTc3MTMyLCJleHAiOjE3Mjg2MjAzMzJ9.sCM6xurdP8TLKuigxVcgmU8vkpDBncGQbX2Nv8741FI', // Include the token in the headers
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data.containsKey('orders')) {
//             _rackedOrder=(data["orders"] as List)
//       .map((orderJson) => ModelByDipu.fromJson(orderJson))
//       .toList();
//       generateRTRCheckBox();
//       print("herec is length of data ${_orders[1].items![0].product.displayName}");
//           return {'success': true, 'data': _orders}; // Return the data in structured format
//         } else {
//           // print('Unexpected response format: $data');
//           return {'success': false, 'message': 'Unexpected response format'};
//         }
//       } else {
//         return {
//           'success': false,
//           'message': 'Failed to fetch orders with status code: ${response.statusCode}'
//         };
//       }
//     } catch (error) {
//       // print('Unexpected response format: ');
//       return {'success': false, 'message': 'An error occurred: $error'};
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//   void updateData(){
//     _showData=!_showData;
//     notifyListeners();
//   }
//   Future<void> numberOfOrderCheckBox(int row, List<int> count, List<int> scannedProducts) async {

//   _orderItemCheckBox = List.generate(row, (index) => List.generate(count[index], (ind) => false));

//   for (int i = 0; i < scannedProducts.length; i++) {
//     for (int j = 0; j < scannedProducts[i]; j++) {
//       _orderItemCheckBox![i][j] = true;
//     }
//   }

//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     notifyListeners();
//   });
// }

//     void updateCheckBoxValue(int row,int col){
//     // print("here row $row   $col");
//     _orderItemCheckBox![row][col-1]=!_orderItemCheckBox![row][col-1];

//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qrorganic/Model/order-response-model.dart';
import 'package:qrorganic/Provider/auth_provider.dart';

class ReadyToPackProvider with ChangeNotifier {
  List<ModelByDipu> _orders = [];
  List<ModelByDipu> _checkOrder = [];
  List<ModelByDipu> _rackedOrder = [];
  List<ModelByDipu> _manifestOrder = [];
  List<ModelByDipu> _pickOrder = [];
  int _packCurrentPage=0;
  int _pickCurrentPage=0;
  int _packTotalPages=0;
  int _pickTotalPages=0;
  int _rackCurrentPage=0;
  int _rackTotalPages=0;
  int _maniFestCurrentPage=0;
  int _maniFestTotalPages=0;
  int _checkCurrentPage=0;
  int _checkTotalPages=0;
  
  bool _isLoading = false;
  List<bool> _checkbox = [];
  List<bool> _rtmcheckbox = [];
  List<bool> _rtccheckbox = [];
  List<bool> _rtrcheckbox = [];
  List<bool> _pickcheckbox = [];
  
  List<List<bool>>? _orderItemCheckBox;
  bool _showData = true;
  
  List<String> _productTitle = [];
  List<int> _numberOfProducts = [];
  List<int> _numberOfScannedProducts = [];

  final String baseUrl = 'https://inventory-management-backend-s37u.onrender.com';

  List<ModelByDipu> get orders => _orders;
  List<ModelByDipu> get checkOrder => _checkOrder;
  List<ModelByDipu> get rackedOrder => _rackedOrder;
  List<ModelByDipu> get pickOrder => _pickOrder;
  List<ModelByDipu> get manifestOrder => _manifestOrder;
  
  bool get isLoading => _isLoading;
  List<bool> get checkBox => _checkbox;
  List<bool> get pickCheckBox => _pickcheckbox;
  List<bool> get rtcCheckBox => _rtccheckbox;
  List<bool> get rtmCheckBox => _rtmcheckbox;
  List<bool> get rtrcheckbox => _rtrcheckbox;
  
  List<String> get productTitle => _productTitle;
  List<int> get numberOfProducts => _numberOfProducts;
  List<int> get numberOfScannedProducts => _numberOfScannedProducts;
  List<List<bool>>? get orderItemCheckBox => _orderItemCheckBox;
  bool get showData => _showData;


  // int get packCurrentPage=>_packCurrentPage;
  // int get rackCurrentPage=>_rackCurrentPage;
  // int get pickCurrentPage=>_pickCurrentPage;
  // int get maniFestCurrentPage=>_maniFestCurrentPage;
  // int get checkCurrentPage=>_checkCurrentPage;

  // int get packTotalPages=>_packTotalPages;
  // int get rackTotalPages=>_rackTotalPages;
  // int get pickTotalPages=>_pickTotalPages;
  // int get maniFestTotalPages=>_maniFestTotalPages;
  // int get checkTotalPages=>_checkTotalPages;
    int getCurrentPage(String pageName) {
    switch (pageName.toLowerCase()) {
      case 'pack':
        return _packCurrentPage;
      case 'rack':
        return _rackCurrentPage;
      case 'pick':
        return _pickCurrentPage;
      case 'manifest':
        return _maniFestCurrentPage;
      case 'check':
        return _checkCurrentPage;
      default:
        return 0;
    }
  }

  int getTotalPages(String pageName) {
    switch (pageName.toLowerCase()) {
      case 'pack':
        return _packTotalPages;
      case 'rack':
        return _rackTotalPages;
      case 'pick':
        return _pickTotalPages;
      case 'manifest':
        return _maniFestTotalPages;
      case 'check':
        return _checkTotalPages;
      default:
        return 0;
    }
  }

  void setCurrentPage(String title, int page) {
  switch (title.toLowerCase()) {
    case 'pack':
      _packCurrentPage = page;
      break;
    case 'rack':
      _rackCurrentPage = page;
      break;
    case 'pick':
      _pickCurrentPage = page;
      break;
    case 'manifest':
      _maniFestCurrentPage = page;
      break;
    case 'check':
      _checkCurrentPage = page;
      break;
    default:
      throw Exception('Invalid page title: $title');
  }
  notifyListeners();
}


  

  void setDetailsOfProducts(List<String> title, List<int> productCount, List<int> scanCount) {
    _productTitle = title;
    _numberOfProducts = productCount;
    _numberOfScannedProducts = scanCount;
    notifyListeners();
  }

  void upDateScannedProducts(int index) {
    _numberOfScannedProducts[index]++;
    notifyListeners();
  }

  void generateCheckBoxes(List<ModelByDipu> orders, List<bool> checkbox) {
    checkbox.clear();
    checkbox.addAll(List.generate(orders.length, (index) {
      if (orders[index].picker!.isEmpty) return false;
      return orders[index].packer!.every((packer) => packer.isFullyScanned);
    }));
    notifyListeners();
  }

  void generateNumberOfCheckBox() {
    generateCheckBoxes(_orders, _checkbox);
  }

  void generateRTMCheckBox() {
    generateCheckBoxes(_manifestOrder, _rtmcheckbox);
  }

  void generateRTRCheckBox() {
    generateCheckBoxes(_rackedOrder, _rtrcheckbox);
  }

  void generateRTCCheckBox() {
    generateCheckBoxes(_checkOrder, _rtccheckbox);
  }

  void generateRTPICKCheckBox() {
    generateCheckBoxes(_pickOrder, _pickcheckbox);
  }

  void updateCheckBoxStatus(int a) {
    _checkbox[a] = !_checkbox[a];
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchOrders(String orderStatus,int page) async {
    _isLoading = true;
    notifyListeners();
    
    final url = Uri.parse('$baseUrl/orders?orderStatus=$orderStatus?currentPage=$page');
    final token = await AuthProvider().getToken();
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('orders')) {
           print("Divyansh Patidar: ${data["currentPage"]} ${data["totalPages"]}");
          List<ModelByDipu> orders = (data["orders"] as List)
              .map((orderJson) => ModelByDipu.fromJson(orderJson))
              .toList();

          switch (orderStatus) {
            case '4':
              _orders = orders;
              _packCurrentPage=data["currentPage"];
              _packTotalPages=data["totalPages"];
              generateNumberOfCheckBox();
              break;
            case '3':
              _pickOrder = orders;
              _pickCurrentPage=data["currentPage"];
              _pickTotalPages=data["totalPages"];
              generateRTPICKCheckBox();
              break;
            case '5':
              _checkOrder = orders;
              _checkCurrentPage=data["currentPage"];
              _checkTotalPages=data["totalPages"];
              generateRTCCheckBox();
              break;
            case '6':
              _rackedOrder = orders;
              _rackCurrentPage=data["currentPage"];
              _rackTotalPages=data["totalPages"];
              generateRTRCheckBox();
              break;
            case '7':
              _manifestOrder = orders;
              _maniFestCurrentPage=data["currentPage"];
              _maniFestTotalPages=data["totalPages"];
              generateRTMCheckBox();
              break;
          }

          return {'success': true, 'data': orders};
        } else {
          return {'success': false, 'message': 'Unexpected response format'};
        }
      } else {
        return {'success': false, 'message': 'Failed to fetch orders with status code: ${response.statusCode}'};
      }
    } catch (error) {
      return {'success': false, 'message': 'An error occurred: $error'};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> fetchReadyToPackOrders({int page=1}) => fetchOrders('4',page);
  Future<Map<String, dynamic>> fetchReadyToPickOrders({int page=1}) => fetchOrders('3',page);
  Future<Map<String, dynamic>> fetchReadyToCheckOrders({int page=1}) => fetchOrders('5',page);
  Future<Map<String, dynamic>> fetchReadyToManiFestOrders({int page=1}) => fetchOrders('7',page);
  Future<Map<String, dynamic>> fetchReadyToRackedOrders({int page=1}) => fetchOrders('6',page);

  void updateData() {
    _showData = !_showData;
    notifyListeners();
  }

  Future<void> numberOfOrderCheckBox(int row, List<int> count, List<int> scannedProducts) async {
    _orderItemCheckBox = List.generate(row, (index) => List.generate(count[index], (ind) => false));
    
    for (int i = 0; i < scannedProducts.length; i++) {
      for (int j = 0; j < scannedProducts[i]; j++) {
        _orderItemCheckBox![i][j] = true;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void updateCheckBoxValue(int row, int col) {
    _orderItemCheckBox![row][col - 1] = !_orderItemCheckBox![row][col - 1];
    notifyListeners();
  }
}

