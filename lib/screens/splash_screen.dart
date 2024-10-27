import 'package:flutter/material.dart';
import 'package:printz/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key}); // Added const and Key parameter

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3)); // Set the delay for 3 seconds
    
    if (mounted) { // Check if the widget is still in the tree
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(), // Navigate to the LoginScreen widget
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color for the splash screen
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
                    fontSize: 36, // Font size of the period should match the text
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
