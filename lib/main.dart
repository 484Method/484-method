import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/maintenance_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/analytics_service.dart';
import 'services/backend.dart';
import 'services/backend_assessor.dart';
import 'services/device_info.dart';
import 'services/entitlement_service.dart';
import 'services/progress_store.dart';

// Injetadas em tempo de build pelos scripts em tool/ (que leem o .env).
// A chave do Azure NÃO entra aqui: a avaliação passa pela Edge Function
// `assess`, então a chave vive só como secret do Supabase (não vaza na web).
const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _boot();
}

/// Sequência de boot inteira, isolada de `main()` pra poder rodar de novo
/// quando o usuário aperta "tentar de novo" na tela de erro de conexão —
/// chamar `runApp` outra vez troca a árvore de widgets sem precisar recarregar
/// a página (Supabase.initialize é idempotente: se a 1ª tentativa já tiver
/// terminado, a 2ª só reaproveita a instância).
Future<void> _boot() async {
  // Backend é obrigatório: a avaliação de pronúncia roda pela Edge Function.
  // Sem credenciais Supabase, Backend.instance fica null → tela de setup;
  // COM credenciais mas sem conseguir conectar, também fica null, mas aí é
  // uma falha de conexão de verdade — a UI trata os dois casos diferente
  // (ver Backend.configured e _ConnectionErrorScreen).
  await Backend.init(url: _supabaseUrl, anonKey: _supabaseAnonKey);
  // Liga/desliga da fase de construção (toggle no painel do dev). Checado só
  // no boot: quem está no meio de um treino termina; ninguém novo entra.
  final maintenance =
      await Backend.instance?.fetchMaintenanceMode() ?? false;
  final store = await ProgressStore.load(backend: Backend.instance);
  final analytics = await AnalyticsService.load(backend: Backend.instance);
  // Uma vez por sessão: browser/SO/idioma agregados, nunca o user-agent cru.
  analytics.log('device_info', collectDeviceInfo());
  // Topo do funil de aquisição: quem chega ainda sem consentimento vai ver a
  // landing. (Recorrente já consentiu e cai direto no app — não conta de novo.)
  if (!store.hasVoiceConsent) analytics.log('landing_viewed');
  // Web/dev usa o fake local; mobile trocará por RevenueCat na mesma interface.
  final entitlement = await LocalEntitlementService.load();
  runApp(Method484App(
      store: store,
      analytics: analytics,
      entitlement: entitlement,
      maintenanceOnBoot: maintenance,
      connectionFailed: Backend.configured && Backend.instance == null));
}

class Method484App extends StatefulWidget {
  const Method484App({
    super.key,
    required this.store,
    required this.entitlement,
    this.analytics,
    this.maintenanceOnBoot = false,
    this.connectionFailed = false,
  });

  final ProgressStore store;
  final EntitlementService entitlement;
  final AnalyticsService? analytics;

  /// Estado da flag app_config/'maintenance' lido no boot (main). Quando
  /// true, tudo fica atrás da MaintenanceScreen até a flag ser religada.
  final bool maintenanceOnBoot;

  /// true quando SUPABASE_URL/ANON_KEY estavam preenchidas no boot mas a
  /// conexão falhou (rede ruim, projeto fora do ar) — distinto de nunca ter
  /// sido configurado. Ver _ConnectionErrorScreen.
  final bool connectionFailed;

  @override
  State<Method484App> createState() => _Method484AppState();
}

