import 'package:flutter/material.dart';
import 'package:qrorganic/Model/inbound_model.dart';
import 'package:qrorganic/custom/colors.dart';
import 'package:qrorganic/services/api_urls.dart';
import 'package:provider/provider.dart';

class CustomForm extends StatefulWidget {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  int sno;
  CustomForm(
      {super.key,
      required this.controller1,
      required this.controller2,
      required this.sno});

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 90,
      width: size.width * 0.9,
      margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
      padding: EdgeInsets.only(right: 10, left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Table(
            border: TableBorder.all(color: Colors.black, width: 1),
            columnWidths: {
              0: FractionColumnWidth(0.2),
              1: FractionColumnWidth(0.3),
              2: FractionColumnWidth(0.3)
            },
            children: [
              TableRow(children: [
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: TableCell(
                    child: Text("${widget.sno}",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                ),
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: TableCell(
                    child: TextField(
                      controller: widget.controller1,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: AppColors.primaryBlue, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: AppColors.primaryBlue, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          hintText: "K-101",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15)),
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: TableCell(
                    child: TextField(
                      controller: widget.controller2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.primaryBlue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.primaryBlue, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        hintText: "10",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),
                )
              ]),
            ],
          ),
        ),
        // return Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [

        //    Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text("Product Id",style: TextStyle(
        //           fontSize: 18,
        //           color: Colors.black,
        //           fontWeight: FontWeight.bold
        //         ),

        //         ),

        // Container(
        //   height: 40,
        //   width: 100,
        //   padding: EdgeInsets.only(left: 5),
        //       child: TextField(
        //         controller: widget.controller1,
        //         decoration: InputDecoration(
        //           border: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(10),
        //             borderSide: BorderSide(color: AppColors.primaryBlue,width: 2),
        //           ),
        //           enabledBorder: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(10),
        //             borderSide: BorderSide(color: AppColors.primaryBlue,width: 2),
        //           ),
        //           focusedBorder: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(10),
        //             borderSide: BorderSide(color: Colors.black,width: 2),
        //           ),
        //           hintText: "K-101",
        //           hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
        //         ),
        //       ),
        //     )
        //   ],
        //  ),
        //  const SizedBox(width: 20,),
        //  Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text("Quantity",style: TextStyle(
        //       fontSize: 18,
        //       color: Colors.black,
        //       fontWeight: FontWeight.bold
        //     ),

        //     ),
        //     Container(
        //       height: 40,
        //       width: 50,
        //       padding: EdgeInsets.only(left: 5),
        //       child: TextField(
        //         controller: widget.controller2,
        //         keyboardType: TextInputType.number,
        //         decoration: InputDecoration(
        //           border: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(10),
        //             borderSide: BorderSide(color: AppColors.primaryBlue,width: 2),
        //           ),
        //           enabledBorder: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(10),
        //             borderSide: BorderSide(color: AppColors.primaryBlue,width: 2),
        //           ),
        //           focusedBorder: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(10),
        //             borderSide: BorderSide(color: Colors.black,width: 2),
        //           ),
        //           hintText: "10",
        //           hintStyle: TextStyle(color: Colors.grey,fontSize: 15)
        //         ),

        //       ),
        // )
        //   ],
        //  ),

        // ],
        // );
      ),
    );
  }
}
