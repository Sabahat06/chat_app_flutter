import 'package:cached_map/cached_map.dart';
import 'package:email_password_login/screens/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
    String storeUrl;
    try {
      if (await canLaunch(storeUrl)) {
        await launch(storeUrl, forceSafariVC: false);
      }
    } on PlatformException {
      Fluttertoast.showToast(msg: "There is some problem with your App, Kindly update manually from $storeUrl");
    }
    await Future.delayed(Duration(seconds: 3));
    Mapped.loadFileDirectly(cachedFileName: "slider").then((file) {
      Get.toNamed(
        authController.isLogedIn.value
          ? '/homepage'
          : '/login',
        );
    });
  }
}



