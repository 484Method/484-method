import 'dart:math';

import 'package:flutter/material.dart';

import '../data/curriculum.dart';
import '../models/lesson.dart';
import '../models/trail.dart';
import '../services/analytics_service.dart';
import '../services/entitlement_service.dart';
import '../services/progress_store.dart';
import '../services/pronunciation_assessor.dart';
import '../services/backend.dart';
import '../ui/app_style.dart';
import 'cohort_recording_screen.dart';
import 'cohort_review_screen.dart';
import 'lesson_screen.dart';
import 'paywall_screen.dart';
import 'privacy_policy_screen.dart';
import 'signup_screen.dart';
import 'terms_of_use_screen.dart';
import 'stats_screen.dart';
import 'word_memory_screen.dart';

/// Índice palavra → (lição, item) do currículo, montado uma vez. A revisão
/// espaçada consulta isto a cada build da home e de novo ao abrir a palavra;
/// varrer as 25 lições item a item toda vez era trabalho repetido à toa.
/// Palavra que aparece em mais de uma lição vale pela PRIMEIRA — é a que a
/// pessoa viu antes, e é sempre uma lição já liberada.
final Map<String, ({Lesson lesson, int index})> _wordIndex = () {
  final out = <String, ({Lesson lesson, int index})>{};
  for (final lesson in curriculum) {
    for (var i = 0; i < lesson.items.length; i++) {
      out.putIfAbsent(lesson.items[i].text, () => (lesson: lesson, index: i));
    }
  }
  return out;
}();

