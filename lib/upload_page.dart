import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Uint8List? imageBytes;
  String? imageName;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file =
    await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    imageBytes = await file.readAsBytes();
    imageName = file.name;

    setState(() {});
  }

  Future<String?> uploadImage() async {
    if (imageBytes == null || imageName == null) return null;

    final url = Uri.parse("http://127.0.0.1:8000/upload-image");
    final request = http.MultipartRequest("POST", url);

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes!,
        filename: imageName,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      return resStr;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("이미지 업로드")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageBytes != null)
            Image.memory(imageBytes!, height: 200),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: pickImage,
            child: Text("이미지 선택"),
          ),

          ElevatedButton(
            onPressed: () async {
              final result = await uploadImage();
              print(result);
            },
            child: Text("업로드"),
          ),
        ],
      ),
    );
  }
}
