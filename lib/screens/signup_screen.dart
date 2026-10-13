import 'package:flutter/material.dart';

import '../services/analytics_service.dart';
import '../services/progress_store.dart';
import '../ui/app_style.dart';

/// Cadastro obrigatório, mas só DEPOIS da 1ª gravação (ver HomeScreen.build):
/// nome + e-mail, porta travada (decisão do produto de identificar quem usa
/// de verdade) — sem "pular". Só captura, sem verificação. Guarda no
/// ProgressStore (local + tabela `signups`). LGPD: pede só nome/e-mail e
/// explica o porquê.
///
/// Visual de formulário do iOS: título, uma frase, os dois campos num grupo
/// "inset grouped" com a nota de privacidade no rodapé e o botão embaixo
/// (sobe junto com o teclado).
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

  /// Campo sem borda própria: quem desenha o cartão e o fio entre as linhas
  /// é o [InsetGroup], como nos formulários do iOS. O placeholder é o ÚNICO
  /// rótulo do campo, então usa o cinza secundário (legível nos dois temas)
  /// em vez do terciário do tema, que fica abaixo de 3:1 no escuro.
  static InputDecoration _field(String hint, AppColors c, TextTheme text) =>
      InputDecoration(
        hintText: hint,
        hintStyle: text.bodyLarge?.copyWith(color: c.secondaryLabel),
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final c = AppColors.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppStyle.maxContentWidth),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(AppStyle.pagePadding,
                        40, AppStyle.pagePadding, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: c.accentFill,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person_rounded,
                                size: 44, color: theme.colorScheme.primary),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Antes de continuar',
                            style: text.headlineLarge,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 10),
                        Text(
                          'Deixe seu nome e e-mail para guardarmos sua '
                          'evolução e avisarmos das novidades do beta.',
                          style:
                              text.bodyLarge?.copyWith(color: c.secondaryLabel),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        InsetGroup(
                          footer: 'Usamos só para falar com você sobre o '
                              '484. Sem spam, e você pode apagar seus dados '
                              'quando quiser.',
                          children: [
                            TextField(
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              style: text.bodyLarge,
                              decoration: _field('Seu nome', c, text),
                              onChanged: (_) => setState(() {}),
                            ),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              style: text.bodyLarge,
                              decoration: _field('Seu e-mail', c, text),
                              onChanged: (_) => setState(() {}),
                              onSubmitted: (_) => _submit(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                BottomActions(
                  children: [
                    FilledButton(
                      onPressed: _valid && !_submitting ? _submit : null,
                      child: _submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Entrar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
