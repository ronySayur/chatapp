import 'package:get/get.dart';

import '../routes/app_pages.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  void login() {
    Get.offAllNamed(Routes.HOME);
  }

  void logout() {
    Get.offAllNamed(Routes.LOGIN);
  }
}
