import 'package:flutter/material.dart';
import 'dart:async'; // Import for Future
import 'home.dart'; // Import your home page

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to home page after 3 seconds
     Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Time+Watch')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
           children:[
            Icon(
              Icons.watch, // You can change this to any icon
              size: 80, // Size of the icon
              color: Colors.deepPurple, // Color of the icon
            ), // Replace with your logo
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('TimeWatch with Flutter - by Arafat with ❤️'),
          ],
        ),
      ),
    );
  }
}