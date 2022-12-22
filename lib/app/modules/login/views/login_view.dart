import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(wDimension.height30),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      SizedBox(
                        width: wDimension.widthSetengah,
                        height: wDimension.heightSetengah,
                        child: Lottie.asset("assets/lottie/login.json"),
                      ),
                      SizedBox(height: wDimension.height30 * 5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.red[900],
                            padding: EdgeInsets.symmetric(
                                vertical: wDimension.height15)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        wDimension.radius30 * 5),
                                  ),
                                  width: wDimension.width30,
                                  height: wDimension.height30,
                                  child: Image.asset("assets/logo/google.png")),
                              SizedBox(width: wDimension.width15),
                              wBigText(
                                text: "Sign in with google",
                                color: Colors.white,
                              )
                            ]),
                        onPressed: () => authC.login(),
                      )
                    ])))));
  }
}
