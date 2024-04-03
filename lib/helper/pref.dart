import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Pref {
  static late Box _box;

  static Future<void> initialize() async {
    //for initializing hive to use app directory
    // Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
    // _box = Hive.box(name: 'myData');

    await Hive.initFlutter();
    _box = await Hive.openBox('myData');
  }

  //for storing theme data
  static bool get isDarkMode => _box.get('isDarkMode') ?? false;
  static set isDarkMode(bool v) => _box.put('isDarkMode', v);

  static ThemeMode get defaultTheme {
    final data = _box.get('isDarkMode');
    log('data: $data');
    if (data == null) return ThemeMode.system;
    if (data == true) return ThemeMode.dark;
    return ThemeMode.light;
  }
}
