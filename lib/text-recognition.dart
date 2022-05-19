import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognition extends StatefulWidget {
  static const route = "/TextRecognition";

  const TextRecognition({Key? key}) : super(key: key);

  @override
  State<TextRecognition> createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition> {
  String? imagePath;
  File? imageFile;
  RecognizedText? recognizedText;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Распознавалка"),
        actions: [
          IconButton(
            onPressed: () {
              recognizeText();
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (imageFile != null)
            Center(
              child: Image.file(imageFile!),
            ),
          if (loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.photo_camera),
        onPressed: () async {
          final ImagePicker _picker = ImagePicker();
          // Pick an image
          final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            setState(() {
              imagePath = image.path;
              imageFile = File(image.path);
            });
          }
        },
      ),
    );
  }

  void recognizeText() async {
    if (imageFile != null) {
      setState(() => loading = true);
      final recognizer = TextRecognizer();
      final inputImage = InputImage.fromFile(imageFile!);
      final result = await recognizer.processImage(inputImage);
      for (TextBlock block in result.blocks) {
        print(block.text);
        print(block.recognizedLanguages);
      }
      setState(() {
        recognizedText = result;
        loading = false;
      });
    }
  }
}
