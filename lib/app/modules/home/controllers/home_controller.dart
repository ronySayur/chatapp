import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String email) {
    return firestore
        .collection("users")
        .doc(email)
        .collection("chats")
        .orderBy("lastTime", descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream(String email) {
    return firestore.collection("users").doc(email).snapshots();
  }

  Future<void> goToChatRoom(
      String chat_id, String email, String friendEmail) async {
    CollectionReference chats = firestore.collection('chats');
    CollectionReference users = firestore.collection('users');

    final updateStatusChat = await chats
        .doc(chat_id)
        .collection("chats")
        .where("isRead", isEqualTo: false)
        .where("penerima", isEqualTo: email)
        .get();

    updateStatusChat.docs.forEach((element) async {
      element.id;
      await chats
          .doc(chat_id)
          .collection("chats")
          .doc(element.id)
          .update({"isRead": true});
    });

//merubah total unread
    await users
        .doc(email)
        .collection("chats")
        .doc(chat_id)
        .update({"total_unread": 0});

    Get.toNamed(Routes.CHAT_ROOM, arguments: {
      "chat_id": chat_id,
      "friendEmail": friendEmail,
    });
  }
}
