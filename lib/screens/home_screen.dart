import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/AlertDialogeWidget.dart';
import 'package:email_password_login/Globals/global_vars.dart';
import 'package:email_password_login/chat/chat_room.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/auth_controller.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  AuthController authController = Get.find();
  final userRef = FirebaseFirestore.instance.collection('users');
  CollectionReference ref = FirebaseFirestore.instance.collection("users");
  String nestedDocId;
  String chatUserName;
  String chatUserid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("users").doc(user.uid).get().then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
      authController.userModel.value = this.loggedInUser;
      UserModel.saveUserToCache(this.loggedInUser);
    });
    updateUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        title: const Text('Chats', style: TextStyle(fontSize: 18, color: Colors.white),),
        actions: [
          IconButton(
            onPressed: () {
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
            icon: Icon(Icons.logout, color: Colors.white,)
          )
        ],
      ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
            itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
            itemBuilder: (_, index) {
              if (snapshot.data.docs[index].get('uid') == GlobalVars.loggedInUserId) {
                GlobalVars.loggedUserName = snapshot.data.docs[index].get('firstName').toString();
              }
              return GestureDetector(
                onTap: () {
                  // print("you wanna chat with ${snapshot.data.docs[index].get('name')} and his user id is ${snapshot.data.docs[index].get('user_id')}");
                  GlobalVars.chatUserName = snapshot.data.docs[index].get('firstName').toString();
                  GlobalVars.chatUserId = snapshot.data.docs[index].get('uid').toString();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom()));
                },
                child: snapshot.data.docs[index].get('uid') == GlobalVars.loggedInUserId
                  ? Container()
                  : Card(
                    child: ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.greenAccent[400]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image.network(
                          snapshot.data.docs[index].get('imageUrl').toString() == null
                            ? 'https://srmuniversity.ac.in/wp-content/uploads/professor/user-avatar-default.jpg'
                            : snapshot.data.docs[index].get('imageUrl').toString(),
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            snapshot.data.docs[index].get('firstName'),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 0, right: 5),
                            child: Text(
                              snapshot.data.docs[index].get('email',),
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ),
                          // Text(snapshot.data.docChanges[index].doc('title')),
                        ],
                      ),
                      trailing: Icon(Icons.email_outlined, color: Colors.greenAccent[400],),
                    ),
                  ),
              );
            },
          );
        }
      ),
    );
  }

  Future updateUserId() async {
    print("trying to upade");
    userRef.doc(GlobalVars.loggedInUserId).update({
      "uid": GlobalVars.loggedInUserId.toString(),
    });
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:email_password_login/model/user_model.dart';
// import 'package:email_password_login/screens/auth_controller.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'login_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   AuthController authController = Get.find();
//   User user = FirebaseAuth.instance.currentUser;
//   UserModel loggedInUser = UserModel();
//
//   @override
//   void initState() {
//     super.initState();
//     // FirebaseFirestore.instance.collection("users").doc(user.uid).get().then((value) {
//     //   this.loggedInUser = UserModel.fromMap(value.data());
//     //   setState(() {});
//     //   authController.userModel.value = this.loggedInUser;
//     //   UserModel.saveUserToCache(this.loggedInUser);
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final logOutButton = Material(
//       elevation: 5,
//       borderRadius: BorderRadius.circular(10),
//       color: Colors.greenAccent[400],
//       child: MaterialButton(
//         padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
//         minWidth: MediaQuery.of(context).size.width,
//         onPressed: () {
//           logout(context);
//           authController.isLogedIn.value = false;
//           UserModel.deleteCachedUser();
//         },
//         child: Text(
//           "LOGOUT",
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
//         )
//       ),
//     );
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.greenAccent[400],
//         title: const Text("Welcome"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               SizedBox(height: 150, child: Image.asset("assets/logo.png", fit: BoxFit.contain),),
//               Text("Welcome ${authController.userModel.value.firstName}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
//               SizedBox(height: 10,),
//               Obx(() => authController.userModel.value.firstName == null && authController.userModel.value.secondName==null
//                 ? Container()
//                 : Row(
//                   children: [
//                     Container(
//                       width: Get.width*0.33,
//                       child: Text("Full Name",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18
//                         )
//                       ),
//                     ),
//                     Text(": ",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18
//                       )
//                     ),
//                     Container(
//                       width: Get.width*0.5 ,
//                       child: Text("${authController.userModel.value.firstName} ${authController.userModel.value.secondName}",
//                         style: TextStyle(
//                           color: Colors.black54,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18
//                         )
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 7,),
//               Obx(() => authController.userModel.value.email == null
//                 ? Container()
//                 : Row(
//                   children: [
//                     Container(
//                       width: Get.width*0.33,
//                       child: Text("Email",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18
//                         )
//                       ),
//                     ),
//                     Text(": ",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18
//                       )
//                     ),
//                     Container(
//                       width: Get.width*0.5,
//                       child: Text("${authController.userModel.value.email}",
//                         style: TextStyle(
//                           color: Colors.black54,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         )
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 7,),
//               Obx(() => authController.userModel.value.phoneNumber == null
//                 ? Container()
//                 : Row(
//                   children: [
//                     Container(
//                       width: Get.width*0.33,
//                       child: Text("Phone Number",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18
//                         )
//                       ),
//                     ),
//                     Text(": ",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18
//                       )
//                     ),
//                     Container(
//                       width: Get.width*0.5,
//                       child: Text("${authController.userModel.value.phoneNumber}",
//                         style: TextStyle(
//                           color: Colors.black54,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18
//                         )
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 15,),
//               logOutButton,
//               // ActionChip(
//               //   labelPadding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
//               //   backgroundColor: Colors.grey,
//               //   label: Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16),),
//               //   onPressed: () {
//               //     logout(context);
//               //   }
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // the logout function
//   Future<void> logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
//   }
// }
