import '../models/request_model.dart';

abstract class RequestRemoteDataSource {
  Future<void> submitRequest({
    required String title,
    required String description,
    required String category,
});

  Stream<List<RequestModel>> watchMyRequest();
}