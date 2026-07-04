import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/analytics_service.dart';
import '../services/backend.dart';
import '../services/entitlement_service.dart';
import '../services/pricing.dart';
import '../services/progress_store.dart';

/// Oferta "Beta Fundador" instrumentada — um teste de willingness-to-pay com
/// COBRANÇA REAL (Pix manual, memo §13 Opção B). Cada usuário vê uma variante
/// de preço ESTÁVEL ([PriceVariant], atribuída pelo ProgressStore) e o funil é
/// logado com o `price_bucket`: `paywall_viewed` → `paywall_subscribe_clicked`
/// → `pix_checkout_started` → `access_code_redeemed` (a conversão que importa,
/// = pagou). Curva de demanda por preço sai daí.
///
/// Fluxo Pix: mostra a chave Pix do dev (app_config 'pix') + o valor; o
/// comprador paga no banco, recebe um código de Fundador (o dev gera no painel
/// e entrega) e resgata aqui → vira Fundador ([EntitlementService]). Quem não
/// quer pagar agora ainda pode entrar na lista por e-mail (fake door, sinal
/// mais fraco). Sem backend, cai direto na lista.
/// Busca a config Pix (chave/nome) — normalmente [Backend.fetchPixConfig].
typedef PixConfigFetcher = Future<Map<String, dynamic>?> Function();

/// Resgata um código de Fundador — normalmente [Backend.redeemAccessCode].
typedef CodeRedeemer = Future<bool> Function(String code);

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({
    super.key,
    required this.store,
    required this.entitlement,
    this.backend,
    this.analytics,
    this.fetchPixConfigOverride,
    this.redeemOverride,
  });

  final ProgressStore store;
  final EntitlementService entitlement;
  final Backend? backend;
  final AnalyticsService? analytics;

  /// Seams de teste: injetam as operações de rede (Pix/resgate) sem depender do
  /// [Backend] concreto (construtor privado + SupabaseClient real). Em produção
  /// ficam null e o fluxo usa o [backend].
  final PixConfigFetcher? fetchPixConfigOverride;
  final CodeRedeemer? redeemOverride;

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

enum _Step { offer, pix, code, email, done }

class _PaywallScreenState extends State<PaywallScreen> {
  // Estável durante toda a sessão do paywall (não re-sorteia a cada rebuild).
  late final PriceVariant _variant = widget.store.assignedPriceVariant();
  _Step _step = _Step.offer;

  final _emailController = TextEditingController();
  bool _emailValid = false;

  final _codeController = TextEditingController();
  bool _redeeming = false;
  String? _codeError;

  Map<String, dynamic>? _pixConfig;
  bool _loadingPix = false;

  bool _becameFounder = false; // done: virou Fundador vs. só entrou na lista

  Map<String, Object?> get _priceProps => {
        'price_bucket': _variant.bucket,
        'amount_cents': _variant.amountCents,
      };

  @override
  void initState() {
    super.initState();
    widget.analytics?.log('paywall_viewed', _priceProps);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  // Operações de rede: override de teste, senão o backend (ou null se offline).
  PixConfigFetcher? get _pixFetcher =>
      widget.fetchPixConfigOverride ?? widget.backend?.fetchPixConfig;
  CodeRedeemer? get _redeemer =>
      widget.redeemOverride ?? widget.backend?.redeemAccessCode;

  /// CTA principal: leva ao pagamento via Pix. Sem como cobrar (a chave e a
  /// validação vivem no servidor) → cai na lista de e-mail.
  Future<void> _startCheckout() async {
    widget.analytics?.log('paywall_subscribe_clicked', _priceProps);
    final fetch = _pixFetcher;
    if (fetch == null) {
      setState(() => _step = _Step.email);
      return;
    }
    setState(() {
      _step = _Step.pix;
      _loadingPix = true;
    });
    final cfg = await fetch();
    if (!mounted) return;
    setState(() {
      _pixConfig = cfg;
      _loadingPix = false;
    });
    widget.analytics?.log('pix_checkout_started', _priceProps);
  }

  void _copyPixKey() {
    final key = _pixConfig?['key'] as String?;
    if (key == null) return;
    Clipboard.setData(ClipboardData(text: key));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Chave Pix copiada.')));
  }

  Future<void> _redeem() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    setState(() {
      _redeeming = true;
      _codeError = null;
    });
    final ok = await (_redeemer?.call(code) ?? Future.value(false));
    if (!mounted) return;
    if (ok) {
      await widget.entitlement.setFounderAccess(true);
      widget.analytics?.log('access_code_redeemed', _priceProps);
      if (!mounted) return;
      setState(() {
        _becameFounder = true;
        _step = _Step.done;
        _redeeming = false;
      });
    } else {
      setState(() {
        _codeError = 'Código inválido ou já usado. Confira e tente de novo.';
        _redeeming = false;
      });
    }
  }

  Future<void> _submitEmail() async {
    final email = _emailController.text.trim();
    widget.analytics?.log('paywall_email_captured', {
      ..._priceProps,
      'email': email,
    });
    await widget.store.setLeftFounderEmail();
    if (!mounted) return;
    setState(() => _step = _Step.done);
  }

