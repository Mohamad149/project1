import 'package:flutter/material.dart';

import '../../app/admin_theme.dart';

class AdminSplashPage extends StatelessWidget {
  const AdminSplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor: AdminTheme.purple,
              child: Text(
                'P',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 18),
            Text(
              'Project Admin',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 28),
            CircularProgressIndicator(color: AdminTheme.purple),
          ],
        ),
      ),
    );
  }
}
