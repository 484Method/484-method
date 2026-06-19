import 'package:flutter/material.dart';

/// Landing de conversão (moldura pra quem abre o link cold — investidor, beta).
/// Não explica "um app de inglês": vende a experiência de finalmente falar em
/// voz alta, ouvir o próprio erro, entender como corrigir e sentir evolução.
/// Estrutura: hero → como funciona → demonstração → pra quem é → o que treina
/// → por que funciona → CTA final. Some após o consentimento.
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key, required this.onStart});

  /// CTA → segue para o consentimento e o primeiro treino.
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _hero(theme),
                  const SizedBox(height: 48),
                  _comoFunciona(theme),
                  const SizedBox(height: 48),
                  _demonstracao(theme),
                  const SizedBox(height: 48),
                  _paraQuemE(theme),
                  const SizedBox(height: 48),
                  _oQueTreina(theme),
                  const SizedBox(height: 48),
                  _porQueFunciona(theme),
                  const SizedBox(height: 40),
                  _ctaFinal(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Hero -----------------------------------------------------------------
  Widget _hero(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Você entende inglês,\nmas trava quando precisa falar?',
          style: theme.textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold, height: 1.2),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          'Treine sua fala em ciclos curtos: escute, repita, grave sua voz, '
          'receba feedback em português e grave de novo até soar mais natural.',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Você não aprende fluência só lendo.\n'
          'Aqui você fala, erra, corrige e tenta de novo.',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: onStart,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Fazer meu primeiro treino de fala'),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Demo grátis no navegador. Use seu microfone. Sem cartão.',
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // --- Como funciona --------------------------------------------------------
  Widget _comoFunciona(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, 'Como funciona'),
        const SizedBox(height: 8),
        _chipFlow(theme,
            ['Ouvir', 'Repetir', 'Gravar', 'Corrigir', 'Regravar']),
        const SizedBox(height: 24),
        _step(theme, '1', 'Escute',
            'Você ouve a palavra ou frase — sem ler nada antes.'),
        _step(theme, '2', 'Repita em voz alta',
            'Treina som, ritmo e a coragem de abrir a boca.'),
        _step(theme, '3', 'Grave sua resposta',
            'O app analisa o seu próprio áudio, não um modelo pronto.'),
        _step(theme, '4', 'Receba feedback em português',
            'Você entende exatamente o que precisa corrigir.'),
        _step(theme, '5', 'Grave de novo',
            'Compara com a 1ª tentativa e sente a evolução na hora.'),
      ],
    );
  }

  // --- Demonstração (exemplo real do app) -----------------------------------
  Widget _demonstracao(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, 'Veja em 10 segundos'),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _demoRow(theme, Icons.volume_up, 'Você ouve',
                    '“water” — sem ver a escrita ainda.'),
                const Divider(height: 24),
                _demoRow(theme, Icons.mic, 'Você grava',
                    'Repete do seu jeito, em voz alta.'),
                const Divider(height: 24),
                _demoRow(
                    theme,
                    Icons.record_voice_over,
                    'Feedback na hora',
                    'Quase! No “water” americano o “t” vira quase um “d” — '
                        'tente “UÓ-der”, sem separar as sílabas. Grave de novo.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Para quem é ----------------------------------------------------------
  Widget _paraQuemE(ThemeData theme) {
    const items = [
      'Você entende vídeos, aulas e textos, mas trava quando precisa responder.',
      'Você sabe a palavra, mas demora pra montar a frase.',
      'Você fica inseguro com pronúncia e ritmo.',
      'Você já estudou inglês, mas a fala não acompanha a compreensão.',
      'Você quer praticar sem vergonha, sem professor olhando, sem pressão.',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, 'Esse treino é pra você se…'),
        const SizedBox(height: 12),
        for (final t in items) _check(theme, t),
      ],
    );
  }

  // --- O que você treina ----------------------------------------------------
  Widget _oQueTreina(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(theme, 'O que você treina'),
        const SizedBox(height: 12),
        _feature(theme, Icons.graphic_eq, 'Pronúncia',
            'Os sons que mais traem o brasileiro.'),
        _feature(theme, Icons.music_note, 'Ritmo',
            'Falar sem soar travado, palavra por palavra.'),
        _feature(theme, Icons.waving_hand, 'Entonação',
            'Soar mais natural, menos robótico.'),
        _feature(theme, Icons.bolt, 'Confiança oral',
            'Acostumar a boca — e a cabeça — a falar em voz alta.'),
      ],
    );
  }

  // --- Por que funciona -----------------------------------------------------
  Widget _porQueFunciona(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('Por que funciona',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            'Fluência oral não nasce lendo explicação. Nasce repetindo, '
            'errando, corrigindo e tentando de novo. É isso que você faz '
            'aqui — em ciclos curtos, com a sua própria voz.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // --- CTA final ------------------------------------------------------------
  Widget _ctaFinal(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: onStart,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Começar meu primeiro treino de fala'),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Baseado no 484 Method: prática oral em ciclos de escuta, '
          'repetição, gravação e correção.',
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // --- Helpers --------------------------------------------------------------
  Widget _sectionTitle(ThemeData theme, String text) => Text(
        text,
        style: theme.textTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      );

  Widget _chipFlow(ThemeData theme, List<String> steps) => Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Chip(
              label: Text(steps[i]),
              visualDensity: VisualDensity.compact,
              backgroundColor: theme.colorScheme.primaryContainer,
            ),
            if (i < steps.length - 1)
              Icon(Icons.arrow_forward,
                  size: 16, color: theme.colorScheme.outline),
          ],
        ],
      );

  Widget _step(ThemeData theme, String n, String title, String body) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: Text(n,
                  style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(body, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _demoRow(ThemeData theme, IconData icon, String label, String body) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelLarge),
                const SizedBox(height: 2),
                Text(body, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      );

  Widget _check(ThemeData theme, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle,
                size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
          ],
        ),
      );

  Widget _feature(ThemeData theme, IconData icon, String title, String body) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  Text(body, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      );
}
