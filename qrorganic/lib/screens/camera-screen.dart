import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:qrorganic/Provider/auth_provider.dart';
import 'package:qrorganic/Provider/ready-to-pack-api.dart';
import 'package:qrorganic/custom/colors.dart';

// manifest/confirm, manifestId, manifestImage

class CameraScreen extends StatefulWidget {
  final String manifestId;
  const CameraScreen({Key? key, required this.manifestId}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _token;
  // bool _isUploading = false;

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  Future<void> _requestGalleryPermission() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      await Permission.photos.request();
    }
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        await _requestCameraPermission();
      } else {
        await _requestGalleryPermission();
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxHeight: 600,
        maxWidth: 600,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No image selected")),
        );
      }
    } catch (e) {
      print("Error occurred while picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to get image: $e")),
      );
    }
  }

  Future<void> sendData() async {
    _token = await AuthProvider().getToken();
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    // Show uploading dialog
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Uploading..."),
            ],
          ),
        );
      },
    );

    // setState(() {
    //   _isUploading = true; // Show loading indicator
    // });

    final mimeTypeData = lookupMimeType(_image!.path)?.split('/');
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://inventory-management-backend-s37u.onrender.com/manifest/confirm'),
    );

    imageUploadRequest.headers['Authorization'] = 'Bearer $_token';
    imageUploadRequest.fields['manifestId'] = widget.manifestId;

    imageUploadRequest.files.add(
      await http.MultipartFile.fromPath(
        'manifestImage',
        _image!.path,
        contentType: mimeTypeData != null
            ? MediaType(mimeTypeData[0], mimeTypeData[1])
            : null,
      ),
    );

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pop();
        Navigator.pop(context, true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Upload successful, Manifest ID - ${widget.manifestId}')),
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
    // finally {
    //   // setState(() {
    //   //   _isUploading = false; // Hide loading indicator
    //   // });
    //   Navigator.of(context).pop(); // Dismiss the upload dialog
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.manifestId,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryBlue, width: 2),
                ),
                child: Image.file(
                  _image!,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              )
            else
              const Text(
                "No image selected.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _getImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
                // ElevatedButton.icon(
                //   onPressed: () => _getImage(ImageSource.gallery),
                //   icon: const Icon(Icons.photo_library),
                //   label: const Text("Gallery"),
                //   style: ElevatedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 20, vertical: 12),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 10),
            if (_image != null)
              ElevatedButton.icon(
                onPressed: sendData,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
