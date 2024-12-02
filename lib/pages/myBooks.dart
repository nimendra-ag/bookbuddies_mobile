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

  Future<void> deleteBook(String bookId) async {
    try {
      await FirebaseFirestore.instance.collection('Book').doc(bookId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete book: ${e.toString()}")),
      );
    }
  }

  Future<void> updateBook(String bookId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection('Book')
          .doc(bookId)
          .update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update book: ${e.toString()}")),
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

        // Filter the items based on the search query and exclude books not uploaded by the current user
        List<DocumentSnapshot> employees = snapshot.data.docs;
        List<DocumentSnapshot> filteredEmployees = employees.where((doc) {
          String name = doc['Name'].toString().toLowerCase();
          return name.contains(searchQuery.toLowerCase()) &&
              doc['UploadedBy'] == currentUserId; // Show only current user's books
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
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          // Open a dialog to edit the book
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              TextEditingController nameController =
                                                  TextEditingController(text: ds['Name']);
                                              TextEditingController authorController =
                                                  TextEditingController(text: ds['Author']);
                                              TextEditingController descriptionController =
                                                  TextEditingController(text: ds['Description']);
                                              TextEditingController categoryController =
                                                  TextEditingController(text: ds['Category']);

                                              return AlertDialog(
                                                title: const Text("Update Book"),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller: nameController,
                                                      decoration: const InputDecoration(
                                                          labelText: "Name"),
                                                    ),
                                                    TextField(
                                                      controller: authorController,
                                                      decoration: const InputDecoration(
                                                          labelText: "Author"),
                                                    ),
                                                    TextField(
                                                      controller: descriptionController,
                                                      decoration: const InputDecoration(
                                                          labelText: "Description"),
                                                    ),
                                                    TextField(
                                                      controller: categoryController,
                                                      decoration: const InputDecoration(
                                                          labelText: "Category"),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Cancel"),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      updateBook(ds.id, {
                                                        "Name": nameController.text,
                                                        "Author": authorController.text,
                                                        "Description": descriptionController.text,
                                                        "Category": categoryController.text,
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Update"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          deleteBook(ds.id);
                                        },
                                      ),
                                    ],
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
          'My Books',
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
