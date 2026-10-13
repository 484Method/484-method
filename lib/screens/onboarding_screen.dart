import 'package:flutter/material.dart';

import '../services/progress_store.dart';
import '../ui/app_style.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_use_screen.dart';

/// Consentimento de gravação de voz (LGPD), antes do primeiro treino.
///
/// A landing (IntroScreen) já vendeu e explicou o método; aqui fica só o
/// aceite, no visual de folha de permissão do iOS: ícone grande, título,
/// pontos curtos e a ação embaixo. O app não grava nada sem este
/// consentimento explícito, e o usuário não chega ao dashboard sem passar
/// por aqui.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    super.key,
    required this.store,
    required this.onDone,
    this.onBack,
  });

  final ProgressStore store;
  final VoidCallback onDone;

  /// Permite recuar para a landing sem aceitar — quem está em dúvida não
  /// fica preso só entre "aceitar" e nada mais.
  final VoidCallback? onBack;

  Future<void> _acceptAndStart() async {
    await store.grantVoiceConsent();
    onDone();
  }

  // O que o aceite cobre. Mesmo conteúdo do texto corrido de antes (análise
  // automática na Microsoft Azure, só pra pronúncia, nunca pra treinar IA,
  // dados técnicos agregados, exclusão a qualquer momento), em pontos curtos.
  static const _points = <(IconData, String, String)>[
    (
      Icons.graphic_eq_rounded,
      'Só para avaliar a pronúncia',
      'O áudio vai para análise automática (Microsoft Azure).',
    ),
    (
      Icons.block_rounded,
      'Não treina IA',
      'Sua voz não é usada para treinar modelos de IA.',
    ),
    (
      Icons.devices_rounded,
      'Dados técnicos agregados',
      'Também registramos navegador, sistema operacional e idioma, para '
          'entender o uso do app.',
    ),
    (
      Icons.delete_outline_rounded,
      'Você no controle',
      'Apague seus dados quando quiser.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final c = AppColors.of(context);
    final linkStyle = TextButton.styleFrom(
      textStyle: text.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
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
                            child: Icon(Icons.mic_rounded,
                                size: 42, color: theme.colorScheme.primary),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Sua voz, suas regras',
                            style: text.headlineLarge,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 10),
                        Text(
                          'Para avaliar sua pronúncia, o app grava sua voz '
                          'durante os exercícios.',
                          style:
                              text.bodyLarge?.copyWith(color: c.secondaryLabel),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        for (final (icon, title, detail) in _points)
                          _point(context, icon, title, detail),
                        const SizedBox(height: 4),
                        Text(
                          'Sem o aceite não dá para praticar, porque todo o '
                          'método é baseado na sua voz.',
                          style: text.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            TextButton(
                              style: linkStyle,
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const PrivacyPolicyScreen()),
                              ),
                              child: const Text('Política de privacidade'),
                            ),
                            TextButton(
                              style: linkStyle,
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const TermsOfUseScreen()),
                              ),
                              child: const Text('Termos de Uso'),
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
                      onPressed: _acceptAndStart,
                      // Respiro vertical pro rótulo quebrado em 2 linhas
                      // (320pt ou texto ampliado) não encostar nas bordas.
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Aceitar e fazer meu primeiro treino',
                            textAlign: TextAlign.center),
                      ),
                    ),
                    if (onBack != null) ...[
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: onBack,
                        child: const Text('Voltar'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _point(
      BuildContext context, IconData icon, String title, String detail) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 36,
            child: Icon(icon,
                size: 26, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleMedium),
                const SizedBox(height: 2),
                Text(detail, style: text.bodyMedium?.copyWith(
                    color: AppColors.of(context).secondaryLabel)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
