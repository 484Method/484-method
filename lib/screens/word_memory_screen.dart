import 'package:flutter/material.dart';

import '../services/backend.dart';
import '../services/progress_store.dart';
import '../ui/app_style.dart';

/// Categoria do ponto de fala a revisar — derivada de dado real (o app só
/// mede pronúncia/accuracy e ritmo/prosódia; não há sinal pra "estrutura de
/// frase" ou "tradução mental", então essas não viram categorias falsas).
enum SpeechCategory { pronunciation, rhythm }

/// Estatística por palavra no mapa de fala: melhor accuracy, tentativas, se já
/// foi dominada (aprovada alguma vez) e, quando a revisar, qual a dimensão
/// fraca (pronúncia x ritmo).
class WordStat {
  const WordStat({
    required this.word,
    required this.attempts,
    required this.bestAccuracy,
    required this.mastered,
    required this.category,
  });

  final String word;
  final int attempts;
  final double bestAccuracy;
  final bool mastered;
  final SpeechCategory category;
}

/// Agrega as tentativas (`attempt_assessed`) do usuário. "A revisar" = nunca
/// aprovadas (pior accuracy primeiro), categorizadas por dimensão fraca:
/// ritmo quando a prosódia é o ponto baixo, senão pronúncia. "Dominadas" =
/// aprovadas alguma vez. Função pura — testável sem rede.
({List<WordStat> review, List<WordStat> mastered}) aggregateWordMemory(
    List<Map<String, dynamic>> rows) {
  final byWord = <String, List<Map<String, dynamic>>>{};
  for (final r in rows) {
    final props = r['props'];
    if (props is! Map) continue;
    final word = props['item'];
    if (word is! String || word.isEmpty) continue;
    byWord.putIfAbsent(word, () => []).add(props.cast<String, dynamic>());
  }

  final stats = <WordStat>[];
  byWord.forEach((word, attempts) {
    var bestAcc = 0.0;
    double? bestPros;
    var mastered = false;
    for (final a in attempts) {
      final acc = (a['accuracy'] as num?)?.toDouble() ?? 0;
      if (acc > bestAcc) bestAcc = acc;
      final pros = (a['prosody'] as num?)?.toDouble();
      if (pros != null && (bestPros == null || pros > bestPros)) bestPros = pros;
      if (a['approved'] == true) mastered = true;
    }
    // Ritmo só quando a prosódia é claramente o elo fraco (e há dado dela).
    final isRhythm =
        bestPros != null && bestPros < 75 && bestPros < bestAcc;
    stats.add(WordStat(
      word: word,
      attempts: attempts.length,
      bestAccuracy: bestAcc,
      mastered: mastered,
      category:
          isRhythm ? SpeechCategory.rhythm : SpeechCategory.pronunciation,
    ));
  });

  final review = stats.where((s) => !s.mastered).toList()
    ..sort((a, b) => a.bestAccuracy.compareTo(b.bestAccuracy));
  final mastered = stats.where((s) => s.mastered).toList()
    ..sort((a, b) => b.bestAccuracy.compareTo(a.bestAccuracy));
  return (review: review, mastered: mastered);
}

/// "Meu mapa de fala": a memória de fala do aluno — onde ele trava (por
/// pronúncia ou ritmo) e o que já domina, a partir do histórico de tentativas.
/// Read-only; as palavras já passaram do Livro Aberto, então exibi-las não
/// fere o princípio som-first.
class WordMemoryScreen extends StatefulWidget {
  const WordMemoryScreen({super.key, this.onReviewWord, this.store});

  /// Para o nível de domínio (Firme x Dominada), que vem da escada de
  /// revisão espaçada guardada no aparelho. Sem store, toda palavra aprovada
  /// conta como Firme.
  final ProgressStore? store;

  /// Chamado ao tocar num ponto "a revisar" → abre o treino daquela palavra.
  final void Function(String word)? onReviewWord;

  @override
  State<WordMemoryScreen> createState() => _WordMemoryScreenState();
}

class _WordMemoryScreenState extends State<WordMemoryScreen> {
  late final Future<List<Map<String, dynamic>>> _future =
      Backend.instance?.fetchAttemptHistory() ?? Future.value(const []);

