import '../models/lesson.dart';
import 'pronunciation_assessor.dart';

/// Feedback curto e acionável em PT-BR (docs/feedback-library.md).
/// Regra de produto: nunca dizer só "errado" — sempre indicar o que tentar.
/// Mensagens fixas por banda de accuracy — sem chamada a IA no caminho da
/// avaliação (removida por custar uma viagem de rede extra por tentativa;
/// ver docs/feedback-library.md).
///
/// [tip] é a dica de som do item (`LessonItem.soundTip`, Trilha 2): quando
/// existe, ela substitui a instrução genérica — a lição foi montada em volta
/// daquela armadilha, então é a correção mais provável. Completude continua
/// tendo prioridade (palavra cortada não é problema de som).
String feedbackFor(PronunciationResult r, Lesson lesson,
    {bool rigorous = false, String? tip}) {
  final approved =
      lesson.approves(r.accuracy, r.minPhoneme, r.prosody, rigorous: rigorous);
  if (approved) return _approvedMessage(r.accuracy);
  return '${_band(r.accuracy)} ${_diagnostic(r, lesson, rigorous, tip)}';
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
String _diagnostic(
    PronunciationResult r, Lesson lesson, bool rigorous, String? tip) {
  if (r.completeness < 100) {
    // Vale pra palavra e pra frase (engolir uma palavra da frase é o caso
    // mais comum de completude < 100).
    return 'Faltou um pedaço. Fale tudo, até o fim.';
  }
  // Um som específico de português escapou: aponta o trecho exato.
  final phonemeFloor = rigorous ? Lesson.rigorousPhoneme : lesson.minPhoneme;
  final worst = r.worstSyllable;
  if (r.minPhoneme < phonemeFloor &&
      worst != null &&
      worst.grapheme.isNotEmpty) {
    final useTip = tip != null && _tipCovers(r, worst, tip);
    return 'O trecho "${worst.grapheme}" saiu com som de português. '
        '${useTip ? tip : 'Escute de novo prestando atenção nesse pedaço.'}';
  }
  // Prosódia: piso da lição (modo normal) ou o do desafio (modo rigoroso).
  // A dica só vale aqui se a própria lição treina ritmo (tem minProsody) —
  // no modo rigoroso a prosódia reprova também as lições de som, e aí a dica
  // de língua/lábios apontaria um som que o Azure já deu como certo.
  final prosodyFloor = rigorous ? Lesson.rigorousProsody : lesson.minProsody;
  if (prosodyFloor != null && (r.prosody ?? 100) < prosodyFloor) {
    final useTip = tip != null && lesson.minProsody != null;
    return useTip
        ? tip
        : 'Ouça onde cai a força e copie a música, não as letras.';
  }
  return tip ?? 'Copie o ritmo do áudio, não a escrita, e tente outra vez.';
}

/// A dica serve pro trecho que o Azure apontou? Item de uma palavra só: sim
/// (a dica é sobre ela). Frase: só se a dica cita a palavra onde está o
/// trecho mais fraco — senão o diagnóstico aponta um pedaço ("place") e a
/// instrução fala de outro ("there").
bool _tipCovers(PronunciationResult r, SyllableScore worst, String tip) {
  if (r.words.length <= 1) return true;
  for (final w in r.words) {
    if (w.syllables.contains(worst)) {
      // "brother's" → "brother": a dica cita a palavra, não o possessivo.
      final word = w.word.toLowerCase().replaceAll(RegExp(r"'.*$"), '');
      return word.isNotEmpty && tip.toLowerCase().contains(word);
    }
  }
  return false;
}
