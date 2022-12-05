import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: wDimension.widthSetengah,
                height: wDimension.heightSetengah,
                child: Lottie.asset("assets/lottie/login.json"),
              ),
              const SizedBox(width: 0.0, height: 150),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: Colors.red[900],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: wDimension.width30,
                      height: wDimension.height30,
                      child: Image.asset("assets/logo/google.png"),
                    ),
                    const SizedBox(width: 15, height: 0.0),
                    wBigText(
                      text: "Sign in with google",
                      color: Colors.white,
                    ),
                  ],
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
      )),
    );
  }
}
