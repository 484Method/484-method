import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

/// Grava do microfone em PCM 16 kHz mono (formato que o Azure exige) e
/// devolve um WAV pronto para envio.
///
/// Regras de custo embutidas (o Azure cobra por segundo de áudio enviado):
/// - auto-stop quando detecta um trecho de silêncio depois que a pessoa já
///   começou a falar (0,7 s em palavra, 1,2 s em frase) — dispensa o clique
///   manual de "parar" na maioria das tentativas. O que é "fala" é decidido
///   por [SpeechActivityDetector], relativo ao microfone de cada aparelho;
/// - [maxDuration] é só um teto de segurança (ruído contínuo, mic aberto);
/// - gravação que é só silêncio retorna null e não deve ser enviada.
class AudioRecorderService {
  /// [maxDuration] é o teto de segurança da gravação; [autoStopOnSilence]
  /// encerra sozinho após um trecho de silêncio depois da fala.
  ///
  /// Default = modo "palavra/chunk" do loop de lição (10s, auto-stop ligado).
  /// Pra fala aberta longa (gravação de baseline/final do desafio de 21 dias)
  /// use [AudioRecorderService.longForm]: teto maior e SEM auto-stop por
  /// silêncio — pausas naturais no meio de uma fala de 30s não podem encerrar.
  AudioRecorderService({
    this.maxDuration = const Duration(seconds: 10),
    this.autoStopOnSilence = true,
  });

  /// Fala aberta longa: até 60s e o encerramento é manual (ou pelo teto).
  factory AudioRecorderService.longForm() => AudioRecorderService(
        maxDuration: const Duration(seconds: 60),
        autoStopOnSilence: false,
      );

  final Duration maxDuration;
  final bool autoStopOnSilence;

  final AudioRecorder _recorder = AudioRecorder();
  final BytesBuilder _chunks = BytesBuilder(copy: false);
  StreamSubscription<Uint8List>? _subscription;
  Timer? _autoStopTimer;
  Timer? _silenceStopTimer;
  bool? _liveIsFloat32;

  static const int sampleRate = 16000;

  /// Silêncio contínuo depois da fala que encerra a gravação sozinha numa
  /// palavra isolada: curto pra não atrasar o resultado.
  static const Duration _wordSilenceStopDelay = Duration(milliseconds: 700);

  /// Em frase, o aluno pausa entre as palavras pra lembrar a próxima — 0,7 s
  /// cortava a frase no meio (relato de 2026-10-12, iPhone).
  static const Duration _phraseSilenceStopDelay = Duration(milliseconds: 1200);

  /// Em frase, tempo mínimo de gravação por palavra antes de o auto-stop
  /// poder disparar — uma pausa logo no começo não encerra a frase.
  static const Duration _minPerPhraseWord = Duration(milliseconds: 400);

  /// RMS mínimo (int16) que a janela mais alta do áudio precisa atingir
  /// para contar como fala. Ruído ambiente fica tipicamente abaixo de ~150;
  /// fala, mesmo baixa, passa de 300. Usado só na checagem pós-gravação
  /// (descarta tentativa que é silêncio puro).
  static const double _silenceRmsThreshold = 250;
  static const int _windowMs = 100;

  Future<bool> hasPermission() => _recorder.hasPermission();

  DateTime? _startedAt;
  SpeechActivityDetector _speech = SpeechActivityDetector();
  Duration _silenceStopDelay = _wordSilenceStopDelay;
  Duration _minRecording = Duration.zero;

