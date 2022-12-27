import 'dart:async';

import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/widgets.dart';
import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  final authC = Get.find<AuthController>();
  final String chat_id = (Get.arguments as Map<String, dynamic>)["chat_id"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.red,
            leadingWidth: wDimension.width20 * 4,
            leading: InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(wDimension.radius30 * 10),
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: wDimension.width10 / 2),
                    wAppIcon(
                        icon: Icons.arrow_back, size: wDimension.iconSize16),
                    SizedBox(width: wDimension.width20 / 2),
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: wDimension.radius20,
                      child: StreamBuilder<DocumentSnapshot<Object?>>(
                        stream: controller.streamFriendData((Get.arguments
                            as Map<String, dynamic>)["friendEmail"]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            var dataFriend =
                                snapshot.data!.data() as Map<String, dynamic>;

                            if (dataFriend["photoUrl"] == "noimage") {
                              return ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      wDimension.radius30 * 5),
                                  child: Image.asset("assets/logo/noimage.png",
                                      fit: BoxFit.cover));
                            } else {
                              return ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      wDimension.radius30 * 5),
                                  child: Image.network(dataFriend["photoUrl"],
                                      fit: BoxFit.cover));
                            }
                          }
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  wDimension.radius30 * 5),
                              child: Image.asset("assets/logo/noimage.png",
                                  fit: BoxFit.cover));
                        },
                      ),
                    ),
                    SizedBox(width: wDimension.width10 / 2),
                  ],
                ),
              ),
            ),
            title: StreamBuilder<DocumentSnapshot<Object?>>(
                stream: controller.streamFriendData(
                    (Get.arguments as Map<String, dynamic>)["friendEmail"]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var dataFriend =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          wBigText(
                              text: dataFriend["name"],
                              color: Colors.white,
                              weight: FontWeight.w600),
                          wSmallText(
                              text: dataFriend["status"], color: Colors.white)
                        ]);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      wBigText(
                          text: "Loading...",
                          color: Colors.white,
                          weight: FontWeight.w600),
                      wSmallText(text: "Loading...", color: Colors.white),
                    ],
                  );
                })),
        body: WillPopScope(
            onWillPop: () {
              if (controller.isShowEmoji.isTrue) {
                controller.isShowEmoji.value = false;
              } else {
                Navigator.pop(context);
              }
              return Future.value(false);
            },
            child: Column(children: [
              //body main chat
              Expanded(
                child: Container(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.streamChats(chat_id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var alldata = snapshot.data!.docs;
                      Timer(
                          Duration.zero,
                          () => controller.scrollC.jumpTo(
                              controller.scrollC.position.maxScrollExtent));
                      return ListView.builder(
                          controller: controller.scrollC,
                          itemCount: alldata.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  SizedBox(height: wDimension.height10),
                                  wSmallText(
                                      weight: FontWeight.bold,
                                      text: "${alldata[index]["groupTime"]}"),
                                  ItemChat(
                                    msg: "${alldata[index]["msg"]}",
                                    isSender: alldata[index]["pengirim"] ==
                                            authC.user.value.email!
                                        ? true
                                        : false,
                                    time: "${alldata[index]["time"]}",
                                  ),
                                ],
                              );
                            } else {
                              //return tanpa kolom
                              if (alldata[index]["groupTime"] ==
                                  alldata[index - 1]["groupTime"]) {
                                return ItemChat(
                                  msg: "${alldata[index]["msg"]}",
                                  isSender: alldata[index]["pengirim"] ==
                                          authC.user.value.email!
                                      ? true
                                      : false,
                                  time: "${alldata[index]["time"]}",
                                );
                              } else {
                                //return kolom
                                return Column(
                                  children: [
                                    wSmallText(
                                        weight: FontWeight.bold,
                                        text: "${alldata[index]["groupTime"]}"),
                                    ItemChat(
                                      msg: "${alldata[index]["msg"]}",
                                      isSender: alldata[index]["pengirim"] ==
                                              authC.user.value.email!
                                          ? true
                                          : false,
                                      time: "${alldata[index]["time"]}",
                                    ),
                                  ],
                                );
                              }
                            }
                          });
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                )),
              ),

              //Bottom in send text
              Container(
                margin: EdgeInsets.only(
                    bottom: controller.isShowEmoji.isTrue
                        ? wDimension.height10
                        : context.mediaQueryPadding.bottom),
                padding:
                    EdgeInsets.symmetric(horizontal: wDimension.width10 / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: TextField(
                            autocorrect: false,
                            onEditingComplete: () => controller.newChat(
                                  authC.user.value.email!,
                                  Get.arguments as Map<String, dynamic>,
                                  controller.chatC.text,
                                ),
                            style: TextStyle(fontSize: wDimension.font26),
                            controller: controller.chatC,
                            focusNode: controller.focusNode,
                            decoration: InputDecoration(
                                prefixIcon: IconButton(
                                  onPressed: () {
                                    controller.focusNode.unfocus();
                                    controller.isShowEmoji.toggle();
                                  },
                                  icon: controller.isShowEmoji.isTrue
                                      ? wAppIcon(
                                          icon: Icons.emoji_emotions_outlined,
                                          iconColor: Colors.blueAccent,
                                          size: wDimension.iconSize24,
                                        )
                                      : wAppIcon(
                                          icon: Icons.emoji_emotions,
                                          iconColor: Colors.grey,
                                          size: wDimension.iconSize24,
                                        ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      wDimension.radius30),
                                )))),
                    SizedBox(width: wDimension.width10),

                    //button
                    Material(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(wDimension.radius30),
                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(wDimension.radius30),
                        onTap: () => controller.newChat(
                          authC.user.value.email!,
                          Get.arguments as Map<String, dynamic>,
                          controller.chatC.text,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(wDimension.width15 / 3),
                          child: wAppIcon(
                            icon: Icons.send,
                            iconSize: wDimension.iconSize24,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              //Emoji
              Obx(
                () => (controller.isShowEmoji.isTrue)
                    ? SizedBox(
                        height: wDimension.height30 * 10,
                        child: EmojiPicker(
                          onEmojiSelected: (category, emoji) {
                            controller.addEmojiToChat(emoji);
                          },
                          onBackspacePressed: () {
                            controller.deleteEmoji();
                          },
                          // ignore: prefer_const_constructors
                          config: Config(
                              columns: 7,
                              verticalSpacing: 0,
                              horizontalSpacing: 0,
                              gridPadding: EdgeInsets.zero,
                              initCategory: Category.RECENT,
                              bgColor: const Color(0xFFF2F2F2),
                              indicatorColor: const Color(0xFFB71C1C),
                              iconColor: Colors.grey,
                              iconColorSelected: const Color(0xFFB71C1C),
                              backspaceColor: const Color(0xFFB71C1C),
                              skinToneDialogBgColor: Colors.white,
                              skinToneIndicatorColor: Colors.grey,
                              enableSkinTones: true,
                              showRecentsTab: true,
                              recentsLimit: 28,
                              noRecents: const Text(
                                'No Recents',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black26),
                                textAlign: TextAlign.center,
                              ), // Needs to be const Widget
                              loadingIndicator: const SizedBox
                                  .shrink(), // Needs to be const Widget
                              tabIndicatorAnimDuration: kTabScrollDuration,
                              categoryIcons: const CategoryIcons(),
                              buttonMode: ButtonMode.MATERIAL),
                        ))
                    : SizedBox(height: wDimension.height10),
              )
            ])));
  }
}

//itemChat
class ItemChat extends StatelessWidget {
  const ItemChat({
    Key? key,
    required this.isSender,
    required this.msg,
    required this.time,
  }) : super(key: key);

  final bool isSender;
  final String msg;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: wDimension.width15,
        horizontal: wDimension.width15,
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red[900],
              borderRadius: isSender
                  ? BorderRadius.only(
                      topLeft: Radius.circular(wDimension.radius15),
                      topRight: Radius.circular(wDimension.radius15),
                      bottomLeft: Radius.circular(wDimension.radius15))
                  : BorderRadius.only(
                      topLeft: Radius.circular(wDimension.radius15),
                      topRight: Radius.circular(wDimension.radius15),
                      bottomRight: Radius.circular(wDimension.radius15)),
            ),
            padding: EdgeInsets.all(wDimension.width15 / 2),
            child: wBigText(
              text: "$msg",
              color: Colors.white,
            ),
          ),
          SizedBox(height: wDimension.height10 / 5),
          wSmallText(text: DateFormat.jm().format(DateTime.parse(time)))
        ],
      ),
    );
  }
}
