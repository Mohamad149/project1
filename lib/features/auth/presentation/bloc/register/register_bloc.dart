import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/usecase/register_user.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required RegisterUser registerUser,
  })  : _registerUser = registerUser,
        super(RegisterInitial()) {
    on<RegisterSubmitted>(_onSubmitted);
  }

  final RegisterUser _registerUser;

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    try {
      await _registerUser(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(RegisterSuccess());
    } on Failure catch (error) {
      emit(RegisterFailure(error.message));
    } catch (_) {
      emit(RegisterFailure('Could not create your account.'));
    }
  }
}
