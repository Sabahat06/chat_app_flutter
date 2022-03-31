import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowImageScreen extends StatelessWidget {
  String imageUrl;
  String title;

  ShowImageScreen({this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.greenAccent[400]), onPressed: () {Navigator.of(context).pop();},),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Container(
            height: Get.height,
            width: Get.width,
            child: Image.network(
              imageUrl,
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
        ),
      )
    );
  }
}
