import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../routes/app_pages.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

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

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {}
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
