import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';

import 'package:vpn_basic_project/controllers/location_controller.dart';
import 'package:vpn_basic_project/controllers/native_ad_controller.dart';
import 'package:vpn_basic_project/helpers/ads_helper.dart';
import 'package:vpn_basic_project/widgets/vpn_card.dart';

import '../helpers/config.dart';
import '../main.dart';

class LocationScreen extends StatelessWidget {
   LocationScreen({super.key});

  //final controller = Get.find<LocationScreen>();
  final _controller = LocationController();
  final _adController = NativeAdController();


  @override
  Widget build(BuildContext context) {
    
if(_controller.vpnList.isEmpty) _controller.getVpnData();
 _adController.ad = AdsHelper.loadNativeAd(adController: _adController);

    return Obx(()=> Scaffold(
        appBar: AppBar(
        
          title: Text('VPN Locations (${_controller.vpnList.length})'),
         
        ),


        bottomNavigationBar: 
        Config.hideAds? null:
        _adController.ad != null && _adController.adLoaded.isTrue ?
        SafeArea(
          child: SizedBox(
            height: 90, 
            child: AdWidget(ad: _adController.ad!),
          ),
        ): null,
// refresh button 
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: FloatingActionButton(
            onPressed: (){
_controller.getVpnData();
            } , 
          child: Icon(CupertinoIcons.refresh),
          ),
        ),


        // body 
        body:  _controller.isLoading.value
        ? _loadingWidget()
        : _controller.vpnList.isEmpty
        ? _noVpnFount()
        : _vpnData()
       
      ),
    );
  }

_vpnData() => ListView.builder(
  physics: BouncingScrollPhysics(),
  itemCount: _controller.vpnList.length, 
  padding: EdgeInsets.only(top: mq.height*.015, bottom: mq.height*.1, left: mq.width*.04, right: mq.width*.04,),
  itemBuilder: (context, index)=>VpnCard(vpn: _controller.vpnList[index],),
);

  _loadingWidget() =>SizedBox( 
    
    width: double.infinity, 
    height: double.infinity, 
    child:  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LottieBuilder.asset("assets/lottie/loading.json", 
        width:mq.width*.5),

        Text("Loading Vpn.....😋", style: TextStyle(fontSize: 18, 
        fontWeight: FontWeight.bold,
        color: Colors.black54),) 
      ],),
    
  );

  _noVpnFount()=> Center(
    child: Text("Vpn Not Fount 😒", style: TextStyle(fontSize: 18, 
          fontWeight: FontWeight.bold,
          color: Colors.black54),),
  ) ;
}