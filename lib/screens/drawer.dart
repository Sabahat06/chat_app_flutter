import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/AlertDialogeWidget.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/auth_controller.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:email_password_login/screens/update_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  final userRef = FirebaseFirestore.instance.collection('users');
  AuthController authController = Get.find();

  setUserStatus(String value) {
    userRef.doc(authController.userModel.value.uid).update({
      "userStatus": value,
    });
    authController.userModel.value.userStatus = value;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 10,),
          ListTile(
            leading: Icon(Icons.perm_identity, color: Colors.black),
            title: Text('Update Profile', style: TextStyle(fontSize: 16, color: Colors.black),),
            onTap: () {
              Get.to(() => UpdateProfileScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined, color: Colors.black),
            title: Text('Logout', style: TextStyle(fontSize: 16, color: Colors.black),),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogWidget(
                    title: 'Log Out',
                    subTitle: "Are you sure to logout from your account?",
                    onPositiveClick: () {
                      Get.back();
                      logout(context);
                      authController.isLogedIn.value = false;
                      UserModel.deleteCachedUser();
                    },
                  );
                }
              );
            },
          ),
        ]
      )
    );
  }



  Future<void> logout(BuildContext context) async {
    setUserStatus('Offline');
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

}
