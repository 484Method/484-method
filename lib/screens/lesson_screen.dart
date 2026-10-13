import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/lesson.dart';
import '../services/analytics_service.dart';
import '../services/audio_recorder_service.dart';
import '../services/backend.dart';
import '../services/feedback_messages.dart';
import '../services/progress_store.dart';
import '../services/pronunciation_assessor.dart';
import '../ui/app_style.dart';

/// Conteúdo de uma etapa: o miolo (centrado, rola se não couber) e as ações
/// presas embaixo, na zona do polegar.
typedef _StepView = ({Widget body, List<Widget> actions});

/// Fluxo som-first de uma microlição (template de 8 etapas do método):
/// ouvir sem texto → repetir de ouvido → feedback → Livro Aberto →
/// regravação final → minutos aprovados.
///
/// Regra inegociável: o texto da palavra NUNCA aparece antes da primeira
/// tentativa oral avaliada.
class LessonScreen extends StatefulWidget {
  const LessonScreen({
    super.key,
    required this.lesson,
    required this.assessor,
    this.store,
    this.analytics,
    this.rigorous = false,
    this.startItemIndex,
  });

  final Lesson lesson;
  final PronunciationAssessor assessor;

  /// Modo desafio: aprovação exige pronúncia próxima da nativa.
  final bool rigorous;

  /// Quando presente, o tempo aprovado é persistido (barra das 484h).
  final ProgressStore? store;

  final AnalyticsService? analytics;

  /// Quando presente, começa neste item — usado por "Revisar agora" do mapa
  /// de fala, em vez de retomar o índice salvo.
  final int? startItemIndex;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

enum _Step {
  intro,
  listen, // áudio sem texto + 1ª gravação
  feedbackFirst,
  livroAberto, // texto liberado + regravação final
  resultFinal,
  finished,
}

enum _RecPhase { idle, preparing, recording, sending }

class _LessonScreenState extends State<LessonScreen>
    with SingleTickerProviderStateMixin {
  final AudioRecorderService _recorder = AudioRecorderService();
  AudioPlayer? _player;

  var _step = _Step.intro;
  var _recPhase = _RecPhase.idle;
  int _index = 0;
  bool _hasListened = false;
  PronunciationResult? _result;
  double? _firstAccuracy; // accuracy da 1ª tentativa, p/ medir a melhora
  String? _error;

  /// Feedback gerado pela Claude (Edge Function) para o resultado atual.
  /// null = ainda não chegou (ou indisponível) → usa a mensagem fixa.
  String? _aiFeedback;
  // Invalida respostas atrasadas: só a última tentativa pode setar o texto.
  int _feedbackToken = 0;
  Duration _approved = Duration.zero;
  Duration _audioSent = Duration.zero;

  /// Tempo da regravação final quando aprovada — exibido no antes/depois.
  Duration? _lastApprovedDuration;
  // "Momento Uau": esconde a pergunta de percepção quando já respondida.
  late bool _ahaAnswered = widget.store?.hasAnsweredAha ?? true;

  /// Accuracy final de cada palavra (capturada ao avançar). Usada para
  /// calcular a média exibida na tela de conclusão.
  final List<double> _wordAccuracies = [];

  LessonItem get _item => widget.lesson.items[_index];
  bool get _isLastItem => _index == widget.lesson.items.length - 1;

  /// "frase" quando o item tem mais de uma palavra, senão "palavra": lição
  /// de chunks não chama tudo de palavra. Só diz o tipo, nunca o texto.
  String get _unit => _item.text.trim().contains(' ') ? 'frase' : 'palavra';

  late final AnimationController _pulseController;
  late final Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();
    // Retoma de onde parou em vez de recomeçar do item 1 — sem isso, quem
    // fecha a lição na metade e volta depois é jogado de volta pro início
    // (achado real: usuários que já tinham passado 3-4 palavras reabriram a
    // lição, caíram na 1ª palavra de novo, reprovaram e desistiram).
    final saved = widget.startItemIndex ??
        widget.store?.itemIndexFor(widget.lesson.id) ??
        0;
    _index = saved.clamp(0, widget.lesson.items.length - 1);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    // Anel que pulsa em volta do botão de gravar enquanto o microfone está
    // aberto (como no Gravador da Apple).
    _pulseScale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _player?.dispose();
    _recorder.dispose();
    super.dispose();
  }

  /// Dispara um evento de ativação (Fase 0) só na 1ª vez (gating no store).
  /// Sem store (testes) não dispara.
  void _logFirst(String event, [Map<String, Object?> extra = const {}]) {
    if (widget.store?.firstOnce(event) ?? false) {
      widget.analytics?.log(event, {'lesson': widget.lesson.id, ...extra});
    }
  }

  Future<void> _play() async {
    if (_recPhase == _RecPhase.recording || _recPhase == _RecPhase.preparing) return;
    // Libera a gravação imediatamente: o destrave da UI não pode depender
    // do ciclo de vida do player (no web, stop/play podem demorar).
    if (!_hasListened) {
      setState(() => _hasListened = true);
      _logFirst('first_listen_completed');
    }
    try {
      _player ??= AudioPlayer();
      if (_player!.state == PlayerState.playing) await _player!.stop();
      await _player!.play(AssetSource(_item.audioAsset));
    } catch (e) {
      debugPrint('[licao] falha ao tocar áudio: $e');
      setState(() => _error = 'Não consegui tocar o áudio. Tente de novo.');
    }
  }

