import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../routes/app_pages.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(wDimension.height30 * 4.25),
            child: AppBar(
                backgroundColor: Colors.red[900],
                title: wBigText(text: "Search", color: Colors.white),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: wAppIcon(
                      icon: Icons.arrow_back, size: wDimension.iconSize24),
                ),
                flexibleSpace: Padding(
                    padding: EdgeInsets.fromLTRB(
                        wDimension.height30,
                        wDimension.height10 * 5,
                        wDimension.height20,
                        wDimension.height20),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: TextField(
                            onChanged: (value) => controller.searchFriend(
                                value, authC.user.value.email!),
                            controller: controller.searchC,
                            cursorColor: Colors.red[900],
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      wDimension.height45),
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: wDimension.width10 / 10)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      wDimension.height45),
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: wDimension.width10 / 10)),
                              hintText: "Search friend",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: wDimension.height30,
                                  vertical: wDimension.height20),
                              suffixIcon: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(
                                      wDimension.height45),
                                  child: wAppIcon(
                                      icon: Icons.search,
                                      iconColor: Colors.red,
                                      size: wDimension.iconSize24)),
                            )))))),

        //
        body: Obx(() => controller.tempSearch.isEmpty
            ? Center(
                child: SizedBox(
                    width: wDimension.screenWidth * 0.7,
                    height: wDimension.screenHeight * 0.7,
                    child: Lottie.asset("assets/lottie/empty.json")))
            : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.tempSearch.length,
                itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black26,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(wDimension.radius30 * 5),
                        child: controller.tempSearch[index]["photoUrl"] ==
                                "noimage"
                            ? Image.asset(
                                "assets/logo/noimage.png",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                controller.tempSearch[index]["photoUrl"],
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    title: wBigText(
                        text: "${controller.tempSearch[index]["name"]}",
                        weight: FontWeight.w600,
                        size: wDimension.font20),
                    subtitle: wSmallText(
                        text: "${controller.tempSearch[index]["email"]}",
                        size: wDimension.font16),
                    trailing: GestureDetector(
                        onTap: () => authC.addNewConnection(
                            controller.tempSearch[index]["email"]),
                        child:
                            Chip(label: wSmallText(text: "Kirim Pesan")))))));
  }
}
