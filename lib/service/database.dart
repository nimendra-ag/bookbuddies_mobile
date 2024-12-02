import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addBookDetails(Map<String, dynamic> bookInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Book")
        .doc(id)
        .set(bookInfoMap);
  }

  Future<Stream<QuerySnapshot>> getBookDetails() async {
    return await FirebaseFirestore.instance.collection("Book").snapshots();
  }

  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(id)
        .set(userInfoMap);
  }
  
  Future addReportDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Report")
        .doc(id)
        .set(userInfoMap);
  }
}
