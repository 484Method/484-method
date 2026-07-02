import 'package:flutter/material.dart';

import '../services/backend.dart';
import 'stats_screen.dart';

/// Tela exibida quando o liga/desliga do app (app_config/'maintenance') está
/// desligado — fase de construção. Bloqueia o uso, mas precisa de uma saída
/// para o próprio dev: pressionar e segurar o ícone abre o gate de senha do
/// painel, de onde a flag pode ser religada; ao voltar (e no botão "Verificar
/// de novo") a flag é rechecada e, se o app voltou ao ar, [onBackOnline]
/// destrava a navegação normal sem exigir reload.
class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({
    super.key,
    required this.backend,
    required this.onBackOnline,
  });

  /// Nullable só para testes de widget (sem Supabase); em produção a tela só
  /// aparece quando o backend existe (a flag vem dele).
  final Backend? backend;
  final VoidCallback onBackOnline;

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  bool _checking = false;

  Future<void> _recheck() async {
    final backend = widget.backend;
    if (backend == null || _checking) return;
    setState(() => _checking = true);
    final stillOff = await backend.fetchMaintenanceMode();
    if (!mounted) return;
    setState(() => _checking = false);
    if (!stillOff) {
      widget.onBackOnline();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ainda em ajustes. Tente mais tarde.')),
      );
    }
  }

  Future<void> _openDevPanel() async {
    final backend = widget.backend;
    if (backend == null) return;
    await StatsScreen.openWithPasswordGate(context, backend);
    // Dev pode ter religado o app pelo painel — rechecar sem avisar de erro.
    if (!mounted) return;
    final stillOff = await backend.fetchMaintenanceMode();
    if (mounted && !stillOff) widget.onBackOnline();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Acesso oculto do dev: segurar o ícone abre o gate de senha.
                GestureDetector(
                  onLongPress: _openDevPanel,
                  child: Icon(Icons.construction,
                      size: 64, color: theme.colorScheme.secondary),
                ),
                const SizedBox(height: 24),
                Text(
                  'Estamos ajustando o treino',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'O 484 Method está temporariamente fora do ar para '
                  'melhorias. Seu progresso está guardado — volte em breve '
                  'para continuar de onde parou.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: _checking ? null : _recheck,
                  icon: _checking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label: const Text('Verificar de novo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
