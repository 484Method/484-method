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

  /// Liga as mensagens de erro dos campos só depois da 1ª tentativa de
  /// enviar: o botão fica sempre ativo e, se faltar algo, a tela diz o quê
  /// (antes ele ficava cinza sem explicar o motivo).
  bool _showErrors = false;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  bool get _nameOk => _nameController.text.trim().isNotEmpty;
  bool get _emailOk => _emailRegex.hasMatch(_emailController.text.trim());
  bool get _valid => _nameOk && _emailOk;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (!_valid) {
      setState(() => _showErrors = true);
      return;
    }
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
  static InputDecoration _field(String hint, AppColors c, TextTheme text,
          {String? error}) =>
      InputDecoration(
        hintText: hint,
        errorText: error,
        hintStyle: text.bodyLarge?.copyWith(color: c.secondaryLabel),
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
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
                        Text('Salve seu progresso',
                            style: text.headlineLarge,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 10),
                        Text(
                          'Você já começou a falar. Deixe seu nome e e-mail '
                          'para acompanharmos sua evolução e falarmos com '
                          'você sobre o 484.',
                          style:
                              text.bodyLarge?.copyWith(color: c.secondaryLabel),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // AutofillGroup + autofillHints: no iPhone o teclado
                        // oferece nome/e-mail do contato (na web vira o
                        // atributo autocomplete).
                        AutofillGroup(
                          child: InsetGroup(
                            footer: 'Sem spam. Você pode apagar seus dados '
                                'quando quiser.',
                            children: [
                              TextField(
                                controller: _nameController,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.name],
                                style: text.bodyLarge,
                                decoration: _field('Seu nome', c, text,
                                    error: _showErrors && !_nameOk
                                        ? 'Falta seu nome'
                                        : null),
                                onChanged: (_) => setState(() {}),
                              ),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.email],
                                autocorrect: false,
                                style: text.bodyLarge,
                                decoration: _field('Seu e-mail', c, text,
                                    error: _showErrors && !_emailOk
                                        ? 'Confira o e-mail (ex.: nome@gmail.com)'
                                        : null),
                                onChanged: (_) => setState(() {}),
                                onSubmitted: (_) => _submit(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BottomActions(
                  children: [
                    FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Continuar'),
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
