import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable{
  LoginEvent();

  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent{
  LoginSubmitted({
    required this.email,
    required this.password,
});

  final String email;
  final String password;

  List<Object?> get props => [email,password];
}