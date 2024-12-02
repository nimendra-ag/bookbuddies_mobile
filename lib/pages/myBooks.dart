import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crud/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Mybooks extends StatefulWidget {
  const Mybooks({super.key});

  @override
  State<Mybooks> createState() => _MybooksState();
}

class _MybooksState extends State<Mybooks> {

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

        // Filter the items based on the search query and exclude books uploaded by the current user
        List<DocumentSnapshot> employees = snapshot.data.docs;
        List<DocumentSnapshot> filteredEmployees = employees.where((doc) {
          String name = doc['Name'].toString().toLowerCase();
          return name.contains(searchQuery.toLowerCase()) &&
              doc['UploadedBy'] == currentUserId; // Exclude current user's books
        }).toList();

        return filteredEmployees.isNotEmpty
            ? ListView.builder(
                itemCount: filteredEmployees.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = filteredEmployees[index];
                  return Container(
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
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(Icons.phone, color: Colors.green),
                                const SizedBox(width: 10),
                                Text(
                                  "${ds['Contact Number']}",
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(Icons.location_pin, color: Colors.red),
                                const SizedBox(width: 10),
                                Text(
                                  "${ds['Location']}",
                                  style: const TextStyle(fontSize: 16.0),
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
