import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/pages/addBook.dart';
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
    // Get the current user ID from FirebaseAuth
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
      // Navigate to the login page after signing out
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

Widget allEmployeeDetails() {
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
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 10.0, // Space between columns
                mainAxisSpacing: 10.0, // Space between rows
                childAspectRatio: 0.75, // Adjust card height-to-width ratio
              ),
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
        hintText: "Search by book",
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
            searchBar(),
            const SizedBox(height: 10.0),
            Expanded(child: allEmployeeDetails()),
          ],
        ),
      ),
    );
  }
}



// Platform  Firebase App Id
// android   1:668028575415:android:10f252bf052fdad54cf732
// ios       1:668028575415:ios:37d9d603745c35cb4cf732
