import 'package:flutter/material.dart';

class DynamicLinkScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Dynamic Link Page", style: TextStyle(fontSize: 18, color: Colors.greenAccent[400]),),
      ),
      body: Center(
        child: Text("This is Chat Room App", style: TextStyle(fontSize: 22, color: Colors.greenAccent[400]),),
      ),
    );
  }
}
