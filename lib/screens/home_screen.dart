
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/helpers/ads_helper.dart';
import 'package:vpn_basic_project/helpers/config.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/screens/location_screen.dart';
import 'package:vpn_basic_project/screens/network_test_screen.dart';
import 'package:vpn_basic_project/widgets/count_down_timer.dart';
import 'package:vpn_basic_project/widgets/home_card.dart';
import 'package:vpn_basic_project/widgets/network_card.dart';
import 'package:vpn_basic_project/widgets/watch_ad_dialog.dart';

import '../main.dart';

import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatelessWidget {

  // for  1 screen
  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {


    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });

    return Scaffold(
      // app bar
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text('Vpn'),
        actions: [
          IconButton(
              onPressed: () {

                // we can't use directly because this is not valid , we have to take permission to the user


                // AdsHelper.showRewardedAd(onComplete: (){
                //   Get.changeThemeMode(
                // Pref.isDarkMode? ThemeMode.light: ThemeMode.dark);
                // Pref.isDarkMode = !Pref.isDarkMode;
                // });

                // if add are false 
                if(Config.hideAds){
                   Get.changeThemeMode(
                Pref.isDarkMode? ThemeMode.light: ThemeMode.dark);
                Pref.isDarkMode = !Pref.isDarkMode;
                return;
                }

                // here we can create alert box 
                Get.dialog(WtachAdDialog(onComplete: (){
                  // watch ad to get reward
                  AdsHelper.showRewardedAd(onComplete: (){
                  Get.changeThemeMode(
                Pref.isDarkMode? ThemeMode.light: ThemeMode.dark);
                Pref.isDarkMode = !Pref.isDarkMode;
                });
                }));
              },

              icon: Icon(
                Icons.brightness_medium,
                size: 26,
              )),
          IconButton(
              padding: EdgeInsets.only(right: 8),
              onPressed: () {
                Get.to(() => NetworkTestScreen());
              },
              icon: Icon(
                CupertinoIcons.info,
                size: 27,
              ))
        ],
      ),

      bottomNavigationBar: _changeLocation(context),

      // body
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        // SizedBox(
        //   height: mq.height * .02,
        //   width: double.maxFinite,
        // ),
        Obx(
          () => _vpnButton(),
        ),

        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeCard(
                  title: _controller.vpn.value.countryLong.isEmpty
                      ? 'Country'
                      : _controller.vpn.value.countryLong,
                  subtitle: "FREE",
                  icon: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 30,
                    child: _controller.vpn.value.countryLong.isEmpty
                        ? Icon(
                            Icons.vpn_lock_rounded,
                            size: 30,
                            color: Colors.white,
                          )
                        : null,
                    backgroundImage: _controller.vpn.value.countryLong.isEmpty
                        ? null
                        : AssetImage(
                            "assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png"),
                  )),
              HomeCard(
                  title: _controller.vpn.value.countryLong.isEmpty
                      ? "100 ms"
                      : '${_controller.vpn.value.ping} ms',
                  subtitle: "PING",
                  icon: CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 30,
                    child: Icon(
                      Icons.equalizer_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(
          height: mq.height * .02,
        ),

        StreamBuilder<VpnStatus?>(
          initialData: VpnStatus(),
          stream: VpnEngine.vpnStatusSnapshot(),
          builder: (context, snapshot) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeCard(
                  title: '${snapshot.data?.byteIn ?? '0 kbps'}',
                  subtitle: "DOWNLOAD",
                  icon: CircleAvatar(
                    backgroundColor: Colors.lightGreen,
                    radius: 30,
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  )),
              HomeCard(
                  title: '${snapshot.data?.byteOut ?? '0 kbps'}',
                  subtitle: "UPLOAD",
                  icon: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 2, 66, 118),
                    radius: 30,
                    child: Icon(
                      Icons.arrow_upward_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ]),
    );
  }

 
  Widget _vpnButton() => Column(children: [
        Semantics(
          button: true,
          child: InkWell(
            onTap: () {
              _controller.connectToVpn();
              // _controller.startTimer.value = !_controller.startTimer.value;
            },
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _controller.getButtonColor.withOpacity(.1),
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _controller.getButtonColor.withOpacity(.3),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: mq.height * .14,
                  height: mq.height * .14,
                  decoration: BoxDecoration(
                    color: _controller.getButtonColor,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.power_settings_new,
                        size: 28,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        _controller.getButtonText,
                        style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
            margin:
                EdgeInsets.only(top: mq.height * .015, bottom: mq.height * .03),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.blue),
            child: Text(
              _controller.vpnState.value == VpnEngine.vpnDisconnected
                  ? "Not Connected"
                  : _controller.vpnState.replaceAll("_", ' ').toUpperCase(),
              style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            )),
        Obx(() => CountDownTimer(
          startTimer: _controller.vpnState.value == VpnEngine.vpnConnected)),
      ]);

  Widget _changeLocation(BuildContext context) => SafeArea(
        child: Semantics(
          button: true,
          child: InkWell(
            onTap: () {
              Get.to(() => LocationScreen());
            },
            child: Container(
              
                color:Theme.of(context).bottomNav,
                padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
                height: 60,
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.globe,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Change location",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                    )
                  ],
                )),
          ),
        ),
      );
}

//  Center(
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       shape: StadiumBorder(),
//                       backgroundColor: Theme.of(context).primaryColor,
//                     ),
//                     child: Text(
//                       _controller.vpnState.value == VpnEngine.vpnDisconnected
//                           ? 'Connect VPN'
//                           : _controller.vpnState.value.replaceAll("_", " ").toUpperCase(),
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: _connectClick,
//                   ),
//                 ),
//                 StreamBuilder<VpnStatus?>(
//                   initialData: VpnStatus(),
//                   stream: VpnEngine.vpnStatusSnapshot(),
//                   builder: (context, snapshot) => Text(
//                       "${snapshot.data?.byteIn ?? ""}, ${snapshot.data?.byteOut ?? ""}",
//                       textAlign: TextAlign.center),
//                 ),

//                 //sample vpn list
//                 Column(
//                     children: _listVpn
//                         .map(
//                           (e) => ListTile(
//                             title: Text(e.country),
//                             leading: SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: Center(
//                                   child: _selectedVpn == e
//                                       ? CircleAvatar(
//                                           backgroundColor: Colors.green)
//                                       : CircleAvatar(
//                                           backgroundColor: Colors.grey)),
//                             ),
//                             onTap: () {
//                               log("${e.country} is selected");
//                               setState(() => _selectedVpn = e);
//                             },
//                           ),
//                         )
//                         .toList()),
