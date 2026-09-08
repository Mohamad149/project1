import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecase/register_user.dart';
import '../features/auth/domain/usecase/reset_password.dart';
import '../features/auth/domain/usecase/sign_in.dart';
import '../features/auth/domain/usecase/sign_out.dart';
import '../features/auth/domain/usecase/watch_auth_state.dart';
import '../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../features/auth/presentation/bloc/forget_password/forgot_password_bloc.dart';
import '../features/auth/presentation/bloc/login/login_bloc.dart';
import '../features/auth/presentation/bloc/register/register_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  if (sl.isRegistered<FirebaseAuth>()) {
    return;
  }

  // Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Data source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<FirebaseAuth>()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton<SignIn>(() => SignIn(sl<AuthRepository>()));
  sl.registerLazySingleton<RegisterUser>(
    () => RegisterUser(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ResetPassword>(
    () => ResetPassword(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignOut>(() => SignOut(sl<AuthRepository>()));
  sl.registerLazySingleton<WatchAuthState>(
    () => WatchAuthState(sl<AuthRepository>()),
  );

  // Blocs
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(signIn: sl<SignIn>()),
  );
  sl.registerFactory<RegisterBloc>(
    () => RegisterBloc(registerUser: sl<RegisterUser>()),
  );
  sl.registerFactory<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(resetPassword: sl<ResetPassword>()),
  );
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      watchAuthState: sl<WatchAuthState>(),
      signOut: sl<SignOut>(),
    ),
  );
}
