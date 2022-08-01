import 'package:cached_map/cached_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/screens/auth_controller.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    navigate();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
                child: Image.asset("assets/logo.png",)
              ),
              // ClipPath(
              //   clipper: CustomClipPathTopContainer(),
              //   child: Container(
              //     height: Get.height*0.3,
              //     color: Colors.green,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Stack(
              //     children: <Widget>[
              //       ClipPath(
              //         clipper: CustomClip(),
              //         child: Image.network(
              //           "http://www.delonghi.com/Global/recipes/multifry/pizza_fresca.jpg",
              //           width: double.infinity,
              //           height: Get.height*0.3,
              //           fit: BoxFit.contain,
              //         )
              //       ),
              //       CustomPaint(
              //         painter: BorderPainter(),
              //         child: Container(
              //           height: Get.height*0.3,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
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

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black;
    var path = pathCode(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = pathCode(size);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class CustomClipPathTopContainer extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth=10.0
      ..color = Colors.black;

    var path = pathCode(size);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

pathCode(Size size) {
  Path path0 = Path();
  path0.moveTo(0,size.height);
  path0.lineTo(0,size.height*0.2114714);
  path0.quadraticBezierTo(size.width*0.1255833,size.height*0.4277857,size.width*0.2698833,size.height*0.4275143);
  path0.cubicTo(size.width*0.4168083,size.height*0.4270286,size.width*0.5467250,size.height*0.0190429,size.width*0.6867167,size.height*0.0189000);
  path0.quadraticBezierTo(size.width*0.8293000,size.height*0.0211000,size.width,size.height*0.2121429);
  path0.lineTo(size.width,size.height);
  path0.lineTo(0,size.height);
  path0.lineTo(0,size.height);
  path0.lineTo(0,size.height*0.9994143);
  path0.close();
  return path0;
}
