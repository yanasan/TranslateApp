import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:url/google_translate_api.dart';

class TranslatePage extends StatefulWidget {
  final String englishText;
  const TranslatePage(this.englishText, {Key? key}) : super(key: key);

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  String japaneseText = '';
  final LanguageModelManager = GoogleMlKit.nlp.translateLanguageModelManager();
  final OnDeviceTranslator = GoogleMlKit.nlp.onDeviceTranslator(
      sourceLanguage: TranslateLanguage.ENGLISH,
      targetLanguage: TranslateLanguage.JAPANESE);

  Future<void> downlodeModel() async {
    await LanguageModelManager.downloadModel('en');
    await LanguageModelManager.downloadModel('ja');

    // await translateText();
  }

  Future<void> translateText() async {
    var result = await OnDeviceTranslator.translateText(widget.englishText);
    setState(() {
      japaneseText = result;
    });
  }

  Future<void> googleTranslate() async {
    japaneseText = await GoogleTranslateApi.translate(widget.englishText);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // downlodeModel();
    googleTranslate();
  }

  @override
  void dispose() {
    super.dispose();
    OnDeviceTranslator.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(10),
            child: Text(
              widget.englishText,
              style: TextStyle(fontSize: 16, height: 2),
            ),
          ),
        )),
        Expanded(
            child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(10),
            child: Text(
              japaneseText,
              style: TextStyle(fontSize: 16, height: 2),
            ),
          ),
        )),
      ]),
    );
  }
}
