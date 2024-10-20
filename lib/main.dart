import 'package:flutter/material.dart';
import 'package:printz/screens/login_screen.dart';
import 'package:printz/screens/register_screen.dart';
import 'package:printz/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Printz',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Customize your theme here
      ),
      home: SplashScreen(), // Set SplashScreen as the home screen
      routes: {
        // Define your routes here
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
