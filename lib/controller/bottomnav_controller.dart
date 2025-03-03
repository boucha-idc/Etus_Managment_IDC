import 'package:get/get.dart';

class NavigationController extends GetxController {
  var selectBtn = 0.obs;

  void selectButton(int index) {
    selectBtn.value = index;
  }
}
