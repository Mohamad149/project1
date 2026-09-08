import 'package:equatable/equatable.dart';

import '../../../domain/entities/app_user.dart';

abstract class AuthState extends Equatable{
  AuthState();

  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  AuthInitial();
}

class AuthAuthenticated extends AuthState{
  AuthAuthenticated(this.user);

  final AppUser user;

  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState{
  AuthUnauthenticated();
}

class AuthFailure extends AuthState{
  AuthFailure(this.message);

  final String message;

  List<Object?> get props => [message];
}