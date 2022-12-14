import 'package:chatapp/app/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  UserModel user = UserModel();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  Future<bool> skipIntro() async {
    final box = GetStorage();

    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

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

        users.doc(_currentUser!.email).update({
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String()
        });

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user = UserModel(
          name: currUserData['name'],
          email: currUserData['email'],
          photoUrl: currUserData['photoUrl'],
          status: currUserData['status'],
          creationTime: currUserData['creationTime'],
          lastSignInTime: currUserData['lastSignInTime'],
          updatedTime: currUserData['updatedTime'],
        );

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

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
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

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
          users.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "email": _currentUser!.email,
            "photoUrl": _currentUser!.photoUrl ?? "noimage",
            "status": "",
            "creationTime":
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
          });
        } else {
          users.doc(_currentUser!.email).update({
            "lastSignInTime":
                userCredential!.user!.metadata.lastSignInTime!.toIso8601String()
          });
        }

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user = UserModel(
          name: currUserData['name'],
          email: currUserData['email'],
          photoUrl: currUserData['photoUrl'],
          status: currUserData['status'],
          creationTime: currUserData['creationTime'],
          lastSignInTime: currUserData['lastSignInTime'],
          updatedTime: currUserData['updatedTime'],
        );

        //
        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {}
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
