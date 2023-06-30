import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/apis/apis.dart';
import 'package:vpn_basic_project/models/ip_details.dart';
import 'package:vpn_basic_project/models/network_data.dart';
import 'package:vpn_basic_project/widgets/network_card.dart';

import '../main.dart';

class NetworkTestScreen extends StatelessWidget {

   NetworkTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
  final ipData = IpDetails.fromJson({}).obs;

  APIs.getIpDetails(ipData: ipData);


    return Scaffold(
      appBar: AppBar(
        title: Text("Network Text Screen"),
      ),

       floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: FloatingActionButton(
            onPressed: (){
              ipData.value = IpDetails.fromJson({});
APIs.getIpDetails(ipData: ipData);
            } , 
          child: Icon(CupertinoIcons.refresh),
          ),
        ),

      body:Obx(
        ()=> ListView(
         physics: BouncingScrollPhysics(),

           padding: EdgeInsets.only(
            top: mq.height*.015, 
            bottom: mq.height*.1, 
            left: mq.width*.04, 
            right: mq.width*.04,),
      
          children: [
           // ip 
            NetworkCard(data: NetworkData(
              title:'IP Address', 
              subtitle: ipData.value.query, 
              icon: Icon(CupertinoIcons.location_solid, 
              color: Colors.blue,) )), 
      
      
              // sip 
            NetworkCard(data: NetworkData(
              title:'Internet Provider', 
              subtitle: ipData.value.isp, 
              icon: Icon(Icons.business, 
              color: Colors.orange,) )), 
      
              // location
            NetworkCard(data: NetworkData(
              title:'Location', 
              subtitle: ipData.value.country.isEmpty 
              ? 'Fetching....'
              :'${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}', 
              icon: Icon(CupertinoIcons.location, 
              color: Colors.pink,) )), 
      
              // pin code 
            NetworkCard(data: NetworkData(
              title:'Pin-code', 
              subtitle: ipData.value.zip, 
              icon: Icon(CupertinoIcons.location_solid, 
              color: Colors.cyan,) )), 
      
                // time zone
            NetworkCard(data: NetworkData(
              title:'Timezone', 
              subtitle: ipData.value.timezone, 
              icon: Icon(CupertinoIcons.clock, 
              color: Colors.green,) )), 
          ],  
          
        ),
      ) ,
    );
  }
}