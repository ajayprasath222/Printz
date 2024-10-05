import 'package:flutter/material.dart';
import 'package:printz/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
_SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
        const Duration(seconds: 3), () {}); // Set the delay for 3 seconds
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen()), // Navigate to the HomePage widget
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Optional: Set background color for the splash screen
      body: SafeArea(
        child: Center(
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Printz', // Black text for "Printz"
                  style: TextStyle(
                    fontSize: 36, // Font size of the text
                    fontWeight: FontWeight.bold, // Make the text bold
                    color: Colors.black, // Text color
                  ),
                ),
                TextSpan(
                  text: '.', // Orange period
                  style: TextStyle(
                    fontSize:
                        36, // Font size of the period should match the text
                    fontWeight: FontWeight.bold,
                    color: Colors.orange, // Orange color for the period
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}