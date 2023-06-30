import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/helpers/ads_helper.dart';
import 'package:vpn_basic_project/helpers/config.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';


late  Size mq; 

void main() async{
 WidgetsFlutterBinding.ensureInitialized(); 
 

 // enter -full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await Firebase.initializeApp();
  await Config.initConfig();

  await Pref.initializeHive();

  await AdsHelper.initAds();
  
  
  // for setting orientation to portrait only 
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown, ])
  .then((value) {
runApp(const MyApp());
  });

  // hive 
 
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'OpenVpn Demo',
      // theme
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true, 
          elevation: 3, 
        )
      ),

      themeMode: Pref.isDarkMode? ThemeMode.dark : ThemeMode.light,

      // theme
      darkTheme: ThemeData(
        brightness: Brightness.dark, 
        appBarTheme: AppBarTheme(
          centerTitle: true, 
          elevation: 3, 
        )
      ),


      home: SplashScreen(),

      
     
    );
  }
}


extension AppTheme on ThemeData{
  Color get lighText => Pref.isDarkMode ? Colors.white70 : Colors.black54;
   Color get bottomNav => Pref.isDarkMode ? Colors.white12 : Colors.blue;
}