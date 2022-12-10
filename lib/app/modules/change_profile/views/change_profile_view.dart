import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/widgets.dart';
import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  const ChangeProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const wAppIcon(
              icon: Icons.arrow_back,
              iconColor: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: wAppIcon(icon: Icons.save),
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
                  margin: EdgeInsets.all(20),
                  width: wDimension.widthSetengah / 4,
                  height: wDimension.heightSetengah / 4,
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius:
                        BorderRadius.circular(wDimension.radius30 * 10),
                    image: DecorationImage(
                      image: AssetImage("assets/logo/noimage.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: controller.emailC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(wDimension.radius30 * 10),
                      borderSide: BorderSide(color: Colors.red)),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(wDimension.radius30 * 10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.nameC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(wDimension.radius30 * 10),
                      borderSide: BorderSide(color: Colors.red)),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(wDimension.radius30 * 10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.statusC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Status",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(wDimension.radius30 * 10),
                      borderSide: BorderSide(color: Colors.red)),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(wDimension.radius30 * 10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
              SizedBox(height: 30),
              SizedBox(
                width: wDimension.screenWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
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
