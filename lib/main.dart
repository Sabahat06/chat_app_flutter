import 'dart:math';

import 'package:email_password_login/screens/auth_controller.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:email_password_login/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runApp(MyApp());
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

  int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1
  );

  int shadeValue(int value, double factor) => max(0, min(value - (value * factor).round(), 255));

  Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1
);

class MyApp extends StatelessWidget {
  AuthController authController = Get.put(AuthController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Email And Password Login',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(Colors.greenAccent[400]),
      ),
        initialRoute: '/',
        //when initial Route is given no need to add home widget for initial start point of app
        //full app route structure
        routes: {
          '/': (context)=> SplashScreen(),
          '/login': (context)=>LoginScreen(),
          '/homepage': (context)=>HomeScreen(),
        },
      debugShowCheckedModeBanner: false,
    );
  }
}
