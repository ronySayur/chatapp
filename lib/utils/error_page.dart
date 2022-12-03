import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: wBigText(
            text: "Terjadi kesalahan",
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
