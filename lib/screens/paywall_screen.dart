import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/analytics_service.dart';
import '../services/backend.dart';
import '../services/entitlement_service.dart';
import '../services/pricing.dart';
import '../services/progress_store.dart';
import '../ui/app_style.dart';

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

  /// Preço pra exibir no meio de frase: espaço inseparável entre "R$" e o
  /// número, pra quebra de linha nunca separar os dois.
  String get _priceText => _variant.priceLabel.replaceAll(' ', '\u00A0');

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
      // Trava o preço que a pessoa pagou — é o que honra a promessa "preço de
      // Fundador travado pra sempre" quando houver conteúdo pago (Fase 2+).
      await widget.store.lockFounderPrice(_variant);
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
    final onOffer = _step == _Step.offer;
    return Scaffold(
      // Na oferta, a saída é o "Agora não" no canto (como nas folhas de
      // oferta do iOS), que registra o `paywall_dismissed`.
      appBar: AppBar(
        automaticallyImplyLeading: !onOffer,
        actions: [
          if (onOffer)
            TextButton(onPressed: _dismiss, child: const Text('Agora não')),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(
          key: ValueKey(_step),
          child: switch (_step) {
            _Step.offer => _offer(theme),
            _Step.pix => _pix(theme),
            _Step.code => _code(theme),
            _Step.email => _email(theme),
            _Step.done => _done(theme),
          },
        ),
      ),
    );
  }

  /// Esqueleto de cada etapa: conteúdo rolável em cima, ações presas embaixo
  /// (zona do polegar). Ficar no body (e não no bottomNavigationBar) mantém o
  /// botão acima do teclado nas etapas com campo de texto.
  Widget _layout({
    required List<Widget> content,
    List<Widget> actions = const [],
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppStyle.maxContentWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              // Esmaece a borda de baixo: o conteúdo some suave sob as ações
              // presas, em vez de ser cortado seco.
              child: ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [Colors.black, Colors.black, Colors.transparent],
                  stops: [0, 1 - (24 / rect.height).clamp(0.0, 1.0), 1],
                ).createShader(rect),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                      AppStyle.pagePadding, 8, AppStyle.pagePadding, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: content,
                  ),
                ),
              ),
            ),
            if (actions.isNotEmpty) BottomActions(children: actions),
          ],
        ),
      ),
    );
  }

  /// Cabeçalho centralizado: glifo num círculo, título grande e uma frase.
  List<Widget> _header(
    ThemeData theme, {
    required IconData icon,
    required Color color,
    required Color fill,
    required String title,
    String? body,
    TextStyle? titleStyle,
  }) {
    final c = AppColors.of(context);
    return [
      const SizedBox(height: 8),
      Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
          child: Icon(icon, size: 40, color: color),
        ),
      ),
      const SizedBox(height: 20),
      Text(title,
          style: titleStyle ?? theme.textTheme.headlineLarge,
          textAlign: TextAlign.center),
      if (body != null) ...[
        const SizedBox(height: 10),
        Text(body,
            style: theme.textTheme.bodyLarge?.copyWith(color: c.secondaryLabel),
            textAlign: TextAlign.center),
      ],
    ];
  }

  Widget _offer(ThemeData theme) {
    final c = AppColors.of(context);
    return _layout(
      content: [
        ..._header(
          theme,
          icon: Icons.workspace_premium_rounded,
          color: theme.colorScheme.secondary,
          fill: c.goldFill,
          // Espaço inseparável: "do 484" nunca fica órfão na 2ª linha.
          title: 'Seja um Fundador do\u00A0484',
          titleStyle: theme.textTheme.displaySmall,
          body: 'A Trilha 1 é grátis pra todo mundo. Quem entra como Fundador '
              'agora trava o acesso e o preço de tudo que vem depois, e ajuda '
              'a decidir o que construir.',
        ),
        const SizedBox(height: 28),
        InsetGroup(children: [
          _benefit(Icons.rocket_launch_rounded,
              'Acesso antecipado às próximas trilhas, à medida que saem'),
          _benefit(Icons.lock_rounded,
              'Preço de Fundador travado pra sempre, sem mensalidade'),
          _benefit(Icons.workspace_premium_rounded,
              'Selo de Fundador no app: você esteve aqui desde o começo'),
          _benefit(Icons.favorite_rounded,
              'Você molda o produto: fala direto com quem constrói'),
        ]),
      ],
      // O preço fica colado no botão: quem toca em "Quero ser Fundador" já
      // viu o valor da sua variante (o teste de preço depende disso).
      actions: [
        _price(theme),
        const SizedBox(height: 14),
        FilledButton(
          onPressed: _startCheckout,
          child: const Text('Quero ser Fundador'),
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: () => setState(() => _step = _Step.email),
          child: const Text('Ainda não posso pagar, me avise depois',
              textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _price(ThemeData theme) {
    final small = theme.textTheme.bodySmall;
    return Column(
      children: [
        Text(
          _priceText,
          style: theme.textTheme.headlineLarge?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(_variant.cadenceLabel, style: small, textAlign: TextAlign.center),
        Text('Pagamento único via Pix. Sem assinatura.',
            style: small, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _benefit(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
    );
  }

  Widget _pix(ThemeData theme) {
    final c = AppColors.of(context);
    if (_loadingPix) {
      return const Center(child: CircularProgressIndicator());
    }
    // Chave Pix ainda não configurada no servidor → cai no fake door (lista).
    if (_pixConfig == null) {
      return _layout(
        content: [
          const SizedBox(height: 24),
          ..._header(
            theme,
            icon: Icons.schedule_rounded,
            color: c.secondaryLabel,
            fill: c.fill,
            title: 'Pagamento abrindo',
            body: 'O Pix está sendo configurado. Deixe seu e-mail e a gente te '
                'chama pra fechar como Fundador pelo preço de '
                '$_priceText.',
          ),
        ],
        actions: [
          FilledButton(
            onPressed: () => setState(() => _step = _Step.email),
            child: const Text('Entrar na lista'),
          ),
        ],
      );
    }

    final key = _pixConfig!['key'] as String? ?? '';
    final name = _pixConfig!['name'] as String? ?? '';
    return _layout(
      content: [
        ..._header(
          theme,
          icon: Icons.pix_rounded,
          color: theme.colorScheme.primary,
          fill: c.accentFill,
          title: 'Pague $_priceText via Pix',
        ),
        const SizedBox(height: 28),
        InsetGroup(
          header: 'Chave Pix',
          footer: name.isNotEmpty ? 'Em nome de $name' : null,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 4, 6),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(key,
                        style: theme.textTheme.titleMedium),
                  ),
                  IconButton(
                    onPressed: _copyPixKey,
                    icon: const Icon(Icons.content_copy_rounded),
                    tooltip: 'Copiar chave',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        InsetGroup(
          header: 'Como funciona',
          children: [
            _pixStep(theme, '1',
                'Abra seu banco e faça um Pix de $_priceText para essa chave.'),
            _pixStep(theme, '2',
                'Toque em "Já paguei": a gente confere e te envia um código de Fundador.'),
            _pixStep(theme, '3', 'Digite o código aqui para ativar seu acesso.'),
          ],
        ),
      ],
      actions: [
        FilledButton(
          onPressed: () => setState(() => _step = _Step.code),
          child: const Text('Já paguei / tenho um código'),
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: () => setState(() => _step = _Step.email),
          child: const Text('Prefiro entrar na lista por e-mail'),
        ),
      ],
    );
  }

  Widget _pixStep(ThemeData theme, String n, String text) {
    final c = AppColors.of(context);
    return ListTile(
      leading: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: c.fill, shape: BoxShape.circle),
        child: Text(n, style: theme.textTheme.titleSmall),
      ),
      title: Text(text),
    );
  }

  /// Campo sem borda própria: quem desenha o cartão é o [InsetGroup], como
  /// nos formulários do iOS (mesmo padrão do cadastro).
  static InputDecoration _field(String hint) => InputDecoration(
        hintText: hint,
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      );

  Widget _code(ThemeData theme) {
    final c = AppColors.of(context);
    return _layout(
      content: [
        ..._header(
          theme,
          icon: Icons.key_rounded,
          color: theme.colorScheme.primary,
          fill: c.accentFill,
          title: 'Ativar Fundador',
          body: 'Digite o código de Fundador que você recebeu depois de pagar.',
        ),
        const SizedBox(height: 28),
        InsetGroup(children: [
          TextField(
            controller: _codeController,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            style: theme.textTheme.bodyLarge,
            decoration: _field('Código (ex.: FUND-ABC123)'),
            onChanged: (_) {
              if (_codeError != null) setState(() => _codeError = null);
            },
            onSubmitted: (_) => _redeem(),
          ),
        ]),
        if (_codeError != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(_codeError!,
                style: theme.textTheme.bodySmall?.copyWith(color: c.red)),
          ),
      ],
      actions: [
        FilledButton(
          onPressed: _redeeming ? null : _redeem,
          child: _redeeming
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Ativar meu acesso'),
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: () => setState(() => _step = _Step.pix),
          child: const Text('Voltar'),
        ),
      ],
    );
  }

  Widget _email(ThemeData theme) {
    final c = AppColors.of(context);
    return _layout(
      content: [
        ..._header(
          theme,
          icon: Icons.mark_email_read_rounded,
          color: theme.colorScheme.primary,
          fill: c.accentFill,
          title: 'Garanta seu preço de Fundador',
          body: 'Deixe seu e-mail: você entra na lista de Fundadores e trava o '
              'preço de $_priceText. A gente te chama primeiro.',
        ),
        const SizedBox(height: 28),
        InsetGroup(
          footer: 'Só pra te avisar da abertura. Sem spam; você pode sair '
              'quando quiser.',
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              style: theme.textTheme.bodyLarge,
              decoration: _field('Seu melhor e-mail'),
              onChanged: (v) {
                final valid = _emailRegex.hasMatch(v.trim());
                if (valid != _emailValid) setState(() => _emailValid = valid);
              },
              onSubmitted: (_) {
                if (_emailValid) _submitEmail();
              },
            ),
          ],
        ),
      ],
      actions: [
        FilledButton(
          onPressed: _emailValid ? _submitEmail : null,
          child: const Text('Garantir minha vaga'),
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: _dismiss,
          child: const Text('Agora não'),
        ),
      ],
    );
  }

  Widget _done(ThemeData theme) {
    final c = AppColors.of(context);
    return _layout(
      content: [
        const SizedBox(height: 24),
        ..._header(
          theme,
          icon: _becameFounder
              ? Icons.workspace_premium_rounded
              : Icons.check_circle_rounded,
          color: _becameFounder ? theme.colorScheme.secondary : c.green,
          fill: _becameFounder ? c.goldFill : c.greenFill,
          title: _becameFounder
              ? 'Você é Fundador do 484!'
              : 'Você está na lista de Fundadores',
          // Um passo menor que as outras etapas: "Fundador do 484!" cabe
          // numa linha no iPhone, sem "484!" órfão.
          titleStyle: theme.textTheme.headlineMedium,
          body: _becameFounder
              ? 'Obrigado por apoiar o 484 desde o começo. Seu acesso de '
                  'Fundador está ativo. Bora treinar.'
              : 'Assim que abrir a leva, a gente te chama com o preço de '
                  'Fundador garantido. Enquanto isso, continue treinando.',
        ),
        if (_becameFounder) ...[
          const SizedBox(height: 28),
          _lockedPrice(theme),
        ],
      ],
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Voltar a treinar'),
        ),
      ],
    );
  }

  /// Torna visível a promessa cumprida: o preço travado que vale pras próximas
  /// trilhas. Lê do store (persistido no resgate), com fallback pra variante
  /// vista caso o resgate tenha ocorrido nesta mesma sessão.
  Widget _lockedPrice(ThemeData theme) {
    final label = (widget.store.founderLockedPriceLabel ?? _variant.priceLabel)
        .replaceAll(' ', '\u00A0');
    return InsetGroup(children: [
      ListTile(
        leading: Icon(Icons.lock_rounded, color: theme.colorScheme.secondary),
        title: Text('Preço de Fundador travado: $label pras próximas trilhas'),
      ),
    ]);
  }
}
