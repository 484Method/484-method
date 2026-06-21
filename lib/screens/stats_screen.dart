import 'package:flutter/material.dart';

import '../services/backend.dart';

/// Painel de uso agregado — para mostrar tração a investidores.
/// Chama a RPC get_public_stats() (SECURITY DEFINER, sem PII) que
/// retorna contagens de todos os usuários anônimos.
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key, required this.backend});
  final Backend backend;

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Map<String, dynamic>? _stats;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await widget.backend.client.rpc('get_public_stats');
      setState(() { _stats = Map<String, dynamic>.from(res as Map); _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de uso'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Erro: $_error'))
              : _Body(stats: _stats!, theme: theme),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.stats, required this.theme});
  final Map<String, dynamic> stats;
  final ThemeData theme;

  String _fmtTime(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return s == 0 ? '${m}min' : '${m}min ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final users = stats['total_users'] as int? ?? 0;
    final completed = stats['total_lessons_completed'] as int? ?? 0;
    final attempts = stats['total_attempts'] as int? ?? 0;
    final approvedSecs = (stats['total_approved_seconds'] as num?)?.toInt() ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Dados ao vivo · todos os usuários',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.outline),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          _grid([
            _Metric(
              icon: Icons.people_outline,
              label: 'Usuários',
              value: '$users',
              sub: 'sessões únicas',
              color: theme.colorScheme.primary,
            ),
            _Metric(
              icon: Icons.check_circle_outline,
              label: 'Lições concluídas',
              value: '$completed',
              sub: 'no total',
              color: Colors.green.shade600,
            ),
            _Metric(
              icon: Icons.mic_outlined,
              label: 'Gravações avaliadas',
              value: '$attempts',
              sub: 'tentativas',
              color: Colors.orange.shade700,
            ),
            _Metric(
              icon: Icons.timer_outlined,
              label: 'Treino aprovado',
              value: _fmtTime(approvedSecs),
              sub: 'fala real',
              color: Colors.purple.shade600,
            ),
          ]),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Métrica norte do produto',
                    style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(
                  'Minutos de prática oral aprovada — '
                  'não tempo de tela, não lições iniciadas.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: approvedSecs / (484 * 3600),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_fmtTime(approvedSecs)} de 484h acumulados pelos usuários',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _grid(List<_Metric> metrics) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
        children: metrics.map((m) => _MetricCard(m: m)).toList(),
      );
}

class _Metric {
  const _Metric({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final Color color;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.m});
  final _Metric m;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: m.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: m.color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(m.icon, color: m.color, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(m.value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: m.color)),
              Text(m.label,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              Text(m.sub,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline)),
            ],
          ),
        ],
      ),
    );
  }
}
