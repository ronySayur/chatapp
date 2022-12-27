import 'package:chatapp/app/data/models/users_model.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../routes/app_pages.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  var user = UsersModel().obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

//First Initial
  Future<void> firstInitialized() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });

    //mengubah isSkip => true
    await skipIntro().then((value) {
      if (value) {
        isSkipIntro.value = true;
      }
    });
  }

//Skip Introduction
  Future<bool> skipIntro() async {
    final box = GetStorage();

    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

//AutoLogin
  Future<bool> autoLogin() async {
    //mengubah isAuth => true => autologin
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);

        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        //masukan data ke firebase
        CollectionReference users = firestore.collection('users');

        await users.doc(_currentUser!.email).update({
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String()
        });

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UsersModel.fromJson(currUserData));

        user.refresh();

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

//
        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chat_id: dataDocChatId,
              connections: dataDocChat["connections"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((val) {
            val!.chats = dataListChats;
          });
        } else {
          user.update((val) {
            val!.chats = [];
          });
        }
        user.refresh();

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

//Login
  Future<void> login() async {
    try {
      //handle kebocoran data user sebelum login
      await _googleSignIn.signOut();

      //pop up sign-in mendapatkan google account
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      //status login user
      final isSignIn = await _googleSignIn.isSignedIn();

      //cek status login user
      if (isSignIn) {
        //kondisi login berhasil
        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        //Simpan status user bahwa pernah login dan tidak akan menampilkan intro screen
        final box = GetStorage();
        if (box.read('skipIntro') != null) {
          box.remove('skipIntro');
        }
        //tulis skip intro 'true' pada mesin
        box.write('skipIntro', true);

        //masukan data ke firebase
        CollectionReference users = firestore.collection('users');

        final checkUser = await users.doc(_currentUser!.email).get();

        if (checkUser.data() == null) {
          await users.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "keyName": _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            "email": _currentUser!.email,
            "photoUrl": _currentUser!.photoUrl ?? "noimage",
            "status": "",
            "creationTime":
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
          });

          await users.doc(_currentUser!.email).collection("chats");
        } else {
          await users.doc(_currentUser!.email).update({
            "lastSignInTime":
                userCredential!.user!.metadata.lastSignInTime!.toIso8601String()
          });
        }

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UsersModel.fromJson(currUserData));

        user.refresh();

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

//
        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chat_id: dataDocChatId,
              connections: dataDocChat["connections"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((val) {
            val!.chats = dataListChats;
          });
        } else {
          user.update((val) {
            val!.chats = [];
          });
        }
        user.refresh();

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {}
    } catch (error) {
      Get.defaultDialog(title: "Error", middleText: "$error");
    }
  }

//Logout
  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

//Change Profile
  Future<void> changeProfile(String name, String status) async {
    //update firebase
    CollectionReference users = firestore.collection('users');
    String date = DateTime.now().toIso8601String();

    //panggil
    users.doc(_currentUser!.email).update({
      "name": name,
      "keyName": name.substring(0, 1).toUpperCase(),
      "status": status,
      "lastSignTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedTime": date,
    });

    //update model
    user.update((user) {
      user!.name = name;
      user.keyName = name.substring(0, 1).toUpperCase();
      user.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });

    user.refresh();
    Get.defaultDialog(
      title: "Succes",
      middleText: "Change Profile success",
      radius: wDimension.radius20,
      contentPadding: EdgeInsets.all(wDimension.radius15 / 2),
    );
    await Future.delayed(const Duration(seconds: 2));
    Get.back();
  }

//Update Status
  Future<void> updateStatus(String status) async {
    //update firebase
    CollectionReference users = firestore.collection('users');
    String date = DateTime.now().toIso8601String();

    //panggil
    users.doc(_currentUser!.email).update({
      "status": status,
      "lastSignTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedTime": date,
    });

    //update model
    user.update((user) {
      user!.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });

    user.refresh();
    Get.defaultDialog(
      title: "Succes",
      middleText: "Update Status success",
      radius: wDimension.radius20,
      contentPadding: EdgeInsets.all(wDimension.radius15 / 2),
    );
    await Future.delayed(const Duration(seconds: 2));
    Get.back();
  }

//addNewConnection
  Future<void> addNewConnection(String friendEmail) async {
    bool flagNewConnection = false;
    var chat_id;
    var date = DateTime.now().toIso8601String();
    
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final docChats =
        await users.doc(_currentUser!.email).collection("chats").get();

    if (docChats.docs.isNotEmpty) {
      final checkConnection = await users
          .doc(_currentUser!.email)
          .collection("chats")
          .where("connections", isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.isNotEmpty) {
        flagNewConnection = false;
        chat_id = checkConnection.docs[0].id; //chat id dari chat collect

      } else {
        //Sudah pernah chat
        flagNewConnection = true;
      }
    } else {
      //Belum pernah chat = Buat koneksi
      flagNewConnection = true;
    }

    if (flagNewConnection) {
      //cek dari chat collection => connection => mereka berdua
      final chatDocs = await chats.where(
        "connections",
        whereIn: [
          [
            _currentUser!.email,
            friendEmail,
          ],
          [
            friendEmail,
            _currentUser!.email,
          ],
        ],
      ).get();

      if (chatDocs.docs.isNotEmpty) {
        //terdapat chats
        final chatDataID = chatDocs.docs[0].id;
        final chatData = chatDocs.docs[0].data() as Map<String, dynamic>;

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(chatDataID)
            .set({
          "connections": friendEmail,
          "lastTime": chatData["lastTime"],
          "total_unread": 0,
        });

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chat_id: dataDocChatId,
              connections: dataDocChat["connections"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((val) {
            val!.chats = dataListChats;
          });
        } else {
          user.update((val) {
            val!.chats = [];
          });
        }

        chat_id = chatDataID;

        user.refresh();
      } else {
        //buat baru
        final newChatDoc = await chats.add({
          "connections": [
            _currentUser!.email,
            friendEmail,
          ]
        });

        await chats.doc(newChatDoc.id).collection("chats");

        await users
            .doc(_currentUser!.email)
            .collection("chats")
            .doc(newChatDoc.id)
            .set({
          "connections": friendEmail,
          "lastTime": date,
          "total_unread": 0
        });

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.isNotEmpty) {
          List<ChatUser> dataListChats = [];

          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chat_id: dataDocChatId,
              connections: dataDocChat["connections"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });

          user.update((val) {
            val!.chats = dataListChats;
          });
        } else {
          user.update((val) {
            val!.chats = [];
          });
        }

        chat_id = newChatDoc.id;

        user.refresh();
      }
    }
    final updateStatusChat = await chats
        .doc(chat_id)
        .collection("chats")
        .where("isRead", isEqualTo: false)
        .where("penerima", isEqualTo: _currentUser!.email)
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
        .doc(_currentUser!.email)
        .collection("chats")
        .doc(chat_id)
        .update({"total_unread": 0});

    Get.toNamed(Routes.CHAT_ROOM,
        arguments: {"chat_id": "$chat_id", "friendEmail": friendEmail});
  }
}
