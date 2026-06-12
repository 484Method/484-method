/// Modelo das microlições da Fase 1.
///
/// O threshold de aprovação é POR LIÇÃO (regra de produto: configurável,
/// permissivo no começo da Fase 1 e subindo gradualmente).
class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.objective,
    required this.approvalThreshold,
    required this.items,
    this.minPhoneme = 65,
    this.minProsody,
  });

  final String id;
  final String title;

  /// Explicado ao aluno em uma frase no início (etapa 1 do template).
  final String objective;

  /// Accuracy mínima (0-100) para aprovar a tentativa.
  ///
  /// A aprovação NÃO usa o PronScore: ele é inflado por fluency e
  /// completeness (fáceis de gabaritar em palavra curta) e mal distingue
  /// pronúncia aportuguesada de nativa — medido em 2026-06: "hotel"
  /// aportuguesado dá PronScore 85.6 vs 93.6 nativo.
  final double approvalThreshold;

  /// Piso por fonema: nenhum som individual pode ficar abaixo disso.
  /// É o critério que pega o som de português ("chocolate" aportuguesado
  /// tem accuracy média 72, mas um fonema em 38).
  final double minPhoneme;

  /// Prosódia mínima (stress/ritmo), para lições de ritmo. Null = não exige.
  final double? minProsody;

  final List<LessonItem> items;

  bool approves(double accuracy, double minPhonemeScore, double? prosody) {
    if (accuracy < approvalThreshold) return false;
    if (minPhonemeScore < minPhoneme) return false;
    final p = minProsody;
    if (p != null && (prosody ?? 100) < p) return false;
    return true;
  }
}

class LessonItem {
  const LessonItem({
    required this.text,
    required this.translation,
    required this.example,
    required this.exampleTranslation,
    required this.audioAsset,
  });

  /// Palavra ou chunk em inglês — é o ReferenceText da avaliação.
  final String text;
  final String translation;
  final String example;
  final String exampleTranslation;

  /// Caminho do MP3 pré-gerado (relativo a assets/, como o audioplayers usa).
  final String audioAsset;
}
