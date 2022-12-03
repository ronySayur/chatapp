import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            width: wDimension.height30,
            height: wDimension.height30,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
