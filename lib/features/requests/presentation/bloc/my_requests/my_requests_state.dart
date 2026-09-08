import 'package:equatable/equatable.dart';

import '../../../domain/entity/service_request.dart';

abstract class MyRequestsState extends Equatable {
  MyRequestsState();

  @override
  List<Object?> get props => [];
}

class MyRequestsLoading extends MyRequestsState {
  MyRequestsLoading();
}

class MyRequestsLoaded extends MyRequestsState {
  MyRequestsLoaded(this.requests);

  final List<ServiceRequest> requests;

  @override
  List<Object?> get props => [requests];
}

class MyRequestsFailure extends MyRequestsState {
  MyRequestsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}