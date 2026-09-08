import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'admin/app/admin_app.dart';
import 'admin/features/auth/admin_session.dart';
import 'admin/features/users/users_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final session = AdminSession(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );

  final usersRepository = UsersRepository(
    firestore: FirebaseFirestore.instance,
  );

  runApp(
    AdminApp(
      session: session,
      usersRepository: usersRepository,
    ),
  );

  session.initialize();
}
