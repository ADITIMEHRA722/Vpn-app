import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/helpers/ads_helper.dart';
import 'package:vpn_basic_project/screens/home_screen.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(microseconds: 2000), (){
       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

       AdsHelper.precacheInterstitialAd();
       AdsHelper.precacheNativeAd();

// we can navigate using getx
Get.off(()=>HomeScreen());
//Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // app logo 
            Positioned(
               left: mq.width*0.35,
               top: mq.height*0.2,
              // width: mq.width*0.4,
              child: ClipRRect(
              
              borderRadius: BorderRadius.circular(60),
              child: Image.asset("assets/images/logo.png", 
              height: 120,
              fit: BoxFit.cover,))), 
            
            Positioned(
              width: mq.width,
              bottom: mq.height*.15,
              child: Text("Made in India 💗", style: TextStyle(
                fontSize: 25,
                letterSpacing: 1,
                color: Theme.of(context).lighText
              ), 
              textAlign: TextAlign.center,))
        ],
      ),
    );
  }
}