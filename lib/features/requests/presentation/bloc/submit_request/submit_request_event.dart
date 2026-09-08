import 'package:equatable/equatable.dart';

abstract class SubmitRequestEvent extends Equatable {
  SubmitRequestEvent();

  @override
  List<Object?> get props => [];
}

class SubmitRequestPressed extends SubmitRequestEvent {
  SubmitRequestPressed({
    required this.title,
    required this.description,
    required this.category,
  });

  final String title;
  final String description;
  final String category;

  @override
  List<Object?> get props => [title, description, category];
}

class UpdateRequestPressed extends SubmitRequestEvent {
  UpdateRequestPressed({
    required this.requestId,
    required this.title,
    required this.description,
    required this.category,
  });

  final String requestId;
  final String title;
  final String description;
  final String category;

  @override
  List<Object?> get props => [requestId, title, description, category];
}