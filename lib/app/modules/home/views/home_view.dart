import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final List<Widget> myChats = List.generate(
    20,
    (index) => ListTile(
      onTap: () => Get.toNamed(Routes.CHAT_ROOM),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.black26,
        child: Image.asset(
          "assets/logo/noimage.png",
          fit: BoxFit.cover,
        ),
      ),
      title: wBigText(
        text: "orang ${index + 1}",
        weight: FontWeight.w600,
        size: wDimension.font20,
      ),
      subtitle: wSmallText(
        text: "status ${index + 1}",
        size: wDimension.font16,
      ),
      trailing: Chip(label: wSmallText(text: "3")),
    ),
  ).reversed.toList();

  HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
            elevation: 5,
            child: Container(
              margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black38)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  wBigText(
                    text: "Chats",
                    weight: FontWeight.bold,
                    size: 35,
                  ),
                  Material(
                    color: Colors.red[900],
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      onTap: () => Get.toNamed(Routes.PROFILE),
                      // ignore: prefer_const_constructors
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        // ignore: prefer_const_constructors
                        child: wAppIcon(
                          icon: Icons.person,
                          iconColor: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: myChats.length,
              itemBuilder: (context, index) => myChats[index],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH),
        backgroundColor: Colors.red[900],
        // ignore: prefer_const_constructors
        child: wAppIcon(
          icon: Icons.search,
          size: 35,
        ),
      ),
    );
  }
}
