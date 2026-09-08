import 'package:equatable/equatable.dart';


abstract class RegisterState extends Equatable{
  RegisterState();

  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState{
  RegisterInitial();
}

class RegisterLoading extends RegisterState{
  RegisterLoading();
}

class RegisterSuccess extends RegisterState{
  RegisterSuccess();
}

class RegisterFailure extends RegisterState{
  RegisterFailure(this.message);

  final String message;

  List<Object?> get props => [message];
}