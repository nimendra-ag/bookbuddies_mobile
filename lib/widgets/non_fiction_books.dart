import 'package:crud/pages/addBook.dart';
import 'package:crud/pages/bookDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NonFictionBooks extends StatefulWidget {
  const NonFictionBooks({super.key});

  @override
  State<NonFictionBooks> createState() => _NonFictionBooksState();
}

class _NonFictionBooksState extends State<NonFictionBooks> {
  Stream? BookStream;
  String searchQuery = ""; // Holds the current search text
  String selectedCategory = "Non-fiction"; // Variable for the category
  String currentUserId = "";


  getontheload() async {

      User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
    }
    BookStream = await DatabaseMethods().getBookDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allBookDetails() {
  return StreamBuilder(
    stream: BookStream,
    builder: (context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
        return const Center(child: Text("No books available"));
      }

      // Filter books
      List<DocumentSnapshot> employees = snapshot.data.docs;
      List<DocumentSnapshot> filteredEmployees = employees.where((doc) {
        String name = doc['Name'].toString().toLowerCase();
        return name.contains(searchQuery.toLowerCase()) &&
            doc['UploadedBy'] != currentUserId;
      }).toList();

      return filteredEmployees.isNotEmpty
          ? ListView.builder(
              itemCount: filteredEmployees.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = filteredEmployees[index];
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
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
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
                            Stack(
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
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "By ${ds['Author']}",
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "${ds['Description']}",
                              style: const TextStyle(fontSize: 16.0),
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
