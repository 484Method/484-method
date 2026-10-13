import 'package:flutter/material.dart';

import '../services/backend.dart';
import '../ui/app_style.dart';
import 'stats_screen.dart';

/// Tela exibida quando o liga/desliga do app (app_config/'maintenance') está
/// desligado — fase de construção. Bloqueia o uso, mas precisa de uma saída
/// para o próprio dev: pressionar e segurar o ícone abre o painel, de onde a
/// flag pode ser religada; ao voltar (e no botão "Verificar de novo") a flag
/// é rechecada e, se o app voltou ao ar, [onBackOnline] destrava a navegação
/// normal sem exigir reload.
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
    await StatsScreen.open(context, backend);
    // Dev pode ter religado o app pelo painel — rechecar sem avisar de erro.
    if (!mounted) return;
    final stillOff = await backend.fetchMaintenanceMode();
    if (mounted && !stillOff) widget.onBackOnline();
  }

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
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppStyle.pagePadding, vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Acesso oculto do dev: segurar o ícone abre o painel.
                          GestureDetector(
                            onLongPress: _openDevPanel,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: c.fill,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.construction,
                                  size: 40, color: c.secondaryLabel),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Estamos ajustando o treino',
                            style: text.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'O 484 Method está fora do ar por um tempo para '
                            'melhorias. Seu progresso está guardado. Volte em '
                            'breve para continuar de onde parou.',
                            style: text.bodyLarge
                                ?.copyWith(color: c.secondaryLabel),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                BottomActions(
                  children: [
                    FilledButton(
                      onPressed: _checking ? null : _recheck,
                      child: _checking
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Verificar de novo'),
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
}
