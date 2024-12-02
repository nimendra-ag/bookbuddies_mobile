import 'package:crud/Screens/IntroScreens.dart';
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
        '/intro': (context) => const Introscreens(),
        '/signUp': (context) => const SignupPage(),
        '/home': (context) => const MainNavigationBar(),
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
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Introscreens()),
      );
    });
  }

@override
Widget build(BuildContext context) {
  return const Scaffold(
    backgroundColor: Colors.yellow,
    body: Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BOOK',
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
        Positioned(
          bottom: 50, // Adjust the distance from the bottom
          left: 0,
          right: 0,
          child: Text(
            "Let's Read Together...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    ),
  );
}



}
