import '../entity/service_request.dart';

abstract class RequestsRepository {
  Future<void> submitRequest({
    required String title,
    required String description,
    required String category,
});

  Stream<List<ServiceRequest>> watchMyRequests();
}