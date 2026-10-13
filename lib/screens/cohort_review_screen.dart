import 'package:flutter/material.dart';

import '../data/fase1.dart';
import '../services/analytics_service.dart';
import '../services/progress_store.dart';
import '../ui/app_style.dart';

/// Escala de autoconfiança pra falar inglês (1–5). É o par SUBJETIVO do
/// antes/depois do desafio de 21 dias: medimos no começo e no fim pra ver se
/// a pessoa PERCEBE melhora. O par objetivo (gravação com nota) é a fatia
/// seguinte (precisa de gravação longa + storage + rating cego).
///
/// Os rótulos são a âncora da escala (iguais desde o começo do desafio); o
/// número só mostra a ordem. Sem emoji: visual "clean" de 2026-10-13.
const List<(int, String)> kConfidenceScale = [
  (1, 'Travo, não consigo falar'),
  (2, 'Falo com muita dificuldade'),
  (3, 'Me viro no básico'),
  (4, 'Falo com alguma segurança'),
  (5, 'Falo com tranquilidade'),
];

String _confidenceLabel(int? score) {
  for (final (value, label) in kConfidenceScale) {
    if (value == score) return label;
  }
  return 'Sem resposta';
}

/// Número da escala num círculo neutro (só indica a ordem 1–5).
class _ScaleNumber extends StatelessWidget {
  const _ScaleNumber(this.value);

