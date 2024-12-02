import 'package:crud/widgets/biography_books.dart';
import 'package:crud/widgets/fantasy_books.dart';
import 'package:crud/widgets/fiction_books.dart';
import 'package:crud/widgets/history_books.dart';
import 'package:crud/widgets/mystery_books.dart';
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
  BiographyBooks biographyBooks = BiographyBooks();
  FantasyBooks fantasyBooks = FantasyBooks();
  HistoryBooks historyBooks = HistoryBooks();
  MysteryBooks mysteryBooks = MysteryBooks();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(254, 216, 106, 1), // Updated app bar color
            ),
          ),
          title: const Text(
            'Book Buddies',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Fiction",
                icon: Icon(Icons.book_outlined),
              ),
              Tab(
                text: "Non-Fiction",
                icon: Icon(Icons.library_books_outlined),
              ),
              Tab(
                text: "Science",
                icon: Icon(Icons.science_outlined),
              ),
              Tab(
                text: "Biography",
                icon: Icon(Icons.person_2_outlined),
              ),
              Tab(
                text: "Fantasy",
                icon: Icon(Icons.star_outlined),
              ),
              Tab(
                text: "History",
                icon: Icon(Icons.timeline_outlined),
              ),
              Tab(
                text: "Mystery",
                icon: Icon(Icons.lock_outlined),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          fictionBooks,
          nonFictionBooks,
          scienceBooks,
          biographyBooks,
          fantasyBooks,
          historyBooks,
          mysteryBooks
        ]),
      ),
    );
  }
}
