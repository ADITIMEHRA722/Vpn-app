

import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Config {
  
  static final _config = FirebaseRemoteConfig.instance;

 static const _defaultValue = {
"interstitial_ad": "ca-app-pub-3940256099942544/1033173712",
  "native_ad": "ca-app-pub-3940256099942544/2247696110",
  "rewarded_ad": "ca-app-pub-3940256099942544/5224354917",
  "show_ads": true
  };

   static Future<void> initConfig()async{
await _config.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(minutes: 30),
));

await _config.setDefaults(_defaultValue);
await _config.fetchAndActivate();
log('Remote config data: ${_config.getAll()}');

 _config.onConfigUpdated.listen((event) async {
   await _config.activate();
   // Use the new config values here.
   log('updated: ${_config.getAll()}');
 });


   }

   static bool get _showAd =>_config.getBool('show_ads');
    static String get nativeAd =>_config.getString('native_ad');
      static String get interstitialAd =>_config.getString('interstitial_ad');
        static String get rewardedAsd =>_config.getString('rewarded_ad');

        static bool get hideAds => !_showAd;
}