import 'package:cloud_firestore/cloud_firestore.dart';

class RequestsRepository {
  final FirebaseFirestore firestore;

  RequestsRepository({required this.firestore});

  Stream<QuerySnapshot<Map<String ,dynamic>>> watchRequests(){
    return firestore 
        .collection('requests')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }


  Future<void> updateRequestStatus(String id, String status){
    return firestore.collection('requests').doc(id).update({
      'status' : status,
      'updatedAt':FieldValue.serverTimestamp(),
    });
  }
}