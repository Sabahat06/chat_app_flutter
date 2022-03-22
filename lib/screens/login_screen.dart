import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/auth_controller.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:email_password_login/screens/phone_number_authentication.dart';
import 'package:email_password_login/screens/registration_screen.dart';
import 'package:email_password_login/screens/reset_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();
  UserModel loggedInUser = UserModel();
  RxBool isLoading = false.obs;
  AuthController authController = Get.find();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;
  
  // string for displaying the error Message
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
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
        emailController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.greenAccent[400])
        // ),
        // errorBorder: new OutlineInputBorder(
        //   borderSide: new BorderSide(color: Colors.greenAccent[400],),
        // ),
        // errorStyle: TextStyle(
        //   color: Colors.greenAccent[400],
        //   fontSize: 13,
        // ),
      )
    );

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(

          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // focusedBorder: OutlineInputBorder(
          //     borderSide: BorderSide(color: Colors.greenAccent[400])
          // ),
          // errorBorder: new OutlineInputBorder(
          //   borderSide: new BorderSide(color: Colors.greenAccent[400],),
          // ),
          // errorStyle: TextStyle(
          //   color: Colors.greenAccent[400],
          //   fontSize: 13,
          // ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.greenAccent[400],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: Text(
          "LOGIN",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        )
      ),
    );

    final phoneNumberButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.greenAccent[400],
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifyPhoneNumber()));
          },
          child: Text(
            "LOGIN WITH PHONE NUMBER",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          )
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
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
                    SizedBox(height: 200, child: Image.asset("assets/logo.png", fit: BoxFit.contain,)),
                    SizedBox(height: 45),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetPassword()));
                          },
                          child: Text("FORGOT PASSWORD? ", style: TextStyle(fontSize: 16, color: Colors.greenAccent[400],),)
                        ),
                      ]
                    ),
                    SizedBox(height: 15),
                    Obx(() => isLoading.value ? Center(child: CircularProgressIndicator(),) : loginButton),
                    SizedBox(height: 15),
                    phoneNumberButton,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifyPhoneNumber()));
                    //       },
                    //       child: Text("Sign in with Phone Number", style: TextStyle(fontSize: 17, color: Colors.greenAccent[400],),)
                    //     ),
                    //   ]
                    // ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("New User? ", style: TextStyle(fontSize: 16, color: Colors.black),),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
                          },
                          child: Text(
                            "REGISTER HERE",
                            style: TextStyle(
                              color: Colors.greenAccent[400],
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                            ),
                          ),
                        )
                      ]
                    ),
                    SizedBox(height: 15),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    isLoading.value = true;
    if (_formKey.currentState.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
            Fluttertoast.showToast(msg: "Login Successful", backgroundColor: Colors.green, fontSize: 16, textColor: Colors.white),
            FirebaseFirestore.instance.collection("users").doc(uid.user.uid).get().then((value) {
              this.loggedInUser = UserModel.fromMap(value.data());
              authController.userModel.value = this.loggedInUser;
              authController.isLogedIn.value = true;
              UserModel.saveUserToCache(this.loggedInUser);
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
              }
            ),
          }
        );
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage, backgroundColor: Colors.greenAccent[400], fontSize: 16, textColor: Colors.white);
        print(error.code);
      }
    }
    isLoading.value = false;
  }
}
