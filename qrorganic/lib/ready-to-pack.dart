// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';

class ReadyToPackPage extends StatefulWidget {
  @override
  _ReadyToPackPageState createState() => _ReadyToPackPageState();
}

class _ReadyToPackPageState extends State<ReadyToPackPage> {
  // Simulated selected products
  List<bool> selectedProducts = List<bool>.filled(10, false); // Assuming 10 products
  bool selectAll = false;

  void toggleSelectAll(bool value) {
    setState(() {
      selectAll = value;
      for (int i = 0; i < selectedProducts.length; i++) {
        selectedProducts[i] = value;
      }
    });
  }

  void toggleProductSelection(int index, bool value) {
    setState(() {
      selectedProducts[index] = value;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  void getData()async{
    var readyToPackProviderProvider=Provider.of<ReadyToPackProvider>(context,listen:false);
   await readyToPackProviderProvider.fetchReadyToPackOrders();
   for(int i=0;i<readyToPackProviderProvider.orders.length;i++){
      for(int j=0;j<readyToPackProviderProvider.orders[i]["items"].length;j++){
          print("data is here ${readyToPackProviderProvider.orders[i]["items"][j]["product_id"]["displayName"]}");
          print("\n");
      }
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ready to Pack'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<ReadyToPackProvider>(
        builder:(con,provider,child)=>SingleChildScrollView(
          child:Row(

            children: [
             
              //  Checkbox(value:true, onChanged:(v){}),
              Text("Orders"),
            ],
          ),
        ),
      ),
    );
  }
}
