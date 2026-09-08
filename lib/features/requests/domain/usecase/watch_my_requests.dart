import '../entity/service_request.dart';
import '../repository/requests_repository.dart';

class WatchMyRequests {
  WatchMyRequests(this._repository);

  final RequestsRepository _repository;

  Stream<List<ServiceRequest>> call (){
    return _repository.watchMyRequests();
  }
}