import 'dart:ui';

import 'package:cached_map/cached_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/screens/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math' as math;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthController authController = Get.put(AuthController());
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

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
              /// Local Notification related Buttons
              // new RaisedButton(
              //   onPressed: _showNotificationWithSound,
              //   child: new Text('Show Notification With Sound'),
              // ),
              // new SizedBox(
              //   height: 30.0,
              // ),
              // new RaisedButton(
              //   onPressed: _showNotificationWithoutSound,
              //   child: new Text('Show Notification Without Sound'),
              // ),
              // new SizedBox(
              //   height: 30.0,
              // ),
              // new RaisedButton(
              //   onPressed: _showNotificationWithDefaultSound,
              //   child: new Text('Show Notification With Default Sound'),
              // ),
              // new SizedBox(
              //   height: 30.0,
              // ),

              /// Clipped Container
              // ClipPath(
              //   clipper: CustomClipPathTopContainer(),
              //   child: Container(
              //     height: Get.height*0.3,
              //     color: Colors.green,
              //   ),
              // ),
              //
              /// Adding border to clipped Container
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

  // If you have skipped step 4 then Method 1 is not for you

// Method 1
  Future _showNotificationWithSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high
    );
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is test Notification in Flutter App',
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }
// Method 2
  Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max,
        priority: Priority.high
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is test Notification in Flutter App',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
// Method 3
  Future _showNotificationWithoutSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        color: Colors.green,
        colorized: true,
        autoCancel: false,
        fullScreenIntent: true,
        playSound: false,
        importance: Importance.max,
        priority: Priority.high
    );
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics, iOS:  iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is test Notification in Flutter App',
      platformChannelSpecifics,
      payload: 'No_Sound',
    );
  }

  navigate() async {
    await Future.delayed(Duration(seconds: 600));
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