  /// Só retorna quando o primeiro chunk de áudio chega — o navegador leva
  /// ~1s para começar a entregar áudio de verdade, e falar antes disso
  /// perde o início da palavra. A UI deve mostrar "fale agora" somente
  /// depois que este future completar.
  ///
  /// [expectedWords] = palavras do texto que a pessoa vai falar: frase ganha
  /// pausa maior e um tempo mínimo antes do auto-stop (ver as constantes).
  Future<void> start({
    required void Function() onAutoStop,
    int expectedWords = 1,
  }) async {
    _chunks.clear();
    _liveIsFloat32 = null;
    _speech = SpeechActivityDetector();
    // Provisório até o 1º chunk (reatribuído abaixo): o mínimo de gravação
    // da frase já vale se a fala for detectada logo no primeiro chunk.
    _startedAt = DateTime.now();
    final isPhrase = expectedWords > 1;
    _silenceStopDelay =
        isPhrase ? _phraseSilenceStopDelay : _wordSilenceStopDelay;
    _minRecording =
        isPhrase ? _minPerPhraseWord * expectedWords : Duration.zero;
    final firstChunk = Completer<void>();
    final stream = await _recorder.startStream(const RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: sampleRate,
      numChannels: 1,
    ));
    _subscription = stream.listen((chunk) {
      if (!firstChunk.isCompleted) firstChunk.complete();
      _chunks.add(chunk);
      // Só decide o formato (int16 vs float32) num chunk com sinal real —
      // num chunk de silêncio puro (bytes zerados) a heurística sempre bate
      // como "float32" (0.0 está em qualquer faixa), travando a leitura
      // errada pro resto da gravação.
      if (_liveIsFloat32 == null && chunk.any((b) => b != 0)) {
        _liveIsFloat32 = _looksLikeFloat32(chunk);
      }
      if (_liveIsFloat32 != null) {
        _feedSilenceDetector(chunk, _liveIsFloat32!, onAutoStop);
      }
    });
    await firstChunk.future;
    _startedAt = DateTime.now();
    _autoStopTimer = Timer(maxDuration, onAutoStop);
  }

  /// A cada chunk que chega, mede o volume; se for fala, (re)arma o timer
  /// de silêncio. Sem fala detectada ainda, não arma nada — silêncio antes
  /// da pessoa começar a falar não deve parar a gravação.
  void _feedSilenceDetector(
    Uint8List chunk,
    bool isFloat32,
    void Function() onAutoStop,
  ) {
    if (!autoStopOnSilence) return; // fala aberta: só para no manual/teto
    final rms = _chunkRms(chunk, isFloat32);
    if (kDebugMode) debugPrint('[silence-calibration] rms=${rms.round()}');
    if (!_speech.feed(rms)) return;
    // Frase: não encerra antes do mínimo, mesmo com pausa no começo.
    final elapsed = _startedAt == null
        ? Duration.zero
        : DateTime.now().difference(_startedAt!);
    final untilMin = _minRecording - elapsed;
    final wait = untilMin > _silenceStopDelay ? untilMin : _silenceStopDelay;
    _silenceStopTimer?.cancel();
    _silenceStopTimer = Timer(wait, onAutoStop);
  }

  double _chunkRms(Uint8List chunk, bool isFloat32) {
    final buffer = Uint8List.fromList(chunk).buffer;
    if (isFloat32) {
      final floats = buffer.asFloat32List(0, chunk.length ~/ 4);
      if (floats.isEmpty) return 0;
      var sumSquares = 0.0;
      for (final v in floats) {
        sumSquares += v * v;
      }
      return math.sqrt(sumSquares / floats.length) * 32768;
    }
    final ints = buffer.asInt16List(0, chunk.length ~/ 2);
    if (ints.isEmpty) return 0;
    var sumSquares = 0.0;
    for (final v in ints) {
      sumSquares += v * v;
    }
    return math.sqrt(sumSquares / ints.length);
  }

  /// Encerra a gravação e devolve o WAV, ou null se for silêncio.
  Future<RecordedAudio?> stop() async {
    _autoStopTimer?.cancel();
    _silenceStopTimer?.cancel();
    await _recorder.stop();
    await _subscription?.cancel();
    final raw = _chunks.takeBytes();
    final wallSeconds =
        DateTime.now().difference(_startedAt!).inMilliseconds / 1000;
    if (raw.length < 64 || wallSeconds <= 0) return null;

    final (pcm, sourceInfo) = _normalizePcm(raw, wallSeconds);
    final audioSeconds = pcm.length / (sampleRate * 2);
    final diagnostics = 'fonte $sourceInfo · relógio '
        '${wallSeconds.toStringAsFixed(1)}s · '
        'áudio ${audioSeconds.toStringAsFixed(1)}s';
    debugPrint('[rec] $diagnostics');
    if (_isSilence(pcm)) return null;
    return RecordedAudio(
      wavBytes: _wavFromPcm(pcm),
      duration: Duration(milliseconds: (audioSeconds * 1000).round()),
      diagnostics: diagnostics,
    );
  }

  /// O navegador nem sempre entrega o que o plugin pede: dependendo da
  /// versão, o stream chega como Float32 na taxa nativa do microfone
  /// (ex.: 44,1 kHz) em vez de Int16 a 16 kHz. Detecta o formato real pelos
  /// bytes, estima a taxa pelo relógio e converte para Int16 16 kHz mono.
  (Uint8List, String) _normalizePcm(Uint8List raw, double wallSeconds) {
    final isFloat32 = _looksLikeFloat32(raw);
    List<double> samples;
    if (isFloat32) {
      final floats = raw.buffer.asFloat32List(0, raw.length ~/ 4);
      samples = [for (final v in floats) v];
    } else {
      final ints = raw.buffer.asInt16List(0, raw.length ~/ 2);
      samples = [for (final v in ints) v / 32768];
    }

    // O navegador também pode ignorar numChannels e entregar estéreo
    // intercalado. Procura a combinação taxa × canais que melhor explica a
    // vazão medida (ex.: 88.200 amostras/s = 2 canais a 44,1 kHz).
    const standardRates = [16000.0, 22050.0, 24000.0, 32000.0, 44100.0, 48000.0];
    final estimated = samples.length / wallSeconds;
    var sourceRate = standardRates.first;
    var channels = 1;
    var bestDiff = double.infinity;
    for (final rate in standardRates) {
      for (final ch in [1, 2]) {
        final diff = (estimated - rate * ch).abs();
        if (diff < bestDiff) {
          bestDiff = diff;
          sourceRate = rate;
          channels = ch;
        }
      }
    }
    if (channels == 2) {
      samples = [
        for (var i = 0; i + 1 < samples.length; i += 2)
          (samples[i] + samples[i + 1]) / 2
      ];
    }

    final outLength = (samples.length * sampleRate / sourceRate).floor();
    final out = Int16List(outLength);
    for (var i = 0; i < outLength; i++) {
      final pos = i * sourceRate / sampleRate;
      final i0 = pos.floor();
      final i1 = math.min(i0 + 1, samples.length - 1);
      final frac = pos - i0;
      final v = samples[i0] * (1 - frac) + samples[i1] * frac;
      out[i] = (v.clamp(-1.0, 1.0) * 32767).round();
    }
    final format = isFloat32 ? 'float32' : 'int16';
    return (
      out.buffer.asUint8List(),
      '$format@${sourceRate.round()}Hz ${channels}ch',
    );
  }

  /// Amostras Float32 de áudio ficam quase todas em [-1, 1]; bytes Int16
  /// reinterpretados como Float32 viram valores absurdos. Essa diferença
  /// identifica o formato com segurança.
  bool _looksLikeFloat32(Uint8List raw) {
    final floats = raw.buffer.asFloat32List(0, raw.length ~/ 4);
    final step = math.max(1, floats.length ~/ 1000);
    var inRange = 0;
    var checked = 0;
    for (var i = 0; i < floats.length; i += step) {
      checked++;
      final v = floats[i];
      if (v.isFinite && v.abs() <= 1.0) inRange++;
    }
    return inRange / checked > 0.95;
  }

  Future<void> dispose() {
    _autoStopTimer?.cancel();
    _silenceStopTimer?.cancel();
    return _recorder.dispose();
  }

  bool _isSilence(Uint8List pcm) {
    final samples = pcm.buffer.asInt16List(0, pcm.length ~/ 2);
    final windowSize = sampleRate * _windowMs ~/ 1000;
    var maxRms = 0.0;
    for (var start = 0; start + windowSize <= samples.length;
        start += windowSize) {
      var sumSquares = 0.0;
      for (var i = start; i < start + windowSize; i++) {
        sumSquares += samples[i] * samples[i];
      }
      final rms = math.sqrt(sumSquares / windowSize);
      if (rms > maxRms) maxRms = rms;
    }
    return maxRms < _silenceRmsThreshold;
  }

  Uint8List _wavFromPcm(Uint8List pcm) {
    const channels = 1;
    const bitsPerSample = 16;
    const byteRate = sampleRate * channels * bitsPerSample ~/ 8;
    final header = ByteData(44);
    void writeAscii(int offset, String s) {
      for (var i = 0; i < s.length; i++) {
        header.setUint8(offset + i, s.codeUnitAt(i));
      }
    }

    writeAscii(0, 'RIFF');
    header.setUint32(4, 36 + pcm.length, Endian.little);
    writeAscii(8, 'WAVE');
    writeAscii(12, 'fmt ');
    header.setUint32(16, 16, Endian.little);
    header.setUint16(20, 1, Endian.little); // PCM
    header.setUint16(22, channels, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(28, byteRate, Endian.little);
    header.setUint16(32, channels * bitsPerSample ~/ 8, Endian.little);
    header.setUint16(34, bitsPerSample, Endian.little);
    writeAscii(36, 'data');
    header.setUint32(40, pcm.length, Endian.little);

    final wav = BytesBuilder(copy: false)
      ..add(header.buffer.asUint8List())
      ..add(pcm);
    return wav.takeBytes();
  }
}

