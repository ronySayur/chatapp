import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfileController extends GetxController {
  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController statusC;
  late ImagePicker imagePicker;

  XFile? pickedImage;

  void resetImage() {
    pickedImage = null;
    update();
  }

  void selectImage() async {
    try {
      final checkDataImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (checkDataImage != null) {
        pickedImage = checkDataImage;
      }
      update();
    } catch (e) {
      Get.defaultDialog(title: "$e");
      pickedImage = null;
      update();
    }
  }

  @override
  void onInit() {
    emailC = TextEditingController();
    nameC = TextEditingController();
    statusC = TextEditingController();
    imagePicker = ImagePicker();
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    nameC.dispose();
    statusC.dispose();
    super.onClose();
  }
}
