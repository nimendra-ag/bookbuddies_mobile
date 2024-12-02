import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  final Map<String, dynamic> bookData;

  const BookDetailsPage({super.key, required this.bookData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(254, 216, 106, 1),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Title
              Text(
                bookData['Name'],
                style: const TextStyle(
                  fontSize: 28.0,
                  color: Color.fromRGBO(0, 11, 88, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),

              // Author Name
              Text(
                "By ${bookData['Author']}",
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromRGBO(131, 139, 227, 1),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16.0),

              // Description
              Container(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  bookData['Description'],
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Color.fromRGBO(0, 11, 88, 1),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 16.0),

              // Category
              Text(
                "Category: ${bookData['Category']}",
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Color.fromRGBO(131, 139, 227, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),

              // Contact Information
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.green, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    "${bookData['Contact Number']}",
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Color.fromRGBO(0, 11, 88, 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Location
              Row(
                children: [
                  const Icon(Icons.location_pin, color: Colors.red, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    "${bookData['Location']}",
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Color.fromRGBO(0, 11, 88, 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
