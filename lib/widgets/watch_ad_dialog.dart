import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WtachAdDialog extends StatelessWidget {
  final VoidCallback onComplete;
   WtachAdDialog({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
  title: Text("Change Theme"), 
  content:Text(" Watch an ad to Change Theme") ,
  actions: [
    CupertinoDialogAction(child: Text("Watch Ad"), 
    isDefaultAction: true,
    textStyle: TextStyle(color: Colors.green),
    onPressed: (){
      Get.back();
      onComplete();
    },
    ), 

    // CupertinoDialogAction(child: Text("Cancel"), 
    // isDefaultAction: true,
    // textStyle: TextStyle(color: Colors.red),
    // ), 
    
  ],
    );
  }
}