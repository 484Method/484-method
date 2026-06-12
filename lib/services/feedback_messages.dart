import 'pronunciation_assessor.dart';

/// Feedback curto e acionável em PT-BR (docs/feedback-library.md).
/// Regra de produto: nunca dizer só "errado" — sempre indicar o que tentar.
/// Nesta fase as mensagens são fixas; depois a Claude API gera variações.
String feedbackFor(PronunciationResult r, double threshold) {
  if (r.pronScore >= threshold) {
    return 'Muito bom! Tente mais uma vez com o mesmo ritmo do áudio.';
  }
  if (r.completeness < 100) {
    return 'Faltou um pedaço — fale a palavra inteira, até o fim.';
  }
  if (r.accuracy < 60) {
    return 'Copie o ritmo do áudio, não a escrita da palavra. '
        'Escute de novo e tente outra vez.';
  }
  return 'Quase lá. Escute mais uma vez e copie a duração dos sons.';
}
