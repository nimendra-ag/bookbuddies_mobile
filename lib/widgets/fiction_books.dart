import 'package:flutter/material.dart';

class FictionBooks extends StatefulWidget {
  const FictionBooks({super.key});

  @override
  State<FictionBooks> createState() => _FictionBooksState();
}

class _FictionBooksState extends State<FictionBooks> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Fiction Page"));
  }
}