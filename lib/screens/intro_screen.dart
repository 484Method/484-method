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

  // A ordem do método: primeiro o ouvido, depois a boca, só depois os olhos.
  // ("Repita" e "Grave" eram o mesmo botão no app; viraram um passo só.)
  static const _cycle = <(IconData, String)>[
    (Icons.headphones_rounded, 'Ouça'),
    (Icons.mic_rounded, 'Fale'),
    (Icons.menu_book_rounded, 'Veja a escrita'),
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

  /// Marca pequena acima da manchete. (Sem selo de "Protótipo": sinal de
  /// beta no topo do funil tira confiança, como já foi feito na Home.)
  Widget _brand(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Text('484 Method',
        style: text.titleMedium, textAlign: TextAlign.center);
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