  Future<void> _toggleRecording() async {
    switch (_recPhase) {
      case _RecPhase.idle:
        if (!await _recorder.hasPermission()) {
          // Sem caminho de Chrome de desktop ("cadeado"): no Safari do
          // iPhone esse ícone não existe. Recarregar faz o navegador
          // perguntar de novo.
          setState(() => _error = kIsWeb
              ? 'Sem acesso ao microfone. Recarregue a página e toque em '
                  'Permitir quando o navegador pedir. Se ele não pedir, '
                  'libere o microfone nos ajustes do site (no iPhone, pelo '
                  'menu ao lado do endereço).'
              : 'Sem acesso ao microfone. Libere o microfone para o 484 '
                  'nos Ajustes do aparelho e grave de novo.');
          return;
        }
        if (_player?.state == PlayerState.playing) await _player!.stop();
        setState(() {
          _recPhase = _RecPhase.preparing;
          _error = null;
        });
        await _recorder.start(
          onAutoStop: _stopAndAssess,
          // Frase ganha pausa maior antes do auto-stop (aluno pausa entre
          // palavras); palavra isolada continua parando rápido.
          expectedWords: _item.text.trim().split(RegExp(r'\s+')).length,
        );
        if (mounted && _recPhase == _RecPhase.preparing) {
          setState(() => _recPhase = _RecPhase.recording);
          _pulseController.repeat(reverse: true);
        }
      case _RecPhase.recording:
        await _stopAndAssess();
      case _RecPhase.preparing:
      case _RecPhase.sending:
        break;
    }
  }

  Future<void> _stopAndAssess() async {
    if (_recPhase != _RecPhase.recording) return;
    setState(() => _recPhase = _RecPhase.sending);
    _pulseController.stop();
    _pulseController.reset();

    final audio = await _recorder.stop();
    if (audio == null) {
      widget.analytics?.log('recording_discarded_silence', {
        'lesson': widget.lesson.id,
        'item': _item.text,
      });
      setState(() {
        _recPhase = _RecPhase.idle;
        _error = 'Não ouvi nada. Fale mais perto do microfone.';
      });
      return;
    }

    // Calcula attempt antes do assess — o servidor precisa para gerar feedback.
    final attempt = _step == _Step.listen ? 1 : 2;
    try {
      final result = await widget.assessor.assess(
        wavAudio: audio.wavBytes,
        referenceText: _item.text,
        attempt: attempt,
      );
      final approved = widget.lesson.approves(
          result.accuracy, result.minPhoneme, result.prosody,
          rigorous: widget.rigorous);
      widget.analytics?.log('attempt_assessed', {
        'lesson': widget.lesson.id,
        'item': _item.text,
        'attempt': attempt,
        'accuracy': result.accuracy,
        'min_phoneme': result.minPhoneme,
        'prosody': result.prosody,
        'approved': approved,
        'audio_seconds': audio.duration.inMilliseconds / 1000,
      });
      // Só a gravação FINAL (etapa 7) mexe na escada de revisão espaçada: a
      // 1ª tentativa é diagnóstico de ouvido, não prova de domínio. Lido aqui
      // porque _step muda dentro do setState logo abaixo.
      final isFinalAttempt = _step == _Step.livroAberto;
      // Fixa a palavra agora: depois do await abaixo o aluno já pode ter
      // tocado em "Próxima palavra", e _item apontaria para a seguinte.
      final srsWord = _item.text;
      final srsStageBefore =
          isFinalAttempt ? widget.store?.srsStageOf(srsWord) : null;
      setState(() {
        _result = result;
        _aiFeedback = null;
        _audioSent += audio.duration;
        _recPhase = _RecPhase.idle;
        if (_step == _Step.listen) {
          _firstAccuracy = result.accuracy;
          _step = _Step.feedbackFirst;
        } else if (_step == _Step.livroAberto) {
          // Zera antes: sem isso, uma final reprovada herdava o tempo da
          // palavra anterior (approvedSeconds do evento aha_moment_answered).
          _lastApprovedDuration = null;
          if (approved) {
            _approved += audio.duration;
            _lastApprovedDuration = audio.duration;
            widget.store?.addApproved(audio.duration);
          }
          _step = _Step.resultFinal;
        }
      });
      // Eventos de ativação (Fase 0) — só na 1ª vez (gating no store).
      _logFirst('first_recording_completed');
      if (attempt == 1) {
        _logFirst('first_feedback_seen');
      } else {
        _logFirst('first_retry_completed');
        _logFirst('first_before_after_seen');
        if (approved) _logFirst('first_approved_minute_earned');
      }
      _maybeFetchAiFeedback(result, attempt, approved);
      if (isFinalAttempt) {
        // try próprio: a avaliação já deu certo e o minuto já contou. Se
        // gravar a agenda local falhar (cota de storage no web, por exemplo),
        // isso não pode cair no catch de baixo e virar "não consegui avaliar
        // sua gravação" — com o áudio ainda contado duas vezes em _audioSent.
        try {
          final stage =
              await widget.store?.recordSrsOutcome(srsWord, approved: approved);
          // Só conta como REVISÃO se a palavra já estava na escada; a primeira
          // aprovação apenas a agenda, não prova que a memória durou.
          if (stage != null && srsStageBefore != null) {
            widget.analytics?.log('srs_review_done', {
              'item': srsWord,
              'from_stage': srsStageBefore,
              'to_stage': stage,
              'approved': approved,
            });
          }
        } catch (e) {
          debugPrint('[licao] agenda de revisão espaçada falhou: $e');
        }
      }
    } catch (e) {
      debugPrint('[licao] avaliação falhou: $e');
      widget.analytics?.log('assessment_failed', {
        'lesson': widget.lesson.id,
        'item': _item.text,
        'attempt': attempt,
        'error': e.toString(),
      });
      setState(() {
        _audioSent += audio.duration;
        // PronunciationAssessmentException já distingue erro do servidor
        // (código HTTP) de falha de conexão na própria mensagem; exceções
        // genéricas (sem rede, timeout) caem no texto fixo de conectividade.
        _error = e is PronunciationAssessmentException
            ? e.message
            : 'Não consegui avaliar sua gravação agora. '
                'Confira sua conexão e grave de novo.';
        _recPhase = _RecPhase.idle;
      });
    }
  }

