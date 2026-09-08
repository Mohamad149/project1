import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AppUser?> watchAuthState() {
    return _remoteDataSource.watchAuthState().map(
          (model) => model?.toEntity(),
        );
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
    } on AppException catch (error) {
      throw Failure(error.message);
    } catch (_) {
      throw Failure('Could not sign in.');
    }
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
    } on AppException catch (error) {
      throw Failure(error.message);
    } catch (_) {
      throw Failure('Could not create your account.');
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _remoteDataSource.resetPassword(email: email);
    } on AppException catch (error) {
      throw Failure(error.message);
    } catch (_) {
      throw Failure('Could not send reset email.');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } on AppException catch (error) {
      throw Failure(error.message);
    } catch (_) {
      throw Failure('Could not sign out.');
    }
  }
}
