import 'package:equatable/equatable.dart';

abstract class MyRequestsEvent extends Equatable {
  MyRequestsEvent();

  @override
  List<Object?> get props => [];
}

class MyRequestsStarted extends MyRequestsEvent {
  MyRequestsStarted();
}