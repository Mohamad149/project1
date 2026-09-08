import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entity/service_request.dart';
import '../../domain/repository/requests_repository.dart';
import '../datasource/request_remote_data_source.dart';

class RequestsRepositoryImpl implements RequestsRepository {
  RequestsRepositoryImpl(this._remoteDataSource);

  final RequestsRemoteDataSource _remoteDataSource;

  @override
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

  @override
  Future<void> updateRequest({
    required String requestId,
    required String title,
    required String description,
    required String category,
  }) async {
    try {
      await _remoteDataSource.updateRequest(
        requestId: requestId,
        title: title,
        description: description,
        category: category,
      );
    } on AppException catch (error) {
      throw Failure(error.message);
    } catch (_) {
      throw Failure('Could not update your request.');
    }
  }

  @override
  Future<void> deleteRequest(String requestId) async {
    try {
      await _remoteDataSource.deleteRequest(requestId);
    } on AppException catch (error) {
      throw Failure(error.message);
    } catch (_) {
      throw Failure('Could not delete your request.');
    }
  }

  @override
  Stream<List<ServiceRequest>> watchMyRequests() {
    return _remoteDataSource.watchMyRequests().map(
          (models) => models.map((model) => model.toEntity()).toList(),
    );
  }
}