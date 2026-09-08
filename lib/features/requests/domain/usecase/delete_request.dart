import '../repository/requests_repository.dart';

class DeleteRequest {
  DeleteRequest(this._repository);

  final RequestsRepository _repository;

  Future<void> call(String requestId) {
    return _repository.deleteRequest(requestId);
  }
}