  /// Mensagem a exibir: a da Claude quando chegou, senão a fixa (fallback
  /// imediato e offline). Mantém a regra de produto mesmo sem rede/chave.
  String _feedbackText(PronunciationResult r) =>
      _aiFeedback ??
      feedbackFor(r, widget.lesson,
          rigorous: widget.rigorous, tip: _item.soundTip);

  /// Dispara o feedback da Claude em segundo plano. Só busca quando a
  /// mensagem realmente será mostrada (1ª tentativa sempre; tentativa final
  /// só quando reprovou) — aprovação na final exibe o selo, não o texto.
  /// Sem backend (modo local) ou acima do teto diário (429), fica na fixa.
  void _maybeFetchAiFeedback(
      PronunciationResult r, int attempt, bool approved) {
    final backend = Backend.instance;
    if (backend == null) return; // modo local-only: fica na mensagem fixa
    if (attempt == 2 && approved) return; // texto não aparece → não gasta
    final token = ++_feedbackToken;
    backend.generateFeedback({
      'word': _item.text,
      'attempt': attempt,
      'approved': approved,
      'accuracy': r.accuracy.round(),
      'fluency': r.fluency.round(),
      'completeness': r.completeness.round(),
      'prosody': r.prosody?.round(),
      'minPhoneme': r.minPhoneme.round(),
      'worstSyllable': r.worstSyllable?.grapheme,
      // Armadilha de som que o item treina (Trilha 2): a function usa como
      // base da instrução quando a tentativa não passou. Versões antigas da
      // function ignoram o campo — o deploy delas é manual.
      if (_item.soundTip != null) 'tip': _item.soundTip,
    }).then((msg) {
      if (!mounted || token != _feedbackToken || msg == null) return;
      setState(() => _aiFeedback = msg);
    });
  }

  /// Regrava a tentativa final: volta ao Livro Aberto (palavra visível, dá
  /// pra ouvir de novo). Mantém _firstAccuracy para a melhora seguir medida
  /// desde a 1ª tentativa de ouvido. Sem prender — é sempre opcional.
  void _retryFinal() {
    setState(() => _step = _Step.livroAberto);
  }

  void _nextItem() {
    if (_result != null) _wordAccuracies.add(_result!.accuracy);
    setState(() {
      if (_isLastItem) {
        _step = _Step.finished;
        // Antes de marcar: markLessonCompleted também dá baixa no desafio.
        final wasDailyChallenge =
            widget.store?.dailyChallengeLessonId == widget.lesson.id &&
                widget.store?.dailyChallengeCompleted == false;
        widget.store?.markLessonCompleted(widget.lesson.id);
        widget.store?.clearItemIndex(widget.lesson.id);
        widget.analytics?.log('lesson_completed', {
          'lesson': widget.lesson.id,
          'approved_seconds': _approved.inSeconds,
          'audio_sent_seconds': _audioSent.inSeconds,
          'daily_challenge': wasDailyChallenge,
        });
      } else {
        _index++;
        widget.store?.saveItemIndex(widget.lesson.id, _index);
        _step = _Step.listen;
        _hasListened = false;
        _result = null;
        _aiFeedback = null;
        _firstAccuracy = null;
        _error = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = AppColors.of(context);
    // Durante o loop (ouvir → resultado) a barra mostra título, contador e
    // progresso; na abertura e na conclusão o título vai grande no corpo.
    final inLoop = _step != _Step.intro && _step != _Step.finished;
    final total = widget.lesson.items.length;
    final view = _buildStep(theme);
    return Scaffold(
      appBar: AppBar(
        title: inLoop ? Text(widget.lesson.title) : null,
        actions: [
          if (inLoop)
            Padding(
              padding: const EdgeInsets.only(right: AppStyle.pagePadding),
              child: Center(
                child: Text(
                  '${_index + 1}/$total',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: c.secondaryLabel,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppStyle.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (inLoop)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppStyle.pagePadding, 4, AppStyle.pagePadding, 0),
                  child: TweenAnimationBuilder<double>(
                    // Item só conta como feito no resultado: a barra não
                    // marca 100% no começo da última palavra.
                    tween: Tween(
                        end: (_index + (_step == _Step.resultFinal ? 1 : 0)) /
                            total),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                      color: theme.colorScheme.secondary,
                      backgroundColor: c.fill,
                    ),
                  ),
                ),
              Expanded(child: view.body),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: _error == null
                    ? const SizedBox(width: double.infinity)
                    : _errorBanner(theme),
              ),
              BottomActions(children: view.actions),
            ],
          ),
        ),
      ),
    );
  }

