import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/widgets.dart';
import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: wAppIcon(
              icon: Icons.arrow_back,
              iconColor: Colors.white,
              size: wDimension.iconSize24,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: wAppIcon(
                icon: Icons.save,
                iconColor: Colors.white,
                size: wDimension.iconSize24,
              ),
            )
          ],
          backgroundColor: Colors.red[900],
          title: const Text('Change Profile'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              AvatarGlow(
                endRadius: 75,
                glowColor: Colors.blue,
                duration: Duration(seconds: 3),
                child: Container(
                  margin: EdgeInsets.all(wDimension.height20),
                  width: wDimension.widthSetengah / 4,
                  height: wDimension.heightSetengah / 4,
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius:
                        BorderRadius.circular(wDimension.radius30 * 10),
                    // ignore: prefer_const_constructors
                    image: DecorationImage(
                      image: const AssetImage("assets/logo/noimage.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: wDimension.height20),
              TextField(
                controller: controller.emailC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                      color: Colors.black, fontSize: wDimension.font20),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(wDimension.radius30 * 10),
                      borderSide: const BorderSide(color: Colors.red)),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(wDimension.radius30 * 10),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: wDimension.width30,
                    vertical: wDimension.height15,
                  ),
                ),
              ),
              SizedBox(height: wDimension.height20),
              TextField(
                controller: controller.nameC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: const TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(wDimension.radius30 * 10),
                      borderSide: const BorderSide(color: Colors.red)),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(wDimension.radius30 * 10),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: wDimension.width30,
                    vertical: wDimension.height15,
                  ),
                ),
              ),
              SizedBox(height: wDimension.height20),
              TextField(
                controller: controller.statusC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Status",
                  labelStyle: const TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(wDimension.radius30 * 10),
                      borderSide: const BorderSide(color: Colors.red)),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(wDimension.radius30 * 10),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: wDimension.width30,
                    vertical: wDimension.height15,
                  ),
                ),
              ),
              SizedBox(height: wDimension.height20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: wDimension.width10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    wSmallText(text: "No image"),
                    TextButton(
                        onPressed: () {},
                        child: wSmallText(
                          text: "chosen..",
                          weight: FontWeight.bold,
                        ))
                  ],
                ),
              ),
              SizedBox(height: wDimension.height30),
              SizedBox(
                width: wDimension.screenWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                    shape: const StadiumBorder(),
                    padding: EdgeInsets.symmetric(
                      horizontal: wDimension.width30,
                      vertical: wDimension.height15,
                    ),
                  ),
                  onPressed: () {},
                  child: wSmallText(
                    text: "Update",
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
