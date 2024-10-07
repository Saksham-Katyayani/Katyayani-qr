import 'package:flutter/material.dart';

class OrderItemProvider extends ChangeNotifier{
  List<List<bool>>?_orderItemCheckBox;

  List<List<bool>>? get orderItemCheckBox =>_orderItemCheckBox;
  void numberOfOrderCheckBox(int row,List<int>count){
    _orderItemCheckBox=List.generate(row, (index) =>List.generate(count[index] as int, (ind)=>true));
    notifyListeners();
  }
    void updateCheckBoxValue(int row,int col){
      print("${_orderItemCheckBox![row][col]}");
    _orderItemCheckBox![row][col]=!_orderItemCheckBox![row][col];
    print("${_orderItemCheckBox![row][col]}");
    notifyListeners();
  }
}