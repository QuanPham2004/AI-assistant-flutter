import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:translator_plus/translator_plus.dart';

import '../helper/global.dart';
import 'app_write.dart';

class APIs {
  static Future<String> getAnswer(
      String question, List<Map<String, dynamic>> trainData) async {
    try {
      bool isRelatedToTrain = false;
      String response = '';
      final trainData = await AppWrite().getTrainData();
      for (var data in trainData!) {
        if (question.contains(data['discribe'])) {
          isRelatedToTrain = true;
          // Dùng từ ngữ trong dữ liệu train để tạo câu trả lời của chat bot
          response = " Tôi là Miracle, Dựa vào: ${data['data']}"
              "trả lời theo thông tin liên quan";
          break;
        }
      }

      if (isRelatedToTrain) {
        // Use the prompt with the chosen ChatGPT model
        final res = await post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $apiKey',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "max_tokens": 2000,
            "temperature": 0,
            "messages": [
              {"role": "user", "content": response},
            ],
          }),
        );

        final data = jsonDecode(utf8.decode(res.bodyBytes));
        final answer = data['choices'][0]['message']['content'];
        // Check Confidence Score (if available) and fallback to appwrite
        //response = answer;
        log('anwser train: $answer');
        return answer;
      } else {
        // Trả lời bằng API ChatGPT 3.5 Turbo
        final res = await post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $apiKey',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "max_tokens": 2000,
            "temperature": 0,
            "messages": [
              {"role": "user", "content": question},
            ],
          }),
        );

        final data = jsonDecode(utf8.decode(res.bodyBytes));
        log('data GPT3.5: $data');
        return data['choices'][0]['message']['content'];
      }
    } catch (e) {
      log('getAnswerE: $e');
      return 'Something went wrong (Try again in sometime)';
    }
  }

  static Future<String> googleTranslate(
      {required String from, required String to, required String text}) async {
    try {
      final res = await GoogleTranslator().translate(text, from: from, to: to);

      return res.text;
    } catch (e) {
      log('googleTranslateE: $e ');
      return 'Something went wrong!';
    }
  }
}
