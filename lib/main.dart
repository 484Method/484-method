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
import 'ui/app_style.dart';

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
  // Visual "clean", inspirado nos apps da Apple (2026-10-13): neutros +
  // um acento só, tipografia fazendo a hierarquia, cartões brancos sem
  // sombra sobre fundo cinza agrupado, barra superior da cor da página.
  // A marca fica no acento: navy no claro, dourado no escuro (contraste).
  // Regras pra telas: ver comentário de AppColors em lib/ui/app_style.dart.
  static const _navy = AppColors.navy;
  static const _gold = AppColors.gold;

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final c = isDark ? AppColors.dark : AppColors.light;
    final cs = ColorScheme(
      brightness: brightness,
      primary: isDark ? _gold : _navy,
      onPrimary: isDark ? _navy : Colors.white,
      primaryContainer: c.accentFill,
      onPrimaryContainer: isDark ? _gold : _navy,
      secondary: _gold,
      onSecondary: isDark ? _navy : Colors.white,
      secondaryContainer: c.goldFill,
      onSecondaryContainer: c.label,
      tertiary: c.green,
      onTertiary: Colors.white,
      tertiaryContainer: c.greenFill,
      onTertiaryContainer: c.label,
      error: c.red,
      onError: Colors.white,
      errorContainer: c.redFill,
      onErrorContainer: c.label,
      surface: c.background,
      onSurface: c.label,
      onSurfaceVariant: c.secondaryLabel,
      surfaceContainerLowest: c.card,
      surfaceContainerLow: c.card,
      surfaceContainer: c.card,
      surfaceContainerHigh: c.fill,
      surfaceContainerHighest: c.fill,
      outline: c.tertiaryLabel,
      outlineVariant: c.separator,
      inverseSurface: c.label,
      onInverseSurface: c.background,
      shadow: Colors.black,
      scrim: Colors.black,
    );

    // Inter é a fonte livre mais próxima da SF Pro. Escala da Apple (HIG):
    // títulos grandes com tracking negativo, corpo 17/15, nota de rodapé 13.
    final inter = GoogleFonts.interTextTheme();
    TextStyle? t(TextStyle? s, double size, FontWeight w,
            {double tracking = 0, double height = 1.25, Color? color}) =>
        s?.copyWith(
          fontSize: size,
          fontWeight: w,
          letterSpacing: tracking,
          height: height,
          color: color ?? c.label,
        );
    final textTheme = TextTheme(
      displayLarge: t(inter.displayLarge, 56, FontWeight.w700, tracking: -1.2, height: 1.05),
      displayMedium: t(inter.displayMedium, 44, FontWeight.w700, tracking: -0.9, height: 1.08),
      displaySmall: t(inter.displaySmall, 34, FontWeight.w700, tracking: -0.6, height: 1.12),
      headlineLarge: t(inter.headlineLarge, 30, FontWeight.w700, tracking: -0.5, height: 1.15),
      headlineMedium: t(inter.headlineMedium, 26, FontWeight.w700, tracking: -0.4, height: 1.18),
      headlineSmall: t(inter.headlineSmall, 22, FontWeight.w600, tracking: -0.3, height: 1.2),
      titleLarge: t(inter.titleLarge, 20, FontWeight.w600, tracking: -0.2),
      titleMedium: t(inter.titleMedium, 17, FontWeight.w600, tracking: -0.2),
      titleSmall: t(inter.titleSmall, 15, FontWeight.w600, tracking: -0.1),
      bodyLarge: t(inter.bodyLarge, 17, FontWeight.w400, tracking: -0.2, height: 1.35),
      bodyMedium: t(inter.bodyMedium, 15, FontWeight.w400, tracking: -0.1, height: 1.35),
      bodySmall: t(inter.bodySmall, 13, FontWeight.w400, height: 1.3, color: c.secondaryLabel),
      labelLarge: t(inter.labelLarge, 17, FontWeight.w600, tracking: -0.2),
      labelMedium: t(inter.labelMedium, 13, FontWeight.w500, color: c.secondaryLabel),
      labelSmall: t(inter.labelSmall, 12, FontWeight.w500, tracking: 0.1, color: c.secondaryLabel),
    );

    final buttonShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppStyle.buttonRadius));
    const buttonSize = Size(64, AppStyle.buttonHeight);
    final buttonText = textTheme.labelLarge;

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: c.fill,
      dividerColor: c.separator,
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.label,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleMedium,
        iconTheme: IconThemeData(color: cs.primary),
        actionsIconTheme: IconThemeData(color: cs.primary),
      ),
      cardTheme: CardThemeData(
        color: c.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyle.cardRadius)),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: cs.primary,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodySmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        minVerticalPadding: 12,
      ),
      dividerTheme: DividerThemeData(
          color: c.separator, thickness: 0.5, space: 0.5),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: c.fill,
          disabledForegroundColor: c.tertiaryLabel,
          textStyle: buttonText,
          minimumSize: buttonSize,
          shape: buttonShape,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          textStyle: buttonText,
          minimumSize: buttonSize,
          shape: buttonShape,
          elevation: 0,
        ),
      ),
      // Botão secundário no estilo iOS "tinted": fundo do acento bem claro,
      // sem borda — em vez do contorno do Material.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: c.accentFill,
          foregroundColor: cs.primary,
          side: BorderSide.none,
          textStyle: buttonText,
          minimumSize: buttonSize,
          shape: buttonShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          minimumSize: const Size(44, 44),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: cs.primary),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cs.primary,
        linearTrackColor: c.fill,
        linearMinHeight: 6,
        borderRadius: BorderRadius.circular(3),
        circularTrackColor: c.fill,
      ),
      // Switch no padrão iOS: verde quando ligado.
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.green : c.fill,
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? cs.primary : null,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.card,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyle.buttonRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyle.buttonRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStyle.buttonRadius),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        labelStyle: textTheme.bodyLarge?.copyWith(color: c.secondaryLabel),
        hintStyle: textTheme.bodyLarge?.copyWith(color: c.tertiaryLabel),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.fill,
        side: BorderSide.none,
        labelStyle: textTheme.bodyMedium,
        shape: const StadiumBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.label,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: c.background),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: textTheme.titleMedium,
        contentTextStyle: textTheme.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.card,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: textTheme.bodyLarge,
      ),
      expansionTileTheme: ExpansionTileThemeData(
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: c.secondaryLabel,
        collapsedIconColor: c.secondaryLabel,
        textColor: c.label,
        collapsedTextColor: c.label,
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
