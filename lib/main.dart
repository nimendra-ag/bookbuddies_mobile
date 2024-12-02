import 'package:crud/Screens/IntroScreens.dart';
import 'package:crud/pages/home.dart';
import 'package:crud/pages/signup.dart';
import 'package:crud/widgets/navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/intro': (context) => Introscreens(),
        '/signUp': (context) => SignupPage(),
        '/home': (context) => MainNavigationBar(),
      },
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to Introscreens() after 3 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Introscreens()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Book',
              style: TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              'Buddies',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
