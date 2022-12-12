import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_status_controller.dart';

class UpdateStatusView extends GetView<UpdateStatusController> {
  const UpdateStatusView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: wAppIcon(
              icon: Icons.arrow_back,
              iconColor: Colors.white,
              size: wDimension.iconSize24,
            ),
          ),
          backgroundColor: Colors.red[900],
          title: const Text('Update Status'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: controller.statusC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Status",
                  labelStyle: TextStyle(
                      color: Colors.black, fontSize: wDimension.font16),
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
                    vertical: wDimension.width15,
                  ),
                ),
              ),
              SizedBox(height: wDimension.height30),
              SizedBox(
                width: wDimension.screenWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                    shape: const StadiumBorder(),
                    padding: EdgeInsets.symmetric(
                      horizontal: wDimension.width30,
                      vertical: wDimension.width15,
                    ),
                  ),
                  onPressed: () {},
                  child: wSmallText(
                      text: "Update",
                      weight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
}
