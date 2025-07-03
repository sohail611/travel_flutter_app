import 'package:flutter/material.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/favorites_provider.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/splash_screen_ifLogin.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox("mybox");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Foreground message received: ${message.notification?.title}');
  });
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug, // Use debug for development only!
    appleProvider: AppleProvider.debug,
  );

    runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {


  ThemeData appTheme = ThemeData(
    primaryColor: const Color(0xFFccd5ff),
    fontFamily: 'SF UI Display',
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 14),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider()..loadFavorites(), // auto-load on startup
      child: MaterialApp(
      title: 'Travel App',
      theme: appTheme,
      home:  SplashScreen(),
      debugShowCheckedModeBanner: false,
    ),
    );
  }
}

class Wrapper extends StatefulWidget {
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late SharedPreferences pref;
  bool? isLoggedIn = false;

  @override
  void initState() {
    initPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn == true ? SplashScreenIflogin() : SplashScreen();
  }

  void initPreferences() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = pref.getBool("isLogin");
    });
  }
}