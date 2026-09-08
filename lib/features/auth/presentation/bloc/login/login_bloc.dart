import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/usecase/sign_in.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required SignIn signIn})
      : _signIn = signIn,
        super(LoginInitial()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  final SignIn _signIn;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      await _signIn(
        email: event.email,
        password: event.password,
      );
      emit(LoginSuccess());
    } on Failure catch (error) {
      emit(LoginFailure(error.message));
    } catch (_) {
      emit(LoginFailure('Could not sign in.'));
    }
  }
}
