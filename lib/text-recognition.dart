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
  List<TextElement> elements = [];
  double? imageWidth;

  calculateImageWidth() async {
    var decodedImage = await decodeImageFromList(imageFile!.readAsBytesSync());
    imageWidth = decodedImage.width.toDouble();
  }

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
          if (imageWidth != null)
            Center(
              child: CustomPaint(
                foregroundPainter: EmailPainter(
                  elements: elements,
                  imageWidth: imageWidth!,
                ),
                child: Image.file(imageFile!),
              ),
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
              calculateImageWidth();
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
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            if (element.text.contains('@')) {
              elements.add(element);
            }
          }
        }
      }
      print(elements);
      setState(() {
        recognizedText = result;
        loading = false;
      });
    }
  }
}

class EmailPainter extends CustomPainter {
  final List<TextElement> elements;
  final double imageWidth;

  EmailPainter({required this.elements, required this.imageWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final scale = size.width / imageWidth;
    paint.strokeWidth = 2;
    paint.color = Colors.red;
    paint.style = PaintingStyle.stroke;
    for (var element in elements) {
      final rect = Rect.fromLTRB(element.boundingBox.left * scale, element.boundingBox.top * scale,
          element.boundingBox.right * scale, element.boundingBox.bottom * scale);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
