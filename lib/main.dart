import 'package:flutter/material.dart';
import 'package:printz/screens/login_screen.dart';
import 'package:printz/screens/register_screen.dart';
import 'package:printz/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Printz',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Customize your theme here
      ),
      home: const SplashScreen(), // Set SplashScreen as the home screen
      routes: {
        // Define your routes here
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
