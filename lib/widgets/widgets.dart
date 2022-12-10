// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class wDimension {
  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;
//ukuran bottomview
  static double bottomHeightBar = screenHeight / 7.03;

//ukuran font
  static double font16 = screenHeight / 52.75;

  static double font20 = screenHeight / 42.2;
  static double font26 = screenHeight / 32.46;
//Ketingggian
  static double height10 = screenHeight / 84.4;

  static double height15 = screenHeight / 56.27;
  static double height20 = screenHeight / 42.2;
  static double height30 = screenHeight / 28.13;
  static double height45 = screenHeight / 18.76;

  static double heightSetengah = screenHeight * 0.5;

  static double iconSize16 = screenHeight / 52.75;
//ukuran icon
  static double iconSize24 = screenHeight / 35.17;

//ukuran image
  static double listViewImgSize = screenWidth / 3.25;

  static double listViewTextContSize = screenWidth / 3.9;
//ukuran page
  static double pageView = screenHeight / 2.64;

  static double pageViewContainer = screenHeight / 3.84;
  static double pageViewTextContainer = screenHeight / 7.03;
//lekuk radius
  static double radius15 = screenHeight / 56.27;

  static double radius20 = screenHeight / 42.2;
  static double radius30 = screenHeight / 28.13;

//Lebar
  static double width10 = screenHeight / 84.4;

  static double width15 = screenHeight / 56.27;
  static double width20 = screenHeight / 42.2;
  static double width30 = screenHeight / 28.13;
  static double widthSetengah = screenHeight * 0.5;
}

// ignore: must_be_immutable
class wBigText extends StatelessWidget {
  wBigText({
    super.key,
    this.color = const Color(0xFF1e81b0),
    required this.text,
    this.size = 0,
    this.weight = FontWeight.normal,
    this.overflow = TextOverflow.ellipsis,
  });

  Color? color;
  TextOverflow overflow;
  double size;
  final String text;
  FontWeight weight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: size == 0 ? wDimension.font20 : size,
        fontWeight: weight,
      ),
    );
  }
}

// ignore: must_be_immutable
class wSmallText extends StatelessWidget {
  wSmallText(
      {super.key,
      required this.text,
      this.weight = FontWeight.normal,
      this.color = const Color(0xFF1e81b0),
      this.size = 12,
      this.height = 1.2,
      this.textalign = TextAlign.start});

  Color? color;
  FontWeight weight;
  double height;
  double size;
  final String text;
  TextAlign textalign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textalign,
      maxLines: 1,
      style: TextStyle(
        color: color,
        fontSize: size,
        height: height,
        fontWeight: weight,
      ),
    );
  }
}

//Widget icon
class wAppIcon extends StatelessWidget {
  const wAppIcon({
    Key? key,
    required this.icon,
    this.backgroundColor = const Color.fromARGB(0, 255, 255, 255),
    this.iconColor = const Color.fromARGB(255, 255, 255, 255),
    this.size = 40,
    this.iconSize = 24,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double iconSize;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          color: backgroundColor),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
