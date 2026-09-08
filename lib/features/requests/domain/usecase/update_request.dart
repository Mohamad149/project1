import '../repository/requests_repository.dart';

class UpdateRequest {
  UpdateRequest(this._repository);

  final RequestsRepository _repository;

  Future<void> call({
    required String requestId,
    required String title,
    required String description,
    required String category,
  }) {
    return _repository.updateRequest(
      requestId: requestId,
      title: title,
      description: description,
      category: category,
    );
  }
}