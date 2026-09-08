import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/usecase/watch_auth_state.dart';
import '../../../domain/usecase/sign_out.dart';
import 'auth_state.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent , AuthState>{
  AuthBloc({
    required WatchAuthState watchAuthState,
    required SignOut signOut,
}) : _watchAuthState = watchAuthState,
     _signOut = signOut,
     super(AuthInitial()){
    on<AuthStart>(_onStarted);
    on<AuthLogoutRequest>(_onLogout);
  }

  final WatchAuthState _watchAuthState;
  final SignOut _signOut;

  Future<void>_onStarted(
      AuthStart evet ,
      Emitter<AuthState> emit,
      )async{
    await emit.forEach(
    _watchAuthState(),
    onData:(user){
      if(user == null){
        return AuthUnauthenticated();
      }

      return AuthAuthenticated(user);
    },
      onError: (error, stackTrace){
      return AuthFailure(
        'Could not check authentication.',
      );
      },
    );
  }

  Future<void>_onLogout(
      AuthLogoutRequest evet,
      Emitter<AuthState> emit,
      )async{
    try{
      await _signOut();
    }on Failure catch (error){
      emit(
        AuthFailure(error.message),
      );
    }
  }
}