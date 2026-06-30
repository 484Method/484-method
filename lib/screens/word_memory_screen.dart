import 'package:flutter/material.dart';

import '../services/backend.dart';

/// Estatística por palavra: melhor accuracy, nº de tentativas e se já foi
/// aprovada alguma vez (= dominada).
class WordStat {
  const WordStat({
    required this.word,
    required this.attempts,
    required this.bestAccuracy,
    required this.mastered,
  });

  final String word;
  final int attempts;
  final double bestAccuracy;
  final bool mastered;
}

/// Agrega as tentativas (eventos `attempt_assessed`) do usuário em duas listas:
/// "a revisar" (nunca aprovadas, da pior accuracy pra melhor) e "dominadas"
/// (aprovadas alguma vez, da melhor pra pior). Função pura — testável sem rede.
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
    var best = 0.0;
    var mastered = false;
    for (final a in attempts) {
      final acc = (a['accuracy'] as num?)?.toDouble() ?? 0;
      if (acc > best) best = acc;
      if (a['approved'] == true) mastered = true;
    }
    stats.add(WordStat(
      word: word,
      attempts: attempts.length,
      bestAccuracy: best,
      mastered: mastered,
    ));
  });

  final review = stats.where((s) => !s.mastered).toList()
    ..sort((a, b) => a.bestAccuracy.compareTo(b.bestAccuracy));
  final mastered = stats.where((s) => s.mastered).toList()
    ..sort((a, b) => b.bestAccuracy.compareTo(a.bestAccuracy));
  return (review: review, mastered: mastered);
}

/// "Minhas palavras": a memória de erros e acertos do aluno. Lista o que
/// revisar (palavras ainda não aprovadas) e o que já dominou, a partir do
/// histórico de tentativas no backend. Read-only — é revisão, não treino; as
/// palavras aqui já passaram do Livro Aberto, então exibi-las não fere o
/// princípio som-first.
class WordMemoryScreen extends StatefulWidget {
  const WordMemoryScreen({super.key});

  @override
  State<WordMemoryScreen> createState() => _WordMemoryScreenState();
}

class _WordMemoryScreenState extends State<WordMemoryScreen> {
  late final Future<List<Map<String, dynamic>>> _future =
      Backend.instance?.fetchAttemptHistory() ?? Future.value(const []);

  Color _colorFor(double accuracy) {
    if (accuracy >= 80) return Colors.green.shade600;
    if (accuracy >= 60) return Colors.orange.shade700;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas palavras')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final mem = aggregateWordMemory(snap.data ?? const []);
          if (mem.review.isEmpty && mem.mastered.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Pratique algumas lições e suas palavras aparecem aqui — '
                  'o que revisar e o que você já domina.',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  if (mem.review.isNotEmpty) ...[
                    _sectionTitle(theme, 'A revisar', mem.review.length),
                    const SizedBox(height: 8),
                    for (final s in mem.review) _wordTile(theme, s),
                    const SizedBox(height: 24),
                  ],
                  if (mem.mastered.isNotEmpty) ...[
                    _sectionTitle(theme, 'Dominadas', mem.mastered.length),
                    const SizedBox(height: 8),
                    for (final s in mem.mastered) _wordTile(theme, s),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, String label, int n) => Text(
        '$label ($n)',
        style: theme.textTheme.titleMedium
            ?.copyWith(color: theme.colorScheme.secondary),
      );

  Widget _wordTile(ThemeData theme, WordStat s) {
    final color = _colorFor(s.bestAccuracy);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(s.mastered ? Icons.check : Icons.refresh,
              color: color, size: 20),
        ),
        title: Text(s.word),
        subtitle: Text(
            '${s.attempts} ${s.attempts == 1 ? "tentativa" : "tentativas"}'),
        trailing: Text(
          '${s.bestAccuracy.round()}',
          style: theme.textTheme.titleMedium
              ?.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
