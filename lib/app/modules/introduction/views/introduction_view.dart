import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../../../routes/app_pages.dart';
import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Berinteraksi dengan mudah",
          body: "HALLLELUYAAAAA",
          image: Container(
            width: Get.width * 0.6,
            height: Get.width * 0.6,
            child: Center(
              child: Lottie.asset("assets/lottie/main-laptop-duduk.json"),
            ),
          ),
        ),
        PageViewModel(
          title: "Hallleeee....",
          body: "LUUUUUUU.....",
          image: Container(
            width: Get.width * 0.6,
            height: Get.width * 0.6,
            child: Center(
              child: Lottie.asset("assets/lottie/ojek.json"),
            ),
          ),
        ),
        PageViewModel(
          title: "YAAAAAAAA....",
          body: "AAAAAAAAA.....",
          image: Container(
            width: Get.width * 0.6,
            height: Get.width * 0.6,
            child: Center(
              child: Lottie.asset("assets/lottie/payment.json"),
            ),
          ),
        ),
      ],
      showSkipButton: true,
      skip: wBigText(text: "Skip", weight: FontWeight.bold),
      next: wBigText(text: "Next", weight: FontWeight.bold),
      done: wBigText(text: "Login", weight: FontWeight.bold),
      onDone: () => Get.offAllNamed(Routes.LOGIN),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    ));
  }
}
