import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/helpers/ads_helper.dart';
import 'package:vpn_basic_project/helpers/my_snackba.dart';


import '../helpers/pref.dart';
import '../models/vpn.dart';
import '../models/vpn_config.dart';
import '../services/vpn_engine.dart';


class HomeController extends GetxController {

  final Rx<Vpn> vpn = Pref.vpn.obs;

  // final RxBool startTimer = false.obs;  

  final vpnState = VpnEngine.vpnDisconnected.obs;

   void connectToVpn() {
     ///Stop right here if user not select a vpn
    // if (_selectedVpn == null) return;

    if(vpn.value.openVPNConfigDataBase64.isEmpty) {
      MyDialogs.info(msg: "Select a location by clicking \'change location\' ");
      return;
      }; 


    if (vpnState.value == VpnEngine.vpnDisconnected) {

     // log('\nBefore : ${vpn.value.openVPNConfigDataBase64}');
      
    final data =  Base64Decoder().convert(vpn.value.openVPNConfigDataBase64);

    final config = Utf8Decoder().convert(data); 

    final vpnConfig = VpnConfig(
      country: vpn.value.countryLong, 
      username: 'vpn', 
      password: 'vpn', 
      config: config);

      // log('\nAfter : ${config}');

      // show interstitial ad and then connect to vpn
        VpnEngine.startVpn(vpnConfig);
      // AdsHelper.showInterstitialAd(onComplete: ()async{
      //  await  VpnEngine.startVpn(vpnConfig);

      // });
      
     // startTimer.value = true;
    } else {
      ///Stop if stage is "not" disconnected
      //startTimer.value = false;
      VpnEngine.stopVpn();
    }
  }

// vpn button color change 
  Color get getButtonColor {
    switch (vpnState.value){
      case VpnEngine.vpnDisconnected :
      return Colors.blue;

      case VpnEngine.vpnConnected :
      return Colors.green;

      default: 
      return Colors.orange;
    }
  } 

  // vpn button color text change 
  String get getButtonText {
    switch (vpnState.value){
      case VpnEngine.vpnDisconnected :
      return  'Tap to Connect';

      case VpnEngine.vpnConnected :
      return 'Disconnected';

      default: 
      return 'Connecting....';
    }
  } 




}