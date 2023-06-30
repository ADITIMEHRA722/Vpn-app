

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vpn_basic_project/main.dart';

import '../models/network_data.dart';



class NetworkCard extends StatelessWidget {
  final NetworkData data;

  NetworkCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: mq.height * .01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          
     
        },
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          // country icon flag
          leading:Icon( 
            data.icon.icon, 
            color: data.icon.color,
            size: data.icon.size?? 28,
            ),

          // title
          title: Text(data.title),
          //subtitile
          subtitle: Text(data.subtitle),

          
        ),
      ),
    );
  }

}

  