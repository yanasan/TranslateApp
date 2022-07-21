import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url/view/translate_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  PickedFile? _image;
  TextDetector _textDetector = GoogleMlKit.vision.textDetector();
  String englishText = '';

  Future<void> pickImageFromGallery() async {
    _image = await _picker.getImage(source: ImageSource.gallery);
    if (_image != null) {
      await processPickedFile();
      print('画像を取得しました');
    }
  }

  Future<void> processPickedFile() async {
    final inputImage = InputImage.fromFile(File(_image!.path));
    final recognisedText = await _textDetector.processImage(inputImage);
    for (TextBlock block in recognisedText.blocks) {
      final String text = block.text;
      englishText = englishText + ' $text';
    }
    englishText = englishText.replaceAll('\n', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('URL'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('MLkit'),
            const SizedBox(height: 100),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                  onPressed: () async {
                    await pickImageFromGallery();
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TranslatePage(englishText)));
                    englishText = '';
                  },
                  child: const Text('画像選択')),
            ),
          ],
        ),
      ),
    );
  }
}
