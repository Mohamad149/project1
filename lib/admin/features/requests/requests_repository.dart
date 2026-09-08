import 'package:cloud_firestore/cloud_firestore.dart';

class RequestsRepository {
  final FirebaseFirestore firestore;

  RequestsRepository({required this.firestore});

  Stream<QuerySnapshot<Map<String, dynamic>>> watchRequests() {
    return firestore
        .collection('requests')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateRequestStatus(String id, String status) {
    return firestore.collection('requests').doc(id).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateRequestDetails(
      String id, {
        required String title,
        required String description,
        required String category,
      }) {
    return firestore.collection('requests').doc(id).update({
      'title': title.trim(),
      'description': description.trim(),
      'category': category,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteRequest(String id) {
    return firestore.collection('requests').doc(id).delete();
  }
}