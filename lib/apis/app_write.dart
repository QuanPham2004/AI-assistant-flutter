import 'dart:developer';

import 'package:appwrite/appwrite.dart';

import '../helper/global.dart';
import '../model/conversation_model.dart';

class AppWrite {
  static final _client = Client();
  static final _database = Databases(_client);

  static void init() {
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('65f7cb7c74043108bdaa')
        .setSelfSigned(status: true);
    getApiKey();
  }

  static Future<String> getApiKey() async {
    try {
      final d = await _database.getDocument(
          databaseId: 'MyDatabase',
          collectionId: 'ApiKey',
          documentId: 'chatGptKey');

      apiKey = d.data['apiKey'].trim();
      log(apiKey);
      return apiKey;
    } catch (e) {
      log('$e');
      return '';
    }
  }

  Future<void> saveConversation(String userID, String message) async {
    try {
      // Tạo một đối tượng Conversation từ userID, message và thời gian hiện tại
      ConversationMessage conversation = ConversationMessage(
        userID: userID,
        message: message,
        timestamp: DateTime.now(),
      );

      // Gọi API của Appwrite để lưu Conversation vào collection "conversations"
      final response = await AppWrite._database.createDocument(
        collectionId: 'conversations',
        data: conversation.toJson(),
        databaseId: 'MyDatabase',
        documentId: ID.unique(),
      );
      // Kiểm tra và xử lý response
      log('Response: $response');
    } catch (e) {
      // Xử lý các trường hợp lỗi
      log('Error: $e');
    }
  }

  // Hàm để lấy dữ liệu train từ Appwrite
  Future<List<Map<String, dynamic>>?> getTrainData() async {
    try {
      // Truy vấn cơ sở dữ liệu Appwrite để lấy dữ liệu train
      final response = await _database.listDocuments(
          databaseId: 'MyDatabase', collectionId: 'train');
      // ignore: unnecessary_null_comparison
      if (response != null && response.documents.isNotEmpty) {
        // Trích xuất dữ liệu từ mỗi document trong danh sách
        final List<Map<String, dynamic>> trainData = [];
        for (final document in response.documents) {
          // Truy cập thuộc tính 'data' của mỗi document
          final Map<String, dynamic> data = document.data;
          trainData.add(data);
        }
        log('Train data: $response');
        return trainData;
      } else {
        // Nếu không có dữ liệu train
        return null;
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }
}
