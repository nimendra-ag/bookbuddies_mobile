import 'package:crud/pages/bookDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScienceBooks extends StatefulWidget {
  const ScienceBooks({super.key});

  @override
  State<ScienceBooks> createState() => _ScienceBooksState();
}

class _ScienceBooksState extends State<ScienceBooks> {
  Stream? bookStream;
  String searchQuery = ""; // Holds the current search text
  String selectedCategory = "Science"; // Filter category
  String currentUserId = "";

  Future<void> getontheload() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
    }
    bookStream = await DatabaseMethods().getBookDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allBookDetails() {
    return StreamBuilder(
      stream: bookStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(child: Text("No books available"));
        }

        // Filter books based on category and search query
        List<DocumentSnapshot> books = snapshot.data.docs;
        List<DocumentSnapshot> filteredBooks = books.where((doc) {
          String name = doc['Name'].toString().toLowerCase();
          String category = doc['Category'].toString();
          return name.contains(searchQuery.toLowerCase()) &&
              category == selectedCategory &&
              doc['UploadedBy'] != currentUserId;
        }).toList();

        return filteredBooks.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 10.0, // Space between columns
                  mainAxisSpacing: 10.0, // Space between rows
                  childAspectRatio: 0.75, // Adjust card height-to-width ratio
                ),
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = filteredBooks[index];
                  return InkWell(
                    onTap: () {
                      // Navigate to BookDetailsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailsPage(
                            bookData: ds.data() as Map<String, dynamic>,
                          ),
                        ),
                      );
                    },
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.book,
                                color: Colors.blue.shade400,
                                size: 30.0,
                              ),
                            ),
                            Text(
                              "${ds['Name']}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "By ${ds['Author']}",
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            Expanded(
                              child: Text(
                                "${ds['Description']}",
                                style: const TextStyle(fontSize: 16.0),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "${ds['Category']}",
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(child: Text("No matching books found"));
      },
    );
  }

  Widget searchBar() {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchQuery = value; // Update search query
        });
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Search by book name",
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Non-Fiction Books',
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            searchBar(),
            const SizedBox(height: 10.0),
            Expanded(child: allBookDetails()),
          ],
        ),
      ),
    );
  }
}
