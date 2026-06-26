import '../models/lesson.dart';
import 'pronunciation_assessor.dart';

/// Feedback curto e acionável em PT-BR (docs/feedback-library.md).
/// Regra de produto: nunca dizer só "errado" — sempre indicar o que tentar.
/// Mensagens fixas por banda de accuracy — sem chamada a IA no caminho da
/// avaliação (removida por custar uma viagem de rede extra por tentativa;
/// ver docs/feedback-library.md).
String feedbackFor(PronunciationResult r, Lesson lesson,
    {bool rigorous = false}) {
  final approved =
      lesson.approves(r.accuracy, r.minPhoneme, r.prosody, rigorous: rigorous);
  if (approved) return _approvedMessage(r.accuracy);
  return '${_band(r.accuracy)} ${_diagnostic(r, lesson, rigorous)}';
}

/// Banda de aprovação: já passou no critério — reforça, sem apontar defeito.
String _approvedMessage(double accuracy) {
  if (accuracy >= 95) {
    return 'Perfeito! Som limpo, do jeito nativo. Pode repetir pra fixar.';
  }
  if (accuracy >= 85) {
    return 'Muito bom! Tente mais uma vez com o mesmo ritmo do áudio.';
  }
  return 'Boa! Passou no critério. Mais uma tentativa deixa ainda melhor.';
}

/// Banda de reprovação por faixa de accuracy: a frase de abertura, antes do
/// diagnóstico específico (sílaba/fonema/prosódia).
String _band(double accuracy) {
  if (accuracy >= 75) return 'Quase lá!';
  if (accuracy >= 60) return 'No caminho, mas ainda precisa ajustar.';
  if (accuracy >= 40) return 'Ficou distante do áudio original.';
  return 'Muito diferente do que era esperado.';
}

/// Aponta a causa mais provável da reprovação, em ordem de prioridade
/// pedagógica: completude > fonema/sílaba > prosódia > genérico.
String _diagnostic(PronunciationResult r, Lesson lesson, bool rigorous) {
  if (r.completeness < 100) {
    return 'Faltou um pedaço — fale a palavra inteira, até o fim.';
  }
  // Um som específico de português escapou: aponta o trecho exato.
  final phonemeFloor = rigorous ? Lesson.rigorousPhoneme : lesson.minPhoneme;
  final worst = r.worstSyllable;
  if (r.minPhoneme < phonemeFloor &&
      worst != null &&
      worst.grapheme.isNotEmpty) {
    return 'O trecho "${worst.grapheme}" saiu com som de português. '
        'Escute de novo prestando atenção nesse pedaço.';
  }
  // Prosódia: piso da lição (modo normal) ou o do desafio (modo rigoroso).
  final prosodyFloor = rigorous ? Lesson.rigorousProsody : lesson.minProsody;
  if (prosodyFloor != null && (r.prosody ?? 100) < prosodyFloor) {
    return 'Ouça onde está a força da palavra e copie a música, não as '
        'letras.';
  }
  return 'Copie o ritmo do áudio, não a escrita da palavra, e tente outra '
      'vez.';
}
