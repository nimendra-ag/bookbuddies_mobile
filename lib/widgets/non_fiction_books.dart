import 'package:flutter/material.dart';

class NonFictionBooks extends StatefulWidget {
  const NonFictionBooks({super.key});

  @override
  State<NonFictionBooks> createState() => _NonFictionBooksState();
}

class _NonFictionBooksState extends State<NonFictionBooks> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Non-Fiction Page"));
  }
}