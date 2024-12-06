// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/custom/colors.dart';
import 'package:qrorganic/widgets/qr_scanner.dart';

class ShowDetailsOfOrderItem extends StatefulWidget {
  String oredrId;
  List<String> title;
  List<String> productName;
  List<int> numberOfItme;
  List<int> scannedQ;
  int totalQty;
  int scannedQty;
  bool isPicker;
  bool isPacker;
  bool isRacker;
  int itemQty;
  ShowDetailsOfOrderItem(
      {super.key,
      required this.numberOfItme,
      required this.title,
      required this.productName,
      required this.oredrId,
      required this.scannedQty,
      required this.totalQty,
      required this.scannedQ,
      this.isPicker = false,
      this.isPacker = false,
      this.isRacker = false,
      required this.itemQty});

  @override
  State<ShowDetailsOfOrderItem> createState() => _ShowDetailsOfOrderItemState();
}

class _ShowDetailsOfOrderItemState extends State<ShowDetailsOfOrderItem> {
  bool val = false;
  // int count=0
  ReadyToPackProvider? pro;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    pro = Provider.of<ReadyToPackProvider>(context, listen: false);

    await pro!.numberOfOrderCheckBox(
        widget.title.length, widget.numberOfItme, widget.scannedQ);
    setState(() {});
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
              color: AppColors.white,
            ),
          ),
        ),
        body: Consumer<ReadyToPackProvider>(
          builder: (context, readyToPackProvider, child) => readyToPackProvider
                  .isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemBuilder: (context, i) => SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                                      "${readyToPackProvider.productTitle[i]}\n(${readyToPackProvider.productName[i]}) ${widget.itemQty}",
                                      style: GoogleFonts.daiBannaSil(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  )),
                                  readyToPackProvider.orderItemCheckBox![i]
                                          [index]
                                      ? const FaIcon(
                                          FontAwesomeIcons.check,
                                          size: 25,
                                          color: Colors.green,
                                        )
                                      : const Text(''),
                                  // Checkbox(
                                  //     value:readyToPackProvider.orderItemCheckBox![i][index],
                                  //     onChanged: (val) {
                                  //       //  print("$i,$index");
                                  //       //  ReadyToPackProvider.updateCheckBoxValue(i,index);
                                  //     })
                                ],
                              ),
                            ),
                            onTap: () {
                              for (int j = 0;
                                  j < readyToPackProvider.productTitle.length;
                                  j++) {
                                if (readyToPackProvider.productTitle[i] ==
                                    readyToPackProvider.productTitle[j]) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ScannerWidget(
                                                onScan: (s) {},
                                                scanned: widget.scannedQ[j],
                                                totalQty:
                                                    widget.numberOfItme[j],
                                                index: j,
                                                oredrId: widget.oredrId,
                                                isPicker: widget.isPicker,
                                                isPacker: widget.isPacker,
                                                isRacker: widget.isRacker,
                                              )));
                                }
                              }
                            },
                          ),
                        );
                      },
                      itemCount: widget.numberOfItme[i],
                    ),
                  ),
                  itemCount: (widget.title.length as num).toInt(),
                ),
        ));
  }
}
