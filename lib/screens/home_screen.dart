import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthController authController = Get.find();
  User user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    // FirebaseFirestore.instance.collection("users").doc(user.uid).get().then((value) {
    //   this.loggedInUser = UserModel.fromMap(value.data());
    //   setState(() {});
    //   authController.userModel.value = this.loggedInUser;
    //   UserModel.saveUserToCache(this.loggedInUser);
    // });
  }

  @override
  Widget build(BuildContext context) {

    final logOutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.greenAccent[400],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          logout(context);
          authController.isLogedIn.value = false;
          UserModel.deleteCachedUser();
        },
        child: Text(
          "LOGOUT",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        )
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        title: const Text("Welcome"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 150, child: Image.asset("assets/logo.png", fit: BoxFit.contain),),
              Text("Welcome ${authController.userModel.value.firstName}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Obx(() => authController.userModel.value.firstName == null && authController.userModel.value.secondName==null
                ? Container()
                : Row(
                  children: [
                    Container(
                      width: Get.width*0.33,
                      child: Text("Full Name",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        )
                      ),
                    ),
                    Text(": ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      )
                    ),
                    Container(
                      width: Get.width*0.5 ,
                      child: Text("${authController.userModel.value.firstName} ${authController.userModel.value.secondName}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7,),
              Obx(() => authController.userModel.value.email == null
                ? Container()
                : Row(
                  children: [
                    Container(
                      width: Get.width*0.33,
                      child: Text("Email",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        )
                      ),
                    ),
                    Text(": ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      )
                    ),
                    Container(
                      width: Get.width*0.5,
                      child: Text("${authController.userModel.value.email}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7,),
              Obx(() => authController.userModel.value.phoneNumber == null
                ? Container()
                : Row(
                  children: [
                    Container(
                      width: Get.width*0.33,
                      child: Text("Phone Number",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        )
                      ),
                    ),
                    Text(": ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      )
                    ),
                    Container(
                      width: Get.width*0.5,
                      child: Text("${authController.userModel.value.phoneNumber}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              logOutButton,
              // ActionChip(
              //   labelPadding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              //   backgroundColor: Colors.grey,
              //   label: Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16),),
              //   onPressed: () {
              //     logout(context);
              //   }
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
