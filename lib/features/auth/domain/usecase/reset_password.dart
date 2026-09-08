import '../repositories/auth_repository.dart';

class ResetPassword {
  ResetPassword(this._repository);

  final AuthRepository  _repository;

  Future<void> call({
    required String email,
}) {
    return _repository.resetPassword(
        email: email,
    );
  }
}