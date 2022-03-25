
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/Globals/global_vars.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DummyChat extends StatefulWidget {
  @override
  _DummyChatState createState() => _DummyChatState();
}

class _DummyChatState extends State<DummyChat> {
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
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/5.jpg"),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        GlobalVars.chatUserName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.settings,
                  color: Colors.black54,
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
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),

                  Expanded(
                    child: TextFormField(
                      controller: msgController,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
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

                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (msgController.text.isNotEmpty) {
                        sendMessage(message: msgController.text.trim());
                        setState(() {

                        });
                      } else {
                        print('una');
                      }
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
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
    await FirebaseFirestore.instance
        .collection("Users")
        .where('Email', isEqualTo: 'emailCtr.text')
        .get()
        .then((value) {
      if (value.docs.length > 0) {}
    });
  }

  sendMessage({@required String message}) {
    var docRef = FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .collection(chatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    listScrollController.animateTo(0.0,
        duration: Duration(microseconds: 300), curve: Curves.easeOut);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.set(docRef, {
        'idFrom': currentUserId,
        'idTo': chatUserId,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'content': message,
        'type': '0',
      });
    });
    msgController.clear();
  }

  createMessageList() {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: chatId == ""
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(chatId)
                  .collection(chatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  listMessage = snapshot.data.docs;
                  final data = snapshot.requireData;
                  return ListView.builder(
                      itemBuilder: (context, index) =>
                          createItem(index, snapshot.data.docs[index]),
                    itemCount: data.size,
                    reverse:  true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  createItem(int index,  var document) {
    if(document['idFrom'] == chatUserId) {
      // my message - right side
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Text(document['content'],style: TextStyle(
                color: Colors.white,fontWeight: FontWeight.w500
              ),),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              width: 200.0,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: EdgeInsets.only(bottom: 10.0,right: 10.0),
            )
          ],
        ),
      );

    }else{
      // others message - left side
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  child: Text(document['content'],style: TextStyle(
                      color: Colors.black,fontWeight: FontWeight.w400
                  ),),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                ),
              ],
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
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
