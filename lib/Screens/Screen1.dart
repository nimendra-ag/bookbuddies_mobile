import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/Reading book-bro.png'),
        const SizedBox(height: 40),
        const Text("Discover Endless Stories", style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.w400
        ),),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Text("Explore a vast collection of books shared by a community of readers just like you", style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w300
          ),
          textAlign: TextAlign.center,
          ),     
        )
      ],
    );
  }
}