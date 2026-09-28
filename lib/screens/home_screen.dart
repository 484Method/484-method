import 'dart:math';

import 'package:flutter/material.dart';

import '../data/fase1.dart';
import '../models/lesson.dart';
import '../services/analytics_service.dart';
import '../services/entitlement_service.dart';
import '../services/progress_store.dart';
import '../services/pronunciation_assessor.dart';
import '../services/backend.dart';
import 'cohort_recording_screen.dart';
import 'cohort_review_screen.dart';
import 'lesson_screen.dart';
import 'paywall_screen.dart';
import 'privacy_policy_screen.dart';
import 'signup_screen.dart';
import 'terms_of_use_screen.dart';
import 'stats_screen.dart';
import 'word_memory_screen.dart';

/// Estado do "Treino de hoje" (experimento de retenção D2): deriva do que já
/// existe (minutos aprovados hoje vs. a meta diária existente,
/// [ProgressStore.dailyGoalSeconds]) — não é um novo sistema de progresso,
/// só uma leitura do que a meta de hoje já significa. `notStarted` → CTA
/// "Começar treino"; `inProgress` → "Continuar treino"; `done` → resumo do
/// dia + próximo treino.
enum _DailySessionState { notStarted, inProgress, done }

/// Índice palavra → (lição, item) do currículo, montado uma vez. A revisão
/// espaçada consulta isto a cada build da home e de novo ao abrir a palavra;
/// varrer as 25 lições item a item toda vez era trabalho repetido à toa.
/// Palavra que aparece em mais de uma lição vale pela PRIMEIRA — é a que a
/// pessoa viu antes, e é sempre uma lição já liberada.
final Map<String, ({Lesson lesson, int index})> _wordIndex = () {
  final out = <String, ({Lesson lesson, int index})>{};
  for (final lesson in fase1Lessons) {
    for (var i = 0; i < lesson.items.length; i++) {
      out.putIfAbsent(lesson.items[i].text, () => (lesson: lesson, index: i));
    }
  }
  return out;
}();

