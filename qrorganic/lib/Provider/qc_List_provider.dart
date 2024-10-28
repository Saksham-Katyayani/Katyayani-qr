import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:qrorganic/services/api_service.dart';
import 'package:qrorganic/Model/product_model.dart';

class QcListProvider with ChangeNotifier{
  late Future<List<Product>> qcList;

  void getQcList() {
    qcList =  getData("INBOUND");
    notifyListeners();
  }
}