  /// Cor com significado: verde só pra palavra dominada (aprovada); a
  /// revisar fica vermelha quando a nota é baixa e neutra no meio-termo.
  Color _colorFor(AppColors c, WordStat s) {
    if (s.mastered) return c.green;
    if (s.bestAccuracy < 60) return c.red;
    return c.label;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Meu mapa de fala')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final mem = aggregateWordMemory(snap.data ?? const []);
          if (mem.review.isEmpty && mem.mastered.isEmpty) {
            return _empty(theme, c);
          }
          final pron = mem.review
              .where((s) => s.category == SpeechCategory.pronunciation)
              .toList();
          final rhythm = mem.review
              .where((s) => s.category == SpeechCategory.rhythm)
              .toList();
          // Aprovada alguma vez = pelo menos Firme. Dominada só quem a escada
          // de revisão (local) diz que passou na revisão de 10 dias.
          final dominated = [
            for (final s in mem.mastered)
              if (widget.store?.wordLevel(s.word) == WordLevel.mastered) s,
          ];
          final firm = [
            for (final s in mem.mastered)
              if (!dominated.contains(s)) s,
          ];
          return Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppStyle.maxContentWidth),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    AppStyle.pagePadding, 8, AppStyle.pagePadding, 32),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.onReviewWord != null
                          ? 'Onde você trava na fala e o que já domina. Toque '
                              'numa palavra a revisar para treinar de novo.'
                          : 'Onde você trava na fala e o que já domina.',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: c.secondaryLabel),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _levelSummary(theme, c,
                      learning: mem.review.length,
                      firm: firm.length,
                      mastered: dominated.length),
                  const SizedBox(height: 28),
                  ..._section(theme, c, 'Pronúncia a revisar', pron),
                  ..._section(theme, c, 'Ritmo a revisar', rhythm),
                  ..._section(theme, c, 'Firmes', firm,
                      footer: 'Aprovadas. Ficam dominadas quando passam na '
                          'revisão de 10 dias.'),
                  ..._section(theme, c, 'Dominadas', dominated),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _empty(ThemeData theme, AppColors c) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppStyle.maxContentWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.graphic_eq_rounded, size: 48, color: c.tertiaryLabel),
              const SizedBox(height: 16),
              Text('Seu mapa ainda está vazio',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'Faça alguns treinos. Aqui aparece onde você trava '
                '(pronúncia, ritmo) e o que já domina.',
                style:
                    theme.textTheme.bodyLarge?.copyWith(color: c.secondaryLabel),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Placar de domínio: três números e uma barra empilhada. É a "coleção"
  /// do aluno: dá pra ver as palavras subindo de nível com o tempo.
  Widget _levelSummary(ThemeData theme, AppColors c,
      {required int learning, required int firm, required int mastered}) {
    final total = learning + firm + mastered;
    Widget count(String label, int n, Color color) => Expanded(
          child: Column(
            children: [
              Text('$n',
                  style: theme.textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontFeatures: const [FontFeature.tabularFigures()])),
              const SizedBox(height: 2),
              Text(label, style: theme.textTheme.labelMedium),
            ],
          ),
        );
    Widget seg(int n, Color color) => n == 0
        ? const SizedBox.shrink()
        : Expanded(flex: n, child: Container(height: 6, color: color));
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          children: [
            Row(children: [
              count('Aprendendo', learning, c.label),
              count('Firmes', firm, theme.colorScheme.secondary),
              count('Dominadas', mastered, c.green),
            ]),
            if (total > 0) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Row(children: [
                  seg(learning, c.fill),
                  seg(firm, theme.colorScheme.secondary),
                  seg(mastered, c.green),
                ]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _section(
      ThemeData theme, AppColors c, String label, List<WordStat> items,
      {String? footer}) {
    if (items.isEmpty) return const [];
    return [
      InsetGroup(
        header: '$label (${items.length})',
        footer: footer,
        children: [for (final s in items) _wordRow(theme, c, s)],
      ),
      const SizedBox(height: 28),
    ];
  }

  Widget _wordRow(ThemeData theme, AppColors c, WordStat s) {
    final canReview = !s.mastered && widget.onReviewWord != null;
    return ListTile(
      leading: !s.mastered
          ? null
          : widget.store?.wordLevel(s.word) == WordLevel.mastered
              ? Icon(Icons.check_circle_rounded, color: c.green)
              : Icon(Icons.trending_up_rounded,
                  color: theme.colorScheme.secondary),
      title: Text(s.word),
      subtitle: Text(
          '${s.attempts} ${s.attempts == 1 ? "tentativa" : "tentativas"}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${s.bestAccuracy.round()}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: _colorFor(c, s),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (canReview) ...[
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, color: c.tertiaryLabel),
          ],
        ],
      ),
      onTap: canReview ? () => widget.onReviewWord!(s.word) : null,
    );
  }
}