  final int value;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: c.fill, shape: BoxShape.circle),
      child: Text('$value', style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

/// Pergunta a autoconfiança (1–5) num bottom sheet. Devolve o valor escolhido
/// ou null se a pessoa fechou sem responder.
Future<int?> showConfidenceSurvey(
  BuildContext context, {
  required String title,
  required String question,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    // Fundo cinza da página: a lista de opções aparece como grupo branco,
    // no estilo das folhas do iOS.
    backgroundColor: AppColors.of(context).background,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      final c = AppColors.of(ctx);
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
              AppStyle.pagePadding, 0, AppStyle.pagePadding, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text(question,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: c.secondaryLabel)),
              const SizedBox(height: 20),
              InsetGroup(
                children: [
                  for (final (value, label) in kConfidenceScale)
                    ListTile(
                      leading: _ScaleNumber(value),
                      title: Text(label),
                      onTap: () => Navigator.of(ctx).pop(value),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Antes/depois do desafio de 21 dias: junta o delta de confiança (subjetivo)
/// com os dados de prática que já rastreamos (minutos aprovados, lições
/// concluídas). Também pede um depoimento — o sinal de outcome mais forte pra
/// o beta (memo §18). O par objetivo por gravação entra na próxima fatia.
class CohortReviewScreen extends StatefulWidget {
  const CohortReviewScreen({
    super.key,
    required this.store,
    this.analytics,
  });

  final ProgressStore store;
  final AnalyticsService? analytics;

  @override
  State<CohortReviewScreen> createState() => _CohortReviewScreenState();
}

class _CohortReviewScreenState extends State<CohortReviewScreen> {
  final _testimonialController = TextEditingController();
  bool _testimonialSent = false;
  bool _hasTestimonialText = false;

  @override
  void initState() {
    super.initState();
    final before = widget.store.baselineConfidence;
    final after = widget.store.finalConfidence;
    widget.analytics?.log('before_after_review_completed', {
      'confidence_before': before,
      'confidence_after': after,
      'confidence_delta': (before != null && after != null)
          ? after - before
          : null,
      'approved_seconds': widget.store.totalApproved.inSeconds,
      'cohort_day': widget.store.cohortDay,
    });
    // Só redesenha o botão (habilita quando há texto); o envio segue igual.
    _testimonialController.addListener(_onTestimonialChanged);
  }

  @override
  void dispose() {
    _testimonialController.dispose();
    super.dispose();
  }

  void _onTestimonialChanged() {
    final has = _testimonialController.text.trim().isNotEmpty;
    if (has != _hasTestimonialText) {
      setState(() => _hasTestimonialText = has);
    }
  }

  void _sendTestimonial() {
    final text = _testimonialController.text.trim();
    if (text.isEmpty) return;
    widget.analytics?.log('testimonial_submitted', {
      'text': text,
      'confidence_after': widget.store.finalConfidence,
    });
    setState(() => _testimonialSent = true);
  }

  int _completedLessonCount() {
    var n = 0;
    for (final l in fase1Lessons) {
      if (widget.store.isLessonCompleted(l.id)) n++;
    }
    return n;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = AppColors.of(context);
    final before = widget.store.baselineConfidence;
    final after = widget.store.finalConfidence;
    final delta = (before != null && after != null) ? after - before : 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Seu antes e depois')),
      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppStyle.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                      AppStyle.pagePadding, 8, AppStyle.pagePadding, 24),
                  children: [
                    Text('21 dias depois',
                        style: theme.textTheme.displaySmall),
                    const SizedBox(height: 6),
                    Text(
                      delta > 0
                          ? 'Sua confiança pra falar subiu. Veja o caminho que você fez.'
                          : 'Veja o caminho que você fez nesses dias.',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: c.secondaryLabel),
                    ),
                    const SizedBox(height: 28),
                    _confidenceGroup(theme, before, after, delta),
                    const SizedBox(height: 28),
                    _practiceStats(theme, c),
                    const SizedBox(height: 28),
                    _testimonial(theme, c),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                child: _testimonialSent
                    ? const SizedBox(width: double.infinity)
                    : BottomActions(
                        children: [
                          FilledButton(
                            onPressed: _hasTestimonialText
                                ? _sendTestimonial
                                : null,
                            child: const Text('Enviar depoimento'),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _confidenceGroup(
      ThemeData theme, int? before, int? after, int delta) {
    return InsetGroup(
      header: 'Como você se sente falando inglês',
      children: [
        _confidenceRow(theme, 'No começo', before),
        _confidenceRow(theme, 'Agora', after),
        if (delta > 0)
          ListTile(
            leading: Icon(Icons.trending_up_rounded,
                color: theme.colorScheme.secondary),
            title: Text(
              '+$delta ${delta == 1 ? "nível" : "níveis"} de confiança',
              style: theme.textTheme.titleMedium,
            ),
          ),
      ],
    );
  }

  Widget _confidenceRow(ThemeData theme, String when, int? score) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(when, style: theme.textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(_confidenceLabel(score), style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  /// Números grandes lado a lado, como nos resumos do app Fitness.
  Widget _practiceStats(ThemeData theme, AppColors c) {
    final minutes = widget.store.totalApproved.inMinutes;
    final lessons = _completedLessonCount();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text('O que você treinou',
              style:
                  theme.textTheme.titleSmall?.copyWith(color: c.secondaryLabel)),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _stat(
                  theme,
                  '$minutes',
                  minutes == 1
                      ? 'minuto de fala aprovada'
                      : 'minutos de fala aprovada',
                  c.green,
                ),
              ),
              const SizedBox(width: AppStyle.gap),
              Expanded(
                child: _stat(
                  theme,
                  '$lessons',
                  lessons == 1 ? 'lição concluída' : 'lições concluídas',
                  c.label,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stat(ThemeData theme, String value, String label, Color color) {
    final c = AppColors.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: color,
                  fontFeatures: const [FontFeature.tabularFigures()],
                )),
            const SizedBox(height: 4),
            Text(label,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: c.secondaryLabel)),
          ],
        ),
      ),
    );
  }

  Widget _testimonial(ThemeData theme, AppColors c) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: _testimonialSent
          ? InsetGroup(
              key: const ValueKey('sent'),
              children: [
                ListTile(
                  leading: Icon(Icons.check_circle_rounded, color: c.green),
                  title:
                      const Text('Obrigado! Seu relato ajuda a construir o 484.'),
                ),
              ],
            )
          : Column(
              key: const ValueKey('form'),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Conta pra gente', style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('O que mudou na sua fala nesses 21 dias?',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: c.secondaryLabel)),
                const SizedBox(height: 12),
                TextField(
                  controller: _testimonialController,
                  minLines: 3,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Seu relato em uma ou duas frases…',
                  ),
                ),
              ],
            ),
    );
  }
}
