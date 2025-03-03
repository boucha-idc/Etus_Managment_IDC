import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:idc_etus_bechar/controller/recipes_controller.dart';
import 'package:idc_etus_bechar/routes/app_routes.dart';
import 'package:idc_etus_bechar/utils/app_translations.dart';
import 'package:get/get.dart';

Future<void> main() async {
  runApp(const MyApp());
  Get.put(BusTripController());
  WidgetsFlutterBinding.ensureInitialized();
  await AppTranslations.loadTranslations();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Etus Bechar',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      translations: AppTranslations(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
    );
  }
}

