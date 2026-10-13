import 'package:flutter/material.dart';

import '../ui/app_style.dart';

/// Landing da demo, no estilo de página de produto da Apple: marca pequena,
/// a dor numa manchete grande, a promessa numa frase cinza, o ciclo do
/// método (diferencial) numa linha discreta de ícones e UM botão embaixo.
/// Some após o consentimento (usuário recorrente cai direto no app).
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key, required this.onStart});

  /// CTA → segue para o consentimento e o primeiro treino.
  final VoidCallback onStart;

  static const _cycle = <(IconData, String)>[
    (Icons.headphones_rounded, 'Ouça'),
    (Icons.record_voice_over_rounded, 'Repita'),
    (Icons.mic_rounded, 'Grave'),
    (Icons.tune_rounded, 'Corrija'),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
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
                  child: LayoutBuilder(
                    builder: (context, box) => SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppStyle.pagePadding, vertical: 24),
                      child: ConstrainedBox(
                        // Centraliza na vertical quando cabe; rola quando
                        // não cabe (tela baixa ou texto ampliado).
                        // (clamp: em janela muito baixa a conta daria
                        // negativa e o BoxConstraints quebraria.)
                        constraints: BoxConstraints(
                            minHeight: (box.maxHeight - 48)
                                .clamp(0.0, double.infinity)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _brand(context),
                            const SizedBox(height: 20),
                            Text(
                              'Você entende inglês, mas trava quando '
                              'precisa falar?',
                              style: text.displaySmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Escute, grave sua voz e receba feedback em '
                              'português. Depois grave de novo, até soar '
                              'natural.',
                              style: text.bodyLarge
                                  ?.copyWith(color: c.secondaryLabel),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),
                            _cycleRow(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                BottomActions(
                  children: [
                    FilledButton(
                      onPressed: onStart,
                      // Respiro vertical: em tela estreita (320pt) ou com
                      // texto ampliado o rótulo quebra em 2 linhas e, sem
                      // isto, encosta nas bordas do botão.
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        // Espaço inseparável em "de fala": se quebrar, não
                        // deixa "fala" sozinha na 2ª linha.
                        child: Text('Fazer meu primeiro treino de\u00A0fala',
                            textAlign: TextAlign.center),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Gratuito para começar. Leva menos de 1\u00A0minuto.',
                      style: text.bodySmall,
                      textAlign: TextAlign.center,
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

  /// Marca pequena acima da manchete + rótulo discreto de protótipo.
  Widget _brand(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final c = AppColors.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        Text('484 Method', style: text.titleMedium),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: c.fill,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Protótipo',
            style: text.labelSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  /// O ciclo do método como uma linha de ícones pequenos e neutros.
  Widget _cycleRow(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final c = AppColors.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (icon, label) in _cycle)
          Expanded(
            child: Column(
              children: [
                Icon(icon, size: 26, color: c.label),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(label, style: text.labelMedium, maxLines: 1),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