/// Decide, chunk a chunk, se a pessoa está falando — com limiar RELATIVO ao
/// microfone de cada aparelho, não um volume fixo.
///
/// Por quê: o limiar fixo antigo (RMS 600, calibrado no MacBook) não servia
/// pro iPhone, que capta mais baixo (relato de 2026-10-12): numa palavra
/// curta a fala nunca passava de 600 e a gravação não parava sozinha
/// ("pizza" exigiu 4 tentativas); numa frase o começo passava e o resto, mais
/// baixo, não — o auto-stop cortava a frase no meio.
///
/// Como decide:
/// - piso de ruído = percentil 10 dos volumes da própria gravação (resiste a
///   um chunk anômalo isolado; antes de a pessoa falar, é o ruído da sala);
/// - fala começa quando o MAIOR volume visto passa de 4× o piso (entre 150
///   e 600). Retroativo: se a pessoa falou rápido antes de haver silêncio
///   pra medir o piso, a fala é reconhecida assim que o silêncio chega;
/// - depois disso, um chunk conta como fala se passar do maior entre 100,
///   2,5× o piso e 12% do pico da fala (nunca acima do limiar de início) —
///   assim a sílaba mais baixa do fim da frase não é tomada por silêncio.
///
/// Microfone alto num ambiente silencioso se comporta como antes (passar de
/// 600 continua sendo fala); ambiente barulhento sobe os limiares junto.
class SpeechActivityDetector {
  final List<double> _levels = [];
  double _peak = 0;
  bool _speaking = false;

