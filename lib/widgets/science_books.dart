import 'package:flutter/material.dart';

class ScienceBooks extends StatefulWidget {
  const ScienceBooks({super.key});

  @override
  State<ScienceBooks> createState() => _ScienceBooksState();
}

class _ScienceBooksState extends State<ScienceBooks> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Science Page"));
  }
}