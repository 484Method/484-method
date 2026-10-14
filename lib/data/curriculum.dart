import '../models/lesson.dart';
import '../models/trail.dart';
import 'fase1.dart';
import 'fase2.dart';
import 'fase3.dart';
import 'fase4.dart';
import 'fase5.dart';

/// O currículo como o aluno vê: trilhas → zonas → lições, na ordem de
/// progressão. Fonte única da estrutura da Home — as zonas eram índices
/// fixos dentro de home_screen.dart, o que quebraria ao entrar a Trilha 2.
///
/// Trilha 1 = "Fase 1 do currículo" (docs/curriculo-fase1.md); Trilha 2 =
/// "Fase 2 do currículo" (docs/curriculo-fase2.md); Trilha 3 = "Fase 3 do
/// currículo" (docs/curriculo-fase3.md); Trilhas 4 e 5 = Fases 4 e 5
/// (docs/curriculo-fase4.md, docs/curriculo-fase5.md). A Trilha 2 abre quando
/// a última lição obrigatória da Trilha 1 é concluída (decisão de
/// 2026-10-11): é a mesma regra linear de sempre, aplicada à fila inteira.
const trilha1 = Trail(
  number: 1,
  title: 'Saia do inglês mudo',
  subtitle: 'Inglês que você já conhece',
  zones: [
    Zone('Zona 1 — Reconhecimento e confiança', [
      licao01,
      licao02,
      licao03,
      licao04,
      licao06,
      licao07,
    ]),
    Zone('Zona 2 — Som e sílaba forte', [
      licao09,
      licao10,
      licao11,
      licao12,
      licao13,
    ]),
    Zone('Zona 3 — Da palavra à frase', [
      licao14,
      licao15,
      licao16,
      licao17,
      licao18,
      licao19,
      licao20,
    ]),
    Zone('Zona 4 — Conversa do dia a dia', [
      licao21,
      licao22,
      licao23,
      licao24,
      licao25,
      licao26,
      licao27,
    ]),
  ],
);

const trilha2 = Trail(
  number: 2,
  title: 'Sons do inglês real',
  subtitle: 'As armadilhas de som do brasileiro',
  zones: fase2Zones,
);

const trilha3 = Trail(
  number: 3,
  title: 'Frases prontas do dia a dia',
  subtitle: 'Responda no automático, sem travar',
  zones: fase3Zones,
);

const trilha4 = Trail(
  number: 4,
  title: 'Estruturas em fala',
  subtitle: 'Pergunte, negue e conte sem pensar na regra',
  zones: fase4Zones,
);

const trilha5 = Trail(
  number: 5,
  title: 'Inglês para sobrevivência',
  subtitle: 'Restaurante, aeroporto, hotel e médico',
  zones: fase5Zones,
);

const trails = [trilha1, trilha2, trilha3, trilha4, trilha5];

/// Todas as lições, na ordem de progressão (uma trilha inteira depois da outra).
final List<Lesson> curriculum = [for (final t in trails) ...t.lessons];

/// Trilha de cada lição (por id), para a Home rotular e numerar dentro da
/// trilha em vez de numerar a fila inteira.
final Map<String, Trail> trailOf = {
  for (final t in trails)
    for (final l in t.lessons) l.id: t,
};
