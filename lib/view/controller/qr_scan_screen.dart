
import 'package:idc_etus_bechar/controller/bus_controller.dart';
import 'package:idc_etus_bechar/services/api_services_admin.dart';
import 'package:idc_etus_bechar/services/api_services_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:idc_etus_bechar/widgets/custom_scan_painter.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';
import 'package:get/get.dart';

class QRScanScreen extends StatelessWidget {
  final bool isValide = true;
  final BusController busController = Get.put(BusController(apiService: ApiServiceController(),
      apiAdminService:ApiServicesAdmin()));
  final TextEditingController _preferencesController = TextEditingController();
  String qrResult = "Scanned Data will appear here";

  Future<void> scanQr() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      if (!Get.isRegistered<BusController>()) return;

      _preferencesController.text = qrCode;
      qrResult = qrCode;
    } on PlatformException {
      qrResult = "Failed to scan QR Code";
    }
  }

  void _validateAndSearch() async {
    String reference = _preferencesController.text;
    if (reference.isEmpty) {
      Get.snackbar(
        "Input Required",
        "Please enter a reference or scan your QR code.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.transparent,
        colorText: Colors.black,
        borderRadius: 20.0,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        borderWidth: 2,
        duration: const Duration(seconds: 3),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    } else {
      var result = await busController.verifyReference(reference);
      if (result != null) {
        // Passing both reference and busId to the next screen
        Get.toNamed('/busEvaluation', arguments: result);
      }  else {
        Get.snackbar(
          "Invalid Reference",
          "The bus reference is not valid. Please try again.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.transparent,
          colorText: Colors.black,
          borderRadius: 20.0,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          borderWidth: 2,
          duration: const Duration(seconds: 3),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (busController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            double customPaintHeight = constraints.maxHeight * 0.4;
            return Stack(
              children: [
                SizedBox(height: 10),
                ClipRect(
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/scan_pic.jpg',
                        fit: BoxFit.cover,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      ),
                    ),
                  ),
                Positioned(
                  top: 30,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/profile');
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/profile_img_test.png'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Etus Bechar',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 60,
                  child: CustomPaint(
                    size: Size(constraints.maxWidth - 20, customPaintHeight),
                    painter: RPSCustomPainter(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 25),
                          Text(
                            "find_your_bus".tr,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "using_references_or_qr".tr,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: TextField(
                                    controller: _preferencesController,
                                    decoration: InputDecoration(
                                      hintText: "enter_your_bus_reference".tr,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(color: AppColors.primary),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 2.0,
                                        ),
                                      ),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primary,
                                          ),
                                          child: const Icon(
                                            Icons.numbers,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await scanQr();
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade200,
                                  ),
                                  child: const Icon(
                                    Icons.qr_code_scanner,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 160,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _validateAndSearch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  side: BorderSide(color: AppColors.primary),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                              ),
                              child: Text(
                                "find_bus".tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}

