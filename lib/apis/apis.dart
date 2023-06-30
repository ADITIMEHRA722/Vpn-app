import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart';
import 'package:vpn_basic_project/helpers/my_snackba.dart';

import '../helpers/pref.dart';
import '../models/ip_details.dart';
import '../models/vpn.dart';

class APIs {
  static Future<List<Vpn>> getVpnServer() async {
    final List<Vpn> vpnList = [];

    try {
      final res = await get(Uri.parse("http://www.vpngate.net/api/iphone/"));
      final csvString = res.body.split("#")[1].replaceAll("*", '');
      List<List<dynamic>> list = const CsvToListConverter().convert(csvString);
      final header = list[0];
      for (int i = 1; i < list.length - 1; i++) {
        Map<String, dynamic> tempjson = {};

        for (int j = 0; j < header.length; j++) {
          tempjson.addAll({header[j].toString(): list[i][j]});
        }
        vpnList.add(Vpn.fromJson(tempjson));
      }

      log(vpnList.first.hostname);
    } catch (e) {
      MyDialogs.error(msg: 'Please check your internet connection');
      log('\ngetVpnServer: $e');
    }
   

   vpnList.shuffle();

   if(vpnList.isNotEmpty){
    Pref.vpnList = vpnList;
   }
    return vpnList;
// log(res.body);
  }


 static Future<void> getIpDetails({ required Rx<IpDetails> ipData}) async {
    

    try {
      final res = await get(Uri.parse("http://ip-api.com/json/"));

      final data = jsonDecode(res.body);
      ipData.value = IpDetails.fromJson(data);
      

      
    } catch (e) {
      MyDialogs.error(msg: 'Please check your internet connection');
      log('\ngetIpDetails: $e');
    }
   
 }

}
