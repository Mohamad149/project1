

import '../models/user_model.dart';


abstract class AuthRemoteDataSource {
  Stream<UserModel?> watchAuthState();

  Future<UserModel> signIn({
    required String email,
    required String password,
});

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
});

  Future<void> resetPassword({
    required String email,
});

  Future<void> signOut();
}