import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../app/admin_theme.dart';
import '../requests/requests_repository.dart';
import '../users/users_repository.dart';

class DashboardPage extends StatelessWidget {
  final UsersRepository usersRepository;
  final RequestsRepository requestsRepository;

  const DashboardPage({
    super.key,
    required this.usersRepository,
    required this.requestsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: usersRepository.watchUsers(),
                builder: (context, snapshot) {
                  final count = snapshot.data?.docs.length;
                  return _StatCard(
                    icon: Icons.people_outline,
                    label: 'Users',
                    value: count,
                  );
                },
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: requestsRepository.watchRequests(),
                builder: (context, snapshot) {
                  final count = snapshot.data?.docs.length;
                  return _StatCard(
                    icon: Icons.assignment_outlined,
                    label: 'Requests',
                    value: count,
                  );
                },
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: requestsRepository.watchRequests(),
                builder: (context, snapshot) {
                  final count = snapshot.data?.docs
                      .where((doc) => (doc.data()['status'] ?? 'pending') == 'pending')
                      .length;
                  return _StatCard(
                    icon: Icons.hourglass_empty,
                    label: 'Pending Requests',
                    value: count,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final int? value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AdminTheme.purple.withValues(alpha: 0.12),
              child: Icon(icon, color: AdminTheme.purple),
            ),
            const SizedBox(height: 16),
            Text(
              value == null ? '—' : value.toString(),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}