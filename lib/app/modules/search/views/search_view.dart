import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../routes/app_pages.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  final List<Widget> friends = List.generate(
    20,
    (index) => ListTile(
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
        text: "Orang${index + 1}@gmail.com",
        size: wDimension.font16,
      ),
      trailing: GestureDetector(
          onTap: () => Get.toNamed(Routes.CHAT_ROOM),
          child: Chip(label: wSmallText(text: "Kirim Pesan"))),
    ),
  );

  SearchView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: AppBar(
          backgroundColor: Colors.red[900],
          title: wBigText(
            text: "Search",
            color: Colors.white,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const wAppIcon(icon: Icons.arrow_back),
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 20, 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                cursorColor: Colors.red[900],
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(wDimension.height45),
                    // ignore: prefer_const_constructors
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(wDimension.height45),
                    // ignore: prefer_const_constructors
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  hintText: "Search friend",
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: wDimension.height30,
                      vertical: wDimension.height20),
                  suffixIcon: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(wDimension.height45),
                    // ignore: prefer_const_constructors
                    child: wAppIcon(
                      icon: Icons.search,
                      iconColor: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(wDimension.height30 * 4.25),
      ),
      body: friends.length == 0
          ? Center(
              child: Container(
                width: wDimension.screenWidth * 0.7,
                height: wDimension.screenHeight * 0.7,
                child: Lottie.asset("assets/lottie//empty.json"),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: friends.length,
              itemBuilder: (context, index) => friends[index],
            ),
    );
  }
}
