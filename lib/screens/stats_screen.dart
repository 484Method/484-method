import 'package:flutter/material.dart';

import '../services/backend.dart';

/// Painel de uso — apenas para o desenvolvedor (acessível via menu oculto).
/// Chama get_dev_stats() (SECURITY DEFINER) que agrega dados de todos os
/// usuários sem expor PII.
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
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await widget.backend.client.rpc('get_dev_stats');
      setState(() {
        _stats = Map<String, dynamic>.from(res as Map);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do desenvolvedor'),
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

  @override
  Widget build(BuildContext context) {
    final totalUsers       = (stats['total_users']         as num?)?.toInt() ?? 0;
    final usersToday       = (stats['users_today']         as num?)?.toInt() ?? 0;
    final users7d          = (stats['users_7d']            as num?)?.toInt() ?? 0;
    final users30d         = (stats['users_30d']           as num?)?.toInt() ?? 0;
    final usersStreak      = (stats['users_with_streak']   as num?)?.toInt() ?? 0;
    final totalAttempts    = (stats['total_attempts']      as num?)?.toInt() ?? 0;
    final totalCompleted   = (stats['total_completed']     as num?)?.toInt() ?? 0;
    final avgAccuracy      = (stats['avg_accuracy']        as num?)?.toInt() ?? 0;
    final approvedMin      = (stats['total_approved_min']  as num?)?.toInt() ?? 0;
    final startedNotDone   = (stats['started_not_finished']as num?)?.toInt() ?? 0;
    final funnel           = (stats['funnel'] as Map?)?.cast<String, dynamic>() ?? {};
    final dau              = (stats['dau_14d'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Usuários ──────────────────────────────────────────────────
          _section('Usuários'),
          _grid([
            _Metric(Icons.people_outline,      '$totalUsers',   'Total',      Colors.blue.shade600),
            _Metric(Icons.today,               '$usersToday',   'Hoje',       Colors.green.shade600),
            _Metric(Icons.date_range,          '$users7d',      'Últimos 7d', Colors.orange.shade700),
            _Metric(Icons.calendar_month,      '$users30d',     'Últimos 30d',Colors.purple.shade600),
          ]),
          const SizedBox(height: 8),
          _row(theme, Icons.local_fire_department, 'Com streak ativo', '$usersStreak usuários'),
          _row(theme, Icons.exit_to_app, 'Iniciaram mas não concluíram nenhuma lição', '$startedNotDone usuários'),

          // ── Engajamento ───────────────────────────────────────────────
          const SizedBox(height: 24),
          _section('Engajamento'),
          _grid([
            _Metric(Icons.mic_outlined,        '$totalAttempts','Gravações',  Colors.indigo.shade600),
            _Metric(Icons.check_circle_outline,'$totalCompleted','Lições OK', Colors.green.shade700),
            _Metric(Icons.grade_outlined,      '$avgAccuracy',  'Média /100', Colors.amber.shade700),
            _Metric(Icons.timer_outlined,      '${approvedMin}min','Aprovados',Colors.teal.shade600),
          ]),

          // ── Funil por lição ───────────────────────────────────────────
          if (funnel.isNotEmpty) ...[
            const SizedBox(height: 24),
            _section('Funil — usuários que completaram cada lição'),
            const SizedBox(height: 8),
            ...funnel.entries.map((e) {
              final users = (e.value as num).toInt();
              final frac  = totalUsers > 0 ? users / totalUsers : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key, style: theme.textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                        Text('$users usuários (${(frac * 100).round()}%)',
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: frac,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.green.shade600,
                    ),
                  ],
                ),
              );
            }),
          ],

          // ── DAU últimos 14 dias ───────────────────────────────────────
          if (dau.isNotEmpty) ...[
            const SizedBox(height: 24),
            _section('Usuários ativos — últimos 14 dias'),
            const SizedBox(height: 8),
            ...dau.map((d) {
              final day  = d['day'] as String? ?? '';
              final u    = (d['users'] as num?)?.toInt() ?? 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  SizedBox(
                    width: 90,
                    child: Text(day.length > 10 ? day.substring(5, 10) : day,
                        style: theme.textTheme.bodySmall),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: u / (totalUsers > 0 ? totalUsers : 1),
                      minHeight: 14,
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.blue.shade400,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('$u', style: theme.textTheme.bodySmall),
                ]),
              );
            }),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(title,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
      );

  Widget _row(ThemeData t, IconData icon, String label, String value) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Icon(icon, size: 16, color: t.colorScheme.outline),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: t.textTheme.bodySmall)),
          Text(value,
              style: t.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ]),
      );

  Widget _grid(List<_Metric> items) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4,
        children: items.map((m) => _Card(m)).toList(),
      );
}

class _Metric {
  const _Metric(this.icon, this.value, this.label, this.color);
  final IconData icon;
  final String value;
  final String label;
  final Color color;
}

class _Card extends StatelessWidget {
  const _Card(this.m);
  final _Metric m;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: m.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: m.color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(m.icon, color: m.color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(m.value,
                  style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold, color: m.color)),
              Text(m.label, style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
