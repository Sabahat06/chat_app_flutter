import 'package:cached_map/cached_map.dart';
import 'package:email_password_login/screens/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatelessWidget {
  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    navigate();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: 250,
            height: 250,
            child: Image.asset("assets/logo.png",)
          ),
        ),
      ),
    );
  }

  navigate() async {
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



