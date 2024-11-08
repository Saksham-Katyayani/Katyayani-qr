import 'dart:convert';
import 'package:qrorganic/Provider/auth_provider.dart';

import '../Model/inbound_model.dart';
import 'package:qrorganic/Model/product_model.dart';
import 'package:qrorganic/services/api_urls.dart';
import 'package:provider/provider.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<String> postInbound(List<InBoundModel> inbounds, File imageFile) async {
  final token = await AuthProvider().getToken();
  String postReslt = '';
  if (imageFile == null) {
    postReslt = 'Please select image and then send data';
    return postReslt;
  }

  final mimeTypeData = lookupMimeType(imageFile!.path)?.split('/');
  final imageUploadRequest = http.MultipartRequest(
    'POST',
    Uri.parse('https://inventory-management-backend-s37u.onrender.com/inbound'),
  );

  // Add headers
  imageUploadRequest.headers['Authorization'] = 'Bearer $token';

  // Add fields
  final products = jsonEncode(inbounds
      .map((product) => {
            "sku": product.sku,
            "quantity": product.quantity,
          })
      .toList());

//     'sku':'${product.sku}',
//     'quantity':product.quantity

//   }).toList());
  imageUploadRequest.fields['products'] = products;

  // Add files
  imageUploadRequest.files.add(
    await http.MultipartFile.fromPath(
      'images',
      imageFile!.path,
      contentType: mimeTypeData != null
          ? MediaType(mimeTypeData[0], mimeTypeData[1])
          : null,
    ),
  );

  try {
    final streamedResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      postReslt = 'Upload successful';
    } else {
      print('Upload failed: ${response.statusCode}');
      print('Failed to upload: ${response.body}');
      postReslt = 'Sorry! Failed to upload data';
    }
  } catch (e) {
    print('Exception caught: $e');
    print('Error uploading: $e');
  }
  return postReslt;
}

Future<List<Product>> getData(String queryValue) async {
  final token = await AuthProvider().getToken();
  final response = await http.get(
    Uri.parse("${baseUrl}" + "/inbound" + "?status=" + "${queryValue}"),
    headers: {
      "Authorization": "Bearer ${token}",
      "Content-type": "application/json; charset=utf-8"
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    var productList = data['inboundInventory'] as List;

    final products = productList.map((product) {
      print(product['updatedAt']);
      return Product(
          products: product['products'],
          id: product['_id'],
          updatedAt: product['updatedAt'],
          images: product['images']);
    }).toList();
    print(products);
    return products;
  } else {
    print("${response.statusCode}" + " " + "${response.reasonPhrase}");
    throw Exception('Failed to load products');
  }
}
