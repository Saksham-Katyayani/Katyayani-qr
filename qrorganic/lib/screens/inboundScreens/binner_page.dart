import 'package:flutter/material.dart';
import 'package:qrorganic/services/api_service.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qrorganic/screens/inboundScreens/qc_check_detail.dart';
import 'package:intl/intl.dart';

class BinnerPage extends StatefulWidget {
  const BinnerPage({super.key});

  @override
  State<BinnerPage> createState() => _BinnerPageState();
}

class _BinnerPageState extends State<BinnerPage> {
  File? qcFile;
  late Future<dynamic> binner;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    binner = getData("QC_CHECKED");
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return 
    // SafeArea(
    //     child: 
        Scaffold(
          appBar: AppBar(
            title: Text("Binner Page",style: TextStyle(fontSize: 20,fontFamily: "Sora-Regular",),),
            backgroundColor: Color.fromRGBO(6, 90, 216, 1),
          ),
      body: FutureBuilder(
          future: binner,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                     String time = snapshot.data![index].updatedAt.toString().substring(11,16);
                     DateFormat format = new DateFormat("HH:mm");
                     DateTime updateAt = format.parse(time);
                     DateFormat outputFormat = new DateFormat("hh:mm aa");
                     String output = outputFormat.format(updateAt);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => CustomContainerWidget(
                                    products: snapshot.data![index].products,
                                    id: snapshot.data![index].id,
                                    isTextFieldRequired: true,
                                    imageUrl: snapshot.data![index].images['qcImages'],
                                  ))).then((value){
                                    setState(() {
                                      binner=getData("QC_CHECKED");
                                    });
                                  });
                    },
                    child: Expanded(
                      child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Order ID: ${snapshot.data![index].id}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                      "STATUS: QC_CHECKED",
                                        style: TextStyle(
                                          color:  Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height:2),
                                  // Displaying each item as a separate card
                                  Column(
                                    children: List.generate(snapshot.data[index].products.length, (i) {
                                      return Card(
                                        elevation: 2,
                                        margin: const EdgeInsets.symmetric(vertical: 5),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => CustomContainerWidget(
                                    products: snapshot.data![index].products,
                                    id: snapshot.data![index].id,
                                    isTextFieldRequired: true,
                                    imageUrl: snapshot.data![index].images['qcImages'],
                                  ))).then((Value){
setState(() {
  binner=getData("QC_CHECKED");
});
                                  });
                                              // Navigate to details page
                                              
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  height:100,
                                                  width: 100,
                                                  child:snapshot.data![index].images['qcImages']!=null?Image.network(snapshot.data![index].images['inboundImage'].toString(),
                                           
                                                    fit: BoxFit.cover,
                                                  ):Image.asset("assets/images/image_placeholder.jpg",fit: BoxFit.cover,)
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                       Text(
                                                        "SKU: ${snapshot.data![index].products[i]['sku']}",
                                                        style: const TextStyle(fontSize:10, fontWeight: FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 4),
                                                   
                                                          Text(
                                                            "Quantity: ${snapshot.data![index].products[i]['quantity']}",
                                                            style: const TextStyle(fontSize: 8, color: Colors.grey,fontWeight: FontWeight.bold),
                                                          ),
                                                      
                                                            
                                                      
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Update At: ${snapshot.data![index].updatedAt.toString().substring(0,10)} at ${output}",
                                                            style: const TextStyle(fontSize:8, color: Colors.blue),
                                                          ),
                                                          
                                                          const FaIcon(FontAwesomeIcons.check, size: 25, color: Colors.green),
                                                        ],
                                                      ),
                
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  const Divider(thickness: 1),
                                ],
                              ),
                            ),
                          ),
                      
                    ),
                    
                    
                    );
                  // return GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         new MaterialPageRoute(
                  //             builder: (context) => CustomContainerWidget(
                  //                   products: snapshot.data![index].products,
                  //                   id: snapshot.data![index].id,
                  //                   isTextFieldRequired: true,
                  //                 )));
                  //   },
                  //   child: Container(
                  //       width: deviceSize.width - 100,
                  //       margin:
                  //           EdgeInsets.only(bottom: 50, right: 10, left: 10),
                  //       padding: EdgeInsets.only(left: 10, top: 30),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         color: Colors.white,
                  //         boxShadow: [
                  //           BoxShadow(
                  //               blurRadius: 2,
                  //               spreadRadius: 2,
                  //               color: Colors.blue.shade700,
                  //               offset: Offset(-2, 2))
                  //         ],
                  //       ),
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //             children: [
                  //               const Text(
                  //                 "Product-id",
                  //                 style: TextStyle(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.black),
                  //               ),
                  //               const Text(
                  //                 "Quantity",
                  //                 style: TextStyle(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.black),
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 30,
                  //           ),
                  //           Container(
                  //             height: deviceSize.height * 0.2,
                  //             width: deviceSize.width * 0.9,
                  //             child: ListView.builder(
                  //               itemBuilder: (context, iindex) {
                  //                 return Row(
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceAround,
                  //                   children: [
                  //                     Text(
                  //                       "${snapshot.data![index].products[iindex]['sku']}",
                  //                       style: TextStyle(
                  //                           fontSize: 18, color: Colors.black),
                  //                     ),
                  //                     Text(
                  //                       "${snapshot.data![index].products[iindex]['quantity']}",
                  //                       style: TextStyle(
                  //                           fontSize: 18, color: Colors.black),
                  //                     ),
                  //                   ],
                  //                 );
                  //               },
                  //               itemCount: snapshot.data![index].products.length,
                  //             ),
                  //           )
                  //         ],
                  //       )),
                  // );
                },
                itemCount: snapshot.data!.length,
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Failed to fetch the data",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 28,
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
          }),
    );
    // );
  }
}