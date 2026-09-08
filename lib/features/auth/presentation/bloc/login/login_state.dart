import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable{
  LoginState();

  List<Object?> get props => [];
}

class LoginInitial extends LoginState{
  LoginInitial();
}

class LoginLoading extends LoginState{
  LoginLoading();
}

class LoginSuccess extends LoginState{
  LoginSuccess();
}

class LoginFailure extends LoginState{
  LoginFailure(this.message);

  final String message;

  List<Object?> get props => [message];
}