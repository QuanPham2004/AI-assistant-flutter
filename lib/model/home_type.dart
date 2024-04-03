import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/chatbot_feature.dart';

import '../screen/translator_feature.dart';

enum HomeType { aiChatBot, aiTranslator }

extension MyHomeType on HomeType {
  //title
  String get title => switch (this) {
        HomeType.aiChatBot => 'AI ChatBot',
        HomeType.aiTranslator => 'Language Translator',
      };

  //lottie
  String get lottie => switch (this) {
        HomeType.aiChatBot => 'ai_hand_waving.json',
        HomeType.aiTranslator => 'ai_ask_me.json',
      };

  //for alignment
  bool get leftAlign => switch (this) {
        HomeType.aiChatBot => true,
        HomeType.aiTranslator => true,
      };

  //for padding
  EdgeInsets get padding => switch (this) {
        HomeType.aiChatBot => EdgeInsets.zero,
        HomeType.aiTranslator => EdgeInsets.zero,
      };

  //for navigation
  VoidCallback get onTap => switch (this) {
        HomeType.aiChatBot => () => Get.to(() => const ChatBotFeature()),
        HomeType.aiTranslator => () => Get.to(() => const TranslatorFeature()),
      };
}
