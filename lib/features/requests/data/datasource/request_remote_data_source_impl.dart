import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/exception.dart';
import '../models/request_model.dart';
import 'request_remote_data_source.dart';

class RequestsRemoteDataSourceImpl implements RequestRemoteDataSource {
  RequestsRemoteDataSourceImpl(this._firestore, this._firebaseAuth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('requests');

  @override
  Future<void> submitRequest({
    required String title,
    required String description,
    required String category,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw AppException('You must be logged in to submit a request.');
    }

    try {
      final model = RequestModel(
        id: '',
        userId: user.uid,
        userName: user.displayName ?? '',
        userEmail: user.email ?? '',
        title: title.trim(),
        description: description.trim(),
        category: category,
        status: 'pending',
      );

      await _collection.add(model.toFirestore());
    } catch (_) {
      throw AppException('Could not submit your request.');
    }
  }

  @override
  Stream<List<RequestModel>> watchMyRequest() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return Stream.value(const []);
    }

    return _collection
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RequestModel.fromFirestore(doc))
          .toList();
    });
  }
}