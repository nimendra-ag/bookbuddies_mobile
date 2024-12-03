import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/pages/bookDetailsPage.dart';
import 'package:crud/pages/login.dart';
import 'package:crud/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? BookStream;
  String searchQuery = "";
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

  // Function to sign out
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      // Handle sign-out error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign Out Failed: ${e.toString()}")),
      );
    }
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
        List<DocumentSnapshot> books = snapshot.data.docs;
        List<DocumentSnapshot> filteredBooks = books.where((doc) {
          String name = doc['Name'].toString().toLowerCase();
          return name.contains(searchQuery.toLowerCase()) &&
              doc['UploadedBy'] != currentUserId;
        }).toList();

        return filteredBooks.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 10.0, 
                  mainAxisSpacing: 10.0, 
                  childAspectRatio: 0.75, 
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
                                      .black, 
                                ),
                                children: [
                                  TextSpan(
                                    text: ds['Author'], 
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Color.fromRGBO(131, 139, 227, 1),
                                      fontStyle: FontStyle
                                          .italic, fontWeight: FontWeight.bold
                                          
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Expanded(
                              child: Text(
                                "${ds['Description']}",
                                style: const TextStyle(fontSize: 13.0, color: Color.fromRGBO(13, 13, 14, 0.694),),
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
                                        1.0), 
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(254, 216, 106,
                                        1.0), 
                                    borderRadius: BorderRadius.circular(
                                        12.0), 
                                  ),
                                  child: Text(
                                    "${ds['Location']}",
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors
                                          .black, 
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
        fillColor: const Color.fromRGBO(242, 242, 242, 1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut, // Sign out when this button is pressed
            tooltip: "Sign Out",
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            searchBar(),
            const SizedBox(height: 20.0),
            Expanded(child: allBookDetails()),
          ],
        ),
      ),
    );
  }
}



// Platform  Firebase App Id
// android   1:668028575415:android:10f252bf052fdad54cf732
// ios       1:668028575415:ios:37d9d603745c35cb4cf732
