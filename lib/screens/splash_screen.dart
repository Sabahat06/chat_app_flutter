import 'package:cached_map/cached_map.dart';
import 'package:email_password_login/screens/auth_controller.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatelessWidget {
  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    navigate();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 250,
          height: 250,
          child: Image.asset("assets/logo.png",)
        ),
      ),
    );
  }


  navigate() async {
    await Future.delayed(Duration(seconds: 3));
    Mapped.loadFileDirectly(cachedFileName: "slider").then((file) {
      Get.off(()=>
        authController.isLogedIn.value
          ? HomeScreen()
          : LoginScreen(),
      );
    });
  }
}
