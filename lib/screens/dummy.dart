import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/chat/chat_room.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  UserModel firebaseUser = UserModel();
  AuthController authController = Get.find();
  final userRef = FirebaseFirestore.instance.collection('users');
  CollectionReference ref = FirebaseFirestore.instance.collection("users");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        title: const Text('Chats', style: TextStyle(fontSize: 18, color: Colors.white),),
      ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
            itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                  FirebaseFirestore.instance.collection("users").doc(snapshot.data.docs[index].get('uid')).get().then((value) {
                    this.firebaseUser = UserModel.fromMap(value.data());
                    setState(() {});
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(firebaseUser.imageUrl),));
                  });
                },
                child: Card(
                  child: ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
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
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [
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

}
