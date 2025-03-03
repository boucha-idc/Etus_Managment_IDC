import 'package:idc_etus_bechar/utils/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  var selectedLanguage = 'English'.obs;
  List<Map<String, dynamic>> languages = [
    {'name': 'English', 'locale': 'en', 'image': 'assets/flags/English.png'},
    {'name': 'French', 'locale': 'fr', 'image': 'assets/flags/french.png'},
    {'name': 'Arabic', 'locale': 'ar', 'image': 'assets/flags/arabic.png'},
  ];

  @override
  void onInit() {
    super.onInit();
    AppTranslations.loadTranslations();
  }

  void selectLanguage(String languageName, String languageCode) {
    selectedLanguage.value = languageName;
    Get.updateLocale(Locale(languageCode));
  }
  double getCircleSize(String languageName) {
    return languageName == selectedLanguage.value ? 60 : 50;
  }
}
