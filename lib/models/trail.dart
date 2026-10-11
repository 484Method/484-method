import 'lesson.dart';

/// Uma trilha do currículo — a "Fase N do currículo" de
/// docs/roadmap-fases.md, do jeito que o aluno vê na Home.
///
/// A progressão é uma fila só, na ordem das trilhas: a 1ª lição de uma
/// trilha exige a última lição obrigatória da anterior (ver
/// home_screen.dart). A trilha só agrupa e dá nome — não tem regra própria.
class Trail {
  const Trail({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.zones,
  });

  final int number;

  /// Nome comercial (ex.: "Saia do inglês mudo"). A Home exibe
  /// "Trilha N — título".
  final String title;
  final String subtitle;
  final List<Zone> zones;

  List<Lesson> get lessons => [for (final z in zones) ...z.lessons];
}

/// Bloco pedagógico dentro de uma trilha ("Zona N — …" na Home).
class Zone {
  const Zone(this.title, this.lessons);

  final String title;
  final List<Lesson> lessons;
}
