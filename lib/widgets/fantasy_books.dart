import 'package:crud/pages/bookDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FantasyBooks extends StatefulWidget {
  const FantasyBooks({super.key});

  @override
  State<FantasyBooks> createState() => _FantasyBooksState();
}

class _FantasyBooksState extends State<FantasyBooks> {
  Stream? bookStream;
  String searchQuery = ""; // Holds the current search text
  String selectedCategory = "Fantasy"; // Filter category
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
                            Text(
                              "${ds['Name']}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Color.fromRGBO(0, 11, 88, 1),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            RichText(
                              text: TextSpan(
                                text: 'By ', // "By" is not italicized
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors
                                      .black, // Ensure proper color is applied
                                ),
                                children: [
                                  TextSpan(
                                    text: ds['Author'], // Author name
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Color.fromRGBO(131, 139, 227, 1),
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold
                                        // Italicized style for the author's name
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Expanded(
                              child: Text(
                                "${ds['Description']}",
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  color: Color.fromRGBO(13, 13, 14, 0.694),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${ds['Category']}",
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(0, 103, 105,
                                        1.0), // Blue color for category
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(254, 216, 106,
                                        1.0), // Background color for the location
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Rounded corners
                                  ),
                                  child: Text(
                                    "${ds['Location']}",
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors
                                          .black, // Text color for visibility
                                    ),
                                  ),
                                ),
                              ],
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
          'Fantasy Books',
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
