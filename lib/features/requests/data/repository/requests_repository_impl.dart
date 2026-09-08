import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entity/service_request.dart';
import '../../domain/repository/requests_repository.dart';
import '../datasource/request_remote_data_source.dart';


class RequestsRepositoryImpl implements RequestsRepository{
  RequestsRepositoryImpl(this._remoteDataSource);

   final RequestRemoteDataSource _remoteDataSource;

  Future<void> submitRequest({
    required String title,
    required String description,
    required String category,
  }) async {
    try {
      await _remoteDataSource.submitRequest(
        title: title,
        description: description,
        category: category,
      );
    } on AppException catch (error) {
      throw Failure(error.message);
    } catch (_) {
      throw Failure('Could not submit your request.');
    }
  }

  Stream<List<ServiceRequest>> watchMyRequests(){
    return _remoteDataSource.watchMyRequest().map(
        (model) => model.map((model) => model.toEntity()).toList(),
    );
  }

}