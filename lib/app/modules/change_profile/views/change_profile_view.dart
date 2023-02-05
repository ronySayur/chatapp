import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/widgets.dart';
import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    //inisiasi
    controller.emailC.text = authC.user.value.email!;
    controller.nameC.text = authC.user.value.name!;
    controller.statusC.text = authC.user.value.status!;

    //return
    return Scaffold(
        //
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: wAppIcon(
              icon: Icons.arrow_back,
              iconColor: Colors.white,
              size: wDimension.iconSize24,
            ),
          ),

          //
          actions: [
            IconButton(
              onPressed: () {
                authC.changeProfile(
                  controller.nameC.text,
                  controller.statusC.text,
                );
              },
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

        //
        body: Padding(
          padding: EdgeInsets.all(wDimension.height20),
          child: Expanded(
            child: ListView(
              children: [
                //
                AvatarGlow(
                    endRadius: wDimension.radius15 * 6,
                    glowColor: Colors.blue,
                    duration: const Duration(seconds: 3),
                    child: Container(
                        margin: EdgeInsets.all(wDimension.height20),
                        width: wDimension.widthSetengah / 4,
                        height: wDimension.heightSetengah / 4,
                        child: Obx(() => ClipRRect(
                            borderRadius:
                                BorderRadius.circular(wDimension.radius30 * 5),
                            child: authC.user.value.photoUrl == "noimage"
                                ? Image.asset("assets/logo/noimage.png",
                                    fit: BoxFit.cover)
                                : Image.network(authC.user.value.photoUrl!,
                                    fit: BoxFit.cover))))),

                //
                SizedBox(height: wDimension.height20),

                //
                TextField(
                  controller: controller.emailC,
                  readOnly: true,
                  textInputAction: TextInputAction.next,
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

                //
                SizedBox(height: wDimension.height20),

                //
                TextField(
                  textInputAction: TextInputAction.next,
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

                //
                SizedBox(height: wDimension.height20),

                //
                TextField(
                  controller: controller.statusC,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () {
                    authC.changeProfile(
                        controller.nameC.text, controller.statusC.text);
                  },
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
                      GetBuilder<ChangeProfileController>(
                          builder: (c) => c.pickedImage != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: wDimension.height20 * 6,
                                        width: wDimension.width20 * 6,
                                        child: Stack(children: [
                                          Container(
                                              height: wDimension.height20 * 5,
                                              width: wDimension.width20 * 5,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          wDimension.radius15 *
                                                              5),
                                                  image: DecorationImage(
                                                      image: FileImage(File(
                                                          c.pickedImage!.path)),
                                                      fit: BoxFit.cover))),
                                          Positioned(
                                              top: -5,
                                              right: 0,
                                              child: IconButton(
                                                  onPressed: () =>
                                                      c.resetImage(),
                                                  icon: wAppIcon(
                                                      icon: Icons.delete,
                                                      iconColor: Colors.red,
                                                      size: wDimension
                                                              .iconSize24 *
                                                          1.25,
                                                      iconSize: wDimension
                                                              .iconSize16 *
                                                          1.25,
                                                      backgroundColor:
                                                          Colors.white)))
                                        ])),
                                    TextButton(
                                        onPressed: () => c
                                                .uploadImage(
                                                    authC.user.value.uid!)
                                                .then((hasilKembalian) {
                                              if (hasilKembalian != null) {
                                                authC.updatePhotoUrl(
                                                    hasilKembalian);
                                              }
                                              ;
                                            }),
                                        child: wSmallText(
                                          text: "upload",
                                          weight: FontWeight.bold,
                                        ))
                                  ],
                                )
                              : wSmallText(text: "No image")),
                      TextButton(
                          onPressed: () => controller.selectImage(),
                          child: wSmallText(
                            text: "chosen..",
                            weight: FontWeight.bold,
                          ))
                    ],
                  ),
                ),

                //
                SizedBox(height: wDimension.height30),

                //
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
                    onPressed: () {
                      authC.changeProfile(
                        controller.nameC.text,
                        controller.statusC.text,
                      );
                    },
                    child: wSmallText(
                      text: "Update",
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
