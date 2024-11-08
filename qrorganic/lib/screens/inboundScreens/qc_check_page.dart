import 'package:flutter/material.dart';
import 'package:qrorganic/custom/colors.dart';
import 'package:qrorganic/services/api_service.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:qrorganic/screens/inboundScreens/qc_check_detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QcCheckPage extends StatefulWidget {
  const QcCheckPage({super.key});

  @override
  State<QcCheckPage> createState() => _QcCheckPageState();
}

class _QcCheckPageState extends State<QcCheckPage> {
  File? qcFile;
  late Future<dynamic> inBounds;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inBounds = getData("INBOUND");
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return
        // SafeArea(
        //     child:
        Scaffold(
      appBar: AppBar(
        title: Text(
          "Qc Check",
          style: TextStyle(
            fontSize: 18,
            fontFamily: "Sora-Regular",
          ),
        ),
        backgroundColor: Color.fromRGBO(6, 90, 216, 1),
      ),
      body: FutureBuilder(
          future: inBounds,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  String time = snapshot.data![index].updatedAt
                      .toString()
                      .substring(11, 16);
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
                                    isTextFieldRequired: false,
                                    imageUrl: snapshot
                                        .data![index].images['inboundImage'],
                                  ))).then((value) {
                        setState(() {
                          inBounds = getData("INBOUND");
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "ID: ${snapshot.data![index].id}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "STATUS: INBOUND",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              // Displaying each item as a separate card
                              Column(
                                children: List.generate(
                                    snapshot.data[index].products.length, (i) {
                                  return Card(
                                    elevation: 2,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomContainerWidget(
                                                        products: snapshot
                                                            .data![index]
                                                            .products,
                                                        id: snapshot
                                                            .data![index].id,
                                                        isTextFieldRequired:
                                                            false,
                                                        imageUrl: snapshot
                                                                .data![index]
                                                                .images[
                                                            'inboundImage'],
                                                      ))).then((Value) {
                                            setState(() {
                                              inBounds = getData("INBOUND");
                                            });
                                          });
                                          // Navigate to details page
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                                height: 100,
                                                width: 100,
                                                child: snapshot.data![index]
                                                                .images[
                                                            'inboundImage'] !=
                                                        null
                                                    ? Image.network(
                                                        snapshot
                                                            .data![index]
                                                            .images[
                                                                'inboundImage']
                                                            .toString(),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        "assets/images/image_placeholder.jpg",
                                                        fit: BoxFit.cover,
                                                      )),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "SKU: ${snapshot.data![index].products[i]['sku']}",
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "Update At: ${snapshot.data![index].updatedAt.toString().substring(0, 10)} at ${output}",
                                                    style: const TextStyle(
                                                        fontSize: 8,
                                                        color: AppColors
                                                            .primaryBlue),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Quantity: ${snapshot.data![index].products[i]['quantity']}",
                                                        style: const TextStyle(
                                                            fontSize: 8,
                                                            color: Colors.grey),
                                                      ),
                                                      const FaIcon(
                                                          FontAwesomeIcons
                                                              .check,
                                                          size: 25,
                                                          color: Colors.green)
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
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             children: [
                  //               Container(
                  //                 width: 200,
                  //                 height: 100,
                  //                 color: Colors.red,
                  //                 child: Image.network(snapshot.data![index].images['inboundImage']),
                  //                 ),
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //                 children: [
                  //                   const Text(
                  //                     "Product-id",
                  //                     style: TextStyle(
                  //                         fontSize: 18,
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.black),
                  //                   ),
                  //                   const Text(
                  //                     "Quantity",
                  //                     style: TextStyle(
                  //                         fontSize: 18,
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.black),
                  //                   ),
                  //                   const Text(
                  //                     "Updated Time",
                  //                     style: TextStyle(
                  //                         fontSize: 18,
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.black),
                  //                   ),
                  //                 ],
                  //               ),
                  //               const SizedBox(
                  //                 height: 30,
                  //               ),
                  //               Container(
                  //                 height: deviceSize.height * 0.2,
                  //                 width: deviceSize.width * 0.9,
                  //                 child: ListView.builder(
                  //                   itemBuilder: (context, iindex) {
                  //                     return Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceAround,
                  //                       children: [
                  //                         Text(
                  //                           "${snapshot.data![index].products[iindex]['sku']}",
                  //                           style: TextStyle(
                  //                               fontSize: 18, color: Colors.black),
                  //                         ),
                  //                         Text(
                  //                           "${snapshot.data![index].products[iindex]['quantity']}",
                  //                           style: TextStyle(
                  //                               fontSize: 18, color: Colors.black),
                  //                         ),
                  //                         Text(
                  //                           "${snapshot.data![index].updatedAt}",
                  //                           style: TextStyle(
                  //                               fontSize: 18, color: Colors.black),
                  //                         ),
                  //                       ],
                  //                     );
                  //                   },
                  //                   itemCount: snapshot.data![index].products.length,
                  //                 ),
                  //               )
                  //             ],
                  //           )),
                  //     );
                },
                itemCount: snapshot.data!.length,
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Sorry, failed to fetch the data",
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 28,
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryBlue,
                ),
              );
            }
          }),
    );
    // );
  }
}
