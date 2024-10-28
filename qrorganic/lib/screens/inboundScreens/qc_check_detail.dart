import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:qrorganic/widgets/bin_textfield.dart';
import 'package:qrorganic/Model/binner_model.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/utils/const.dart';
import '../../services/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import '../../utils/image_picker_function.dart';


class CustomContainerWidget extends StatefulWidget {
  final List products;
  final String id;
  final imageUrl;
  final bool isTextFieldRequired;
  // Variable to hold data passed through constructor

  CustomContainerWidget({required this.id, required this.products,required this.isTextFieldRequired,required this.imageUrl});

  @override
  _CustomContainerWidgetState createState() => _CustomContainerWidgetState();
}

class _CustomContainerWidgetState extends State<CustomContainerWidget> {
  
  final TextEditingController _textFieldController = TextEditingController();
  File? file;
  int count =1;
  bool isLoading = false;
  final List<TextEditingController> binControllers = [];
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.id);
    for(int i=0;i<widget.products.length;i++){
      binControllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // return 
    // SafeArea(
      // child: 
      return Scaffold(
        resizeToAvoidBottomInset: false,
         appBar: AppBar(
            title: Text(widget.isTextFieldRequired?"Bin Detail Page":"Qc Check Detail Page",style: TextStyle(fontSize: 18,fontFamily: "Sora-Regular",),),
            backgroundColor: Color.fromRGBO(6, 90, 216, 1),
          ),
          body: Card(
        margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
        elevation: 4,
         
      
 
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
            
                Table(
                  border: TableBorder.all(color: Colors.black, width: 1),
                  columnWidths: widget.isTextFieldRequired? {
                    0: FractionColumnWidth(0.18), // S.No. column
                    1: FractionColumnWidth(0.3), // Sku column
                    2: FractionColumnWidth(0.25), // Quantity column (increased width)
                    3: FractionColumnWidth(0.27),
                  // Bin column
                  }:{
                    0: FractionColumnWidth(0.25), // S.No. column
                    1: FractionColumnWidth(0.4), // Sku column
                    2: FractionColumnWidth(0.35), // Quantity column (increased width)
                    // Bin column
                  },
                  children: widget.isTextFieldRequired? [
                    TableRow(children: [
                      TableCell(
                child: Container(
                  height: 80,
                 
                   // Set the height for the header row
                  alignment: Alignment.center,
                     
                  child: Text("S.No.", style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                      ),
                      TableCell(
                child: Container(
                  height: 80,
                  alignment: Alignment.center,
                  
                  child: Text("Sku", style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                      ),
                      TableCell(
                child: Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: Text("Quantity", style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                      ),
                      TableCell(
                child: Container(
                  height: 80,
                  alignment: Alignment.center,
                 
                  child: Text("Bin", style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                      ),
                  
                    ]),
                    ...widget.products.asMap().entries.map((entry) {
                      int index = entry.key;
                      var product = entry.value;
                      return TableRow(children: [
                TableCell(
                  child: Container(
                    height: 80, // Set the height for each product row
                    alignment: Alignment.center,
                    child: Text("${index + 1}", textAlign: TextAlign.center),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text("${product['sku']}", textAlign: TextAlign.center),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text("${product['quantity']}", textAlign: TextAlign.center),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: widget.isTextFieldRequired ? BinTextField(controller: binControllers[index]) : Container(),
                  ),
                ),
                     
                      ]);
                    }).toList(),
                  ]:[
                    TableRow(children: [
                      TableCell(
                child: Container(
                  height: 80, // Set the height for the header row
                  alignment: Alignment.center,
                     
                  child: Text("S.No.", style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                      ),
                      TableCell(
                child: Container(
                  height: 80,
                  alignment: Alignment.center,
                  
                  child: Text("Sku", style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                      ),
                      TableCell(
                child: Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: Text("Quantity", style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                      ),
                    
                    ]),
                    ...widget.products.asMap().entries.map((entry) {
                      int index = entry.key;
                      var product = entry.value;
                      return TableRow(children: [
                TableCell(
                  child: Container(
                    height: 80, // Set the height for each product row
                    alignment: Alignment.center,
                    child: Text("${index + 1}", textAlign: TextAlign.center),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text("${product['sku']}", textAlign: TextAlign.center),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Text("${product['quantity']}", textAlign: TextAlign.center),
                  ),
                ),
                  
                    
                    
              
                      ]);
                    }).toList(),
                  ],
                  
                ),
                const Divider(thickness: 3),
                Container(
                  
                  height: 50,
                  width: deviceSize.width*0.9,
                  alignment: Alignment.center,
                  child: Text("Bin Image",style: TextStyle(color: Colors.blue,fontSize: 24,fontWeight: FontWeight.bold),),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                ),
                  GestureDetector(
                  onTap: () {
                    showDialog(
                     
                        context: context,
                        builder: (context) {
                          return Dialog(
                             insetPadding: EdgeInsets.zero,
                            child: Container(
                              height: 220,
                              width: 220,
                              decoration: BoxDecoration(
                                color: Colors.black87,
                               
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      file = await uploadImage(ImageSource.gallery);
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
                                      file = await uploadImage(ImageSource.camera);
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
                    height: deviceSize.height * 0.35,
                    width: deviceSize.width * 0.9,
                    margin: EdgeInsets.only(top: 5),
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
                               height: deviceSize.height*0.2,
                               width: deviceSize.width*0.8,
                               decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage("assets/images/image_placeholder.jpg"),fit: BoxFit.cover)
                               ),
                              ),
                              Container(
                                  height: 80,
                                  width: 200,
                                  padding: EdgeInsets.only(left: 15),
                                  margin: EdgeInsets.only(top: 15),
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
                const Divider(thickness: 3),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if(widget.isTextFieldRequired){
                        for(int i=0;i<widget.products.length;i++){
                          if(binControllers[i].text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a bin at S.No. $i and then submit",style: TextStyle(color: Colors.white,fontSize: 18,),),backgroundColor: Colors.black,));
                            return;
                          }
                          else{
                            bins.add(BinnerModel(sku: widget.products[i]['sku'], quantity: widget.products[i]['quantity'], Bin: binControllers[i].text.toString().toUpperCase()));
                          }
                        }
                         _sendData("bin", widget.id);
                         
                      }
                      else{
                      _sendData("qc",widget.id);
                      }
                      
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black)
                      ),
                      elevation: 4,
                      backgroundColor: Colors.blue.shade700,
                      fixedSize: Size(120,50) // Button color
                    ),
                    child: isLoading?Center(child: CircularProgressIndicator(color: Colors.white,),): Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         const Text(
        //           "S.No.",
        //           style: TextStyle(
        //             color: Colors.black,
        //             fontSize: 18,
        //           ),
        //         ),
        //         widget.isTextFieldRequired?const SizedBox(width: 23,):const SizedBox(width: 57,),
        //         const Text(
        //           "Product-id",
        //           style: TextStyle(
        //             color: Colors.black,
        //             fontSize: 18,
        //           ),
        //         ),
        //          widget.isTextFieldRequired?const SizedBox(width: 30,):const SizedBox(width: 57,),
        //         const Text(
        //           "Quantity",
        //           style: TextStyle(color: Colors.black, fontSize: 18),
        //         ),
        //         // const SizedBox(
        //         //   width: 70,
        //         // ),
        //          const SizedBox(width: 38,),
        //         widget.isTextFieldRequired?const Text(
        //           "Bin",
        //           style: TextStyle(color: Colors.black, fontSize: 18),
        //         ):Container(),
        //       ],
        //     ),
        //     const SizedBox(
        //       height: 20,
        //     ),
        //     Container(
        //       height: deviceSize.height * 0.2,
        //       width: deviceSize.width * 0.9,
        //       child: Row(
        //         children: [
        //           Container(
        //             width: deviceSize.width*0.8,
        //             child: ListView.builder(
        //               itemBuilder: (context, index) {
        //                 return Row(
        //                   mainAxisAlignment: widget.isTextFieldRequired?MainAxisAlignment.start:MainAxisAlignment.center,
        //                   children: [
        //                     // widget.isTextFieldRequired?const SizedBox(width: 0,):const SizedBox(width: 20,),
        //                     Text(
        //                       "${index+1}",
        //                       style: TextStyle(
        //                         color: Colors.black,
        //                         fontSize: 18,
        //                       ),
        //                     ),
        //                     widget.isTextFieldRequired?const SizedBox(width: 80,):const SizedBox(width: 100,),
        //                     Text(
        //                       "${widget.products[index]['sku']}",
        //                       style: TextStyle(
        //                         color: Colors.black,
        //                         fontSize: 18,
        //                       ),
        //                     ),
        //                 widget.isTextFieldRequired?const SizedBox(width: 80,):const SizedBox(width: 100,),
        //                     // const SizedBox(width: 100,),
        //                     Text(
        //                       "${widget.products[index]['quantity']}",
        //                       style: TextStyle(
        //                         color: Colors.black,
        //                         fontSize: 18,
        //                       ),
        //                     ),
        //                     const SizedBox(width: 40,),
        //                     // const SizedBox(width: 100,),
        //                     widget.isTextFieldRequired?BinTextField(controller: binControllers[index],):Container(),
        //                   ],
        //                 );
        //               },
        //               itemCount: widget.products.length,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     const SizedBox(
        //       height: 20,
        //     ),
        //     GestureDetector(
        //       onTap: () {
        //         showDialog(
        //             context: context,
        //             builder: (context) {
        //               return Dialog(
        //                 child: Container(
        //                   height: 200,
        //                   width: 200,
        //                   decoration: BoxDecoration(
        //                     color: Colors.black87,
        //                     borderRadius: BorderRadius.circular(20),
        //                   ),
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       ElevatedButton(
        //                         onPressed: () async {
        //                           file = await uploadImage(ImageSource.gallery);
        //                           setState(() {});
        //                           Navigator.pop(context);
        //                         },
        //                         child: Text(
        //                           "Photo From Gallery",
        //                           style: TextStyle(
        //                               color: Colors.white,
        //                               fontSize: 14,
        //                               fontWeight: FontWeight.bold),
        //                         ),
        //                         style: ElevatedButton.styleFrom(
        //                           backgroundColor: Colors.transparent,
        //                           side: BorderSide(color: Colors.grey),
        //                           fixedSize: Size(200, 80),
        //                         ),
        //                       ),
        //                       SizedBox(
        //                         height: 10,
        //                       ),
        //                       ElevatedButton(
        //                         onPressed: () async {
        //                           file = await uploadImage(ImageSource.camera);
        //                           setState(() {});
        //                           Navigator.pop(context);
        //                         },
        //                         child: Text(
        //                           "Capture From camera",
        //                           style: TextStyle(
        //                               color: Colors.white,
        //                               fontSize: 14,
        //                               fontWeight: FontWeight.bold),
        //                         ),
        //                         style: ElevatedButton.styleFrom(
        //                           backgroundColor: Colors.transparent,
        //                           side: BorderSide(color: Colors.grey),
        //                           fixedSize: Size(200, 80),
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //               );
        //             });
        //       },
        //       child: Container(
        //         height: deviceSize.height * 0.2,
        //         width: deviceSize.width * 0.7,
        //         decoration: BoxDecoration(
        //           border: Border.all(color: Colors.black),
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //         child: file != null
        //             ? Image.file(
        //                 file!,
        //                 fit: BoxFit.cover,
        //               )
        //             : Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Icon(
        //                     Icons.add,
        //                     color: Colors.black,
        //                     size: 50,
        //                   ),
        //                   Container(
        //                       height: 80,
        //                       width: 200,
        //                       padding: EdgeInsets.only(left: 15),
        //                       child: Text(
        //                         "Upload Photo Or Capture From camera",
        //                         style: TextStyle(
        //                           fontSize: 18,
        //                           color: Colors.black,
        //                         ),
        //                         overflow: TextOverflow.clip,
        //                         textAlign: TextAlign.left,
        //                       ))
        //                 ],
        //               ),
        //       ),
        //     ),

            // Spacer(), // Space between text field and button
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       if(widget.isTextFieldRequired){
            //         for(int i=0;i<widget.products.length;i++){
            //           if(binControllers[i].text.isEmpty){
            //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a bin at S.No. $i and then submit",style: TextStyle(color: Colors.white,fontSize: 18,),),backgroundColor: Colors.black,));
            //             return;
            //           }
            //           else{
            //             bins.add(BinnerModel(sku: widget.products[i]['sku'], quantity: widget.products[i]['quantity'], Bin: binControllers[i].text.toString().toUpperCase()));
            //           }
            //         }
            //          _sendData("bin", widget.id);
            //       }
            //       else{
            //       _sendData("qc",widget.id);
            //       }
            //     },
            //     style: ElevatedButton.styleFrom(
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       backgroundColor: Colors.blue.shade700, // Button color
            //     ),
            //     child: Text(
            //       'Submit',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // ),
        //   ],
        // ),
      )
      );
    // );
  }
  Future<void> _sendData(String endPoint,String id) async {
    setState(() {
      isLoading = true;
    });
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      setState(() {
        isLoading=false;
      });
      return;
    }

    final mimeTypeData = lookupMimeType(file!.path)?.split('/');
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://inventory-management-backend-s37u.onrender.com/inbound/${endPoint}/${id}'),
    );

    // Add headers
    imageUploadRequest.headers['Authorization'] = 'Bearer $token';

    // Add fields
    if(widget.isTextFieldRequired){
      final binProducts = jsonEncode(bins
      .map((binProduct) => {
            "Sku": binProduct.sku,
            "bin":binProduct.Bin,
          })
      .toList());
      imageUploadRequest.fields['products'] = binProducts;

    }
    // final products = jsonEncode([
    //   {
    //     'sku': widget.productId,
    //     'quantity': int.parse(widget.quantity.toString())
    //   }
    // ]);
    // imageUploadRequest.fields['products'] = products;

    // Add files
    imageUploadRequest.files.add(
      await http.MultipartFile.fromPath(
        'images',
        file!.path,
        contentType: mimeTypeData != null
            ? MediaType(mimeTypeData[0], mimeTypeData[1])
            : null,
      ),
    );

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201||response.statusCode==200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.reasonPhrase}')),
        );
        print('Failed to upload: ${response.body}');
      }
    } catch (e) {
      print('Exception caught: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading: $e')),
      );
    }
    setState(() {
      isLoading=false;
    });
   
 
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    binControllers.forEach((bin){
      bin.dispose();
    });
  }
}