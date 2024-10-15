import 'dart:async';

import 'package:flutter/material.dart';

class OrderItemProvider extends ChangeNotifier{
  List<List<bool>>?_orderItemCheckBox;
  bool _showData=true;

  List<List<bool>>? get orderItemCheckBox =>_orderItemCheckBox;
  bool get showData=>_showData;
  void updateShowData(){
    _showData=!_showData;
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

    void updateCheckBoxValue(int row,int col){
    
    _orderItemCheckBox![row][col]=!_orderItemCheckBox![row][col];

    notifyListeners();
  }
}