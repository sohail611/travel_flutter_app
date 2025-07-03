import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isPrecached = false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isPrecached) {
      precacheImage(
          const AssetImage('assets/images/george-desipris-WpLm6hix8i8-unsplash.png'),
          context);
      precacheImage(
          const AssetImage('assets/images/road-ahead-SwFvRMFRHJY-unsplash.png'),
          context);
      precacheImage(const AssetImage('assets/images/simon-harvey-simhxrvey-6Jkru6FSX90-unsplash1.png'),
          context);
      _isPrecached = true;
    }
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/george-desipris-WpLm6hix8i8-unsplash.png",
      "title": "Discover New Places",
      "subtitle": "Explore the world’s best destinations with us."
    },
    {
      "image": "assets/images/road-ahead-SwFvRMFRHJY-unsplash.png",
      "title": "Plan Your Trips",
      "subtitle": "Book flights, hotels, and tours with ease."
    },
    {
      "image": "assets/images/simon-harvey-simhxrvey-6Jkru6FSX90-unsplash1.png",
      "title": "Enjoy the Journey",
      "subtitle": "Travel safely, smoothly, and stress-free."
    },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(250),


                            child: Image.asset(onboardingData[index]["image"]!,
                              fit: BoxFit.fill,
                            ),

                        ),

                      ),

                      const SizedBox(height: 25),
                      Text(
                        onboardingData[index]["title"]!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        onboardingData[index]["subtitle"]!,
                        style: TextStyle(fontSize: 19, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
                height: 10,
                width: _currentPage == index ? 20 : 10,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == onboardingData.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );

                } else {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _currentPage == onboardingData.length - 1 ? "Get Started" : "Next",
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
