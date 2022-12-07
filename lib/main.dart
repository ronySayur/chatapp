import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'utils/error_page.dart';
import 'utils/loading_page.dart';
import 'utils/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Chat App",
            initialRoute: Routes.SEARCH,
            getPages: AppPages.routes,
          );

          // return FutureBuilder(
          //   future: Future.delayed(const Duration(seconds: 3)),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       return Obx(() => GetMaterialApp(
          //             debugShowCheckedModeBanner: false,
          //             title: "ChatApp",
          //             initialRoute: authC.isSkipIntro.isTrue
          //                 ? authC.isAuth.isTrue
          //                     ? Routes.HOME
          //                     : Routes.LOGIN
          //                 : Routes.INTRODUCTION,
          //             getPages: AppPages.routes,
          //           ));
          // }

          // return SplashScreen();
          // },
          // );
        }
        return LoadingScreen();
      },
    );
  }
}
