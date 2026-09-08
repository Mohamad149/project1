import '../repository/requests_repository.dart';

class SubmitRequest {
  SubmitRequest(this._repository);

  final RequestsRepository _repository;


  Future<void> call({
    required String title,
    required String description,
    required String category,
}){
    return _repository.submitRequest(
        title: title,
        description: description,
        category: category,
    );
  }

}