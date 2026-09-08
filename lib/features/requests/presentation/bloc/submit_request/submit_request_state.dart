import 'package:equatable/equatable.dart';

abstract class SubmitRequestState extends Equatable{
  SubmitRequestState();

  List<Object?> get props => [];

}

class SubmitRequestInitial extends SubmitRequestState{
  SubmitRequestInitial();
}

class SubmitRequestLoading extends SubmitRequestState{
  SubmitRequestLoading();
}

class SubmitRequestSuccess extends SubmitRequestState{
  SubmitRequestSuccess();
}

class SubmitRequestFailure extends SubmitRequestState{
  SubmitRequestFailure(this.message);

  final String message;

  List<Object?> get props => [message];
}