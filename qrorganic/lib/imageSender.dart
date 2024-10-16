import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class ImageSender extends StatefulWidget {
  const ImageSender({super.key});

  @override
  _ImageSenderState createState() => _ImageSenderState();
}

class _ImageSenderState extends State<ImageSender> {
  final _formKey = GlobalKey<FormState>();
  final _skuController = TextEditingController();
  final _quantityController = TextEditingController();
  File? _image;
  final _picker = ImagePicker();
  final String _token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InNha3NoYW0uZGV2QGthdHlheWFuaW9yZ2FuaWNzLmNvbSIsImlkIjoiNjZjNTc5ZGJmNTA1YTA0OWE4YjVjMzA3IiwiaWF0IjoxNzI5MDYyMzk5LCJleHAiOjE3MjkxMDU1OTl9.3Hv9AUAHpPFMDNYq7JHKYBjpKdekn5te3j7ajE_bYsQ";

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendData() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    final mimeTypeData = lookupMimeType(_image!.path)?.split('/');
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://inventory-management-backend-s37u.onrender.com/inbound'),
    );

    // Add headers
    imageUploadRequest.headers['Authorization'] = 'Bearer $_token';

    // Add fields
    final products = jsonEncode([
      {
        'sku': _skuController.text,
        'quantity': int.parse(_quantityController.text)
      }
    ]);
    imageUploadRequest.fields['products'] = products;

    // Add files
    imageUploadRequest.files.add(
      await http.MultipartFile.fromPath(
        'images',
        _image!.path,
        contentType: mimeTypeData != null
            ? MediaType(mimeTypeData[0], mimeTypeData[1])
            : null,
      ),
    );

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Entry")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _skuController,
                  decoration: InputDecoration(labelText: 'SKU'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter SKU';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    return null;
                  },
                ),
                if (_image != null) Image.file(_image!),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),
                ElevatedButton(
                  onPressed: _sendData,
                  child: Text('Send Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
