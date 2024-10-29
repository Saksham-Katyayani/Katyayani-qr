import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qrorganic/services/api_service.dart';
import 'package:qrorganic/widgets/custom_form.dart';
import 'package:qrorganic/Model/inbound_model.dart';
import 'package:qrorganic/Model/product_model.dart';
import 'package:qrorganic/services/api_urls.dart';
import 'package:provider/provider.dart';
import '../../utils/image_picker_function.dart';

class InBoundPage extends StatefulWidget {
  const InBoundPage({super.key});

  @override
  State<InBoundPage> createState() => _InBoundPageState();
}

class _InBoundPageState extends State<InBoundPage> {
  bool isLoading = false;
  File? file;
  List<TextEditingController> inboundController1 = [];
  List<TextEditingController> inboundController2 = [];
  List<CustomForm> customforms = [];
  List<InBoundModel> inboundData = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    print(count);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return
        // SafeArea(
        //   child:
        Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                "Inbound",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Sora-Regular"),
              ),
              backgroundColor: Color.fromRGBO(6, 90, 216, 1),
            ),
            body: // child is the third parameter
                SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 3),
                      height: deviceSize.height * 0.5,
                      child: count == 0
                          ? Center(
                              child: Container(
                                  width: deviceSize.width * 0.6,
                                  height: deviceSize.height * 0.15,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.blue.shade700, width: 3),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Click on Add field button given at bottom to add a field",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ))),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Table(
                                      columnWidths: {
                                        0: FractionColumnWidth(0.2),
                                        1: FractionColumnWidth(0.3),
                                        2: FractionColumnWidth(0.3),
                                      },
                                      border:
                                          TableBorder.all(color: Colors.black),
                                      children: [
                                        TableRow(
                                          children: [
                                            Container(
                                              height: 80,
                                              alignment: Alignment.center,
                                              child: TableCell(
                                                child: Text("S.No",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ),
                                            Container(
                                              height: 80,
                                              alignment: Alignment.center,
                                              child: TableCell(
                                                child: Text("Product-Id",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ),
                                            Container(
                                              height: 80,
                                              alignment: Alignment.center,
                                              child: TableCell(
                                                child: Text("Quantity",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                                Expanded(
                                  flex: 3,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return CustomForm(
                                        controller1: inboundController1[index],
                                        controller2: inboundController2[index],
                                        sno: index + 1,
                                      );
                                    },
                                    itemCount: count,
                                  ),
                                ),
                              ],
                            )
                      // formList.fieldLists.length==0?CustomForm():ListView.builder(
                      //   itemBuilder: (context, index) {
                      //     // return a widget here, for example:
                      //     return formList.fieldLists[index];
                      //   },
                      //   itemCount: formList.fieldLists.length,
                      // ),
                      ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: const Divider(
                      thickness: 3,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(150, 50),
                      elevation: 4,
                      backgroundColor: Colors.blueAccent,
                      side: BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        inboundController1.add(TextEditingController());
                        inboundController2.add(TextEditingController());
                        count++;
                      });
                    },
                    child: Text(
                      'Add Field',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        file = await uploadImage(
                                            ImageSource.gallery);
                                        setState(() {});

                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Photo From Gallery",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        side: BorderSide(color: Colors.grey),
                                        fixedSize: Size(200, 80),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        file = await uploadImage(
                                            ImageSource.camera);
                                        setState(() {});
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Capture From camera",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        side: BorderSide(color: Colors.grey),
                                        fixedSize: Size(200, 80),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      height: deviceSize.height * 0.2,
                      width: deviceSize.width * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: file != null
                          ? Image.file(
                              file!,
                              fit: BoxFit.cover,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: 80,
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                      "assets/images/image_placeholder.jpg",
                                      fit: BoxFit.cover,
                                    )),
                                Container(
                                    height: 80,
                                    width: 200,
                                    margin: EdgeInsets.only(top: 10),
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "Upload Photo ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.left,
                                    )),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(150, 50),
                      backgroundColor: Colors.blueAccent,
                      side: BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                        for (int i = 0; i < count; i++) {
                          inboundData.add(InBoundModel(
                              sku: inboundController1[i].text.toString(),
                              quantity: int.parse(
                                  inboundController2[i].text.toString())));
                        }
                      });
                      print("inboundData ${inboundData}");
                      String result = await postInbound(inboundData, file!);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "Your data is successfully posted",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        backgroundColor: Colors.black,
                      ));
                      setState(() {
                        isLoading = false;
                        file = null;
                      });
                      count = 0;
                      inboundController1.clear();
                      inboundController2.clear();
                    },
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Submit',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                  ),
                ],
              ),
            )
            // ),
            );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for (int i = 0; i < count; i++) {
      inboundController1.clear();
      inboundController2.clear();
      inboundData.clear();
      customforms.clear();
      file = null;
    }
  }
}
