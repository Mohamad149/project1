import 'package:flutter/material.dart';

import '../features/auth/admin_login_page.dart';
import '../features/auth/admin_session.dart';
import '../features/auth/admin_splash_page.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/requests/requests_page.dart';
import '../features/requests/requests_repository.dart';
import '../features/users/users_page.dart';
import '../features/users/users_repository.dart';
import 'admin_theme.dart';

class AdminApp extends StatelessWidget {
  final AdminSession session;
  final UsersRepository usersRepository;
  final RequestsRepository requestsRepository;

  const AdminApp({
    super.key,
    required this.session,
    required this.usersRepository,
    required this.requestsRepository,
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

          return _AdminShell(
            session: session,
            usersRepository: usersRepository,
            requestsRepository: requestsRepository,
          );
        },
      ),
    );
  }
}

class _AdminShell extends StatefulWidget {
  final AdminSession session;
  final UsersRepository usersRepository;
  final RequestsRepository requestsRepository;

  const _AdminShell({
    required this.session,
    required this.usersRepository,
    required this.requestsRepository,
  });

  @override
  State<_AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<_AdminShell> {
  int _selectedIndex = 0;

  static const _titles = ['Dashboard', 'Users', 'Requests'];

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        usersRepository: widget.usersRepository,
        requestsRepository: widget.requestsRepository,
      ),
      UsersPage(
        repository: widget.usersRepository,
        currentAdminUid: widget.session.user?.uid ?? '',
      ),
      RequestsPage(repository: widget.requestsRepository),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            onPressed: widget.session.signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.assignment_outlined),
                selectedIcon: Icon(Icons.assignment),
                label: Text('Requests'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: pages[_selectedIndex]),
        ],
      ),
    );
  }
}