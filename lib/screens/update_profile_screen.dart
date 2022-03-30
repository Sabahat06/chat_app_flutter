import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/screens/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatelessWidget {
  final userRef = FirebaseFirestore.instance.collection('users');

  AuthController authController = Get.find();
  RxBool isLoading = false.obs;
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String errorMessage;


  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  TextEditingController firstNameEditingController;
  TextEditingController secondNameEditingController;
  TextEditingController emailEditingController;
  TextEditingController phoneNumberEditingController;

  @override
  Widget build(BuildContext context) {
    firstNameEditingController = TextEditingController(text: authController.userModel.value.firstName);
    secondNameEditingController = TextEditingController(text: authController.userModel.value.secondName);
    emailEditingController = TextEditingController(text: authController.userModel.value.email);
    phoneNumberEditingController = TextEditingController(text: authController.userModel.value.phoneNumber);
    ///first name field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        )
    );

    ///second name field
    final secondNameField = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value.isEmpty) {
            return ("Second Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Second Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        )
    );

    ///email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        )
    );

    ///Phone number field
    final phoneNumberField = TextFormField(
      autofocus: false,
      controller: phoneNumberEditingController,
      validator: (value) {
        if (value.isEmpty) {
          return ("First Name cannot be Empty");
        }
        if(!value.contains('+92')) {
          return ("Please Start your number with +92 instead of 0");
        }
        if(value.length<13) {
          return ("Please Enter a valid Phone Number");
        }
        // if (!RegExp("r'\+994\s+\([0-9]{2}\)\s+[0-9]{3}\s+[0-9]{2}\s+[0-9]{2}'").hasMatch(value)) {
        //   return ("Please Enter a valid Phone Number");
        // }
        return null;
      },
      onSaved: (value) {
        phoneNumberEditingController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Phone Number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      )
    );

    ///signup button
    final updateProfile = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.greenAccent[400],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          updateUserProfile(firstNameEditingController.text, secondNameEditingController.text, emailEditingController.text, phoneNumberEditingController.text);
        },
        child: Text(
          "UPDATE PROFILE",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        )
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.greenAccent[400]),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Obx(() => Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(80), border: Border.all(color: Colors.greenAccent[400])),
                        child: CircleAvatar(backgroundImage: authController.userModel.value.imageUrl != null && authController.userModel.value.imageUrl != ''
                            ? NetworkImage(authController.userModel.value.imageUrl)
                            : authController.updateProfileFile.value == ''
                              ? NetworkImage('https://srmuniversity.ac.in/wp-content/uploads/professor/user-avatar-default.jpg')
                              : FileImage(authController.updateProfileFile.value),
                          child: Stack(
                            children: [
                              Positioned(
                                right: 2,
                                bottom: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.greenAccent[400],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        pickImageDialogForUpdateProfile(context);
                                      },
                                      child: const Icon(Icons.camera_alt, size: 30,),
                                    ),
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),),
                    SizedBox(height: 10),
                    firstNameField,
                    SizedBox(height: 10),
                    secondNameField,
                    SizedBox(height: 10),
                    emailField,
                    SizedBox(height: 10),
                    phoneNumberField,
                    SizedBox(height: 15),
                    Obx(() => isLoading.value ? Center(child: CircularProgressIndicator(),) : updateProfile),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///Post user data in firebase

  pickImageDialogForUpdateProfile(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Complete Action Using"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  authController.openGalleryForUpdateProfile(true);
                },
                child: Column(
                  children: const [
                    Icon(
                      Icons.image,
                      color: Colors.greenAccent,
                      size: 30,
                    ),
                    Text("Gallery")
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  authController.openGalleryForUpdateProfile(false);
                },
                child: Column(
                  children: const [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.greenAccent,
                      size: 30,
                    ),
                    Text("Camera")
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  void updateUserProfile(String firstNameValue, String secondNameValue, String emailValue, String phoneNumberValue, ) async {

    isLoading.value = true;
    if (_formKey.currentState.validate()) {
      userRef.doc(authController.userModel.value.uid).update({
        "firstName": firstNameValue,
        "lastName": secondNameValue,
        "email": emailValue,
        "phoneNumber": phoneNumberValue,
      });
      isLoading.value = false;
      Fluttertoast.showToast(msg: "Your Profile has been Updated Successfully", backgroundColor: Colors.greenAccent[400], fontSize: 16, textColor: Colors.white,);
      authController.userModel.value.firstName = firstNameValue;
      authController.userModel.value.secondName = secondNameValue;
      authController.userModel.value.email = emailValue;
      authController.userModel.value.phoneNumber = phoneNumberValue;
      if(authController.updateProfileImageUploaded) {
        authController.userModel.value.imageUrl = authController.imageFromFirebase;
      }

      Get.back();
      // try {
      //   await _auth.createUserWithEmailAndPassword(email: email, password: password)
      //     .then((value) => {
      //     }
      //   ).catchError((e) {
      //     Fluttertoast.showToast(msg: e.message, backgroundColor: Colors.greenAccent[400], fontSize: 16, textColor: Colors.white,);
      //   });
      // } on FirebaseAuthException catch (error) {
      //   switch (error.code) {
      //     case "invalid-email":
      //       errorMessage = "Your email address appears to be malformed.";
      //       break;
      //     case "wrong-password":
      //       errorMessage = "Your password is wrong.";
      //       break;
      //     case "user-not-found":
      //       errorMessage = "User with this email doesn't exist.";
      //       break;
      //     case "user-disabled":
      //       errorMessage = "User with this email has been disabled.";
      //       break;
      //     case "too-many-requests":
      //       errorMessage = "Too many requests";
      //       break;
      //     case "operation-not-allowed":
      //       errorMessage = "Signing in with Email and Password is not enabled.";
      //       break;
      //     default:
      //       errorMessage = "An undefined Error happened.";
      //   }
      //   Fluttertoast.showToast(msg: errorMessage, backgroundColor: Colors.greenAccent[400], fontSize: 16, textColor: Colors.white);
      //   print(error.code);
      // }
    }
  }
}
