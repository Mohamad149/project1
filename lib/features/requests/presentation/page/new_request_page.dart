import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/service_request.dart';
import '../bloc/submit_request/submit_request_bloc.dart';
import '../bloc/submit_request/submit_request_event.dart';
import '../bloc/submit_request/submit_request_state.dart';

class NewRequestPage extends StatefulWidget {
  const NewRequestPage({super.key, this.existingRequest});


  final ServiceRequest? existingRequest;

  static const categories = [
    'General',
    'Technical Support',
    'Billing',
    'Other',
  ];

  @override
  State<NewRequestPage> createState() => _NewRequestPageState();
}

class _NewRequestPageState extends State<NewRequestPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late String _category;

  bool get _isEditing => widget.existingRequest != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingRequest;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _descriptionController = TextEditingController(
      text: existing?.description ?? '',
    );
    _category = existing?.category ?? NewRequestPage.categories.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_isEditing) {
      context.read<SubmitRequestBloc>().add(
        UpdateRequestPressed(
          requestId: widget.existingRequest!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          category: _category,
        ),
      );
    } else {
      context.read<SubmitRequestBloc>().add(
        SubmitRequestPressed(
          title: _titleController.text,
          description: _descriptionController.text,
          category: _category,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubmitRequestBloc, SubmitRequestState>(
      listener: (context, state) {
        if (state is SubmitRequestSuccess) {
          Navigator.pop(context, true);
        } else if (state is SubmitRequestFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Request' : 'New Request'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.title_outlined),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Title is required.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: NewRequestPage.categories
                      .map(
                        (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Description is required.';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<SubmitRequestBloc, SubmitRequestState>(
                  builder: (context, state) {
                    final loading = state is SubmitRequestLoading;

                    return FilledButton(
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : Text(_isEditing ? 'Save Changes' : 'Submit Request'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}