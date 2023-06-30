import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vpn_basic_project/controllers/native_ad_controller.dart';

class MyDialogs{
  static success({required String msg}){
     Get.snackbar('Success', msg, 
    colorText: Colors.white,
    backgroundColor: Colors.green.withOpacity(.6), 
    duration: Duration(seconds: 4));
  } 

  static error({required String msg}) {
    Get.snackbar('Error', msg, 
    colorText: Colors.white, 
    backgroundColor: Colors.redAccent.withOpacity(.6));
  }

  static info({required String msg}) {
    Get.snackbar('Info', msg, 
    colorText: Colors.white);
  }

   static showProgress() {
    Get.dialog(Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.green,
      ),
    ));
  }


  

}