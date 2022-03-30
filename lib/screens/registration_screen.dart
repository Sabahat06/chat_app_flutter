import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/Globals/global_vars.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/auth_controller.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  AuthController authController = Get.find();
  RxBool isLoading = false.obs;
  final _auth = FirebaseAuth.instance;
  
  // string for displaying the error Message
  String errorMessage;


  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  final phoneNumberEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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

    ///password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
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
        firstNameEditingController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      )
    );

    ///confirm password field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return "Password don't match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      )
    );

    ///signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.greenAccent[400],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUpValidationForImage();
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: Text(
          "SIGNUP",
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
                          child: CircleAvatar(backgroundImage: authController.file.value.path == ''
                            ? NetworkImage('https://srmuniversity.ac.in/wp-content/uploads/professor/user-avatar-default.jpg')
                            : FileImage(authController.file.value),
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
                                          pickImageDialog(context);
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
                    SizedBox(height: 10),
                    passwordField,
                    SizedBox(height: 10),
                    confirmPasswordField,
                    SizedBox(height: 15),
                    Obx(() => isLoading.value ? Center(child: CircularProgressIndicator(),) : signUpButton),
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

  void signUp(String email, String password) async {
    isLoading.value = true;
    if (_formKey.currentState.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
            postDetailsToFirestore()}
            )
          .catchError((e) {
          Fluttertoast.showToast(msg: e.message, backgroundColor: Colors.greenAccent[400], fontSize: 16, textColor: Colors.white,);
        });
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

  ///Post user data in firebase
  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;
    userModel.phoneNumber = phoneNumberEditingController.text;
    userModel.imageUrl = authController.imageFromFirebase;
    userModel.userStatus = 'Online';


    ///Storing User Locally
    authController.userModel.value = userModel;
    authController.isLogedIn.value = true;
    UserModel.saveUserToCache(userModel);
    GlobalVars.loggedInUserId = user.uid;
    ///storing data in firebase
    await firebaseFirestore.collection("users").doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
  }

  pickImageDialog(BuildContext context){
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
                  authController.openGallery(true);
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
                  authController.openGallery(false);
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
      });
  }

  signUpValidationForImage(){
    if(authController.imageFromFirebase.trim().length==0)  {
      Fluttertoast.showToast(msg: 'Please Upload your image');
      return false;
    }
    else
      return true;
  }

}
