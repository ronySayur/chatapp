import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/widgets.dart';
import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({Key? key}) : super(key: key);

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
                wAppIcon(icon: Icons.arrow_back, size: wDimension.iconSize16),
                SizedBox(width: wDimension.width20 / 2),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: wDimension.radius20,
                  child: Image.asset("assets/logo/noimage.png"),
                ),
                SizedBox(width: wDimension.width10 / 2),
              ],
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            wBigText(
                text: "Lorem", color: Colors.white, weight: FontWeight.w600),
            wSmallText(text: "status Lorem", color: Colors.white),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          if (controller.isShowEmoji.isTrue) {
            controller.isShowEmoji.value = false;
          } else {
            Navigator.pop(context);
          }
          return Future.value(false);
        },
        child: Column(
          children: [
            //body main chat
            Expanded(
              child: ListView(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  //body single chat
                  const ItemChat(isSender: true),
                  const ItemChat(isSender: false),
                ],
              ),
            ),

            //Bottom in send text
            Container(
              margin: EdgeInsets.only(
                  bottom: controller.isShowEmoji.isTrue
                      ? wDimension.height10
                      : context.mediaQueryPadding.bottom),
              padding: EdgeInsets.symmetric(horizontal: wDimension.width10 / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: TextField(
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
                        borderRadius:
                            BorderRadius.circular(wDimension.radius30),
                      ),
                    ),
                  )),
                  SizedBox(width: wDimension.width10),

                  //button
                  Material(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(wDimension.radius30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(wDimension.radius30),
                      onTap: () {},
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
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ), // Needs to be const Widget
                          loadingIndicator: const SizedBox
                              .shrink(), // Needs to be const Widget
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                        ),
                      ),
                    )
                  : SizedBox(height: wDimension.height10),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat({
    Key? key,
    required this.isSender,
  }) : super(key: key);

  final bool isSender;

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
              text: "text",
              color: Colors.white,
            ),
          ),
          SizedBox(height: wDimension.height10 / 5),
          wSmallText(text: "01:00 PM")
        ],
      ),
    );
  }
}
