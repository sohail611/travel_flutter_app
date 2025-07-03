import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => OnboardingScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFF0E46B6), // Change to your Figma background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/original-c9de8d5dcb218367bd6af5352d4afbed.webp', // Replace with your logo asset
              height: 170,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.blueAccent), // Optional
          ],
        ),
      ),
    );
  }
}
