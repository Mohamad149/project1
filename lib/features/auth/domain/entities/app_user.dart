import 'package:equatable/equatable.dart';

class AppUser extends Equatable{
  AppUser({
    required this.id,
    required this.name,
    required this.email
});

  final String id;
  final String name;
  final String email;


  List<Object?> get props => [id, name, email];

}