/// Dashboard: a barra das 484 horas, o streak e a porta de entrada das
/// lições. É a tela que o aluno vê todo dia — precisa mostrar progresso
/// real em segundos, não conclusão de telas.
///
/// Visual "clean" (2026-10-13, inspirado nos apps da Apple): título grande
/// no corpo, UM herói no topo (o próximo treino, com a única ação grande da
/// tela), progresso num cartão só, ofertas/instrumentos como linhas neutras
/// de lista e a trilha em grupos "inset grouped" por zona.
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

  // #8: por padrão só mostra concluídos + treino atual + poucos bloqueados —
  // muitos cadeados em sequência davam sensação de caminho longo e cansativo.
  bool _showAllLessons = false;

  // Desafio do dia, resolvido fora do build (o sorteio tem efeito colateral de
  // persistir no ProgressStore). Null = nenhuma lição elegível (não deve
  // acontecer: a lição 1 está sempre liberada) ou ainda não resolvido.
  Lesson? _challenge;

  // Título grande no corpo (estilo iOS): quando ele sai de vista ao rolar, o
  // título pequeno aparece centralizado na barra. Só apresentação.
  final ScrollController _scroll = ScrollController();
  bool _titleCollapsed = false;

  // #5/#13 Missões: rótulos pras primeiras lições não-bônus (camada leve por
  // cima do currículo). Sem número fixo no texto — o índice da missão não é
  // o mesmo da lição (bônus não contam), então numerar as duas confundia
  // (ex.: "Missão 7" dentro do card da lição 8). Aparece só no herói (o
  // próximo treino), como a frase de objetivo abaixo do nome da lição.
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
    for (final l in curriculum) {
      if (l.bonus) continue;
      if (l.id == lessonId) {
        return idx < _missions.length ? _missions[idx] : null;
      }
      idx++;
    }
    return null;
  }

  // Zonas de todas as trilhas, na ordem da fila (lib/data/curriculum.dart):
  // índice da 1ª lição de cada zona → trilha e nome exibido no cabeçalho.
  // O nome vem do currículo ("Zona 1 — …"); na tela o travessão vira "·".
  static final List<(int, Trail, String)> _zones = () {
    final out = <(int, Trail, String)>[];
    var i = 0;
    for (final t in trails) {
      for (final z in t.zones) {
        out.add((i, t, z.title.replaceFirst(' — ', ' · ')));
        i += z.lessons.length;
      }
    }
    return out;
  }();

  int _zoneOf(int lessonIndex) {
    var zone = 0;
    for (final (z, (start, _, _)) in _zones.indexed) {
      if (lessonIndex >= start) zone = z;
    }
    return zone;
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
    _scroll.addListener(_onScroll);
    _ensureDailyChallenge();
    // Conserto do funil: quem acabou de consentir entra direto na 1ª lição,
    // em vez de cair na dashboard vazia ("0 de 484h" assusta e não tem CTA).
    // Só no 1º acesso (progresso zero); initState roda 1x, sem repetir.
    if (widget.autostartFirstLesson &&
        widget.store.totalApproved == Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openLesson(curriculum.first);
      });
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    final collapsed = _scroll.hasClients && _scroll.offset > 40;
    if (collapsed != _titleCollapsed) {
      setState(() => _titleCollapsed = collapsed);
    }
  }

  Future<void> _confirmClearData() async {
    final cs = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apagar todos os seus dados?'),
        content: const Text(
            'Progresso, sequência de dias, lições concluídas, o '
            'consentimento de gravação e as gravações do desafio serão '
            'apagados deste dispositivo e da nuvem. Essa ação não pode ser '
            'desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            // Ação destrutiva em vermelho (tokens do tema: error = c.red).
            style: FilledButton.styleFrom(
              backgroundColor: cs.error,
              foregroundColor: cs.onError,
            ),
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

  /// Selo persistente de Fundador na barra do topo — torna o status (que hoje
  /// é o que o Fundador compra, já que as Trilhas 1 e 2 são grátis pra todos)
  /// visível.
  Widget _founderBadge(ThemeData theme) {
    final c = AppColors.of(context);
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
            color: c.goldFill,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.workspace_premium_rounded,
                  size: 16, color: theme.colorScheme.secondary),
              const SizedBox(width: 4),
              Text('Fundador',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: c.label,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  /// Linha neutra de lista (estilo Ajustes do iOS) para os cartões de
  /// produto: ícone em quadradinho, título, uma linha de apoio e chevron
  /// quando tocável.
  Widget _row({
    required Widget leading,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final c = AppColors.of(context);
    return ListTile(
      leading: leading,
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: trailing ??
          (onTap == null
              ? null
              : Icon(Icons.chevron_right_rounded, color: c.tertiaryLabel)),
      onTap: onTap,
    );
  }

  /// CTA da oferta Beta Fundador na dashboard. Aparece no "momento uau" (a
  /// pessoa já viu seu antes/depois → sabe que funciona) e some quando ela
  /// entra na lista de Fundadores. Não bloqueia nada: mede intenção sem
  /// tirar as lições grátis de quem só quer praticar.
  Widget _founderOfferRow(ThemeData theme) {
    return _row(
      leading: IconTile(Icons.workspace_premium_rounded,
          color: theme.colorScheme.secondary),
      title: 'Seja um Fundador do 484',
      // "voz no que vem depois" virava trocadilho ambíguo num app de fala;
      // volta à promessa original (apoio + ajudar a decidir), sem perk oco.
      subtitle: 'Garanta acesso vitalício e ajude a decidir o que vem depois.',
      onTap: _openPaywall,
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
      builder: (ctx) {
        final primary = Theme.of(ctx).colorScheme.primary;
        return AlertDialog(
          title: const Text('Tema'),
          contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (mode, label) in const [
                (ThemeMode.system, 'Sistema'),
                (ThemeMode.light, 'Claro'),
                (ThemeMode.dark, 'Escuro'),
              ])
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  title: Text(label),
                  trailing: widget.themeMode == mode
                      ? Icon(Icons.check_rounded, color: primary)
                      : null,
                  onTap: () {
                    widget.onThemeModeChanged?.call(mode);
                    Navigator.of(ctx).pop();
                  },
                ),
            ],
          ),
        );
      },
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
      if (mounted) setState(() {});
    });
  }

  /// Painel do dev, aberto só pelo long-press no título "484 Method".
  /// NÃO é controle de acesso (ver comentário no build).
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
        title: const Text('Ativar modo precisão?'),
        content: const Text(
            'Daqui pra frente, cada gravação passa por um critério mais '
            'exigente de clareza, ritmo e pronúncia, inclusive se você '
            'refizer uma lição. O que já está concluído continua concluído.'),
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
    while (prereq >= 0 && curriculum[prereq].bonus) {
      prereq--;
    }
    return prereq < 0 ||
        widget.store.isLessonCompleted(curriculum[prereq].id);
  }

  /// Resolve o desafio de hoje em [_challenge]. Tem efeito colateral (persiste
  /// o sorteio), então roda FORA do build — no initState e depois de eventos
  /// que mudam a elegibilidade (concluir lição, alternar acesso). Reaproveita
  /// o sorteio salvo do dia se ele ainda for elegível; re-sorteia se o acesso
  /// foi perdido (virou paywall) ou o id não existe mais (currículo mudou).
  void _ensureDailyChallenge() {
    final savedId = widget.store.dailyChallengeLessonId;
    if (savedId != null) {
      final idx = curriculum.indexWhere((l) => l.id == savedId);
      if (idx >= 0 && !_isPaywalled(idx) && _isProgressionUnlocked(idx)) {
        _challenge = curriculum[idx];
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
      for (final (i, l) in curriculum.indexed)
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

  Widget _dailyChallengeRow(ThemeData theme, Lesson lesson) {
    final c = AppColors.of(context);
    final done = widget.store.dailyChallengeCompleted;
    final isReview = widget.store.isLessonCompleted(lesson.id) && !done;
    return _row(
      leading: const IconTile(Icons.bolt_rounded),
      title: 'Desafio de hoje',
      subtitle: done
          ? '${lesson.title}. Feito, amanhã tem outro.'
          : isReview
              ? '${lesson.title} · revisão'
              : lesson.title,
      trailing: done
          ? Icon(Icons.check_circle_rounded,
              color: c.green, semanticLabel: 'Feito')
          : null,
      onTap: done ? null : () => _openLesson(lesson),
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
  /// esta linha traz de volta o que ela JÁ acertou e está na hora de conferir,
  /// antes que a memória caia. Cada revisão passa pelo loop normal, então
  /// rende minuto APROVADO — a métrica norte — e não só tempo de tela.
  Widget _srsReviewRow(ThemeData theme, List<String> due) {
    final n = due.length;
    return _row(
      leading: const IconTile(Icons.replay_rounded),
      title: 'Revisar hoje',
      // Diz POR QUE revisar (já acertou antes), sem travessão.
      subtitle: n == 1
          ? '1 palavra que você já acertou. Veja se ainda sai.'
          : '$n palavras que você já acertou. Veja se ainda saem.',
      onTap: () => _reviewWord(due.first),
    );
  }

  /// Desafio de 21 dias (instrumento de validação do beta): mede outcome, não
  /// só comportamento — confiança inicial vs. final + o antes/depois. A linha
  /// muda conforme o estágio: entrar → em andamento → fechar → concluído.
  Widget _cohortRow(ThemeData theme) {
    final store = widget.store;
    final c = AppColors.of(context);
    final gold = theme.colorScheme.secondary;

    if (!store.cohortStarted) {
      return _row(
        leading: IconTile(Icons.flag_rounded, color: gold),
        title: 'Desafio de 21 dias',
        subtitle: 'Treine todo dia. No fim, veja seu antes e depois.',
        onTap: _startCohort,
      );
    }

    if (store.cohortFinalDone) {
      return _row(
        leading: IconTile(Icons.emoji_events_rounded, color: gold),
        title: 'Desafio de 21 dias concluído',
        subtitle: 'Ver seu antes e depois',
        onTap: _openReview,
      );
    }

    if (store.cohortFinalUnlocked) {
      return _row(
        leading: IconTile(Icons.emoji_events_rounded, color: gold),
        title: 'Você chegou ao dia ${store.cohortDay}',
        subtitle: 'Feche o desafio e veja seu antes e depois.',
        onTap: _finishCohort,
      );
    }

    final day = store.cohortDay.clamp(1, ProgressStore.cohortLength);
    return _row(
      leading: IconTile(Icons.flag_rounded, color: gold),
      title: 'Desafio de 21 dias',
      subtitle: 'Dia $day de ${ProgressStore.cohortLength}. '
          'Pratique um pouco hoje.',
      trailing: SizedBox(
        width: 26,
        height: 26,
        child: CircularProgressIndicator(
          value: day / ProgressStore.cohortLength,
          strokeWidth: 3.5,
          color: gold,
          backgroundColor: c.fill,
          semanticsLabel:
              'Desafio de 21 dias: dia $day de ${ProgressStore.cohortLength}',
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
            'Pra você comparar seu antes e depois, o 484 vai guardar duas '
            'gravações suas: uma hoje e outra no fim dos 21 dias. Nas lições '
            'o áudio só é analisado na hora; aqui ele fica salvo, num espaço '
            'privado. Você pode apagar tudo quando quiser em "Apagar meus '
            'dados". Sem isso, o desafio segue só com a sua autoavaliação.'),
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
      title: 'Você chegou ao fim do desafio',
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
    for (final l in curriculum) {
      if (l.bonus) continue;
      if (!widget.store.isLessonCompleted(l.id)) return l;
    }
    return null;
  }

  /// O herói da home (#8): uma única ação clara no topo, sem paradoxo de
  /// escolha. #9: nomeia o treino (nome grande), a missão e o tamanho do
  /// treino; a recompensa concreta (meta de hoje/primeiro marco) aparece
  /// logo abaixo, no cartão de progresso.
  Widget _nextBestActionCard(ThemeData theme, Lesson next) {
    final c = AppColors.of(context);
    final mission = _missionFor(next.id);
    // Já gravou algum item desta lição e saiu no meio: retoma de onde parou.
    final started = widget.store.itemIndexFor(next.id) > 0;
    final trail = trailOf[next.id];
    final opensTrail = trail != null &&
        trail.number > 1 &&
        trail.lessons.first.id == next.id;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Próxima melhor ação" era termo de produto; o aluno lê "treino".
            // Abertura de trilha: a anterior acabou de ser concluída, vale
            // dizer isso em vez de só "próximo treino".
            Text(
                opensTrail
                    ? 'Trilha ${trail.number - 1} concluída. Agora: '
                        'Trilha ${trail.number} · ${trail.title}'
                    : 'Seu próximo treino',
                style: theme.textTheme.labelMedium),
            const SizedBox(height: 6),
            Text(next.title, style: theme.textTheme.headlineMedium),
            if (mission != null) ...[
              const SizedBox(height: 4),
              Text(mission,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: c.secondaryLabel)),
            ],
            const SizedBox(height: 10),
            // O microSkill é nota interna do currículo ("Progresso visível",
            // "Molde único, 5 finais"): não vai pra tela do aluno.
            Text('${next.items.length} tentativas de fala · ~5 min',
                style: theme.textTheme.bodySmall),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _openLesson(next),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(started ? 'Continuar' : 'Começar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Uma linha de progresso: rótulo + valor à direita e barra fina embaixo.
  Widget _meter(
    ThemeData theme, {
    required String label,
    required String value,
    required double fraction,
    required Color color,
    bool done = false,
  }) {
    final c = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Wrap em vez de Row: em tela estreita (320pt) ou com fonte grande o
        // valor desce pra linha de baixo em vez de estourar a largura.
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 2,
          children: [
            Text(label, style: theme.textTheme.titleSmall),
            if (done)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, size: 16, color: c.green),
                  const SizedBox(width: 4),
                  Text('Concluída',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: c.green, fontWeight: FontWeight.w600)),
                ],
              )
            else
              Text(value, style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: fraction.clamp(0.0, 1.0),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
          color: color,
          backgroundColor: c.fill,
          // Valor só numérico no semantics da barra; o texto vai no rótulo.
          semanticsLabel: '$label: ${done ? 'concluída' : value}',
        ),
      ],
    );
  }

  /// #7: a hierarquia de progresso num cartão só, do mais imediato pro mais
  /// distante: meta de hoje → primeiro marco, que dá lugar à jornada de 484h
  /// quando alcançado, e a sequência de dias no rodapé. Escondido no dia 0 (a
  /// barra "0 de 484h" assusta e a sequência ainda é 0 mesmo).
  Widget _progressCard(ThemeData theme) {
    final c = AppColors.of(context);
    final store = widget.store;
    final gold = theme.colorScheme.secondary;
    final today = store.approvedToday;
    const goal = ProgressStore.dailyGoalSeconds;
    final reached = today.inSeconds >= goal;
    final total = store.totalApproved;
    final streak = store.streakDays;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _meter(
              theme,
              label: 'Meta de hoje',
              value: '${_short(today)} de '
                  '${_short(const Duration(seconds: goal))}',
              fraction: today.inSeconds / goal,
              color: reached ? c.green : gold,
              done: reached,
            ),
            if (!store.reachedFirstMilestone) ...[
              const SizedBox(height: 16),
              _meter(
                theme,
                label: 'Primeiro marco',
                value: '${_short(total)} de ${_short(const Duration(
                    seconds: ProgressStore.firstMilestoneSeconds))}',
                fraction: store.firstMilestoneFraction,
                color: gold,
              ),
            ] else ...[
              // A jornada SUBSTITUI o primeiro marco (as duas barras medem o
              // mesmo total; juntas eram dois medidores do mesmo número).
              const SizedBox(height: 16),
              _meter(
                theme,
                label: 'Jornada 484h',
                value: '${_short(total)} de 484h',
                fraction: store.goalFraction,
                color: gold,
              ),
            ],
            if (streak > 0) ...[
              const SizedBox(height: 16),
              Divider(height: 0.5, thickness: 0.5, color: c.separator),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.local_fire_department_rounded,
                      size: 18, color: gold),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      streak == 1
                          ? 'Sequência de 1 dia'
                          : 'Sequência de $streak dias',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
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
  Widget _precisionModeGroup(ThemeData theme) {
    return InsetGroup(
      footer: 'Critério mais exigente de clareza, ritmo e pronúncia.',
      children: [
        SwitchListTile(
          value: widget.store.rigorousMode,
          onChanged: (v) async {
            if (v && !await _confirmEnableRigorous()) return;
            await widget.store.setRigorousMode(v);
            setState(() {});
          },
          title: const Text('Modo precisão'),
          secondary: const IconTile(Icons.track_changes_rounded),
        ),
      ],
    );
  }

  /// Uma lição da trilha como linha de lista: estado à esquerda (check verde
  /// = concluída, play no acento = liberada, cadeado cinza = bloqueada),
  /// título, tentativas/duração e chevron quando dá pra abrir.
  Widget _lessonRow(
    ThemeData theme,
    Lesson lesson, {
    required bool completed,
    required bool paywalled,
    required bool progressionUnlocked,
  }) {
    final c = AppColors.of(context);
    final unlocked = !paywalled && progressionUnlocked;
    final meta = '${lesson.items.length} tentativas de fala · ~5 min';
    final String subtitle;
    final trail = trailOf[lesson.id];
    if (paywalled) {
      subtitle = 'Beta Fundador';
    } else if (!progressionUnlocked &&
        trail != null &&
        trail.number > 1 &&
        trail.lessons.first.id == lesson.id) {
      // A 1ª lição da trilha exige a trilha anterior inteira (não só a
      // lição de cima): diz isso em vez de só mostrar o cadeado.
      subtitle = 'Conclua a trilha anterior para liberar';
    } else if (lesson.bonus) {
      subtitle = 'Bônus · $meta';
    } else {
      subtitle = meta;
    }
    final Widget status;
    if (completed) {
      status = Icon(Icons.check_circle_rounded,
          size: 28, color: c.green, semanticLabel: 'Concluída');
    } else if (paywalled) {
      status = Icon(Icons.workspace_premium_rounded,
          size: 26,
          color: theme.colorScheme.secondary,
          semanticLabel: 'Beta Fundador');
    } else if (!progressionUnlocked) {
      status = Icon(Icons.lock_rounded,
          size: 22, color: c.tertiaryLabel, semanticLabel: 'Bloqueada');
    } else {
      status = Icon(Icons.play_circle_fill_rounded,
          size: 28, color: theme.colorScheme.primary);
    }
    final tappable = unlocked || paywalled;
    return ListTile(
      // Paywalled fica tocável para mostrar o aviso do gate.
      enabled: tappable,
      leading: SizedBox(width: 30, child: Center(child: status)),
      title: Text(lesson.title),
      subtitle: Text(subtitle),
      trailing: tappable
          ? Icon(Icons.chevron_right_rounded, color: c.tertiaryLabel)
          : null,
      onTap: paywalled
          ? _openPaywall
          : unlocked
              ? () => _openLesson(lesson)
              : null,
    );
  }

  /// Cabeçalho de trilha: nome grande + "Trilha N · subtítulo".
  Widget _trailHeader(ThemeData theme, Trail trail) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(trail.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 2),
            Text('Trilha ${trail.number} · ${trail.subtitle}',
                style: theme.textTheme.bodySmall),
          ],
        ),
      );

  /// #8: reduz o efeito visual de muitos bloqueios — mostra concluídos, o
  /// treino atual e só os próximos poucos bloqueados; o resto fica atrás de
  /// um botão "Ver trilha completa"; zona concluída encolhe pra uma linha.
  /// Cada zona vira um grupo "inset grouped".
  List<Widget> _lessonList(ThemeData theme) {
    const lockedVisibleLimit = 3;
    final next = _nextLesson();
    final nextIndex = next == null ? -1 : curriculum.indexOf(next);
    final rowsByZone = <int, List<Widget>>{};
    var lockedShown = 0;
    var hiddenCount = 0;

    // Zonas com todas as lições obrigatórias feitas encolhem pra uma linha
    // (senão, no meio da trilha, as concluídas empurram o treino atual pra
    // telas abaixo). Bônus não contam, como na progressão.
    final completedZones = <int>{
      for (var z = 0; z < _zones.length; z++)
        if (curriculum.indexed.every((e) =>
            _zoneOf(e.$1) != z ||
            e.$2.bonus ||
            widget.store.isLessonCompleted(e.$2.id)))
          z,
    };
    final collapsedCount = <int, int>{};

    for (final (i, lesson) in curriculum.indexed) {
      final zone = _zoneOf(i);
      if (!_showAllLessons && completedZones.contains(zone)) {
        hiddenCount++;
        if (widget.store.isLessonCompleted(lesson.id)) {
          collapsedCount[zone] = (collapsedCount[zone] ?? 0) + 1;
        }
        continue;
      }
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

      rowsByZone.putIfAbsent(zone, () => []).add(_lessonRow(
            theme,
            lesson,
            completed: completed,
            paywalled: paywalled,
            progressionUnlocked: progressionUnlocked,
          ));
    }

    final widgets = <Widget>[];
    final c = AppColors.of(context);
    Trail? shownTrail;
    for (final (z, (_, trail, name)) in _zones.indexed) {
      var rows = rowsByZone[z];
      final done = completedZones.contains(z);
      if (rows == null && done && !_showAllLessons) {
        final n = collapsedCount[z] ?? 0;
        rows = [
          ListTile(
            leading: SizedBox(
              width: 30,
              child: Center(
                child: Icon(Icons.check_circle_rounded,
                    size: 28, color: c.green, semanticLabel: 'Concluída'),
              ),
            ),
            title: Text(n == 1 ? '1 treino feito' : '$n treinos feitos'),
            trailing:
                Icon(Icons.chevron_right_rounded, color: c.tertiaryLabel),
            onTap: () => setState(() => _showAllLessons = true),
          ),
        ];
      }
      if (rows == null) continue;
      if (trail != shownTrail) {
        // Cabeçalho da trilha entra junto do 1º grupo visível dela.
        shownTrail = trail;
        if (widgets.isNotEmpty) widgets.add(const SizedBox(height: 36));
        widgets.add(_trailHeader(theme, trail));
        widgets.add(const SizedBox(height: 16));
      } else if (widgets.isNotEmpty) {
        widgets.add(const SizedBox(height: 24));
      }
      widgets.add(InsetGroup(
          header: done ? '$name · concluída' : name, children: rows));
    }

    if (hiddenCount > 0 && !_showAllLessons) {
      widgets.add(const SizedBox(height: 8));
      widgets.add(Center(
        child: TextButton(
          onPressed: () => setState(() => _showAllLessons = true),
          child: const Text('Ver trilha completa'),
        ),
      ));
    }

    return widgets;
  }

  /// Pergunta curta com respostas em chips (pesquisas de abandono e de PMF):
  /// cartão branco compacto, sem cor de fundo.
  Widget _surveyCard(
    ThemeData theme, {
    required String question,
    required List<(String, String)> options,
    required ValueChanged<String> onAnswer,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pergunta rápida', style: theme.textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(question, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (val, label) in options)
                  ActionChip(
                    label: Text(label),
                    onPressed: () => onAnswer(val),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // #10 Card de abandono: aparece quando a pessoa começou mas não fechou o
  // 1º ciclo (gravou, mas não chegou ao antes/depois). Pergunta o porquê.
  Widget _abandonCard(ThemeData theme) => _surveyCard(
        theme,
        question: 'O que te impediu de continuar?',
        options: _abandonOptions,
        onAnswer: _answerAbandon,
      );

  void _answerAbandon(String reason) {
    widget.analytics?.log('abandon_reason', {'reason': reason});
    widget.store.setAskedAbandon();
    setState(() => _abandonAnswered = true);
  }

  /// Teste de PMF (Sean Ellis): uma pergunta a quem já sentiu o valor e voltou.
  /// Mede a INTENSIDADE que a retenção sozinha não captura.
  Widget _pmfCard(ThemeData theme) => _surveyCard(
        theme,
        question: 'Como você se sentiria se não pudesse mais usar o 484?',
        options: _pmfOptions,
        onAnswer: _answerPmf,
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
    final c = AppColors.of(context);
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
    // Quem já é Fundador não vê mais a oferta (vê o selo no topo).
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

    // Cartões de produto viram linhas de grupos neutros (mesmas condições).
    // Treino (revisão + desafio de hoje) fica colado no herói: é prática que
    // rende minuto aprovado e não pode cair abaixo da dobra. Convites
    // (21 dias, Fundador) vão depois do progresso, sem competir com o herói.
    final trainingRows = <Widget>[
      if (dueReview.isNotEmpty) _srsReviewRow(theme, dueReview),
      if (showChallenge) _dailyChallengeRow(theme, challenge),
    ];
    final inviteRows = <Widget>[
      if (showCohort) _cohortRow(theme),
      if (showFounderOffer) _founderOfferRow(theme),
    ];

    // Blocos do topo, na ordem: herói → treino extra → pesquisas →
    // progresso → convites.
    final blocks = <Widget>[
      if (next != null) _nextBestActionCard(theme, next),
      if (trainingRows.isNotEmpty) InsetGroup(children: trainingRows),
      if (askAbandon) _abandonCard(theme),
      if (showPmf) _pmfCard(theme),
      // #7: meta de hoje → primeiro marco (depois jornada 484h). Escondido no
      // dia 0 (o herói já carrega a promessa do primeiro treino).
      if (!isBrandNew) _progressCard(theme),
      if (inviteRows.isNotEmpty) InsetGroup(children: inviteRows),
    ];

    return Scaffold(
      appBar: AppBar(
        title: AnimatedOpacity(
          opacity: _titleCollapsed ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          // Acesso oculto do painel do dev (mesmo gesto do título grande).
          child: GestureDetector(
            onLongPress: _openStats,
            child: const Text('484 Method'),
          ),
        ),
        shape: _titleCollapsed
            ? Border(bottom: BorderSide(color: c.separator, width: 0.5))
            : null,
        actions: [
          if (widget.entitlement.hasFounderAccess) _founderBadge(theme),
          PopupMenuButton<String>(
            tooltip: 'Mais opções',
            icon: const Icon(Icons.more_horiz_rounded),
            onSelected: (v) {
              if (v == 'clear') _confirmClearData();
              if (v == 'privacy') _openPrivacyPolicy();
              if (v == 'terms') _openTermsOfUse();
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
              const PopupMenuItem(
                value: 'privacy',
                child: Text('Política de privacidade'),
              ),
              const PopupMenuItem(
                value: 'terms',
                child: Text('Termos de Uso'),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'clear',
                child: Text('Apagar meus dados',
                    style: TextStyle(color: c.red)),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppStyle.maxContentWidth),
          child: ListView(
            controller: _scroll,
            padding: EdgeInsets.fromLTRB(
              AppStyle.pagePadding,
              0,
              AppStyle.pagePadding,
              32 + MediaQuery.paddingOf(context).bottom,
            ),
            children: [
              // Título grande alinhado à esquerda, como nas telas raiz do iOS.
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Semantics(
                  header: true,
                  // Painel do dev: segurar o título abre (mesmo padrão de
                  // maintenance_screen). Isto NÃO é controle de acesso, só
                  // evita que o aluno caia lá por clique acidental (antes era
                  // um item do menu ⋮ visível pra todos). O dev-stats segue
                  // aberto a qualquer sessão; o caminho certo é login real
                  // com allowlist (ver CLAUDE.md).
                  child: GestureDetector(
                    onLongPress: _openStats,
                    child: Text('484 Method',
                        style: theme.textTheme.displaySmall),
                  ),
                ),
              ),
              for (final (i, block) in blocks.indexed) ...[
                if (i > 0) const SizedBox(height: 16),
                block,
              ],
              const SizedBox(height: 36),
..._lessonList(theme),
              if (showPrecision) ...[
                const SizedBox(height: 32),
                _precisionModeGroup(theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Duração enxuta pra UI: segundos só quando é pouco (abaixo de 10min),
  /// pra não virar contagem irrisória ("42min 0s").
  String _short(Duration d) {
    if (d.inHours > 0) {
      final m = d.inMinutes % 60;
      return m == 0 ? '${d.inHours}h' : '${d.inHours}h ${m}min';
    }
    if (d.inMinutes > 0) {
      final s = d.inSeconds % 60;
      return (s == 0 || d.inMinutes >= 10)
          ? '${d.inMinutes}min'
          : '${d.inMinutes}min ${s}s';
    }
    return '${d.inSeconds}s';
  }
}
