//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/my_dialog.dart';
import '../model/message.dart';
import '../apis/app_write.dart';
import '../apis/apis.dart';

class ChatController extends GetxController {
  final textC = TextEditingController();
  final scrollC = ScrollController();

  final list = <Message>[
    Message(msg: 'Xin chào, bạn cần giúp gì?', msgType: MessageType.bot)
  ].obs;

  //user id demo
  final String userID = '01';

  Future<void> askQuestion() async {
    if (textC.text.isNotEmpty) {
      list.add(Message(msg: textC.text, msgType: MessageType.user));
      list.add(Message(msg: '', msgType: MessageType.bot));
      _scrollDown();

      // final res = await AppWrite().getTrainData();
      // print('res: $res');
      // if (res != null) {
      //   final botRes = await APIs.getAnswer(textC.text);
      //   list.removeLast();
      //   list.add(Message(msg: botRes, msgType: MessageType.bot));
      //   await AppWrite().saveConversation(userID, botRes);
      //   _scrollDown();
      // } else {
      final botRes = await APIs.getAnswer(textC.text, []);
      list.removeLast();
      list.add(Message(msg: botRes, msgType: MessageType.bot));
      await AppWrite().saveConversation(userID, botRes);
      _scrollDown();

      textC.text = '';
    } else {
      MyDialog.info('Hãy hỏi điều gì đó!');
    }
  }

  // Future<void> saveAllConversations() async {
  //   for (var message in list) {
  //     if (message.msgType == MessageType.user) {
  //       await AppWrite().saveConversation(userID, message.msg);
  //     }
  //   }
  // }

  void _scrollDown() {
    scrollC.animateTo(
      scrollC.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
