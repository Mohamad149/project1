import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/date_formatters.dart';
import 'requests_repository.dart';

class RequestsPage extends StatefulWidget {
  final RequestsRepository repository;

  const RequestsPage({super.key, required this.repository});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  static const categories = ['General', 'Technical Support', 'Billing', 'Other'];

  Future<void> _updateStatus(String id, String status) async {
    try {
      await widget.repository.updateRequestStatus(id, status);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request $status.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update request: $error')),
      );
    }
  }

  void _viewRequest(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text((data['title'] ?? '—').toString()),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow(label: 'Category', value: (data['category'] ?? '—').toString()),
              _DetailRow(label: 'Status', value: (data['status'] ?? '—').toString()),
              _DetailRow(label: 'Submitted by', value: (data['userName'] ?? '—').toString()),
              _DetailRow(label: 'Email', value: (data['userEmail'] ?? '—').toString()),
              _DetailRow(label: 'Date', value: formatFirestoreDate(data['createdAt'])),
              const SizedBox(height: 12),
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text((data['description'] ?? '—').toString()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _editRequest(String id, Map<String, dynamic> data) async {
    final titleController = TextEditingController(text: (data['title'] ?? '').toString());
    final descriptionController = TextEditingController(
      text: (data['description'] ?? '').toString(),
    );
    String category = categories.contains(data['category'])
        ? data['category'] as String
        : categories.first;
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Request'),
          content: SizedBox(
            width: 420,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) =>
                    (value?.trim().isEmpty ?? true) ? 'Title is required.' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setDialogState(() => category = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) =>
                    (value?.trim().isEmpty ?? true) ? 'Description is required.' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );

    if (saved != true) return;
    if (!mounted) return;

    try {
      await widget.repository.updateRequestDetails(
        id,
        title: titleController.text,
        description: descriptionController.text,
        category: category,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request updated.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update request: $error')),
      );
    }
  }

  Future<void> _deleteRequest(String id, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Request'),
        content: Text('Delete "$title"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    try {
      await widget.repository.deleteRequest(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request deleted.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete request: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Card(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: widget.repository.watchRequests(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Could not load requests: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(child: Text('No requests yet.'));
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: docs.map((doc) {
                    final data = doc.data();
                    final status = (data['status'] ?? 'pending').toString();
                    final isPending = status == 'pending';

                    return DataRow(
                      cells: [
                        DataCell(Text((data['title'] ?? '—').toString())),
                        DataCell(Text((data['userName'] ?? '—').toString())),
                        DataCell(Text((data['category'] ?? '—').toString())),
                        DataCell(_StatusChip(status: status)),
                        DataCell(Text(formatFirestoreDate(data['createdAt']))),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'View',
                                icon: const Icon(Icons.visibility_outlined),
                                onPressed: () => _viewRequest(data),
                              ),
                              IconButton(
                                tooltip: 'Accept',
                                icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                                onPressed: isPending
                                    ? () => _updateStatus(doc.id, 'accepted')
                                    : null,
                              ),
                              IconButton(
                                tooltip: 'Decline',
                                icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                                onPressed: isPending
                                    ? () => _updateStatus(doc.id, 'declined')
                                    : null,
                              ),
                              IconButton(
                                tooltip: 'Edit',
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _editRequest(doc.id, data),
                              ),
                              IconButton(
                                tooltip: 'Delete',
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => _deleteRequest(
                                  doc.id,
                                  (data['title'] ?? '').toString(),
                                ),
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
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final Color color;
    switch (status) {
      case 'accepted':
        color = Colors.green;
        break;
      case 'declined':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Chip(
      label: Text(status, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}