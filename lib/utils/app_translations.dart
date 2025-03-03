import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static Future<void> loadTranslations() async {
    try {
      final ar = await rootBundle.loadString('assets/lang/ar.json');
      final fr = await rootBundle.loadString('assets/lang/fr.json');
      final en = await rootBundle.loadString('assets/lang/en.json');


      final Map<String, Map<String, String>> translations = {
        'ar': Map<String, String>.from(json.decode(ar)),
        'fr': Map<String, String>.from(json.decode(fr)),
        'en': Map<String, String>.from(json.decode(en)),
      };


      Get.addTranslations(translations);
      Get.updateLocale(Locale('en'));
    } catch (e) {
      print("Error loading translations: $e");
    }
  }

  @override
  Map<String, Map<String, String>> get keys => {};
}
