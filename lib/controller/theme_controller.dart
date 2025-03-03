import 'package:idc_etus_bechar/utils/theme.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }

  ThemeData get theme => isDarkMode.value ? AppTheme.darkTheme : AppTheme.lightTheme;

  @override
  void onInit() {
    super.onInit();
  }
}
