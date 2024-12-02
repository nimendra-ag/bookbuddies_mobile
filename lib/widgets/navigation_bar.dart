import 'package:crud/pages/Categories.dart';
import 'package:crud/pages/addBook.dart';
import 'package:crud/pages/home.dart';
import 'package:crud/pages/myBooks.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({super.key});

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  final _navigationItems = [
    const CurvedNavigationBarItem(
      child: Icon(Icons.book_outlined),
      label: 'Books',
    ),
    const CurvedNavigationBarItem(
      child: Icon(Icons.category_outlined),
      label: 'Categories',
    ),
    const CurvedNavigationBarItem(
      child: Icon(Icons.add_outlined),
      label: 'Add',
    ),
    const CurvedNavigationBarItem(
      child: Icon(Icons.report_outlined),
      label: 'Report',
    ),
    const CurvedNavigationBarItem(
      child: Icon(Icons.my_library_books_outlined),
      label: 'My Books',
    ),
  ];

  final screens = const [
    Home(),
    Categories(),
    Book(),
    Home(),
    Mybooks()
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromRGBO(246, 246, 246, 1), // Updated color
        items: _navigationItems,
        height: 75,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
      ),
    );
  }
}
