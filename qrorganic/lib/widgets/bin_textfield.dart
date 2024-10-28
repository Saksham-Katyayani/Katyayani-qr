import 'package:flutter/material.dart';

class BinTextField extends StatefulWidget {
  TextEditingController controller=TextEditingController();
  BinTextField({super.key,required this.controller});

  @override
  State<BinTextField> createState() => _BinTextFieldState();
}

class _BinTextFieldState extends State<BinTextField> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
                         width: 50,
                         height: 30,
                         margin: EdgeInsets.only(bottom: 10),
                        child: TextField(
                          cursorHeight: 20,
                          decoration: InputDecoration(
                            
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue.shade700),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue.shade700),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          hintText: "Tag",
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                          ),
                          keyboardType: TextInputType.name,
                          controller: widget.controller,
                        ),);
  }
}