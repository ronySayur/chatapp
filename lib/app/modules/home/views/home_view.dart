import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
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
                            text: "Chats", weight: FontWeight.bold, size: 35),
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
                                        size: 35))))
                      ]))),
          Expanded(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: controller.chatStream(authC.user.value.email!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var allChats = (snapshot.data!.data()
                          as Map<String, dynamic>)["chats"] as List;

                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: allChats.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                stream: controller.friendStream(
                                    allChats[index]["connections"]),
                                builder: (context, snapshot) {
                                  //
                                  if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    var data = snapshot.data!.data();

                                    //
                                    return data!["status"] == ""
                                        ? ListTile(
                                            onTap: () =>
                                                Get.toNamed(Routes.CHAT_ROOM),
                                            leading: CircleAvatar(
                                                radius: 30,
                                                backgroundColor: Colors.black26,
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(
                                                        wDimension.radius30 *
                                                            5),
                                                    child: data["photoUrl"] == "noimage"
                                                        ? Image.asset(
                                                            "assets/logo/noimage.png",
                                                            fit: BoxFit.cover)
                                                        : Image.network(
                                                            "${data["photoUrl"]}",
                                                            fit:
                                                                BoxFit.cover))),
                                            title: wBigText(
                                                text: "${data["name"]}",
                                                weight: FontWeight.w600,
                                                size: wDimension.font20),
                                            trailing: allChats[index]["total_unread"] == 0
                                                ? const SizedBox()
                                                : Chip(label: wSmallText(text: "${allChats[index]["total_unread"]}")))
                                        : ListTile(
                                            onTap: () => Get.toNamed(Routes.CHAT_ROOM),
                                            leading: CircleAvatar(radius: 30, backgroundColor: Colors.black26, child: ClipRRect(borderRadius: BorderRadius.circular(wDimension.radius30 * 5), child: data["photoUrl"] == "noimage" ? Image.asset("assets/logo/noimage.png", fit: BoxFit.cover) : Image.network("${data["photoUrl"]}", fit: BoxFit.cover))),
                                            title: wBigText(text: "${data["name"]}", weight: FontWeight.w600, size: wDimension.font20),
                                            subtitle: wSmallText(text: "${data["status"]}", size: wDimension.font16),
                                            trailing: allChats[index]["total_unread"] == 0
                                                ? const SizedBox()
                                                : Chip(
                                                    label: wSmallText(
                                                        text:
                                                            "${allChats[index]["total_unread"]}"),
                                                  ));
                                  }
                                  // ignore: prefer_const_constructors
                                  return Center(
                                      child: const CircularProgressIndicator());
                                });
                          });
                    }
                    // ignore: prefer_const_constructors
                    return Center(
                      child: const CircularProgressIndicator(),
                    );
                  }))
        ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed(Routes.SEARCH),
            backgroundColor: Colors.red[900],
            // ignore: prefer_const_constructors
            child: wAppIcon(icon: Icons.search, size: 35)));
  }
}
