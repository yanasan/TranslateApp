import 'package:dio/dio.dart';

class GoogleTranslateApi {
  static String apiKey = 'AIzaSyBPrFFuSy804wotiC6Kib_7Dgag_2F45FQ';

  static Future<String> translate(String text) async {
    final response = await Dio().post(
        'https://translation.googleapis.com/language/translate/v2?target=ja&key=$apiKey&q=$text');
    String translatedText =
        response.data['data']['translations'][0]['translatedText'];
    return translatedText;
  }
}
