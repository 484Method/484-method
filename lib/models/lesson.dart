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
  });

  final String id;
  final String title;

  /// Explicado ao aluno em uma frase no início (etapa 1 do template).
  final String objective;

  /// PronScore mínimo (0-100) para a tentativa contar como aprovada.
  final double approvalThreshold;

  final List<LessonItem> items;
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
