import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/Globals/global_vars.dart';
import 'package:email_password_login/screens/auth_controller.dart';
import 'package:email_password_login/screens/show_image_screen.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  String imageUrl;
  ChatRoom(this.imageUrl);
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthController authController = Get.find();
  Rx<File> file = File('').obs;
  String imageFromFirebaseChat;
  // CollectionReference ref = FirebaseFirestore.instance
  //     .collection("chat_room")
  //     .where('room_id',arrayContainsAny:[GlobalVars.loggedInUserId+"_"+GlobalVars.chatUserId,GlobalVars.chatUserId+"_"+GlobalVars.loggedInUserId] )
  //     .get()
  //     .then((value) {

  // });
  //CollectionReference ref=FirebaseFirestore.instance.collection('chat_room').doc().collection('messages');
  String currentUserId;
  String chatUserId;
  String chatId;
  String chatRoomIdRev;

  final ScrollController listScrollController = ScrollController();

  var msgController = TextEditingController();
  var listMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserId = GlobalVars.loggedInUserId;
    chatUserId = GlobalVars.chatUserId;

    if (currentUserId.hashCode <= chatUserId.hashCode) {
      chatId = '$currentUserId-$chatUserId';
    } else {
      chatId = '$chatUserId-$currentUserId';
    }

    // if (currentUserId.compareTo(chatUserId) > 0) {
    //   chatRoomId = '$currentUserId-$chatUserId';
    // } else {
    //   chatRoomId = '$chatUserId-$currentUserId';
    // }
    // chatRoomIdRev=chatUserId+currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.arrow_back, color: Colors.greenAccent),),
                const SizedBox(width: 2,),
                CircleAvatar(backgroundImage: NetworkImage(widget.imageUrl), maxRadius: 20,),
                const SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(GlobalVars.chatUserName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                      const SizedBox(height: 2,),
                      Text(GlobalVars.userStatus, style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          createMessageList(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      pickImageDialogForChat(context);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(color: Colors.greenAccent[400], borderRadius: BorderRadius.circular(30),),
                      child: const Icon(Icons.add, color: Colors.white, size: 20,),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: TextFormField(
                      controller: msgController,
                      decoration: const InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  // child: TextField(
                  //
                  //   decoration: InputDecoration(
                  //       hintText: "Write message...",
                  //       hintStyle: TextStyle(color: Colors.black54),
                  //       border: InputBorder.none
                  //   ),
                  // ),

                  const SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: () {
                      if (msgController.text.isNotEmpty) {
                        sendMessage(message: msgController.text.trim(), isImage: false);
                        setState(() {});
                      } else {
                        print('una');
                      }
                    },
                    child: const Icon(Icons.send, color: Colors.white, size: 18,),
                    backgroundColor: Colors.greenAccent[400],
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future userSignUp() async {
    await FirebaseFirestore.instance.collection("Users").where('Email', isEqualTo: 'emailCtr.text').get().then((value) {
      if (value.docs.length > 0) {}
    });
  }

  sendMessage({String message, String urlImage, bool isImage}) {
    var docRef = FirebaseFirestore.instance.collection('messages').doc(chatId).collection(chatId).doc(DateTime.now().millisecondsSinceEpoch.toString());
    listScrollController.animateTo(0.0, duration: Duration(microseconds: 300), curve: Curves.easeOut);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.set(docRef, {
        'idFrom': authController.userModel.value.uid,
        'idTo': chatUserId,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'content': message??'',
        'image' : urlImage??'',
        'type': '0',
      });
    });
    msgController.clear();
  }

  createMessageList() {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: chatId == ""
        ? Center(child: CircularProgressIndicator(),)
        : StreamBuilder(
          stream: FirebaseFirestore.instance.collection('messages').doc(chatId).collection(chatId).orderBy('timestamp', descending: true).limit(20).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(),);
            } else {
              listMessage = snapshot.data.docs;
              final data = snapshot.requireData;
              return data.size == 0
                  ? Center(child: Text('Type Message and start conversation with ${GlobalVars.chatUserName}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent[400]),),)
                  : ListView.builder(
                itemBuilder: (context, index) => createItem(index, snapshot.data.docs[index]),
                itemCount: data.size,
                reverse:  true,
                controller: listScrollController,
              );
            }
          },
        ),
    );
  }

  createItem(int index, var document) {
    if(document['idFrom'] == chatUserId) {
      // my message - right side
      return Padding(
        padding: const EdgeInsets.only(left: 5.0),
        child: Container(
          child: Row(
            children: [
              Column(
                children: [
                  document['image'] == ''
                    ? Container(
                      child: Text(document['content'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      // width: 200.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    )
                    : GestureDetector(
                      onTap: () {
                        Get.to(() => ShowImageScreen(imageUrl: document['image'], title: GlobalVars.chatUserName,), transition: Transition.circularReveal);
                      },
                      child: Container(
                        height: Get.height*0.3,
                        width: Get.width*0.35,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            document['image'],
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
                    ),
                  // ClipPath(
                  //   clipper: MessageClipper(),
                  //   child: Container(
                  //     alignment: Alignment.centerRight,
                  //     height: 10,
                  //     width: 200,
                  //     color: Colors.grey[300],
                  //   ),
                  // ),
                  SizedBox(height: 5,)
                ],
              )
            ],
          ),
        ),
      );
    }
    else{
      return Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      document['image'] == ''
                        ? Container(
                          child: Text(document['content'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),),
                          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                          // width: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent[400],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          margin: EdgeInsets.only(left: 10.0),
                        )
                        : GestureDetector(
                          onTap: () {
                            Get.to(() => ShowImageScreen(imageUrl: document['image'], title: GlobalVars.chatUserName,), transition: Transition.circularReveal);
                          },
                          child: Container(
                          height: Get.height*0.25,
                          width: Get.width*0.25,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              document['image'],
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
                        ),
                    ],
                  ),
                ],
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 5.0),
        ),
      );
    }
  }

  pickImageDialogForChat(BuildContext context) {
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
                  openGalleryForChat(true);
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
                  openGalleryForChat(false);
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

  Future<void> openGalleryForChat(bool openGallary)  {
    ImagePicker().getImage(
      source: openGallary ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 15
    ).then((imageFile) {
      file.value = File(imageFile.path);
      if(file.value != null) {
        uploadFileInFirebaseChat();
      }
    });
  }

  Future uploadFileInFirebaseChat() async {
    if (file.value == null) return;
    final fileName = basename(file.value.path);
    final destination = '${DateTime.now()}/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child('file/');

      UploadTask uploadTask;
      uploadTask = ref.child(fileName).putFile(file.value);
      // now get the url of image and store in firebase
      var imageUrl;
      imageUrl = await (await uploadTask).ref.getDownloadURL();
      String url = imageUrl.toString();
      print(url);
      imageFromFirebaseChat = url;
      sendMessage(message: '', isImage: true, urlImage: url);
      // await ref.putFile(file.value);
      // String url = ref.getDownloadURL();
      // print(url);
      // UploadTask uploadTask;

    } catch (e) {
      print('error occured');
    }
  }

 // bool isLastMsgRight(int index) {
 //    if((index>0 && listMessage!=null && listMessage[index-1]['idFrom'] != currentUserId) || index == 0){
 //        return true;
 //    }else{
 //      return false;
 //    }
 //  }
 // bool isLastMsgLeft(int index) {
 //    if((index>0  && listMessage!=null && listMessage[index-1]['idFrom'] == currentUserId) || index == 0){
 //        return true;
 //    }else{
 //      return false;
 //    }
 //  }
}

class ChatMessage {
  String messageContent;
  String messageType;

  ChatMessage({@required this.messageContent, @required this.messageType});
}

class MessageClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {

    var firstOffset = Offset(size.width * 0.1, 0.0);
    var secondPoint = Offset(size.width * 0.15, size.height );
    var lastPoint = Offset(size.width * 0.2, 0.0);
    var path = Path()
      ..moveTo(firstOffset.dx, firstOffset.dy)
      ..lineTo(secondPoint.dx, secondPoint.dy)
      ..lineTo(lastPoint.dx, lastPoint.dy)
      ..close();


    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {

    return true;
  }

}
