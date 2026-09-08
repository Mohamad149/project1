import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/usecase/reset_password.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({required ResetPassword resetPassword})
      : _resetPassword = resetPassword,
        super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  final ResetPassword _resetPassword;

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());

    try {
      await _resetPassword(email: event.email);
      emit(ForgotPasswordSuccess());
    } on Failure catch (error) {
      emit(ForgotPasswordFailure(error.message));
    } catch (_) {
      emit(ForgotPasswordFailure('Could not send reset email.'));
    }
  }
}