  /// Erro discreto logo acima das ações: texto normal sobre um vermelho
  /// bem claro, com o ícone carregando a cor.
  Widget _errorBanner(ThemeData theme) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppStyle.pagePadding, 8, AppStyle.pagePadding, 0),
      // Fica fora da rolagem do miolo, junto das ações fixas: com a
      // mensagem longa do microfone + fonte grande (ou tela baixa) ela
      // empurraria os botões pra fora da tela. Teto de altura + rolagem
      // própria mantém os botões de gravar sempre visíveis.
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.25),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: c.redFill,
            borderRadius: BorderRadius.circular(AppStyle.buttonRadius),
          ),
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.error_outline_rounded, color: c.red, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(_error!, style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Comparação antes/depois (tentativa 1 → 2): o "momento de
  /// transformação" do método, num cartão compacto. Selo do estado em cima,
  /// as duas notas, o ganho em verde e, em frases, o mapa por sílaba.
  Widget _resultHero(ThemeData theme, PronunciationResult r, double gain,
      {required String badge, required bool approved}) {
    final c = AppColors.of(context);
    final text = theme.textTheme;
    const tabular = [FontFeature.tabularFigures()];
    Widget score(String label, int value, {required bool big}) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: text.labelMedium),
            const SizedBox(height: 2),
            Text(
              '$value',
              style: big
                  ? text.displayMedium?.copyWith(fontFeatures: tabular)
                  : text.headlineLarge?.copyWith(
                      color: c.secondaryLabel,
                      fontWeight: FontWeight.w600,
                      fontFeatures: tabular),
            ),
          ],
        );
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          children: [
            _statusBadge(theme, badge, approved: approved),
            const SizedBox(height: 16),
            if (_firstAccuracy != null)
              // scaleDown: com fonte grande (acessibilidade) numa tela de
              // 320pt as duas notas não cabem lado a lado; encolhe em vez de
              // estourar a linha.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    score('Antes', _firstAccuracy!.round(), big: false),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Icon(Icons.arrow_forward_rounded,
                          size: 26, color: c.tertiaryLabel),
                    ),
                    score('Depois', r.accuracy.round(), big: true),
                  ],
                ),
              )
            else
              score('Sua nota', r.accuracy.round(), big: true),
            if (_firstAccuracy != null) ...[
              const SizedBox(height: 6),
              Text(
                '${gain >= 0 ? "+" : ""}${gain.toStringAsFixed(0)} pontos',
                style: text.titleMedium?.copyWith(
                    color: gain > 0 ? c.green : c.secondaryLabel),
              ),
            ],
            // Mapa de sílabas: a escrita já foi liberada no Livro Aberto,
            // então mostrar os grafemas aqui não fere o som-first.
            _SyllableMap(result: r),
          ],
        ),
      ),
    );
  }

  /// Selo do resultado: verde quando aprovado, neutro quando ainda não
  /// (nunca vermelho: a fala melhorou, só não bateu o critério).
  Widget _statusBadge(ThemeData theme, String label, {required bool approved}) {
    final c = AppColors.of(context);
    final fg = approved ? c.green : c.secondaryLabel;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: approved ? c.greenFill : c.fill,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              approved
                  ? Icons.check_circle_rounded
                  : Icons.replay_circle_filled_rounded,
              size: 18,
              color: fg),
          const SizedBox(width: 6),
          Flexible(
            child: Text(label,
                style: theme.textTheme.titleSmall?.copyWith(color: fg)),
          ),
        ],
      ),
    );
  }

  /// Pergunta de "Momento Uau" (Fase 0): a percepção subjetiva de melhora é
  /// o sinal de ativação mais forte. Aparece uma vez, após o 1º antes/depois.
  /// Compacta (2 colunas) para não competir com a ação principal.
  Widget _ahaQuestion(ThemeData theme) {
    const options = [
      ('sim_claramente', 'Sim, claramente'),
      ('um_pouco', 'Um pouco'),
      ('nao_percebi', 'Não percebi'),
      ('nao_consegui_comparar', 'Não consegui comparar'),
    ];
    Widget option((String, String) o) => OutlinedButton(
          onPressed: () => _answerAha(o.$1),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 44),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            textStyle: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(o.$2, textAlign: TextAlign.center),
        );
    Widget pair((String, String) a, (String, String) b) => IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: option(a)),
              const SizedBox(width: 8),
              Expanded(child: option(b)),
            ],
          ),
        );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Você sentiu melhora entre a primeira e a segunda tentativa?',
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            pair(options[0], options[1]),
            const SizedBox(height: 8),
            pair(options[2], options[3]),
          ],
        ),
      ),
    );
  }

  void _answerAha(String answer) {
    final before = _firstAccuracy?.round();
    final after = _result?.accuracy.round();
    widget.analytics?.log('aha_moment_answered', {
      'answer': answer,
      'lessonId': widget.lesson.id,
      'item': _item.text,
      'scoreBefore': before,
      'scoreAfter': after,
      'delta': (before != null && after != null) ? after - before : null,
      'approvedSeconds': _lastApprovedDuration?.inSeconds ?? 0,
      'challengeModeEnabled': widget.rigorous,
    });
    widget.store?.setAhaAnswered();
    setState(() => _ahaAnswered = true);
  }

  /// "Por que este resultado?" recolhido: os critérios técnicos ficam aqui,
  /// fora do caminho de quem só quer seguir.
  Widget _criteriaExpansion(ThemeData theme, PronunciationResult r,
      {required bool approvedNormal,
      required bool approvedChallenge,
      required bool precisionPending}) {
    final c = AppColors.of(context);
    final l = widget.lesson;
    final rig = widget.rigorous;
    final accFloor = rig ? Lesson.rigorousAccuracy : l.approvalThreshold;
    final phonFloor = rig ? Lesson.rigorousPhoneme : l.minPhoneme;
    final prosFloor = rig ? Lesson.rigorousProsody : l.minProsody;
    final point = r.worstSyllable?.grapheme;
    Widget line(bool ok, String label, [int? value]) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Icon(
                  ok
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 20,
                  color: ok ? c.green : theme.colorScheme.secondary),
              const SizedBox(width: 10),
              Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
              if (value != null)
                Text('$value',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: c.secondaryLabel,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    )),
            ],
          ),
        );
    Widget note(String s) => Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(s, style: theme.textTheme.bodySmall),
        );
    // Formas/cores do ExpansionTile já vêm do tema (sem fios, chevron cinza).
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        title: Text('Por que este resultado?',
            style: theme.textTheme.bodyLarge),
        children: [
          // Só as linhas que de fato decidem a aprovação (Lesson.approves),
          // com o piso do modo em uso: nada de ✓ fixo.
          line(r.accuracy >= accFloor, 'Clareza geral', r.accuracy.round()),
          if (r.prosody != null && prosFloor != null)
            line(r.prosody! >= prosFloor, 'Ritmo', r.prosody!.round()),
          line(r.minPhoneme >= phonFloor, 'Pronúncia (som mais fraco)',
              r.minPhoneme.round()),
          if (widget.rigorous)
            line(approvedChallenge,
                'Modo precisão: critério mais exigente de clareza, ritmo e '
                'pronúncia'),
          if (point != null) note('Ponto trabalhado: o som "$point".'),
          if (precisionPending)
            note('Você concluiu o treino normal, mas o modo precisão é mais '
                'exigente. Tente de novo se quiser buscar precisão máxima.'),
          // Sem promessa de revisão: palavra nunca aprovada não entra na
          // agenda (recordSrsOutcome devolve null).
          if (!approvedNormal)
            note('Este som ainda saiu instável. Vale gravar de novo para '
                'fixar.'),
          note('Só a gravação final aprovada soma tempo de prática.'),
        ],
      ),
    );
  }

  /// Dica de som (Trilha 2): cartão branco com o ícone no dourado, no
  /// padrão "clean" (sem fundo colorido).
  Widget _soundTipCard(ThemeData theme, String tip) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(Icons.hearing_rounded,
                  color: theme.colorScheme.secondary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dica de som', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(tip, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  _StepView _buildStep(ThemeData theme) {
    final c = AppColors.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;
    switch (_step) {
      case _Step.intro:
        return (
          body: _centered([
            Center(
              child: IconTile(Icons.headphones_rounded,
                  color: cs.secondary, size: 64),
            ),
            const SizedBox(height: 20),
            Text(widget.lesson.title,
                style: text.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(widget.lesson.objective,
                style: text.bodyLarge?.copyWith(color: c.secondaryLabel),
                textAlign: TextAlign.center),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.hearing_rounded,
                        size: 22, color: c.secondaryLabel),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Regra do jogo', style: text.titleSmall),
                          const SizedBox(height: 2),
                          Text(
                            'Primeiro você ouve e repete. A escrita só '
                            'aparece depois da sua primeira tentativa.',
                            style: text.bodyMedium
                                ?.copyWith(color: c.secondaryLabel),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
          actions: [
            FilledButton(
              onPressed: () {
                widget.analytics
                    ?.log('lesson_started', {'lesson': widget.lesson.id});
                setState(() => _step = _Step.listen);
              },
              child: const Text('Começar'),
            ),
          ],
        );

      case _Step.listen:
        // Só som: nada da escrita aparece nesta etapa.
        return (
          body: _centered([
            Icon(Icons.graphic_eq_rounded, size: 48, color: c.tertiaryLabel),
            const SizedBox(height: 16),
            Text('${_unit == 'frase' ? 'Frase' : 'Palavra'} ${_index + 1}',
                style: text.titleSmall?.copyWith(color: c.secondaryLabel),
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('Ouça e repita',
                style: text.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
                'Ouça com atenção, sem ler nada, e repita o mais parecido '
                'possível.',
                style: text.bodyLarge?.copyWith(color: c.secondaryLabel),
                textAlign: TextAlign.center),
          ]),
          actions: [
            // Gate som-first: gravar só depois de ouvir.
            _recorderControls(theme,
                playLabel: 'Ouvir',
                recordLabel: 'Gravar',
                canRecord: _hasListened,
                emphasizePlay: !_hasListened),
          ],
        );

      case _Step.feedbackFirst:
        final r = _result!;
        final message = _feedbackText(r);
        return (
          body: _centered([
            Text('Sua primeira tentativa',
                style: text.titleSmall?.copyWith(color: c.secondaryLabel),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            _scoreBadge(theme, r.accuracy),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                // A mensagem fixa aparece na hora; a da Claude entra por
                // cima quando chega, com um fade curto.
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(message,
                      key: ValueKey(message),
                      style: text.bodyLarge,
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ]),
          actions: [
            FilledButton.icon(
              onPressed: () => setState(() => _step = _Step.livroAberto),
              icon: const Icon(Icons.menu_book_rounded),
              label: Text('Ver a $_unit'),
            ),
            // O feedback manda "escute de novo": a 2ª escuta acontece aqui,
            // ainda sem a escrita na tela.
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: _recPhase == _RecPhase.idle ? _play : null,
              icon: const Icon(Icons.play_arrow_rounded, size: 22),
              label: const Text('Ouvir de novo'),
            ),
          ],
        );

      case _Step.livroAberto:
        final word = _item.text;
        final wordStyle =
            word.length > 14 ? text.displaySmall : text.displayMedium;
        final singleWord = !word.trim().contains(' ');
        return (
          body: _centered([
            // Palavra solta nunca quebra no meio ("comfortabl/e") em tela
            // estreita ou com fonte grande: encolhe pra caber numa linha.
            // Frase continua quebrando entre palavras.
            if (singleWord)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(word,
                    style: wordStyle, maxLines: 1, textAlign: TextAlign.center),
              )
            else
              Text(word, style: wordStyle, textAlign: TextAlign.center),
            // Fonética: simplificada PT-BR (acessível, vem primeiro) + IPA
            // (preciso, só apoio). Só aqui, depois da 1ª tentativa de
            // ouvido — nunca antes (regra som-first).
            if (_item.phonetic != null) ...[
              const SizedBox(height: 8),
              Text(_item.phonetic!,
                  style: text.bodyLarge, textAlign: TextAlign.center),
            ],
            if (_item.ipa != null) ...[
              const SizedBox(height: 2),
              Text(_item.ipa!,
                  style: text.bodySmall, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 12),
            Text(_item.translation,
                style: text.titleMedium, textAlign: TextAlign.center),
            // Dica de som (Trilha 2): o zoom no ponto difícil, junto com a
            // escrita — depois da 1ª tentativa de ouvido, como o resto do Livro.
            if (_item.soundTip != null) ...[
              const SizedBox(height: 20),
              _soundTipCard(theme, _item.soundTip!),
            ],
            const SizedBox(height: 28),
            InsetGroup(
              header: 'Exemplo',
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_item.example, style: text.bodyLarge),
                      const SizedBox(height: 4),
                      Text(_item.exampleTranslation, style: text.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            // Lembra o que corrigir antes da gravação que vale minuto; é
            // também onde a orientação da Claude aparece se chegar atrasada.
            if (_result != null) ...[
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(_feedbackText(_result!),
                    key: ValueKey(_feedbackText(_result!)),
                    style: text.bodyMedium?.copyWith(color: c.secondaryLabel),
                    textAlign: TextAlign.center),
              ),
            ],
          ]),
          actions: [
            _recorderControls(theme,
                playLabel: 'Ouvir de novo',
                recordLabel: 'Gravação final',
                canRecord: true,
                emphasizePlay: false),
          ],
        );

      case _Step.resultFinal:
        final r = _result!;
        final approvedNormal = widget.lesson
            .approves(r.accuracy, r.minPhoneme, r.prosody, rigorous: false);
        final approvedChallenge = widget.lesson
            .approves(r.accuracy, r.minPhoneme, r.prosody, rigorous: true);
        final approved = widget.rigorous ? approvedChallenge : approvedNormal;
        final gain =
            _firstAccuracy == null ? 0.0 : r.accuracy - _firstAccuracy!;
        // Três estados — nunca "não bateu o critério" sem explicar (#1): o
        // selo diz o estado, a orientação diz o que fazer e o "por quê"
        // recolhido explica o critério.
        final precisionPending =
            widget.rigorous && !approvedChallenge && approvedNormal;
        final String badge, retryLabel;
        if (precisionPending) {
          badge = 'Modo precisão: ainda não';
          retryLabel = 'Tentar modo precisão de novo';
        } else if (approved) {
          badge = 'Aprovado';
          retryLabel = 'Gravar de novo';
        } else {
          badge = 'Ainda não';
          retryLabel = 'Gravar de novo para tentar dominar';
        }
        final message = _feedbackText(r);
        final nextLabel = _isLastItem ? 'Concluir treino' : 'Próxima $_unit';
        return (
          body: _centered([
            _resultHero(theme, r, gain, badge: badge, approved: approved),
            // Aprovado: o selo fala por si. A orientação só aparece quando
            // ainda há o que corrigir (a fixa de aprovado diria "tente mais
            // uma vez" ao lado de "Próxima palavra").
            if (!approved) ...[
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(message,
                    key: ValueKey(message),
                    style: text.bodyLarge,
                    textAlign: TextAlign.center),
              ),
            ],
            if (!_ahaAnswered) ...[
              const SizedBox(height: 20),
              _ahaQuestion(theme),
            ],
            const SizedBox(height: 20),
            _criteriaExpansion(theme, r,
                approvedNormal: approvedNormal,
                approvedChallenge: approvedChallenge,
                precisionPending: precisionPending),
          ]),
          // CTA (#15): seguir é sempre o principal; regravar é o secundário,
          // com rótulo conforme o estado.
          actions: [
            FilledButton(onPressed: _nextItem, child: Text(nextLabel)),
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: _retryFinal,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(retryLabel, textAlign: TextAlign.center),
            ),
          ],
        );

      case _Step.finished:
        final approvedSecs = _approved.inSeconds;
        final avgAccuracy = _wordAccuracies.isEmpty
            ? null
            : _wordAccuracies.reduce((a, b) => a + b) /
                _wordAccuracies.length;
        return (
          body: _centered([
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.6, end: 1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Icon(Icons.check_circle_rounded, size: 88, color: c.green),
            ),
            const SizedBox(height: 16),
            Text('Lição concluída',
                style: text.headlineLarge, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(widget.lesson.title,
                style: text.bodyLarge?.copyWith(color: c.secondaryLabel),
                textAlign: TextAlign.center),
            const SizedBox(height: 28),
            InsetGroup(
              footer: approvedSecs > 0
                  ? 'Esse tempo já conta para as suas 484 horas. Continue '
                      'amanhã para manter o ritmo.'
                  : 'Você completou a lição. Cada repetição treina o ouvido.',
              children: [
                _statTile(theme, Icons.record_voice_over_rounded,
                    c.secondaryLabel, _practicedLabel(),
                    '${widget.lesson.items.length}'),
                if (avgAccuracy != null)
                  _statTile(theme, Icons.insights_rounded, cs.secondary,
                      'Média de pronúncia', '${avgAccuracy.round()}/100'),
                _statTile(theme, Icons.timer_rounded, c.green,
                    'Treino aprovado', _formatDuration(_approved)),
              ],
            ),
          ]),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              // Sem cadastro, a Home abre o formulário: o rótulo já avisa.
              child: Text(widget.store?.hasRegistered == false
                  ? 'Salvar meu progresso'
                  : 'Ver meu progresso'),
            ),
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: () => _shareWhatsApp(avgAccuracy),
              icon: const Icon(Icons.ios_share, size: 20),
              label: const Text('Compartilhar no WhatsApp'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: c.secondaryLabel),
              onPressed: () => setState(() {
                _index = 0;
                widget.store?.clearItemIndex(widget.lesson.id);
                _step = _Step.intro;
                _hasListened = false;
                _result = null;
                _aiFeedback = null;
                _approved = Duration.zero;
                _firstAccuracy = null;
                _wordAccuracies.clear();
                _error = null;
              }),
              child: const Text('Praticar de novo'),
            ),
          ],
        );
    }
  }

  /// Rótulo da contagem na conclusão, conforme a lição tenha palavras,
  /// frases ou os dois.
  String _practicedLabel() {
    final phrases =
        widget.lesson.items.where((i) => i.text.trim().contains(' ')).length;
    if (phrases == 0) return 'Palavras praticadas';
    if (phrases == widget.lesson.items.length) return 'Frases praticadas';
    return 'Palavras e frases';
  }

  Future<void> _shareWhatsApp(double? avgAccuracy) async {
    final score = avgAccuracy != null ? '${avgAccuracy.round()}/100' : null;
    final scoreLine = score != null ? '\nMinha pronúncia: $score 🎯' : '';
    final text =
        'Acabei de treinar inglês no 484 Method 🎙️\n'
        'Lição: "${widget.lesson.title}"$scoreLine\n\n'
        'Experimenta você (grátis): https://484method.github.io/484-method';
    final uri = Uri.parse(
        'https://wa.me/?text=${Uri.encodeComponent(text)}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  /// Linha de estatística no estilo Ajustes: ícone em quadradinho, rótulo
  /// à esquerda, valor em cinza à direita.
  Widget _statTile(ThemeData theme, IconData icon, Color color, String label,
      String value) {
    final c = AppColors.of(context);
    return ListTile(
      leading: IconTile(icon, color: color),
      title: Text(label),
      trailing: Text(value,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: c.secondaryLabel,
            fontFeatures: const [FontFeature.tabularFigures()],
          )),
    );
  }

  /// Controles de áudio no espírito do Gravador da Apple: dois botões
  /// redondos grandes (ouvir e gravar), com rótulo curto embaixo, e uma
  /// linha de estado acima ("Prepare-se…", "Fale agora", "Avaliando…").
  Widget _recorderControls(ThemeData theme,
      {required String playLabel,
      required String recordLabel,
      required bool canRecord,
      required bool emphasizePlay}) {
    final c = AppColors.of(context);
    final cs = theme.colorScheme;
    final idle = _recPhase == _RecPhase.idle;
    final recording = _recPhase == _RecPhase.recording;

    final String? status = switch (_recPhase) {
      _RecPhase.preparing => 'Prepare-se…',
      _RecPhase.recording => 'Fale agora',
      _RecPhase.sending => 'Avaliando…',
      _RecPhase.idle => canRecord ? null : 'Primeiro ouça, depois grave.',
    };
    final statusStyle = idle
        ? theme.textTheme.bodyMedium?.copyWith(color: c.secondaryLabel)
        : theme.textTheme.titleMedium
            ?.copyWith(color: recording ? c.red : c.label);

    final playColor =
        !idle ? c.fill : (emphasizePlay ? cs.primary : c.accentFill);
    final playIconColor =
        !idle ? c.tertiaryLabel : (emphasizePlay ? cs.onPrimary : cs.primary);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 28),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: status == null
                ? const SizedBox.shrink(key: ValueKey('no-status'))
                : Text(status,
                    key: ValueKey(status),
                    style: statusStyle,
                    textAlign: TextAlign.center),
          ),
        ),
        const SizedBox(height: 4),
        // Cada botão ocupa metade de uma faixa de no máximo 300pt: ficam
        // próximos no celular e o rótulo quebra linha (em vez de estourar)
        // com fonte grande.
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _RoundButton(
                    label: playLabel,
                    onPressed: idle ? _play : null,
                    color: playColor,
                    mutedLabel: !idle,
                    child: Icon(Icons.play_arrow_rounded,
                        size: 42, color: playIconColor),
                  ),
                ),
                Expanded(
                  child: _RoundButton(
                    label: recording ? 'Parar' : recordLabel,
                    onPressed: canRecord && (idle || recording)
                        ? _toggleRecording
                        : null,
                    color: canRecord ? c.red : c.fill,
                    mutedLabel: !canRecord,
                    halo: recording
                        ? AnimatedBuilder(
                            animation: _pulseScale,
                            builder: (context, _) => Transform.scale(
                              scale: _pulseScale.value,
                              child: Container(
                                width: _RoundButton.size,
                                height: _RoundButton.size,
                                decoration: BoxDecoration(
                                  color: c.red.withValues(alpha: 0.22),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          )
                        : null,
                    child: switch (_recPhase) {
                      _RecPhase.idle => Icon(Icons.mic_rounded,
                          size: 36,
                          color: canRecord ? cs.onError : c.tertiaryLabel),
                      _RecPhase.recording => Icon(Icons.stop_rounded,
                          size: 44, color: cs.onError),
                      _RecPhase.preparing ||
                      _RecPhase.sending =>
                        SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: cs.onError),
                        ),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _scoreBadge(ThemeData theme, double score) {
    final c = AppColors.of(context);
    return TweenAnimationBuilder<double>(
      key: ValueKey('score_${_step.name}_${score.round()}'),
      tween: Tween(begin: 0, end: score),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, _) => Column(children: [
        Text(value.toStringAsFixed(0),
            style: theme.textTheme.displayLarge?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()]),
            textAlign: TextAlign.center),
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
              color: theme.colorScheme.secondary,
              backgroundColor: c.fill,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _centered(List<Widget> children) {
    // Centraliza quando o conteúdo cabe; rola quando não cabe (telas baixas
    // e paisagem) — evita overflow na tela de resultado, que é a mais alta.
    const vPad = 16.0;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: AppStyle.pagePadding, vertical: vPad),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - 2 * vPad)
                  .clamp(0.0, double.infinity)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }

  /// "8 s", "2 min", "1 min 20 s".
  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    if (m == 0) return s == 0 ? '0 min' : '$s s';
    if (s == 0) return '$m min';
    return '$m min $s s';
  }
}

/// Botão redondo grande com rótulo embaixo (ouvir / gravar).
class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.label,
    required this.onPressed,
    required this.color,
    required this.child,
    this.halo,
    this.mutedLabel = false,
  });

  static const double size = 76;

  /// Caixa com folga para o anel pulsante não empurrar o layout.
  static const double _box = 96;

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Widget child;
  final Widget? halo;
  final bool mutedLabel;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _box,
              height: _box,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ?halo,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size,
                    height: size,
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle),
                    child: Material(
                      type: MaterialType.transparency,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: onPressed,
                        customBorder: const CircleBorder(),
                        // O destaque padrão do tema (c.fill, opaco, feito
                        // pras linhas de lista) cobriria o vermelho/azul do
                        // círculo ao tocar; aqui o toque só escurece/clareia
                        // de leve, como nos botões redondos do iOS.
                        highlightColor: c.label.withValues(alpha: 0.12),
                        child: Center(child: child),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: mutedLabel ? c.tertiaryLabel : c.label,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mapa de pronúncia por sílaba: cada pedaço da palavra com um traço
/// colorido pela accuracy (verde = nativo, dourado = quase, vermelho = som
/// de português). Torna visível ONDE o som falhou, não só a nota geral.
class _SyllableMap extends StatelessWidget {
  const _SyllableMap({required this.result});

  final PronunciationResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = AppColors.of(context);
    Color colorFor(double accuracy) {
      if (accuracy >= 80) return c.green;
      if (accuracy >= 60) return theme.colorScheme.secondary;
      return c.red;
    }

    final syllables = [
      for (final w in result.words)
        ...w.syllables.where((s) => s.grapheme.isNotEmpty)
    ];
    // Para palavras monossilábicas o mapa duplica o placar principal com um
    // valor ligeiramente diferente (Azure calcula word e syllable de forma
    // independente), o que confunde. Só mostra quando há ≥2 sílabas.
    if (syllables.length <= 1) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 14,
        runSpacing: 12,
        children: [
          for (final s in syllables)
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 32),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(s.grapheme,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorFor(s.accuracy),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(s.accuracy.toStringAsFixed(0),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
