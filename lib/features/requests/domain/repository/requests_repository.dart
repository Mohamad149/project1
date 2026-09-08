import '../entity/service_request.dart';

abstract class RequestsRepository {
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

  Stream<List<ServiceRequest>> watchMyRequests();
}