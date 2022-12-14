import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: wAppIcon(
            icon: Icons.arrow_back,
            iconColor: Colors.black,
            size: wDimension.iconSize24,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => authC.logout(),
              icon: wAppIcon(
                icon: Icons.logout,
                iconColor: Colors.black,
                size: wDimension.iconSize24,
              ))
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              AvatarGlow(
                endRadius: 110,
                glowColor: Colors.blue,
                duration: const Duration(seconds: 3),
                child: Container(
                  margin: EdgeInsets.all(wDimension.height20),
                  width: wDimension.widthSetengah / 3,
                  height: wDimension.heightSetengah / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      wDimension.radius30 * 5,
                    ),
                    child: authC.user.value.photoUrl == "noimage"
                        ? Image.asset(
                            "assets/logo/noimage.png",
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            authC.user.value.photoUrl!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              Obx(
                () => wSmallText(
                    text: "${authC.user.value.name}",
                    textalign: TextAlign.center,
                    weight: FontWeight.bold,
                    size: wDimension.font20,
                    color: Colors.black54),
              ),
              wSmallText(
                  text: "${authC.user.value.email}",
                  textalign: TextAlign.center,
                  size: wDimension.font16,
                  color: Colors.black54),
            ],
          ),

          //
          SizedBox(height: wDimension.height20),

          //
          Expanded(
            child: Column(
              children: [
                ListTile(
                  onTap: () => Get.toNamed(Routes.UPDATE_STATUS),
                  leading: wAppIcon(
                    icon: Icons.note_add_outlined,
                    iconColor: Colors.black54,
                    size: wDimension.font20,
                  ),
                  title: wBigText(
                    text: "Update Status",
                    color: Colors.black54,
                  ),
                  trailing: wAppIcon(
                    icon: Icons.arrow_right,
                    iconColor: Colors.black54,
                    size: wDimension.iconSize24,
                  ),
                ),
                ListTile(
                  onTap: () => Get.toNamed(Routes.CHANGE_PROFILE),
                  leading: wAppIcon(
                    icon: Icons.person,
                    iconColor: Colors.black54,
                    size: wDimension.iconSize24,
                  ),
                  title: wBigText(
                    text: "Change Profile",
                    color: Colors.black54,
                  ),
                  trailing: wAppIcon(
                    icon: Icons.arrow_right,
                    iconColor: Colors.black54,
                    size: wDimension.iconSize24,
                  ),
                ),
                ListTile(
                  onTap: () => Get.toNamed(Routes.CHANGE_PROFILE),
                  leading: wAppIcon(
                    icon: Icons.color_lens,
                    iconColor: Colors.black54,
                    size: wDimension.iconSize24,
                  ),
                  title: wBigText(
                    text: "Change Theme",
                    color: Colors.black54,
                  ),
                  trailing: wBigText(text: "Light"),
                ),
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(bottom: context.mediaQueryPadding.bottom + 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                wSmallText(text: "Chat App", color: Colors.black54),
                wSmallText(text: "v 1.0", color: Colors.black54),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
