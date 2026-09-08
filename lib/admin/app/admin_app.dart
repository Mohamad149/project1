import 'package:flutter/material.dart';

import '../features/auth/admin_login_page.dart';
import '../features/auth/admin_session.dart';
import '../features/auth/admin_splash_page.dart';
import '../features/users/users_page.dart';
import '../features/users/users_repository.dart';
import 'admin_theme.dart';

class AdminApp extends StatelessWidget {
  final AdminSession session;
  final UsersRepository usersRepository;

  const AdminApp({
    super.key,
    required this.session,
    required this.usersRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.themeData,
      home: AnimatedBuilder(
        animation: session,
        builder: (context, _) {
          if (!session.initialized) {
            return const AdminSplashPage();
          }

          if (!session.isAdmin) {
            return AdminLoginPage(session: session);
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Admin Panel'),
              actions: [
                IconButton(
                  onPressed: session.signOut,
                  icon: const Icon(Icons.logout),
                  tooltip: 'Sign out',
                ),
              ],
            ),
            body: UsersPage(
              repository: usersRepository,
              currentAdminUid: session.user?.uid ?? '',
            ),
          );
        },
      ),
    );
  }
}