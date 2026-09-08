import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> watchAuthState();

  Future<void> signIn({
    required String email,
    required String password,
});

  Future<void> register({
    required String name,
    required String email,
    required String password,
});

  Future<void> resetPassword({
    required String email,
});

  Future<void> signOut();
}