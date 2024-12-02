import 'package:crud/service/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String? selectedType; // Selected type for the dropdown

  final List<String> reportTypes = [
    "Fraud",
    "Theft",
    "Harassment",
    "Vandalism",
    "Assault",
    "Other",
  ]; // Predefined list of report types

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(254, 216, 106, 1), // Updated app bar color
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Submit a Report',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Container(
          color: Color.fromRGBO(246, 246, 246, 1), // Updated background color
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField(
                label: "Title",
                icon: Icons.title,
                controller: titleController,
                hintText: "Enter the title of the report",
              ),
              const SizedBox(height: 20),
              buildTextField(
                label: "Details",
                icon: Icons.description,
                controller: detailsController,
                hintText: "Enter detailed information about the incident",
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              buildDropdownField(
                label: "Type of Incident",
                icon: Icons.category,
                items: reportTypes,
                value: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              buildTextField(
                label: "Contact Number",
                icon: Icons.phone,
                controller: contactNumberController,
                hintText: "Enter your contact number",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              buildTextField(
                label: "Location",
                icon: Icons.location_on,
                controller: locationController,
                hintText: "Enter the location of the incident",
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedType == null) {
                      Fluttertoast.showToast(
                        msg: "Please select the type of incident",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Color.fromRGBO(254, 216, 106, 1),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    String userId = FirebaseAuth.instance.currentUser!.uid; // Get current user ID
                    String id = randomAlphaNumeric(10);

                    Map<String, dynamic> reportInfoMap = {
                      "Title": titleController.text,
                      "Details": detailsController.text,
                      "Type": selectedType,
                      "Contact Number": contactNumberController.text,
                      "Location": locationController.text,
                      "ReportedBy": userId, // Add the current user's ID
                      "Timestamp": DateTime.now().toIso8601String(), // Optional: Add timestamp
                    };

                    titleController.clear();
                    detailsController.clear();
                    contactNumberController.clear();
                    locationController.clear();
                    setState(() {
                      selectedType = null;
                    });

                    await DatabaseMethods()
                        .addReportDetails(reportInfoMap, id)
                        .then((value) {
                      Fluttertoast.showToast(
                        msg: "Book data added successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    });

                    Fluttertoast.showToast(
                      msg: "Report submitted successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5, // Transparent background for gradient
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Set the background as transparent
                    shadowColor: MaterialStateProperty.all<Color>(Colors.transparent), // Optional: Remove shadow
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(254, 216, 106, 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 50.0,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Text color
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1),
            color: Colors.grey[200],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey),
              hintText: hintText,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDropdownField({
    required String label,
    required IconData icon,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1),
            color: Colors.grey[200],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: const Text("Select a type"),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              isExpanded: true,
              items: items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
