import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable{
  ForgotPasswordState();

  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState{
  ForgotPasswordInitial();
}

class ForgotPasswordLoading extends ForgotPasswordState{
  ForgotPasswordLoading();
}

class ForgotPasswordSuccess extends ForgotPasswordState{
  ForgotPasswordSuccess();
}

class ForgotPasswordFailure extends ForgotPasswordState{
  ForgotPasswordFailure(this.message);

  final String message;

  List<Object?> get props => [message];
}