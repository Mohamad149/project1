import 'package:equatable/equatable.dart';

enum RequestStatus{pending , accepted , declined}

class ServiceRequest extends Equatable {
  ServiceRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    this.createdAt,
});

  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String title;
  final String description;
  final String category;
  final RequestStatus status;
  final DateTime? createdAt;


  List<Object?> get props => [
    id,
    userId,
    userName,
    userEmail,
    title,
    description,
    category,
    status,
    createdAt,
  ];
}