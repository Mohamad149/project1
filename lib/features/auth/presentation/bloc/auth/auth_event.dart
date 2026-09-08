import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable{
  AuthEvent();

  List<Object?> get props => [];
}


class AuthStart extends AuthEvent{
  AuthStart();
}

class AuthLogoutRequest extends AuthEvent{
  AuthLogoutRequest();
}