class _Method484AppState extends State<Method484App> {
  static const _navy  = Color(0xFF1B2D4F);
  static const _gold  = Color(0xFFC9A252);
  static const _cream = Color(0xFFF5F2EB);
  // Tons do tema escuro (mantêm a identidade navy/gold da marca).
  static const _darkBg   = Color(0xFF0F1626);
  static const _darkCard = Color(0xFF1B2740);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = ColorScheme.fromSeed(seedColor: _navy, brightness: brightness);
    final cs = isDark
        ? base.copyWith(
            primary: _gold, // no escuro o dourado vira o destaque (contraste)
            onPrimary: _navy,
            secondary: _gold,
            onSecondary: _navy,
            tertiary: _gold,
            onTertiary: _navy,
            surface: _darkBg,
            onSurface: _cream,
            surfaceContainerHighest: _darkCard,
          )
        : base.copyWith(
            primary: _navy,
            onPrimary: Colors.white,
            secondary: _gold,
            onSecondary: Colors.white,
            tertiary: _gold,
            onTertiary: Colors.white,
            surface: _cream,
            onSurface: _navy,
            surfaceContainerHighest: const Color(0xFFEBE7DE),
          );
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: cs.surface,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: TextTheme(
        headlineLarge:  GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, height: 1.2),
        headlineSmall:  GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600),
        titleLarge:     GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600),
        titleMedium:    GoogleFonts.playfairDisplay(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? _darkCard : _navy,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: isDark ? _darkCard : Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: isDark ? 1 : 2,
        shadowColor: isDark
            ? Colors.black.withValues(alpha: 0.4)
            : _navy.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _gold,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? _gold : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? _gold.withValues(alpha: 0.4) : null,
        ),
      ),
    );
  }

  // Landing antes do onboarding: enquadra a demo pra quem abre o link cold.
  // Em memória (some no reload) — o usuário recorrente já tem consentimento
  // e cai direto no app, sem ver a landing nem o onboarding.
  bool _introSeen = false;

  // Logo após o onboarding, leva direto à 1ª lição (conserto do funil
  // consentimento→1ª lição). A HomeScreen consome no initState (roda 1x só).
  bool _justOnboarded = false;

  // Tema: Sistema (default) / Claro / Escuro, persistido no ProgressStore.
  // `late` + inicializador: avaliado no 1º build (quando `widget` já existe).
  late ThemeMode _themeMode = _themeModeFromPref(widget.store.themePref);

  // Manutenção: começa com o valor lido no boot; a MaintenanceScreen derruba
  // via onBackOnline quando a flag é religada (sem exigir reload da página).
  late bool _maintenance = widget.maintenanceOnBoot;

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
    widget.store.setThemePref(_prefFromThemeMode(mode));
  }

  static ThemeMode _themeModeFromPref(String p) => switch (p) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  static String _prefFromThemeMode(ThemeMode m) => switch (m) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };

  @override
  Widget build(BuildContext context) {
    final Widget home;
    final backend = Backend.instance;
    if (backend == null) {
      home = widget.connectionFailed
          ? const _ConnectionErrorScreen()
          : const _MissingConfigScreen();
    } else if (_maintenance) {
      // Fase de construção: app desligado pelo painel do dev. Antes de
      // qualquer outra tela — inclusive onboarding — ninguém entra.
      home = MaintenanceScreen(
        backend: backend,
        onBackOnline: () => setState(() => _maintenance = false),
      );
    } else if (!widget.store.hasVoiceConsent) {
      // LGPD: nenhuma gravação antes do consentimento do onboarding.
      home = _introSeen
          ? OnboardingScreen(
              store: widget.store,
              onDone: () {
                widget.analytics?.log('onboarding_consent_accepted');
                // Cai direto na 1ª lição (não na dashboard vazia) — remove o
                // atrito consentimento→1ª lição e leva ao "aha" do loop.
                setState(() => _justOnboarded = true);
              },
              onBack: () => setState(() => _introSeen = false),
            )
          : IntroScreen(onStart: () {
              widget.analytics?.log('onboarding_cta_clicked');
              setState(() => _introSeen = true);
            });
    } else {
      home = HomeScreen(
        store: widget.store,
        entitlement: widget.entitlement,
        assessor: BackendPronunciationAssessor(backend),
        analytics: widget.analytics,
        autostartFirstLesson: _justOnboarded,
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
        // Exclusão de dados derruba o consentimento → volta ao onboarding.
        onDataCleared: () => setState(() {}),
      );
    }
    return MaterialApp(
      title: '484 Method',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _themeMode,
      home: home,
    );
  }
}

class _MissingConfigScreen extends StatelessWidget {
  const _MissingConfigScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Supabase não configurado.\n\n'
            '1. Copie .env.example para .env e preencha SUPABASE_URL e '
            'SUPABASE_ANON_KEY.\n'
            '2. Rode o app com: ./tool/run_web.sh',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// Credenciais configuradas, mas o boot não conseguiu falar com o Supabase
/// (rede ruim no celular, projeto pausado demorando mais que o timeout,
/// etc.) — quem vê essa tela é um usuário de verdade, não um dev sem `.env`,
/// então a mensagem e a ação (tentar de novo) são as dele.
class _ConnectionErrorScreen extends StatefulWidget {
  const _ConnectionErrorScreen();

  @override
  State<_ConnectionErrorScreen> createState() =>
      _ConnectionErrorScreenState();
}

class _ConnectionErrorScreenState extends State<_ConnectionErrorScreen> {
  bool _retrying = false;

  Future<void> _retry() async {
    setState(() => _retrying = true);
    // Refaz o boot inteiro; se conectar dessa vez, o runApp novo substitui
    // esta tela. Se falhar de novo, _boot() volta a montar esta mesma tela
    // (novo connectionFailed=true) e o spinner some.
    await _boot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2D4F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  color: Color(0xFFF5F2EB), size: 40),
              const SizedBox(height: 16),
              const Text(
                'Não foi possível conectar.\nVerifique sua internet e tente de novo.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFF5F2EB), fontSize: 16),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _retrying ? null : _retry,
                child: _retrying
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Tentar de novo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
