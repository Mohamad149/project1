import 'package:equatable/equatable.dart';

abstract class SubmitRequestEvent   extends Equatable{
  SubmitRequestEvent();

  List<Object?> get props => [];
}

class SubmitRequestPressed  extends SubmitRequestEvent{
  SubmitRequestPressed({
    required this.title,
    required this.description,
    required this.category,
});

  final String title;
  final String description;
  final String category;

  List<Object?> get props => [title ,description ,category];
}