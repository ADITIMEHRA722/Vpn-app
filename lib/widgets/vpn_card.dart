import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/services/vpn_engine.dart';

import '../helpers/my_snackba.dart';
import '../helpers/pref.dart';
import '../main.dart';
import '../models/vpn.dart';

class VpnCard extends StatelessWidget {
  final Vpn vpn;

  VpnCard({super.key, required this.vpn});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: mq.height * .01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          controller.vpn.value = vpn; 
          Pref.vpn = vpn;
          Get.back();

          MyDialogs.success(msg: 'Connecting to Vpn ....');

        if(controller.vpnState.value == VpnEngine.vpnConnected){
          VpnEngine.stopVpn();
          Future.delayed(Duration(seconds: 2) ,(){
            controller.connectToVpn(); 
          });

        }else{
          controller.connectToVpn();
        }

          
        },
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          // country icon flag
          leading: Container(
            padding: EdgeInsets.all(.5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(5)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                "assets/flags/${vpn.countryShort.toLowerCase()}.png",
                height: 40,
                width: mq.width*.15,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // title
          title: Text(vpn.countryLong),
          //subtitile
          subtitle: Row(
            children: [
              Icon(
                Icons.speed_rounded,
                color: Colors.blue,
                size: 20,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                _formateBytes(vpn.speed, 1),
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vpn.numVpnSessions.toString(),
                style: TextStyle(fontSize: 13, 
                color: Theme.of(context).lighText
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Icon(
                CupertinoIcons.person_3,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formateBytes(int bytes, int decimal) {
    if (bytes < 0) {
      return "0 B";
    }
    const suffixes = ['Bps', 'Kbps', 'Mbps', 'Gbps', 'Tbps'];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimal)} ${suffixes[i]}';
  }
}
