import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/dependency_injection.dart';
import '../../../app/route_app.dart';
import '../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../auth/presentation/bloc/auth/auth_event.dart';
import '../../requests/domain/entity/service_request.dart';
import '../../requests/domain/usecase/delete_request.dart';
import '../../requests/presentation/bloc/my_requests/my_requests_bloc.dart';
import '../../requests/presentation/bloc/my_requests/my_requests_event.dart';
import '../../requests/presentation/bloc/my_requests/my_requests_state.dart';
import '../../requests/presentation/bloc/submit_request/submit_request_bloc.dart';
import '../../requests/presentation/page/new_request_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyRequestsBloc>(
      create: (_) => sl<MyRequestsBloc>()..add(MyRequestsStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Project'),
          actions: [
            IconButton(
              tooltip: 'Log out',
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequest());
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                      (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: BlocBuilder<MyRequestsBloc, MyRequestsState>(
          builder: (context, state) {
            if (state is MyRequestsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MyRequestsFailure) {
              return Center(child: Text(state.message));
            }

            final requests = (state as MyRequestsLoaded).requests;

            if (requests.isEmpty) {
              return const Center(
                child: Text('You have no requests yet.\nTap + to create one.'),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final request = requests[index];
                return _RequestCard(request: request);
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider<SubmitRequestBloc>(
                  create: (_) => sl<SubmitRequestBloc>(),
                  child: const NewRequestPage(),
                ),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('New Request'),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});

  final ServiceRequest request;

  bool get _isPending => request.status == RequestStatus.pending;

  Future<void> _edit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<SubmitRequestBloc>(
          create: (_) => sl<SubmitRequestBloc>(),
          child: NewRequestPage(existingRequest: request),
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Request'),
        content: Text('Delete "${request.title}"? This cannot be undone.'),
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
    if (!context.mounted) return;

    try {
      await sl<DeleteRequest>()(request.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request deleted.')),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete your request.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(request.title),
        subtitle: Text(request.category),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatusChip(status: request.status),
            if (_isPending) ...[
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _edit(context),
              ),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _delete(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final RequestStatus status;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    switch (status) {
      case RequestStatus.accepted:
        color = Colors.green;
        label = 'Accepted';
        break;
      case RequestStatus.declined:
        color = Colors.red;
        label = 'Declined';
        break;
      case RequestStatus.pending:
        color = Colors.orange;
        label = 'Pending';
        break;
    }

    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
    );
  }
}