/// Dashboard: a barra das 484 horas, o streak e a porta de entrada das
/// lições. É a tela que o aluno vê todo dia — precisa mostrar progresso
/// real em segundos, não conclusão de telas.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.store,
    required this.entitlement,
    required this.assessor,
    this.analytics,
    this.onDataCleared,
    this.autostartFirstLesson = false,
    this.themeMode = ThemeMode.system,
    this.onThemeModeChanged,
  });

  final ProgressStore store;
  final EntitlementService entitlement;
  final PronunciationAssessor assessor;
  final AnalyticsService? analytics;

  /// Chamado após a exclusão de dados (o app volta ao onboarding).
  final VoidCallback? onDataCleared;

  /// Logo após o onboarding: abre a 1ª lição automaticamente (conserto do
  /// funil consentimento→1ª lição), em vez de deixar o novato na dashboard.
  final bool autostartFirstLesson;

  /// Tema atual e callback pra trocar (Sistema/Claro/Escuro). Controlados e
  /// persistidos pelo App; aqui só exibimos o seletor no menu.
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Survey de abandono respondido nesta sessão (esconde o card na hora).
  bool _abandonAnswered = false;
  bool _pmfAnswered = false;

  // Evita logar 'daily_training_completed' de novo a cada rebuild depois que
  // a meta de hoje foi batida — o evento é disparado uma vez por estado desta
  // tela (não persiste entre sessões; reabrir o app e bater a meta nunca é
  // problema, só relogaria o mesmo dia uma vez a mais).
  bool _dailyTrainingCompletedLogged = false;

  // #8: por padrão só mostra concluídos + treino atual + poucos bloqueados —
  // muitos cadeados em sequência davam sensação de caminho longo e cansativo.
  bool _showAllLessons = false;

  // Desafio do dia, resolvido fora do build (o sorteio tem efeito colateral de
  // persistir no ProgressStore). Null = nenhuma lição elegível (não deve
  // acontecer: a lição 1 está sempre liberada) ou ainda não resolvido.
  Lesson? _challenge;

  // #5/#13 Missões: rótulos pras primeiras lições não-bônus (camada leve por
  // cima do currículo). Sem número fixo no texto — o índice da missão não é
  // o mesmo da lição (bônus não contam), então numerar as duas confundia
  // (ex.: "Missão 7" dentro do card da lição 8). A UI sempre prefixa com
  // "Missão atual" em vez de expor esse índice.
  static const _missions = [
    'Fale sem ler pela primeira vez',
    'Melhore sua segunda tentativa',
    'Corrija seu primeiro som difícil',
    'Ganhe seus primeiros 5 minutos aprovados',
    'Responda mais rápido',
    'Use uma frase real de viagem',
    'Complete seu primeiro bloco de fala ativa',
  ];

  String? _missionFor(String lessonId) {
    var idx = 0;
    for (final l in fase1Lessons) {
      if (l.bonus) continue;
      if (l.id == lessonId) {
        return idx < _missions.length ? _missions[idx] : null;
      }
      idx++;
    }
    return null;
  }

  // #10 Survey de abandono: opções de motivo (valor p/ evento, rótulo p/ UI).
  static const _abandonOptions = [
    ('nao_entendi', 'Não entendi o que fazer'),
    ('vergonha', 'Tive vergonha de gravar'),
    ('microfone', 'O microfone não funcionou'),
    ('dificil', 'Achei difícil'),
    ('facil_demais', 'Achei fácil demais'),
    ('sem_valor', 'Não vi valor'),
    ('sem_tempo', 'Estou sem tempo'),
  ];

  // Teste de PMF (Sean Ellis). A ordem importa: "muito" primeiro (a resposta
  // que interessa — >40% dela = sinal de product-market fit).
  static const _pmfOptions = [
    ('very', 'Muito decepcionado'),
    ('somewhat', 'Pouco decepcionado'),
    ('not', 'Indiferente'),
  ];

  @override
  void initState() {
    super.initState();
    _ensureDailyChallenge();
    // Experimento de retenção D2 ("Treino de hoje"): visto uma vez por
    // abertura da Home, com o resumo do que há pra fazer — alimenta o funil
    // visualizou → iniciou → concluiu (get_daily_training_stats no painel).
    widget.analytics?.log('daily_training_viewed', _dailyTrainingProps());
    // Conserto do funil: quem acabou de consentir entra direto na 1ª lição,
    // em vez de cair na dashboard vazia ("0 de 484h" assusta e não tem CTA).
    // Só no 1º acesso (progresso zero); initState roda 1x, sem repetir.
    if (widget.autostartFirstLesson &&
        widget.store.totalApproved == Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openLesson(fase1Lessons.first);
      });
    }
  }

  Future<void> _confirmClearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apagar todos os seus dados?'),
        content: const Text(
            'Progresso, streak, lições concluídas, o consentimento de '
            'gravação e as gravações do desafio serão apagados deste '
            'dispositivo e da nuvem. Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Apagar tudo'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.store.clearAll();
    widget.onDataCleared?.call();
  }

  /// Abre a oferta Beta Fundador (teste de willingness-to-pay). O paywall
  /// cuida do preço testado, do funil e da captura de e-mail (fake door); o
  /// pagamento real via Pix entra dentro dele depois. Ao voltar, atualiza a
  /// home (o CTA de Fundador some se a pessoa deixou o e-mail).
  Future<void> _openPaywall() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PaywallScreen(
        store: widget.store,
        entitlement: widget.entitlement,
        backend: Backend.instance,
        analytics: widget.analytics,
      ),
    ));
    if (mounted) setState(() {});
  }

  /// Selo persistente de Fundador na AppBar — torna o status (que hoje é o
  /// que o Fundador compra, já que a Trilha 1 é grátis pra todos) visível.
  Widget _founderBadge(ThemeData theme) {
    final since = widget.store.founderSince;
    final price = widget.store.founderLockedPriceLabel;
    final tip = StringBuffer('Você é Fundador do 484');
    if (since != null) {
      tip.write(' desde ${since.day.toString().padLeft(2, '0')}/'
          '${since.month.toString().padLeft(2, '0')}/${since.year}');
    }
    if (price != null) tip.write('\nPreço travado: $price pras próximas trilhas');
    return Tooltip(
      message: tip.toString(),
      child: Center(
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium,
                size: 16, color: theme.colorScheme.onTertiaryContainer),
            const SizedBox(width: 4),
            Text('Fundador',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    ));
  }

  /// CTA da oferta Beta Fundador na dashboard. Aparece no "momento uau" (a
  /// pessoa já viu seu antes/depois → sabe que funciona) e some quando ela
  /// entra na lista de Fundadores. Não bloqueia nada: mede intenção sem
  /// tirar as lições grátis de quem só quer praticar.
  Widget _founderOfferCard(ThemeData theme) {
    return Card(
      color: theme.colorScheme.tertiaryContainer,
      child: InkWell(
        onTap: _openPaywall,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.workspace_premium,
                  size: 36, color: theme.colorScheme.tertiary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seja um Fundador do 484',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      'Garanta acesso vitalício e ajude a decidir o que vem '
                      'depois da Trilha 1.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _openPrivacyPolicy() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => const PrivacyPolicyScreen(),
    ));
  }

  void _openTermsOfUse() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => const TermsOfUseScreen(),
    ));
  }

  /// Seletor de tema: Sistema (segue o aparelho), Claro ou Escuro.
  void _openThemeChooser() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (mode, label) in const [
              (ThemeMode.system, 'Sistema'),
              (ThemeMode.light, 'Claro'),
              (ThemeMode.dark, 'Escuro'),
            ])
              ListTile(
                title: Text(label),
                trailing:
                    widget.themeMode == mode ? const Icon(Icons.check) : null,
                onTap: () {
                  widget.onThemeModeChanged?.call(mode);
                  Navigator.of(ctx).pop();
                },
              ),
          ],
        ),
      ),
    );
  }

  void _openWordMemory() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => WordMemoryScreen(onReviewWord: _reviewWord),
    ));
  }

  /// "Revisar agora": abre o treino da 1ª lição que contém a palavra, já no
  /// item dela (via startItemIndex) — em vez de retomar o índice salvo.
  void _reviewWord(String word) {
    final found = _wordIndex[word];
    if (found == null) return; // palavra saiu do currículo: nada a treinar
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => LessonScreen(
        lesson: found.lesson,
        assessor: widget.assessor,
        store: widget.store,
        analytics: widget.analytics,
        rigorous: widget.store.rigorousMode,
        startItemIndex: found.index,
      ),
    )).then((_) {
      if (mounted) {
        _maybeLogDailyTrainingCompleted();
        setState(() {});
      }
    });
  }

  Future<void> _openStats() async {
    final backend = Backend.instance;
    if (backend == null) return;
    await StatsScreen.open(context, backend);
  }

  /// Explica o efeito antes de ligar: o critério mais rígido vale para
  /// qualquer tentativa a partir de agora (lições já concluídas continuam
  /// concluídas, mas refazê-las ou seguir adiante usa o novo critério) —
  /// sem isso, a mesma pronúncia passar antes e reprovar depois confunde.
  Future<bool> _confirmEnableRigorous() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ativar modo desafio?'),
        content: const Text(
            'A partir de agora, toda gravação — inclusive em lições que '
            'você já concluiu, se refizer — só é aprovada com pronúncia '
            'bem próxima da nativa. O que já está concluído continua '
            'concluído; só o critério das próximas tentativas muda.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Ativar'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  bool _isPaywalled(int i) =>
      i >= kFreeLessonCount && !widget.entitlement.hasFounderAccess;

  /// O pré-requisito é a lição anterior NÃO bônus — lições bônus nunca
  /// bloqueiam (nem precisam de) progressão.
  bool _isProgressionUnlocked(int i) {
    int prereq = i - 1;
    while (prereq >= 0 && fase1Lessons[prereq].bonus) {
      prereq--;
    }
    return prereq < 0 ||
        widget.store.isLessonCompleted(fase1Lessons[prereq].id);
  }

  /// Resolve o desafio de hoje em [_challenge]. Tem efeito colateral (persiste
  /// o sorteio), então roda FORA do build — no initState e depois de eventos
  /// que mudam a elegibilidade (concluir lição, alternar acesso). Reaproveita
  /// o sorteio salvo do dia se ele ainda for elegível; re-sorteia se o acesso
  /// foi perdido (virou paywall) ou o id não existe mais (currículo mudou).
  void _ensureDailyChallenge() {
    final savedId = widget.store.dailyChallengeLessonId;
    if (savedId != null) {
      final idx = fase1Lessons.indexWhere((l) => l.id == savedId);
      if (idx >= 0 && !_isPaywalled(idx) && _isProgressionUnlocked(idx)) {
        _challenge = fase1Lessons[idx];
        return;
      }
    }
    _challenge = _pickDailyChallenge();
  }

  /// Sorteia uma lição do dia entre as liberadas e ainda não concluídas — dá
  /// visibilidade às bônus (que a "próxima melhor ação" nunca aponta) e vira
  /// revisão quando a trilha liberada está toda feita. Persiste o sorteio
  /// (não troca a cada rebuild; expira sozinho ao virar o dia).
  Lesson? _pickDailyChallenge() {
    final unlocked = [
      for (final (i, l) in fase1Lessons.indexed)
        if (!_isPaywalled(i) && _isProgressionUnlocked(i)) l,
    ];
    if (unlocked.isEmpty) return null;
    final incomplete = [
      for (final l in unlocked)
        if (!widget.store.isLessonCompleted(l.id)) l,
    ];
    final pool = incomplete.isNotEmpty ? incomplete : unlocked;
    final picked = pool[Random().nextInt(pool.length)];
    widget.store.setDailyChallenge(picked.id);
    return picked;
  }

  Widget _dailyChallengeCard(ThemeData theme, Lesson lesson) {
    final done = widget.store.dailyChallengeCompleted;
    final isReview = widget.store.isLessonCompleted(lesson.id) && !done;
    return Card(
      child: ListTile(
        leading: Icon(
          done ? Icons.check_circle : Icons.local_fire_department,
          color: theme.colorScheme.secondary,
        ),
        title: const Text('Desafio de hoje'),
        subtitle: Text(done
            ? '${lesson.title} — feito! Amanhã tem outro.'
            : isReview
                ? '${lesson.title} · revisão'
                : lesson.title),
        trailing: done ? null : const Icon(Icons.chevron_right),
        onTap: done ? null : () => _openLesson(lesson),
      ),
    );
  }

  /// Palavras que a revisão espaçada agendou pra hoje e que ainda existem no
  /// currículo — a agenda é local e sobrevive a mudança de conteúdo, mas
  /// palavra que saiu das lições não tem mais onde ser treinada.
  List<String> _dueReviewWords() => [
        for (final w in widget.store.srsDueWords())
          if (_wordIndex.containsKey(w)) w,
      ];

  /// Revisão espaçada: o mapa de fala mostra o que a pessoa NUNCA acertou;
  /// este card traz de volta o que ela JÁ acertou e está na hora de conferir,
  /// antes que a memória caia. Cada revisão passa pelo loop normal, então
  /// rende minuto APROVADO — a métrica norte — e não só tempo de tela.
  Widget _srsReviewCard(ThemeData theme, List<String> due) {
    final n = due.length;
    return Card(
      child: ListTile(
        leading: Icon(Icons.history, color: theme.colorScheme.secondary),
        title: const Text('Revisar hoje'),
        subtitle: Text(n == 1
            ? '1 palavra que você já dominou — veja se ainda sai'
            : '$n palavras que você já dominou — veja se ainda saem'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _reviewWord(due.first),
      ),
    );
  }

  /// Desafio de 21 dias (instrumento de validação do beta): mede outcome, não
  /// só comportamento — confiança inicial vs. final + o antes/depois. O card
  /// muda conforme o estágio: entrar → em andamento → fechar → concluído.
  Widget _cohortCard(ThemeData theme) {
    final store = widget.store;

    if (!store.cohortStarted) {
      return _cohortCta(
        theme,
        color: theme.colorScheme.primaryContainer,
        accent: theme.colorScheme.primary,
        icon: Icons.flag,
        title: 'Desafio de 21 dias',
        subtitle:
            'Treine o ouvido e a boca todo dia. No fim, veja seu antes e depois.',
        onTap: _startCohort,
      );
    }

    if (store.cohortFinalDone) {
      return Card(
        child: ListTile(
          leading:
              Icon(Icons.emoji_events, color: theme.colorScheme.secondary),
          title: const Text('Desafio de 21 dias concluído'),
          subtitle: const Text('Ver seu antes e depois'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _openReview,
        ),
      );
    }

    if (store.cohortFinalUnlocked) {
      return _cohortCta(
        theme,
        color: theme.colorScheme.secondaryContainer,
        accent: theme.colorScheme.secondary,
        icon: Icons.emoji_events,
        title: 'Você chegou ao dia ${store.cohortDay}!',
        subtitle: 'Feche o desafio e veja seu antes e depois.',
        onTap: _finishCohort,
      );
    }

    final day = store.cohortDay.clamp(1, ProgressStore.cohortLength);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Desafio de 21 dias · Dia $day de ${ProgressStore.cohortLength}',
                style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: day / ProgressStore.cohortLength,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              color: theme.colorScheme.primary,
              backgroundColor:
                  theme.colorScheme.primary.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 8),
            Text('Pratique um pouco hoje pra manter o ritmo.',
                style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _cohortCta(
    ThemeData theme, {
    required Color color,
    required Color accent,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 36, color: accent),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  /// Guardar gravações é uma base LGPD diferente de processá-las na hora (loop
  /// de lição), então pede consentimento próprio. Só faz sentido com backend
  /// (o áudio vai pro Storage); em local-only o desafio roda só com confiança.
  Future<bool> _confirmVoiceStorageConsent() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Guardar suas gravações do desafio?'),
        content: const Text(
            'Pra você comparar seu antes e depois, o 484 vai GUARDAR duas '
            'gravações suas (hoje e no fim dos 21 dias) — não só analisar na '
            'hora, como nas lições. Ficam num espaço privado; você pode apagar '
            'tudo quando quiser em "Apagar meus dados". Sem isso, o desafio '
            'segue só com a sua autoavaliação.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Não, obrigado'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Pode guardar'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _recordCohortSpeech(String kind) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CohortRecordingScreen(
        kind: kind,
        store: widget.store,
        backend: Backend.instance,
        analytics: widget.analytics,
      ),
    ));
  }

  Future<void> _startCohort() async {
    // O áudio só pode ser guardado com backend; sem ele, desafio de confiança.
    final canRecord = Backend.instance != null;
    if (canRecord && !widget.store.hasVoiceStorageConsent) {
      if (await _confirmVoiceStorageConsent()) {
        await widget.store.grantVoiceStorageConsent();
      }
    }
    if (!mounted) return;
    final score = await showConfidenceSurvey(
      context,
      title: 'Desafio de 21 dias',
      question: 'Antes de começar: como você se sente falando inglês hoje?',
    );
    if (score == null) return;
    await widget.store.startCohort(score);
    widget.analytics?.log('cohort_started', {
      'baseline_confidence': score,
      'audio_consent': widget.store.hasVoiceStorageConsent,
    });
    if (!mounted) return;
    // Gravação de baseline (best-effort): registra a fala de hoje pro depois.
    if (canRecord && widget.store.hasVoiceStorageConsent) {
      await _recordCohortSpeech('baseline');
    }
    if (mounted) setState(() {});
  }

  Future<void> _finishCohort() async {
    final score = await showConfidenceSurvey(
      context,
      title: 'Você chegou ao fim do desafio!',
      question: 'Agora, como você se sente falando inglês?',
    );
    if (score == null) return;
    await widget.store.setFinalConfidence(score);
    widget.analytics?.log('final_confidence', {'final_confidence': score});
    if (!mounted) return;
    // Gravação final (best-effort) antes do antes/depois, se houve consentimento.
    if (Backend.instance != null && widget.store.hasVoiceStorageConsent) {
      await _recordCohortSpeech('final');
    }
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CohortReviewScreen(
        store: widget.store,
        analytics: widget.analytics,
      ),
    ));
    if (mounted) setState(() {});
  }

  void _openReview() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CohortReviewScreen(
        store: widget.store,
        analytics: widget.analytics,
      ),
    )).then((_) {
      if (mounted) setState(() {});
    });
  }

  /// A "próxima melhor ação": a 1ª lição não-bônus ainda não concluída (o
  /// caminho principal é linear). Null = concluiu tudo.
  Lesson? _nextLesson() {
    for (final l in fase1Lessons) {
      if (l.bonus) continue;
      if (!widget.store.isLessonCompleted(l.id)) return l;
    }
    return null;
  }

  /// Quantas palavras vencidas entram no resumo do treino de hoje. A agenda
  /// de SRS pode acumular muitas atrasadas (quem sumiu por semanas); o
  /// treino de hoje continua sendo ~5min, não "zerar o backlog inteiro" — as
  /// que sobrarem continuam aparecendo amanhã (a agenda em si não perde nada,
  /// ver [_dueReviewWords]).
  static const _sessionReviewCap = 3;

  /// Resumo do que compõe o treino de hoje, na ordem pedagógica exigida
  /// (revisão → novo conteúdo → desafio de fala). Reaproveita 100% de
  /// entidades existentes (agenda de SRS, próxima lição, desafio do dia) —
  /// não há uma "unidade de treino" nova. `estimatedMinutes` segue a mesma
  /// convenção já usada nos cards de lição (~1min por tentativa de fala).
  ({
    int reviewCount,
    Lesson? newLesson,
    Lesson? challengeLesson,
    int estimatedMinutes
  }) _dailyTrainingSummary() {
    final due = _dueReviewWords();
    final reviewCount =
        due.length > _sessionReviewCap ? _sessionReviewCap : due.length;
    final newLesson = _nextLesson();
    final challenge = _challenge;
    // Mesma regra de dedup do card de desafio existente: não contar a mesma
    // lição duas vezes quando o sorteio do dia coincide com a próxima lição.
    final hasChallenge = challenge != null && challenge.id != newLesson?.id;
    final minutes = reviewCount +
        (newLesson?.items.length ?? 0) +
        (hasChallenge ? challenge.items.length : 0);
    return (
      reviewCount: reviewCount,
      newLesson: newLesson,
      challengeLesson: hasChallenge ? challenge : null,
      estimatedMinutes: minutes < 1 ? 1 : minutes,
    );
  }

  Map<String, Object?> _dailyTrainingProps() {
    final s = _dailyTrainingSummary();
    return {
      'review_count': s.reviewCount,
      'has_new_content': s.newLesson != null,
      'has_challenge': s.challengeLesson != null,
      'estimated_minutes': s.estimatedMinutes,
      'session_state': _dailySessionState().name,
    };
  }

  /// Estado do dia: nada feito ainda / em andamento / meta batida. Deriva da
  /// meta diária JÁ existente (#7, [ProgressStore.dailyGoalSeconds]) — não é
  /// um segundo sistema de progresso, só a leitura que decide o rótulo do
  /// botão principal (Começar/Continuar treino) e quando mostrar o resumo do
  /// dia.
  _DailySessionState _dailySessionState() {
    final approvedToday = widget.store.approvedToday;
    if (approvedToday.inSeconds >= ProgressStore.dailyGoalSeconds) {
      return _DailySessionState.done;
    }
    if (approvedToday > Duration.zero) return _DailySessionState.inProgress;
    return _DailySessionState.notStarted;
  }

  /// A ÚNICA regra de roteamento do treino de hoje, na ordem pedida: revisão
  /// vencida → conteúdo novo → desafio de fala. Usada tanto pelo CTA
  /// principal quanto pelo "treino mínimo" — não são dois sistemas: o
  /// mínimo é o mesmo roteamento, só entrando por um botão com outra moldura
  /// ("sem tempo? fale agora"). Como a aprovação já conta por gravação (não
  /// por lição inteira — `addApproved` roda por palavra em `LessonScreen`),
  /// parar depois de uma única gravação aprovada já cumpre a regra "1
  /// prática = dia mantido"; nada aqui força a pessoa a continuar.
  void _goToNextTrainingStep() {
    final due = _dueReviewWords();
    if (due.isNotEmpty) {
      _reviewWord(due.first);
      return;
    }
    final next = _nextLesson();
    if (next != null) {
      _openLesson(next);
      return;
    }
    final challenge = _challenge;
    if (challenge != null) _openLesson(challenge);
  }

  void _startDailyTraining() {
    widget.analytics?.log('daily_training_started', {
      'source': 'main_cta',
      ..._dailyTrainingProps(),
    });
    _goToNextTrainingStep();
  }

  /// "Sem tempo hoje?" — mesmo roteamento do treino completo, só
  /// instrumentado à parte: mede quantas pessoas usam a porta de saída de
  /// baixo esforço em vez do treino de hoje inteiro.
  void _startMinimumTraining() {
    widget.analytics?.log('minimum_training_started', _dailyTrainingProps());
    _goToNextTrainingStep();
  }

  /// Loga a conclusão do treino de hoje (meta diária batida) uma vez por
  /// abertura da Home. Chamado ao VOLTAR de uma lição/revisão — nunca durante
  /// o build, que não deve ter efeito colateral — nos mesmos pontos que já
  /// reavaliam o desafio do dia ([_openLesson], [_reviewWord]).
  void _maybeLogDailyTrainingCompleted() {
    if (_dailyTrainingCompletedLogged) return;
    if (_dailySessionState() != _DailySessionState.done) return;
    _dailyTrainingCompletedLogged = true;
    widget.analytics?.log('daily_training_completed', _dailyTrainingProps());
  }

  /// #8 "Preparar o próximo treino": descreve o que vem a seguir sem
  /// inventar números que a agenda de SRS não permite prever com precisão
  /// (quantas palavras vencem amanhã depende de quando cada uma for
  /// revisada hoje) — mostra a próxima lição do currículo, que é
  /// determinística.
  String _nextTrainingPreview() {
    final next = _nextLesson();
    if (next == null) {
      return 'Seu próximo treino: revisões, assim que estiverem prontas.';
    }
    return 'Seu próximo treino: "${next.title}" — foco: ${next.microSkill}.';
  }

  /// Hero da Home (#1 da hierarquia do experimento "Treino de hoje"): a ação
  /// principal precisa ser evidente, então este card assume o lugar que era
  /// da "Próxima melhor ação" — mesma ideia (uma ação clara, sem paradoxo de
  /// escolha), agora com o quadro completo (revisão + novo + desafio) e um
  /// estado que muda com o dia real da pessoa, nunca com pressão artificial.
  Widget _dailyTrainingCard(ThemeData theme) {
    final summary = _dailyTrainingSummary();
    final hasContent = summary.reviewCount > 0 ||
        summary.newLesson != null ||
        summary.challengeLesson != null;
    if (!hasContent) return _dailyTrainingEmptyCard(theme);

    final state = _dailySessionState();
    // #9 "retorno de usuário ausente": recepção calorosa, nunca "você
    // perdeu sua sequência" — só quando ainda não fez nada hoje (senão
    // soaria estranho depois que a pessoa já começou a praticar agora).
    final daysSince = widget.store.daysSinceLastPractice;
    final isReturning = state == _DailySessionState.notStarted &&
        daysSince != null &&
        daysSince >= 2;

    final lines = <String>[
      if (summary.reviewCount > 0)
        summary.reviewCount == 1
            ? '1 palavra para revisar'
            : '${summary.reviewCount} palavras para revisar',
      if (summary.newLesson != null)
        '${summary.newLesson!.title} — foco: ${summary.newLesson!.microSkill}',
      if (summary.challengeLesson != null) '1 desafio de fala',
    ];

    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isReturning ? 'Bom te ver de novo' : 'Seu treino de hoje',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            if (isReturning) ...[
              const SizedBox(height: 4),
              Text('Vamos continuar de onde você parou.',
                  style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            if (state == _DailySessionState.done) ...[
              Row(children: [
                Icon(Icons.check_circle,
                    color: Colors.green.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Você falou hoje. Treino concluído.',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(height: 8),
              Text(_nextTrainingPreview(), style: theme.textTheme.bodyMedium),
            ] else ...[
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text('•  $line', style: theme.textTheme.bodyMedium),
                ),
              const SizedBox(height: 4),
              Text('Aproximadamente ${summary.estimatedMinutes} min',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer
                          .withValues(alpha: 0.75))),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _startDailyTraining,
                child: Text(state == _DailySessionState.inProgress
                    ? 'Continuar treino'
                    : 'Começar treino'),
              ),
              const SizedBox(height: 4),
              Center(
                child: TextButton(
                  onPressed: _startMinimumTraining,
                  child: const Text('Sem tempo hoje? Fale agora'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Currículo em dia e nada vencido pra revisar: não é um erro nem um
  /// estado vazio genérico — é a pessoa estar quite com a prática. Some a
  /// urgência sem esconder que ainda existe um lugar pra voltar amanhã.
  Widget _dailyTrainingEmptyCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Você está em dia',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              'Nenhuma revisão vencida agora e você já concluiu o conteúdo '
              'disponível. Volte amanhã para continuar.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// #7: meta curta do dia — o 1º degrau da hierarquia de progresso, antes
  /// do primeiro marco e da jornada de 484h.
  Widget _todayGoalCard(ThemeData theme) {
    final today = widget.store.approvedToday;
    final goal = ProgressStore.dailyGoalSeconds;
    final reached = today.inSeconds >= goal;
    final remaining = (goal - today.inSeconds).clamp(0, goal);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meta de hoje: ${_format(Duration(seconds: goal))} aprovados',
                style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (today.inSeconds / goal).clamp(0.0, 1.0),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              color: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 8),
            Text(
              reached
                  ? 'Você bateu sua meta de hoje. 🎉'
                  : 'Você fez ${_format(today)}. '
                      'Faltam ${_format(Duration(seconds: remaining))}.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// #7: primeiro marco (10min aprovados) — a ponte entre a meta de hoje e a
  /// jornada de 484h. Some quando alcançado.
  Widget _firstMilestoneCard(ThemeData theme) {
    final total = widget.store.totalApproved;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Primeiro marco: '
                '${_format(Duration(seconds: ProgressStore.firstMilestoneSeconds))} '
                'aprovados',
                style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: widget.store.firstMilestoneFraction,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              color: theme.colorScheme.secondary,
              backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 8),
            Text('${_format(total)} de ${_format(Duration(seconds: ProgressStore.firstMilestoneSeconds))}',
                style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  /// Só faz sentido mostrar quando já dá pra recomendar (≥30min aprovados) —
  /// abaixo disso o card virava um aviso "pode ser difícil demais" e só
  /// competia com a ação principal do iniciante. Ver `_showPrecision`.
  static const _precisionBaseSeconds = 30 * 60;

  /// #10: "Modo precisão" (ex-"Modo desafio") — copy menos intimidante, sem
  /// prometer "pronúncia nativa". Aparece só depois da base de 30min.
  Widget _precisionModeCard(ThemeData theme) {
    return Card(
      child: SwitchListTile(
        value: widget.store.rigorousMode,
        onChanged: (v) async {
          if (v && !await _confirmEnableRigorous()) return;
          await widget.store.setRigorousMode(v);
          setState(() {});
        },
        title: const Text('Modo precisão'),
        subtitle: const Text(
            'Use quando quiser treinar com critério mais exigente de '
            'clareza, ritmo e pronúncia. Recomendado depois dos '
            'primeiros 30 minutos aprovados.'),
        secondary: const Icon(Icons.fitness_center),
      ),
    );
  }

  /// #7 (mais distante da hierarquia): a jornada de 484h + streak. Fica abaixo
  /// da meta de hoje e do primeiro marco; escondida no dia 0 (a barra "0 de
  /// 484h" assusta e o streak ainda é 0 mesmo).
  Widget _journeyCard(ThemeData theme) {
    final total = widget.store.totalApproved;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jornada 484h iniciada',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: widget.store.goalFraction,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              color: theme.colorScheme.secondary,
              backgroundColor:
                  theme.colorScheme.secondary.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 8),
            Text(
              total.inSeconds > 0
                  ? '${_format(total)} de treino aprovado no total'
                  : 'Comece o primeiro treino hoje.',
              style: theme.textTheme.bodySmall,
            ),
            if (widget.store.streakDays > 0) ...[
              const SizedBox(height: 4),
              Text(
                '🔥 ${widget.store.streakDays} '
                '${widget.store.streakDays == 1 ? "dia" : "dias"} seguidos',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// #8: reduz o efeito visual de muitos bloqueios — mostra concluídos, o
  /// treino atual e só os próximos poucos bloqueados; o resto fica atrás de
  /// um botão "Ver próximos treinos da trilha".
  List<Widget> _lessonList(ThemeData theme) {
    const lockedVisibleLimit = 3;
    final next = _nextLesson();
    final nextIndex = next == null ? -1 : fase1Lessons.indexOf(next);
    final widgets = <Widget>[];
    var lockedShown = 0;
    var hiddenCount = 0;

    for (final (i, lesson) in fase1Lessons.indexed) {
      final completed = widget.store.isLessonCompleted(lesson.id);
      final paywalled = _isPaywalled(i);
      final progressionUnlocked = _isProgressionUnlocked(i);
      final unlocked = !paywalled && progressionUnlocked;
      final isCurrent = i == nextIndex;

      bool visible;
      if (_showAllLessons || completed || isCurrent || unlocked) {
        visible = true;
      } else if (lockedShown < lockedVisibleLimit) {
        visible = true;
        lockedShown++;
      } else {
        visible = false;
      }

      if (!visible) {
        hiddenCount++;
        continue;
      }

      if (i == 0 || i == 6 || i == 11 || i == 18) {
        widgets.add(Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : 16, bottom: 4),
          child: Text(
            switch (i) {
              0 => 'Zona 1 — Reconhecimento e confiança',
              6 => 'Zona 2 — Som e sílaba forte',
              11 => 'Zona 3 — Da palavra à frase',
              _ => 'Zona 4 — Conversa do dia a dia',
            },
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
      }

      final mission = _missionFor(lesson.id);
      final String subtitle;
      if (paywalled) {
        subtitle = 'Beta Fundador';
      } else if (!progressionUnlocked) {
        subtitle = 'Complete a missão anterior para liberar';
      } else if (lesson.bonus) {
        subtitle =
            'Bônus opcional · ${lesson.items.length} tentativas de fala · ~5 min';
      } else {
        subtitle = '${lesson.items.length} tentativas de fala · ~5 min';
      }
      final IconData trailing;
      if (paywalled) {
        trailing = Icons.workspace_premium_outlined;
      } else if (!progressionUnlocked) {
        trailing = Icons.lock_outline;
      } else {
        trailing = completed ? Icons.replay : Icons.play_arrow;
      }
      widgets.add(Card(
        child: ListTile(
          // Paywalled fica tocável para mostrar o aviso do gate.
          enabled: unlocked || paywalled,
          leading: CircleAvatar(
            backgroundColor: completed
                ? theme.colorScheme.secondary.withValues(alpha: 0.18)
                : theme.colorScheme.surfaceContainerHighest,
            foregroundColor: completed
                ? theme.colorScheme.secondary
                : theme.colorScheme.onSurface,
            child: completed
                ? const Icon(Icons.check, size: 20)
                : Text('${i + 1}'),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: Text(lesson.title)),
              if (lesson.bonus) ...[
                const SizedBox(width: 6),
                Icon(Icons.star, size: 16, color: theme.colorScheme.secondary),
              ],
            ],
          ),
          isThreeLine: mission != null && !completed,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (mission != null && !completed)
                Text('Missão atual: $mission',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600)),
              Text(subtitle),
            ],
          ),
          trailing: Icon(trailing),
          onTap: paywalled
              ? _openPaywall
              : unlocked
                  ? () => _openLesson(lesson)
                  : null,
        ),
      ));
    }

    if (hiddenCount > 0 && !_showAllLessons) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 8),
        child: OutlinedButton(
          onPressed: () => setState(() => _showAllLessons = true),
          child: const Text('Ver próximos treinos da trilha'),
        ),
      ));
    }

    return widgets;
  }

  // #10 Card de abandono: aparece quando a pessoa começou mas não fechou o
  // 1º ciclo (gravou, mas não chegou ao antes/depois). Pergunta o porquê.
  Widget _abandonCard(ThemeData theme) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('O que te impediu de continuar?',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (val, label) in _abandonOptions)
                    ActionChip(
                      label: Text(label),
                      onPressed: () => _answerAbandon(val),
                    ),
                ],
              ),
            ],
          ),
        ),
      );

  void _answerAbandon(String reason) {
    widget.analytics?.log('abandon_reason', {'reason': reason});
    widget.store.setAskedAbandon();
    setState(() => _abandonAnswered = true);
  }

  /// Teste de PMF (Sean Ellis): uma pergunta a quem já sentiu o valor e voltou.
  /// Mede a INTENSIDADE que a retenção sozinha não captura.
  Widget _pmfCard(ThemeData theme) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Como você se sentiria se não pudesse mais usar o 484?',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (val, label) in _pmfOptions)
                    ActionChip(
                      label: Text(label),
                      onPressed: () => _answerPmf(val),
                    ),
                ],
              ),
            ],
          ),
        ),
      );

  void _answerPmf(String answer) {
    widget.analytics?.log('pmf_survey_answered', {'answer': answer});
    widget.store.setAskedPmf();
    setState(() => _pmfAnswered = true);
  }

  Future<void> _openLesson(Lesson lesson) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => LessonScreen(
        lesson: lesson,
        assessor: widget.assessor,
        store: widget.store,
        analytics: widget.analytics,
        rigorous: widget.store.rigorousMode,
      ),
    ));
    // Progresso pode ter mudado: reavalia elegibilidade e refaz o sorteio se
    // o dia virou enquanto a tela estava aberta.
    _ensureDailyChallenge();
    _maybeLogDailyTrainingCompleted();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Cadastro (nome+e-mail) só aparece DEPOIS da 1ª gravação, não antes da
    // 1ª lição. Dado real (2026-07-13): 40 pessoas aceitaram o consentimento
    // de voz, só 10 completaram o cadastro — 75% de perda bem no portão
    // antigo, antes de qualquer "aha". Mover pra cá deixa a pessoa sentir o
    // valor primeiro; o cadastro reaparece quando ela volta pra Home (fim da
    // lição ou saída no meio) — nunca interrompe a lição em andamento.
    if (!widget.store.hasRegistered &&
        widget.store.hasDone('first_recording_completed')) {
      return SignupScreen(
        store: widget.store,
        analytics: widget.analytics,
        onDone: () => setState(() {}),
      );
    }
    final theme = Theme.of(context);
    final total = widget.store.totalApproved;
    final next = _nextLesson();
    final challenge = _challenge;
    // #10: começou a praticar (gravou) mas não chegou ao antes/depois → perguntar.
    final askAbandon = !_abandonAnswered &&
        widget.store.hasDone('first_recording_completed') &&
        !widget.store.hasDone('first_before_after_seen') &&
        !widget.store.hasAskedAbandon;
    // Teste de PMF (Sean Ellis): pergunta a quem JÁ sentiu o valor (viu o
    // antes/depois) e VOLTOU (streak ≥ 2 dias = usou o suficiente pra ter
    // opinião). Complemento do abandono; mutuamente exclusivos pelo
    // first_before_after_seen. Uma vez só.
    final showPmf = !_pmfAnswered &&
        !widget.store.hasAskedPmf &&
        widget.store.hasDone('first_before_after_seen') &&
        widget.store.streakDays >= 2;
    // Oferta Beta Fundador: só depois do "momento uau" (viu o antes/depois) e
    // enquanto a pessoa não entrou na lista de Fundadores.
    // Quem já é Fundador não vê mais a oferta (vê o selo na AppBar).
    final showFounderOffer = !widget.entitlement.hasFounderAccess &&
        widget.store.hasDone('first_before_after_seen') &&
        !widget.store.hasLeftFounderEmail;

    // Priorização por estágio (evita a "parede de cards" no dia 0). No dia 0 a
    // única coisa é a próxima ação + a trilha; medidores e ofertas secundárias
    // entram à medida que a pessoa acumula prática real.
    final isBrandNew = total == Duration.zero;
    // Desafio de hoje: não repetir a lição que a "próxima melhor ação" já
    // aponta (seria o mesmo card duas vezes), nem oferecer no dia 0.
    final showChallenge =
        !isBrandNew && challenge != null && challenge.id != next?.id;
    // Convite do desafio de 21 dias só depois da 1ª prática; já iniciado,
    // mostra sempre (é o frame ativo).
    final showCohort = widget.store.cohortStarted || !isBrandNew;
    final showPrecision =
        total.inSeconds >= _precisionBaseSeconds; // só quando é recomendável
    // Revisão espaçada: só aparece quando há palavra vencida. No dia 0 nunca
    // há (nada foi aprovado ainda), então não precisa de gate por isBrandNew.
    final dueReview = _dueReviewWords();
    return Scaffold(
      appBar: AppBar(
        title: const Text('484 Method'),
        actions: [
          if (widget.entitlement.hasFounderAccess) _founderBadge(theme),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'clear') _confirmClearData();
              if (v == 'privacy') _openPrivacyPolicy();
              if (v == 'terms') _openTermsOfUse();
              if (v == 'stats') _openStats();
              if (v == 'theme') _openThemeChooser();
              if (v == 'words') _openWordMemory();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'theme',
                child: Text('Tema'),
              ),
              if (Backend.instance != null)
                const PopupMenuItem(
                  value: 'words',
                  child: Text('Meu mapa de fala'),
                ),
              if (Backend.instance != null)
                const PopupMenuItem(
                  value: 'stats',
                  child: Text('Painel de uso'),
                ),
              const PopupMenuItem(
                value: 'privacy',
                child: Text('Política de privacidade'),
              ),
              const PopupMenuItem(
                value: 'terms',
                child: Text('Termos de Uso'),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Text('Apagar meus dados'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (askAbandon) ...[
                _abandonCard(theme),
                const SizedBox(height: 12),
              ],
              if (showPmf) ...[
                _pmfCard(theme),
                const SizedBox(height: 12),
              ],
              // Hierarquia do experimento "Treino de hoje" (#11): a ação
              // principal (1: treino de hoje / continuar treino) evidente no
              // topo, seguida de progresso (3), revisões pendentes (4),
              // jornada 484h (5) e só depois os dados secundários (6) — nunca
              // um painel cheio de números antes da ação.
              _dailyTrainingCard(theme),
              const SizedBox(height: 12),
              // #7: meta de hoje → primeiro marco, do mais imediato pro mais
              // distante. Escondidos no dia 0 (o hero já carrega a promessa
              // da meta de hoje).
              if (!isBrandNew) ...[
                _todayGoalCard(theme),
                const SizedBox(height: 12),
              ],
              if (!isBrandNew && !widget.store.reachedFirstMilestone) ...[
                _firstMilestoneCard(theme),
                const SizedBox(height: 12),
              ],
              if (dueReview.isNotEmpty) ...[
                _srsReviewCard(theme, dueReview),
                const SizedBox(height: 12),
              ],
              if (!isBrandNew) ...[
                _journeyCard(theme),
                const SizedBox(height: 12),
              ],
              // Dados secundários (#6): desafio do dia, desafio de 21 dias,
              // oferta de Fundador e modo precisão — acesso direto opcional,
              // sem competir com a ação principal do hero.
              if (showChallenge) ...[
                _dailyChallengeCard(theme, challenge),
                const SizedBox(height: 12),
              ],
              if (showCohort) ...[
                _cohortCard(theme),
                const SizedBox(height: 12),
              ],
              if (showFounderOffer) ...[
                _founderOfferCard(theme),
                const SizedBox(height: 12),
              ],
              if (showPrecision) ...[
                _precisionModeCard(theme),
                const SizedBox(height: 4),
              ],
              const SizedBox(height: 12),
              Text('Trilha 1 — Saia do inglês mudo',
                  style: theme.textTheme.titleMedium),
              Text('Inglês que você já conhece',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              ..._lessonList(theme),
            ],
          ),
        ),
      ),
    );
  }

  String _format(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes % 60}min';
    if (d.inMinutes > 0) return '${d.inMinutes}min ${d.inSeconds % 60}s';
    return '${d.inSeconds}s';
  }
}