  void _dismiss() {
    if (_step == _Step.offer) {
      widget.analytics?.log('paywall_dismissed', _priceProps);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: switch (_step) {
              _Step.offer => _offer(theme),
              _Step.pix => _pix(theme),
              _Step.code => _code(theme),
              _Step.email => _email(theme),
              _Step.done => _done(theme),
            },
          ),
        ),
      ),
    );
  }

  Widget _offer(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.workspace_premium,
            size: 64, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text('Seja um Fundador do 484',
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          'Você já provou que consegue falar. Os primeiros que apoiarem o '
          'projeto garantem acesso vitalício e ajudam a decidir o que vem '
          'depois da Trilha 1.',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _benefit(theme, Icons.lock_open,
            'Acesso vitalício de Fundador — sem mensalidade'),
        _benefit(theme, Icons.record_voice_over,
            'Feedback de pronúncia em português, em cada tentativa'),
        _benefit(theme, Icons.rocket_launch,
            'Acesso antecipado às próximas trilhas, à medida que saem'),
        _benefit(theme, Icons.favorite,
            'Você molda o produto: fala direto com quem constrói'),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: [
            Text(
              _variant.priceLabel,
              style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 4),
            Text(_variant.cadenceLabel, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Text(
              'Pagamento único via Pix. Sem assinatura.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ]),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _startCheckout,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Quero ser Fundador'),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _step = _Step.email),
          child: const Text('Ainda não posso pagar — me avise depois'),
        ),
        TextButton(
          onPressed: _dismiss,
          child: const Text('Agora não'),
        ),
      ],
    );
  }

  Widget _pix(ThemeData theme) {
    if (_loadingPix) {
      return const Padding(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    // Chave Pix ainda não configurada no servidor → cai no fake door (lista).
    if (_pixConfig == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.schedule, size: 56, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text('Pagamento abrindo',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            'O Pix está sendo configurado. Deixe seu e-mail e a gente te chama '
            'pra fechar como Fundador pelo preço de ${_variant.priceLabel}.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => setState(() => _step = _Step.email),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Entrar na lista'),
            ),
          ),
        ],
      );
    }

    final key = _pixConfig!['key'] as String? ?? '';
    final name = _pixConfig!['name'] as String? ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.pix, size: 56, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text('Pague ${_variant.priceLabel} via Pix',
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chave Pix', style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: SelectableText(key,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  IconButton(
                    onPressed: _copyPixKey,
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copiar chave',
                  ),
                ],
              ),
              if (name.isNotEmpty)
                Text('em nome de $name', style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _pixStep(theme, '1',
            'Abra seu banco e faça um Pix de ${_variant.priceLabel} para essa chave.'),
        _pixStep(theme, '2',
            'Toque em "Já paguei" — a gente confere e te envia um código de Fundador.'),
        _pixStep(theme, '3', 'Digite o código aqui para ativar seu acesso.'),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => setState(() => _step = _Step.code),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Já paguei / tenho um código'),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _step = _Step.email),
          child: const Text('Prefiro entrar na lista por e-mail'),
        ),
      ],
    );
  }

  Widget _pixStep(ThemeData theme, String n, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            child: Text(n, style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _code(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.vpn_key, size: 56, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text('Ativar Fundador',
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('Digite o código de Fundador que você recebeu depois de pagar.',
            style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        TextField(
          controller: _codeController,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: 'Código (ex.: FUND-ABC123)',
            border: const OutlineInputBorder(),
            errorText: _codeError,
          ),
          onChanged: (_) {
            if (_codeError != null) setState(() => _codeError = null);
          },
          onSubmitted: (_) => _redeem(),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _redeeming ? null : _redeem,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _redeeming
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Ativar meu acesso'),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _step = _Step.pix),
          child: const Text('Voltar'),
        ),
      ],
    );
  }

  Widget _email(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.mark_email_read_outlined,
            size: 56, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text('Garanta seu preço de Fundador',
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          'Deixe seu e-mail: você entra na lista de Fundadores e trava o preço '
          'de ${_variant.priceLabel} — a gente te chama primeiro.',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Seu melhor e-mail',
            border: OutlineInputBorder(),
          ),
          onChanged: (v) {
            final valid = _emailRegex.hasMatch(v.trim());
            if (valid != _emailValid) setState(() => _emailValid = valid);
          },
          onSubmitted: (_) {
            if (_emailValid) _submitEmail();
          },
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _emailValid ? _submitEmail : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Garantir minha vaga'),
          ),
        ),
        TextButton(
          onPressed: _dismiss,
          child: const Text('Agora não'),
        ),
        const SizedBox(height: 8),
        Text(
          'Só pra te avisar da abertura. Sem spam; você pode sair quando '
          'quiser.',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _done(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(_becameFounder ? Icons.workspace_premium : Icons.check_circle,
            size: 64, color: theme.colorScheme.secondary),
        const SizedBox(height: 16),
        Text(
            _becameFounder
                ? 'Você é Fundador do 484! 🎉'
                : 'Você está na lista de Fundadores',
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          _becameFounder
              ? 'Obrigado por apoiar o 484 desde o começo. Seu acesso de '
                  'Fundador está ativo — bora treinar.'
              : 'Assim que abrir a leva, a gente te chama com o preço de '
                  'Fundador garantido. Enquanto isso, continue treinando.',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Voltar a treinar'),
          ),
        ),
      ],
    );
  }

  Widget _benefit(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ]),
    );
  }
}
