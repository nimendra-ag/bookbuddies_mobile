import 'package:crud/widgets/fiction_books.dart';
import 'package:crud/widgets/non_fiction_books.dart';
import 'package:crud/widgets/science_books.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  FictionBooks fictionBooks = FictionBooks();
  NonFictionBooks nonFictionBooks = NonFictionBooks();
  ScienceBooks scienceBooks = ScienceBooks();
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("TabBar"),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Fiction",
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                text: "Non-Fiction",
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                text: "Science",
                icon: Icon(Icons.cloud_outlined),
              ),
            ],
            ),
        ),
        body: TabBarView(
          children: [
            fictionBooks,
            nonFictionBooks,
            scienceBooks
          ]),
      ),
    );
  }
}