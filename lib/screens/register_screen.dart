import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event_model.dart';
import '../providers/language_provider.dart';
import '../providers/registered_provider.dart';

class RegisterScreen extends StatefulWidget {
  final Event event;

  const RegisterScreen({super.key, required this.event});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final registered = context.read<RegisteredProvider>();
    final lang = context.read<LanguageProvider>();

    if (registered.isRegistered(widget.event.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.t('already_registered'))),
      );
      return;
    }

    setState(() => _submitting = true);

    // Simulate a brief network/processing delay
    await Future.delayed(const Duration(milliseconds: 600));

    await registered.register(widget.event);

    if (!mounted) return;
    setState(() => _submitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(lang.t('success')),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Pop twice: Register screen → Details screen → stay on Home
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final t = lang.t;
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(title: Text(t('register_title'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Event summary card ──────────────────────────────────────
              Card(
                child: ListTile(
                  leading: const Icon(Icons.event),
                  title: Text(event.name,
                      style:
                          const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      '${event.formattedDate}  •  ${event.location}'),
                ),
              ),
              const SizedBox(height: 24),

              // ── Form fields ─────────────────────────────────────────────
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: t('name'),
                  prefixIcon: const Icon(Icons.person_outline),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? t('name_required') : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: t('email'),
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return t('email_required');
                  if (!v.contains('@') || !v.contains('.')) {
                    return t('email_required');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _idController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t('student_id'),
                  prefixIcon: const Icon(Icons.badge_outlined),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? t('id_required') : null,
              ),
              const SizedBox(height: 32),

              // ── Submit button ────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Text(t('submit')),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(t('cancel')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
