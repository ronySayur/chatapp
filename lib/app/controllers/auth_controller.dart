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
            "chats": [],
          });
        } else {
          await users.doc(_currentUser!.email).update({
            "lastSignInTime":
                userCredential!.user!.metadata.lastSignInTime!.toIso8601String()
          });
        }

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UsersModel.fromJson(currUserData));

        //
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
    Get.back();
  }

//Search
  Future<void> addNewConnection(String friendEmail) async {
    bool flagNewConnection = false;
    String date = DateTime.now().toIso8601String();
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final docUser = await users.doc(_currentUser!.email).get();

    final docChats = (docUser.data() as Map<String, dynamic>)["chats"] as List;
    // ignore: prefer_typing_uninitialized_variables
    var chat_id;

    if (docChats.length != 0) {
      docChats.forEach((singleChat) {
        if (singleChat["connections"] == friendEmail) {
          chat_id = singleChat["chat_id"];
        }
      });

      if (chat_id != null) {
        // 2. pernah chat
        flagNewConnection = false;
      } else {
        // 1. Belum pernah chat
        flagNewConnection = true;
      }
    } else {
      // 1. Belum pernah chat
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

      if (chatDocs.docs.length != 0) {
        //terdapat chats

        final chatDataID = chatDocs.docs[0].id;
        final chatData = chatDocs.docs[0].data() as Map<String, dynamic>;

        docChats.add({
          "connections": friendEmail,
          "chat_id": chatDataID,
          "lastTime": chatData["lastTime"],
          "total_unread": 0,
        });

        await users.doc(_currentUser!.email).update({"chats": docChats});

        user.update((user) {
          user!.chats = docChats.cast<ChatUser>();
        });

        chat_id = chatDataID;

        user.refresh();
      } else {
        //buat baru
        final newChatDoc = await chats.add({
          "connections": [
            _currentUser!.email,
            friendEmail,
          ],
          "chats": [],
        });

        docChats.add({
          "connections": friendEmail,
          "chat_id": newChatDoc.id,
          "lastTime": date,
          "total_unread": 0,
        });

        await users.doc(_currentUser!.email).update({"chats": docChats});

        user.update((user) {
          user!.chats = docChats.cast<ChatUser>();
        });

        chat_id = newChatDoc.id;

        user.refresh();
      }
    }
    Get.toNamed(Routes.CHAT_ROOM, arguments: chat_id);
  }
}
