import 'package:cloud_firestore/cloud_firestore.dart';

class UsersRepository {
  final FirebaseFirestore firestore;

  UsersRepository({required this.firestore});

  Stream<QuerySnapshot<Map<String, dynamic>>> watchUsers() {
    return firestore.collection('users').snapshots();
  }

  Future<void> updateUserRole(String uid, String role) {
    return firestore.collection('users').doc(uid).update({
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
