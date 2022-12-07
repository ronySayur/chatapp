import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              icon: wAppIcon(
                icon: Icons.logout,
                iconColor: Colors.black,
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Column(children: [
              AvatarGlow(
                endRadius: 110,
                glowColor: Colors.blue,
                duration: Duration(seconds: 3),
                child: Container(
                  margin: EdgeInsets.all(20),
                  width: wDimension.widthSetengah / 3,
                  height: wDimension.heightSetengah / 3,
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
              wSmallText(
                  text: "Lorem Ipsum",
                  textalign: TextAlign.center,
                  weight: FontWeight.bold,
                  size: wDimension.font20,
                  color: Colors.black54),
              wSmallText(
                  text: "Lorem Ipsum@gmail.com",
                  textalign: TextAlign.center,
                  size: wDimension.font16,
                  color: Colors.black54),
            ]),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: wAppIcon(
                        icon: Icons.note_add_outlined,
                        iconColor: Colors.black54),
                    title: wBigText(
                      text: "Update Status",
                      color: Colors.black54,
                    ),
                    trailing: wAppIcon(
                        icon: Icons.arrow_right, iconColor: Colors.black54),
                  ),
                  ListTile(
                    onTap: () {},
                    leading:
                        wAppIcon(icon: Icons.person, iconColor: Colors.black54),
                    title: wBigText(
                      text: "Change Profile",
                      color: Colors.black54,
                    ),
                    trailing: wAppIcon(
                        icon: Icons.arrow_right, iconColor: Colors.black54),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: wAppIcon(
                        icon: Icons.color_lens, iconColor: Colors.black54),
                    title: wBigText(
                      text: "Change Theme",
                      color: Colors.black54,
                    ),
                    trailing: wBigText(text: "Light"),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(bottom: context.mediaQueryPadding.bottom + 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
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
