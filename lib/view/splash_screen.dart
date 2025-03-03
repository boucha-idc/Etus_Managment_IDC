import 'package:idc_etus_bechar/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final role = prefs.getString('role') ?? '';

    if (token != null && token.isNotEmpty) {
      if (role.toLowerCase() == 'controller') {
        Get.offAllNamed(AppRoutes.scanQR);
      } else if (role.toLowerCase() == 'admin') {
        Get.offAllNamed(AppRoutes.homePage);
      } else {
        Get.offAllNamed(AppRoutes.signIn);
      }
    } else {
      Get.offAllNamed(AppRoutes.signIn);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.outline,
      body: Center(
        child: Stack(
          children: [
            Image.asset(
              'assets/icon/logo_etus.png',
              height: 300,
            ),

          ],
        ),
      ),
    );
  }
}
