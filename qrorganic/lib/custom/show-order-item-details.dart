// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/show-order-item.dart';
import 'package:qrorganic/custom/qr-generator.dart';

class ShowDetailsOfOrderItem extends StatefulWidget {
  String oredrId;
  List<String> title;
  List<int> numberOfItme;
  ShowDetailsOfOrderItem(
      {super.key,
      required this.numberOfItme,
      required this.title,
      required this.oredrId});

  @override
  State<ShowDetailsOfOrderItem> createState() => _ShowDetailsOfOrderItemState();
}

class _ShowDetailsOfOrderItemState extends State<ShowDetailsOfOrderItem> {
  bool val = false;
  // int count=0
  OrderItemProvider? orderItemProvider1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     orderItemProvider1=Provider.of<OrderItemProvider>(context,listen:false);

     orderItemProvider1!.numberOfOrderCheckBox(widget.title.length,widget.numberOfItme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.oredrId,
            style: GoogleFonts.daiBannaSil(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ),
        body: Consumer<OrderItemProvider>(
          builder:(context,orderItemProvider1,child)=>ListView.builder(
            itemBuilder: (context, i) => SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              // height:MediaQuery.of(context).size.width*(widget.numberOfItme[i]/25),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 2, bottom: 5),
                    child: InkWell(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                        elevation: 5,
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.title[i],
                                style: GoogleFonts.daiBannaSil(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            )),
                            Checkbox(
                                value:orderItemProvider1!.orderItemCheckBox![i][index],
                                onChanged: (val) {
                                   print("$i,$index");
                                   orderItemProvider1.updateCheckBoxValue(i,index);
                                })
                          ],
                        ),
                      ),
                      onTap:(){
                        Navigator.push(context,MaterialPageRoute(builder:(context)=>QrGenerator()));
                      },
                    ),
                  );
                },
                itemCount: widget.numberOfItme[i] as int,
              ),
            ),
            itemCount: (widget.title.length as num).toInt(),
          ),
        )
        // ),
        );
  }
}