  /// Alimenta o volume (RMS int16) de um chunk. Devolve true quando o timer
  /// de silêncio deve ser (re)armado agora: fala acabou de ser detectada, ou
  /// este chunk ainda é fala.
  bool feed(double rms) {
    if (rms <= 0) return false; // aquecimento do microfone: bytes zerados
    _levels.add(rms);
    if (rms > _peak) _peak = rms;
    final noise = _noiseFloor();
    final startThreshold = (noise * 4).clamp(150.0, 600.0);
    if (!_speaking) {
      if (_peak < startThreshold) return false;
      _speaking = true;
      return true;
    }
    final keepThreshold = math.min(
      startThreshold,
      math.max(100.0, math.max(noise * 2.5, _peak * 0.12)),
    );
    return rms >= keepThreshold;
  }

  double _noiseFloor() {
    final sorted = [..._levels]..sort();
    return sorted[(sorted.length * 0.1).floor()];
  }
}

class RecordedAudio {
  const RecordedAudio({
    required this.wavBytes,
    required this.duration,
    required this.diagnostics,
  });

  final Uint8List wavBytes;
  final Duration duration;

  /// Linha de diagnóstico (relógio vs duração do áudio) exibida na UI do
  /// protótipo enquanto investigamos a captura de áudio na web.
  final String diagnostics;
}
