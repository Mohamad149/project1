import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/date_formatters.dart';
import 'users_repository.dart';

class UsersPage extends StatefulWidget {
  final UsersRepository repository;
  final String currentAdminUid;

  const UsersPage({
    super.key,
    required this.repository,
    required this.currentAdminUid,
  });

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String _query = '';

  Future<void> _changeRole(String uid, String role) async {
    try {
      await widget.repository.updateUserRole(uid, role);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Role changed to $role.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update role: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
                  decoration: const InputDecoration(
                    hintText: 'Search by name or email',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(12),
            ),

          ),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: widget.repository.watchUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Could not load users: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs.where((doc) {
                    final data = doc.data();
                    final name = (data['name'] ?? '').toString().toLowerCase();
                    final email = (data['email'] ?? '').toString().toLowerCase();
                    return _query.isEmpty || name.contains(_query) || email.contains(_query);
                  }).toList();

                  if (docs.isEmpty) {
                    return const Center(child: Text('No users found.'));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Role')),
                            DataColumn(label: Text('Created')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: docs.map((doc) {
                            final data = doc.data();
                            final role = (data['role'] ?? 'user').toString();
                            final self = doc.id == widget.currentAdminUid;

                            return DataRow(
                              cells: [
                                DataCell(Text((data['name'] ?? '—').toString())),
                                DataCell(Text((data['email'] ?? '—').toString())),
                                DataCell(Chip(label: Text(role))),
                                DataCell(Text(formatFirestoreDate(data['createdAt']))),
                                DataCell(
                                  PopupMenuButton<String>(
                                    tooltip: self
                                        ? 'You cannot change your own role here'
                                        : 'Change role',
                                    enabled: !self,
                                    onSelected: (value) => _changeRole(doc.id, value),
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'user',
                                        child: Text('Make user'),
                                      ),
                                      PopupMenuItem(
                                        value: 'admin',
                                        child: Text('Make admin'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
