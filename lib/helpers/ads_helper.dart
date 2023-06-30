


import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vpn_basic_project/helpers/config.dart';
import 'package:vpn_basic_project/helpers/my_snackba.dart';

import '../controllers/native_ad_controller.dart';

class AdsHelper{
static Future<void> initAds() async { 
    await MobileAds.instance.initialize();
  }

  static InterstitialAd? _interstitialAd;
  static bool _interstitialAdLoaded = false;

  static NativeAd? _nativeAd;
  static bool _nativeAdLoaded = false;

// ************* Interstitial Ad************************//
static void precacheInterstitialAd() {
  log('precache Interstitial Ad - Id: ${Config.interstitialAd}');
  if(Config.hideAds){
    return;
  }

    InterstitialAd.load(
      adUnitId: Config.interstitialAd,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) { 
              _resetInterstitialAd();
              precacheInterstitialAd();
            },
            
          );
          _interstitialAd = ad;
          _interstitialAdLoaded = true; 
          
        },
        onAdFailedToLoad: (err) { 
          _resetInterstitialAd();
          log('Failed to load an interstitial ad: ${err.message}');
         
        },
      ),
    );
  }

  static void _resetInterstitialAd(){
    _interstitialAd?.dispose(); 
    _interstitialAd = null; 
    _interstitialAdLoaded = false;
  }
// interstitial ads
 static void showInterstitialAd({
  required VoidCallback onComplete

 }) {


  if(Config.hideAds){
    onComplete();
    return;
  }

  if(_interstitialAdLoaded && _interstitialAd != null){
    _interstitialAd?.show();
    onComplete();
    return; 
  }
MyDialogs.showProgress();
    InterstitialAd.load(
      adUnitId: Config.interstitialAd,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) { 
              onComplete();
              _resetInterstitialAd();
              precacheInterstitialAd();
            },
            
          );
          Get.back();
          ad.show();

          
        },
        onAdFailedToLoad: (err) {
          Get.back();
          log('Failed to load an interstitial ad: ${err.message}');
          onComplete();
        },
      ),
    );
  }


//****************************** Native Ad ******************//

   static void precacheNativeAd() {

    log('precache Native ad Id ${Config.nativeAd}');

if(Config.hideAds)return;

    _nativeAd =  NativeAd(
        adUnitId: Config.nativeAd,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
          _nativeAdLoaded = true;
          // _resetNativelAd(dispose: false);
          // precacheNativeAd();
          },
          onAdFailedToLoad: (ad, error) {
  _resetNativelAd();
            // Dispose the ad here to free resources.
            log('$NativeAd failed to load: $error');
            
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
           
            templateType: TemplateType.small,
        ))
      ..load();
  }

static void _resetNativelAd(){
    _nativeAd?.dispose(); 
    _nativeAd = null; 
    _nativeAdLoaded = false;
  }


// native ads 
  static NativeAd? loadNativeAd({required NativeAdController adController}) {

    log('Precache Native ad Id ${Config.nativeAd}');

     if(_nativeAdLoaded && _nativeAd != null)  {
      adController.adLoaded.value = true; 
      return  _nativeAd; }
  
    

if(Config.hideAds){
    
    return null;
  }

    return NativeAd(
        adUnitId: Config.nativeAd,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            adController.adLoaded.value= true; 
             _resetNativelAd();
          precacheNativeAd();
          },
          onAdFailedToLoad: (ad, error) {
            _resetNativelAd();
            // Dispose the ad here to free resources.
            log('$NativeAd failed to load: $error');
           
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
           
            templateType: TemplateType.small,
        ))
      ..load();
  }


// rewarded ads 

static void showRewardedAd({
  required VoidCallback onComplete
 }) {

   log('Rewarded ad Id ${Config.rewardedAsd}');

  if(Config.hideAds){
    onComplete();
    return;
  }
MyDialogs.showProgress();
    RewardedAd.load(
      adUnitId: Config.rewardedAsd,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
            
          Get.back();
          // reward listener 
          ad.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem){
              onComplete();
            }
          );

          
        },
        onAdFailedToLoad: (err) {
          log('Failed to load an interstitial ad: ${err.message}');
          Get.back();
          //onComplete();
        },
      ),
    );
  }



}