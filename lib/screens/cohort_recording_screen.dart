import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../services/analytics_service.dart';
import '../services/audio_recorder_service.dart';
import '../services/backend.dart';
import '../services/progress_store.dart';
import '../ui/app_style.dart';

/// Gravação de fala aberta (~30s) do desafio de 21 dias: baseline no começo,
/// final no fim. É o par OBJETIVO do antes/depois — o áudio vai pro Storage
/// privado pra um avaliador cego pontuar depois (o Azure não pontua fala
/// aberta sem texto de referência). Best-effort: se o upload falhar ou a
/// pessoa pular, o desafio segue com a autoavaliação de confiança.
class CohortRecordingScreen extends StatefulWidget {
  const CohortRecordingScreen({
    super.key,
    required this.kind,
    required this.store,
    this.backend,
    this.analytics,
  });

  /// 'baseline' (dia 0) ou 'final' (dia 21).
  final String kind;
  final ProgressStore store;
  final Backend? backend;
  final AnalyticsService? analytics;

  @override
  State<CohortRecordingScreen> createState() => _CohortRecordingScreenState();
}

enum _Phase { intro, preparing, recording, uploading, done, error }

class _CohortRecordingScreenState extends State<CohortRecordingScreen> {
  final AudioRecorderService _recorder = AudioRecorderService.longForm();
  _Phase _phase = _Phase.intro;
  Timer? _ticker;
  int _elapsed = 0;
  String? _error;

  bool get _isBaseline => widget.kind == 'baseline';

  String get _prompt => _isBaseline
      ? 'Fale por uns 30 segundos em inglês. Pode ser simples: diga seu nome, o '
          'que você faz, por que quer melhorar seu inglês e uma situação em que '
          'você trava.'
      : 'Fale por uns 30 segundos em inglês. Diga o que você praticou, quais '
          'palavras ficaram mais fáceis e como você se sente falando inglês '
          'agora.';

  @override
  void dispose() {
    _ticker?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    if (!await _recorder.hasPermission()) {
      setState(() {
        _phase = _Phase.error;
        // Mesma orientação da lição: sem o caminho do "cadeado" do Chrome
        // de desktop, que não existe no Safari do iPhone.
        _error = kIsWeb
            ? 'Sem acesso ao microfone. Recarregue a página e toque em '
                'Permitir quando o navegador pedir. Se ele não pedir, '
                'libere o microfone nos ajustes do site (no iPhone, pelo '
                'menu ao lado do endereço).'
            : 'Sem acesso ao microfone. Libere o microfone para o 484 '
                'nos Ajustes do aparelho e grave de novo.';
      });
      return;
    }
    setState(() {
      _phase = _Phase.preparing;
      _error = null;
    });
    await _recorder.start(onAutoStop: _stopAndUpload);
    if (!mounted || _phase != _Phase.preparing) return;
    setState(() {
      _phase = _Phase.recording;
      _elapsed = 0;
    });
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed++);
    });
  }

  Future<void> _stopAndUpload() async {
    if (_phase != _Phase.recording) return;
    _ticker?.cancel();
    setState(() => _phase = _Phase.uploading);

    final audio = await _recorder.stop();
    if (audio == null) {
      setState(() {
        _phase = _Phase.error;
        _error = 'Não ouvi nada. Fale mais perto do microfone e tente de novo.';
      });
      return;
    }

    final ok = await widget.backend?.uploadCohortRecording(
          kind: widget.kind,
          wavBytes: audio.wavBytes,
          durationMs: audio.duration.inMilliseconds,
          cohortDay: widget.store.cohortDay,
        ) ??
        false;
    widget.analytics?.log('cohort_recording_saved', {
      'kind': widget.kind,
      'uploaded': ok,
      'duration_ms': audio.duration.inMilliseconds,
    });
    if (!mounted) return;
    setState(() => _phase = _Phase.done);
  }

  void _skip() {
    widget.analytics?.log('cohort_recording_skipped', {'kind': widget.kind});
    Navigator.of(context).pop(false);
  }

  /// Relógio no formato do Gravador (0:07, 1:02).
  String _clock(int seconds) =>
      '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isBaseline ? 'Sua fala de hoje' : 'Sua fala de agora'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppStyle.maxContentWidth),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: switch (_phase) {
              _Phase.done => _doneView(theme),
              _ => _recordView(theme),
            },
          ),
        ),
      ),
    );
  }

  Widget _recordView(ThemeData theme) {
    final c = AppColors.of(context);
    final recording = _phase == _Phase.recording;
    final busy = _phase == _Phase.preparing || _phase == _Phase.uploading;
    return Column(
      key: const ValueKey('record'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
                AppStyle.pagePadding, 8, AppStyle.pagePadding, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isBaseline
                      ? 'Antes de começar, registre sua fala de hoje. No fim '
                          'dos 21 dias você grava de novo e compara.'
                      : 'Você chegou ao fim! Registre sua fala agora pra ver o '
                          'quanto evoluiu desde o começo.',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: c.secondaryLabel),
                ),
                const SizedBox(height: 24),
                InsetGroup(
                  header: 'O que falar',
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Text(_prompt, style: theme.textTheme.bodyLarge),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                _micIndicator(theme, c, recording: recording, busy: busy),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: c.red),
                  ),
                ],
              ],
            ),
          ),
        ),
        BottomActions(
          children: [
            FilledButton.icon(
              // Vermelho = gravando (como no Gravador); parado, o acento.
              style: recording
                  ? FilledButton.styleFrom(
                      backgroundColor: c.red,
                      foregroundColor: Colors.white,
                    )
                  : null,
              onPressed: busy
                  ? null
                  : recording
                      ? _stopAndUpload
                      : _start,
              icon: Icon(recording
                  ? Icons.stop_rounded
                  : Icons.fiber_manual_record_rounded),
              label: Text(recording ? 'Parar e enviar' : 'Gravar'),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: busy ? null : _skip,
              child: const Text('Pular por agora'),
            ),
          ],
        ),
      ],
    );
  }

  /// Microfone grande no centro: neutro parado, vermelho gravando, com o
  /// relógio da gravação logo abaixo.
  Widget _micIndicator(ThemeData theme, AppColors c,
      {required bool recording, required bool busy}) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: recording ? c.redFill : c.fill,
            shape: BoxShape.circle,
          ),
          child: Icon(
            recording ? Icons.mic_rounded : Icons.mic_none_rounded,
            size: 44,
            color: recording ? c.red : c.secondaryLabel,
          ),
        ),
        const SizedBox(height: 16),
        if (recording)
          Text(
            _clock(_elapsed),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        Text(
          recording
              ? 'Gravando'
              : busy
                  ? 'Um instante…'
                  : 'Toque em Gravar quando estiver pronto',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: recording ? c.red : c.secondaryLabel,
          ),
        ),
      ],
    );
  }

  Widget _doneView(ThemeData theme) {
    final c = AppColors.of(context);
    return Column(
      key: const ValueKey('done'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppStyle.pagePadding, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: c.greenFill,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_rounded, size: 44, color: c.green),
                  ),
                  const SizedBox(height: 20),
                  Text('Fala registrada',
                      style: theme.textTheme.headlineLarge,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(
                    _isBaseline
                        ? 'Agora é treinar todo dia.'
                        : 'Vamos ver seu antes e depois.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: c.secondaryLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
        BottomActions(
          children: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Continuar'),
            ),
          ],
        ),
      ],
    );
  }
}
