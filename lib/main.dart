import 'package:crud/Screens/IntroScreens.dart';
import 'package:crud/pages/home.dart';
import 'package:crud/pages/login.dart';
import 'package:crud/pages/signup.dart';
import 'package:crud/widgets/navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Introscreens(),
        '/signUp': (context) => SignupPage(),
        '/home': (context) => MainNavigationBar(),
      },
    );
  }
}


