import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertDialogWidget extends StatelessWidget {
  String title;
  String subTitle;
  GestureTapCallback onPositiveClick;

  AlertDialogWidget({this.title, this.subTitle, this.onPositiveClick});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(subTitle, style: TextStyle(),),
      actions: [
        TextButton(
          child: Text(
            'No',
            style: TextStyle(
              fontSize: 16,
              color: Colors.greenAccent[400],
              fontWeight: FontWeight.bold
            )
          ),
          onPressed: (){Get.back();},
        ),
        TextButton(
          child: Text(
            'Yes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.greenAccent[400],
              fontWeight: FontWeight.bold
            ),
          ),
          onPressed: onPositiveClick
        ),
      ],
    );
  }
}