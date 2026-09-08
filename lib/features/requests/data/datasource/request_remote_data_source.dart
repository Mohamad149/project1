import '../models/request_model.dart';

abstract class RequestsRemoteDataSource {
  Future<void> submitRequest({
    required String title,
    required String description,
    required String category,
  });

  Future<void> updateRequest({
    required String requestId,
    required String title,
    required String description,
    required String category,
  });

  Future<void> deleteRequest(String requestId);

  Stream<List<RequestModel>> watchMyRequests();
}