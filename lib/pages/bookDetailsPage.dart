import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  final Map<String, dynamic> bookData;

  const BookDetailsPage({super.key, required this.bookData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bookData['Name'],
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text("By ${bookData['Author']}"),
            const SizedBox(height: 8.0),
            Text(bookData['Description']),
            const SizedBox(height: 8.0),
            Text("Category: ${bookData['Category']}"),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.green),
                const SizedBox(width: 10),
                Text("${bookData['Contact Number']}"),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.location_pin, color: Colors.red),
                const SizedBox(width: 10),
                Text("${bookData['Location']}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
