import 'package:flutter/material.dart';

import '../services/analytics_service.dart';
import '../services/progress_store.dart';

/// Cadastro obrigatório na entrada: nome + e-mail antes de usar o app. É uma
/// porta travada (decisão do produto de identificar quem entra) — sem "pular".
/// Só captura, sem verificação. Guarda no ProgressStore (local + tabela
/// `signups`). LGPD: pede só nome/e-mail e explica o porquê.
class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
    required this.store,
    required this.onDone,
    this.analytics,
  });

  final ProgressStore store;
  final VoidCallback onDone;
  final AnalyticsService? analytics;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _submitting = false;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool get _valid =>
      _nameController.text.trim().isNotEmpty &&
      _emailRegex.hasMatch(_emailController.text.trim());

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_valid || _submitting) return;
    setState(() => _submitting = true);
    await widget.store.setRegistration(
      _nameController.text.trim(),
      _emailController.text.trim(),
    );
    widget.analytics?.log('signup_completed');
    if (!mounted) return;
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.waving_hand,
                    size: 56, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text('Antes de começar',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  'Diz seu nome e um e-mail pra gente acompanhar sua evolução e '
                  'te avisar das novidades do beta.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Seu nome',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Seu e-mail',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _valid && !_submitting ? _submit : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child:
                                CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Entrar'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Usamos só pra falar com você sobre o 484. Sem spam, e você '
                  'pode apagar seus dados quando quiser.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
