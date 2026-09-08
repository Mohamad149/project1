import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  AppUser toEntity() => AppUser(
    id: id,
    name: name,
    email: email,
  );

  Map<String, dynamic> toFirestore() {
    return {
      'uid': id,
      'email': email,
      'name': name,
    };
  }
}