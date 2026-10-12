import '../models/lesson.dart';

/// Lições da Fase 2 ("Verbo To Be — Forma e Som"), 8 blocos pedagógicos em
/// progressão controlada: forma completa → contraste → som da contração
/// isolada → frase contraída → contraste contraído. Ver
/// docs/curriculo-fase2.md.
///
/// Diferente da Fase 1 (vocabulário, 5 itens/lição), aqui os itens já são
/// FRASES completas (ou, nos blocos 4-5, a contração isolada como unidade de
/// som) — por isso cada lição tem 10 itens em vez de 5, e mantém o ritmo de
/// 5-10min mesmo assim (frase curta, não palavra solta).
///
/// Blocos 4 e 5 são treino de SOM, não de frase: o aluno ouve e repete só a
/// contração (`I'm.`, `You're.`) sem contexto de frase ainda — por isso
/// `example`/`exampleTranslation` repetem o próprio item (não há uma "frase
/// de uso" maior pra uma contração isolada). A repetição de itens entre o
/// bloco 4 e o 5 é PROPOSITAL (ver docs/curriculo-fase2.md): pro método,
/// repetição não é conteúdo duplicado, é prática oral.
///
/// Nos blocos 3 e 8 (contraste), cada item do currículo original já vem como
/// DOIS enunciados ("I am happy. I am not sad.") — em vez de repetir o par
/// inteiro em `example` (redundante), `text`/`translation` levam a frase
/// afirmativa e `example`/`exampleTranslation` levam a negativa: o cartão do
/// Livro Aberto mostra o contraste de verdade, não um eco do título. Como o
/// `text` (ReferenceText avaliado) de cada item é IDÊNTICO ao afirmativo de
/// licao01/licao06, `audioAsset` aponta pros arquivos delas — mesmo padrão
/// de reaproveitamento das lições de revisão da Fase 1; `tool/
/// gen_lesson_audio.sh` não gera áudio próprio pra licao03/licao08.
///
/// Sem `ipa`/`phonetic`: são aproximações que exigem revisão com ouvido
/// nativo (mesma ressalva da Fase 1), e aqui o item é uma frase inteira, não
/// uma palavra — sem alguém revisando, é melhor não ter do que ter errado.
const fase2Lessons = [
  licao01, licao02, licao03, licao04, licao05,
  licao06, licao07, licao08,
];

// ---------------------------------------------------------------------------
// BLOCO 1 — Affirmative | Full Forms
// ---------------------------------------------------------------------------

const licao01 = Lesson(
  id: 'fase2-licao01',
  title: 'Eu sou, eu estou',
  objective: 'Você vai praticar a forma completa do verbo to be — I am, '
      'you are, he is — em frases afirmativas do dia a dia.',
  microSkill: 'Verbo to be — afirmativo completo',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'I am happy.',
      translation: 'Eu estou feliz.',
      example: 'I am happy.',
      exampleTranslation: 'Eu estou feliz.',
      audioAsset: 'audio/fase2/licao01/01.mp3',
    ),
    LessonItem(
      text: 'I am calm.',
      translation: 'Eu estou calmo(a).',
      example: 'I am calm.',
      exampleTranslation: 'Eu estou calmo(a).',
      audioAsset: 'audio/fase2/licao01/02.mp3',
    ),
    LessonItem(
      text: 'I am tired.',
      translation: 'Eu estou cansado(a).',
      example: 'I am tired.',
      exampleTranslation: 'Eu estou cansado(a).',
      audioAsset: 'audio/fase2/licao01/03.mp3',
    ),
    LessonItem(
      text: 'You are confident.',
      translation: 'Você está confiante.',
      example: 'You are confident.',
      exampleTranslation: 'Você está confiante.',
      audioAsset: 'audio/fase2/licao01/04.mp3',
    ),
    LessonItem(
      text: 'You are busy.',
      translation: 'Você está ocupado(a).',
      example: 'You are busy.',
      exampleTranslation: 'Você está ocupado(a).',
      audioAsset: 'audio/fase2/licao01/05.mp3',
    ),
    LessonItem(
      text: 'He is friendly.',
      translation: 'Ele é simpático.',
      example: 'He is friendly.',
      exampleTranslation: 'Ele é simpático.',
      audioAsset: 'audio/fase2/licao01/06.mp3',
    ),
    LessonItem(
      text: 'She is nervous.',
      translation: 'Ela está nervosa.',
      example: 'She is nervous.',
      exampleTranslation: 'Ela está nervosa.',
      audioAsset: 'audio/fase2/licao01/07.mp3',
    ),
    LessonItem(
      text: 'It is important.',
      translation: 'Isso é importante.',
      example: 'It is important.',
      exampleTranslation: 'Isso é importante.',
      audioAsset: 'audio/fase2/licao01/08.mp3',
    ),
    LessonItem(
      text: 'We are ready.',
      translation: 'Nós estamos prontos.',
      example: 'We are ready.',
      exampleTranslation: 'Nós estamos prontos.',
      audioAsset: 'audio/fase2/licao01/09.mp3',
    ),
    LessonItem(
      text: 'They are excited.',
      translation: 'Eles estão animados.',
      example: 'They are excited.',
      exampleTranslation: 'Eles estão animados.',
      audioAsset: 'audio/fase2/licao01/10.mp3',
    ),
  ],
);

// ---------------------------------------------------------------------------
// BLOCO 2 — Negative | Full Forms
// ---------------------------------------------------------------------------

const licao02 = Lesson(
  id: 'fase2-licao02',
  title: 'Eu não sou, eu não estou',
  objective: 'Agora a forma negativa completa: am not, is not, are not — '
      'pra dizer o que você NÃO é ou não está.',
  microSkill: 'Verbo to be — negativo completo',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'I am not sad.',
      translation: 'Eu não estou triste.',
      example: 'I am not sad.',
      exampleTranslation: 'Eu não estou triste.',
      audioAsset: 'audio/fase2/licao02/01.mp3',
    ),
    LessonItem(
      text: 'I am not nervous.',
      translation: 'Eu não estou nervoso(a).',
      example: 'I am not nervous.',
      exampleTranslation: 'Eu não estou nervoso(a).',
      audioAsset: 'audio/fase2/licao02/02.mp3',
    ),
    LessonItem(
      text: 'I am not energetic.',
      translation: 'Eu não estou cheio(a) de energia.',
      example: 'I am not energetic.',
      exampleTranslation: 'Eu não estou cheio(a) de energia.',
      audioAsset: 'audio/fase2/licao02/03.mp3',
    ),
    LessonItem(
      text: 'You are not insecure.',
      translation: 'Você não está inseguro(a).',
      example: 'You are not insecure.',
      exampleTranslation: 'Você não está inseguro(a).',
      audioAsset: 'audio/fase2/licao02/04.mp3',
    ),
    LessonItem(
      text: 'You are not free.',
      translation: 'Você não está livre.',
      example: 'You are not free.',
      exampleTranslation: 'Você não está livre.',
      audioAsset: 'audio/fase2/licao02/05.mp3',
    ),
    LessonItem(
      text: 'He is not unfriendly.',
      translation: 'Ele não é antipático.',
      example: 'He is not unfriendly.',
      exampleTranslation: 'Ele não é antipático.',
      audioAsset: 'audio/fase2/licao02/06.mp3',
    ),
    LessonItem(
      text: 'She is not calm.',
      translation: 'Ela não está calma.',
      example: 'She is not calm.',
      exampleTranslation: 'Ela não está calma.',
      audioAsset: 'audio/fase2/licao02/07.mp3',
    ),
    LessonItem(
      text: 'It is not irrelevant.',
      translation: 'Isso não é irrelevante.',
      example: 'It is not irrelevant.',
      exampleTranslation: 'Isso não é irrelevante.',
      audioAsset: 'audio/fase2/licao02/08.mp3',
    ),
    LessonItem(
      text: 'We are not unprepared.',
      translation: 'Nós não estamos despreparados.',
      example: 'We are not unprepared.',
      exampleTranslation: 'Nós não estamos despreparados.',
      audioAsset: 'audio/fase2/licao02/09.mp3',
    ),
    LessonItem(
      text: 'They are not bored.',
      translation: 'Eles não estão entediados.',
      example: 'They are not bored.',
      exampleTranslation: 'Eles não estão entediados.',
      audioAsset: 'audio/fase2/licao02/10.mp3',
    ),
  ],
);

// ---------------------------------------------------------------------------
// BLOCO 3 — Affirmative + Negative | Full Forms (contraste)
// ---------------------------------------------------------------------------

const licao03 = Lesson(
  id: 'fase2-licao03',
  title: 'Sim e não',
  objective: 'Junte afirmativo e negativo na mesma respiração — o '
      'contraste que mostra que você domina as duas formas.',
  microSkill: 'Verbo to be — contraste',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'I am happy.',
      translation: 'Eu estou feliz.',
      example: 'I am not sad.',
      exampleTranslation: 'Eu não estou triste.',
      audioAsset: 'audio/fase2/licao01/01.mp3',
    ),
    LessonItem(
      text: 'I am calm.',
      translation: 'Eu estou calmo(a).',
      example: 'I am not nervous.',
      exampleTranslation: 'Eu não estou nervoso(a).',
      audioAsset: 'audio/fase2/licao01/02.mp3',
    ),
    LessonItem(
      text: 'I am tired.',
      translation: 'Eu estou cansado(a).',
      example: 'I am not energetic.',
      exampleTranslation: 'Eu não estou cheio(a) de energia.',
      audioAsset: 'audio/fase2/licao01/03.mp3',
    ),
    LessonItem(
      text: 'You are confident.',
      translation: 'Você está confiante.',
      example: 'You are not insecure.',
      exampleTranslation: 'Você não está inseguro(a).',
      audioAsset: 'audio/fase2/licao01/04.mp3',
    ),
    LessonItem(
      text: 'You are busy.',
      translation: 'Você está ocupado(a).',
      example: 'You are not free.',
      exampleTranslation: 'Você não está livre.',
      audioAsset: 'audio/fase2/licao01/05.mp3',
    ),
    LessonItem(
      text: 'He is friendly.',
      translation: 'Ele é simpático.',
      example: 'He is not unfriendly.',
      exampleTranslation: 'Ele não é antipático.',
      audioAsset: 'audio/fase2/licao01/06.mp3',
    ),
    LessonItem(
      text: 'She is nervous.',
      translation: 'Ela está nervosa.',
      example: 'She is not calm.',
      exampleTranslation: 'Ela não está calma.',
      audioAsset: 'audio/fase2/licao01/07.mp3',
    ),
    LessonItem(
      text: 'It is important.',
      translation: 'Isso é importante.',
      example: 'It is not irrelevant.',
      exampleTranslation: 'Isso não é irrelevante.',
      audioAsset: 'audio/fase2/licao01/08.mp3',
    ),
    LessonItem(
      text: 'We are ready.',
      translation: 'Nós estamos prontos.',
      example: 'We are not unprepared.',
      exampleTranslation: 'Nós não estamos despreparados.',
      audioAsset: 'audio/fase2/licao01/09.mp3',
    ),
    LessonItem(
      text: 'They are excited.',
      translation: 'Eles estão animados.',
      example: 'They are not bored.',
      exampleTranslation: 'Eles não estão entediados.',
      audioAsset: 'audio/fase2/licao01/10.mp3',
    ),
  ],
);

// ---------------------------------------------------------------------------
// BLOCO 4 — Contractions | Sound Training
// ---------------------------------------------------------------------------

const licao04 = Lesson(
  id: 'fase2-licao04',
  title: 'O som da contração',
  objective: "Antes das frases, o som: I'm, you're, he's — treine só a "
      'contração, sem pressa de montar frase.',
  microSkill: 'Som das contrações — afirmativo e negativo',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I'm.",
      translation: 'contração de "I am"',
      example: "I'm.",
      exampleTranslation: 'contração de "I am"',
      audioAsset: 'audio/fase2/licao04/01.mp3',
    ),
    LessonItem(
      text: "You're.",
      translation: 'contração de "you are"',
      example: "You're.",
      exampleTranslation: 'contração de "you are"',
      audioAsset: 'audio/fase2/licao04/02.mp3',
    ),
    LessonItem(
      text: "He's.",
      translation: 'contração de "he is"',
      example: "He's.",
      exampleTranslation: 'contração de "he is"',
      audioAsset: 'audio/fase2/licao04/03.mp3',
    ),
    LessonItem(
      text: "She's.",
      translation: 'contração de "she is"',
      example: "She's.",
      exampleTranslation: 'contração de "she is"',
      audioAsset: 'audio/fase2/licao04/04.mp3',
    ),
    LessonItem(
      text: "It's.",
      translation: 'contração de "it is"',
      example: "It's.",
      exampleTranslation: 'contração de "it is"',
      audioAsset: 'audio/fase2/licao04/05.mp3',
    ),
    LessonItem(
      text: "We're.",
      translation: 'contração de "we are"',
      example: "We're.",
      exampleTranslation: 'contração de "we are"',
      audioAsset: 'audio/fase2/licao04/06.mp3',
    ),
    LessonItem(
      text: "They're.",
      translation: 'contração de "they are"',
      example: "They're.",
      exampleTranslation: 'contração de "they are"',
      audioAsset: 'audio/fase2/licao04/07.mp3',
    ),
    LessonItem(
      text: "I'm not.",
      translation: 'contração de "I am not"',
      example: "I'm not.",
      exampleTranslation: 'contração de "I am not"',
      audioAsset: 'audio/fase2/licao04/08.mp3',
    ),
    LessonItem(
      text: "You aren't.",
      translation: 'contração de "you are not"',
      example: "You aren't.",
      exampleTranslation: 'contração de "you are not"',
      audioAsset: 'audio/fase2/licao04/09.mp3',
    ),
    LessonItem(
      text: "He isn't.",
      translation: 'contração de "he is not"',
      example: "He isn't.",
      exampleTranslation: 'contração de "he is not"',
      audioAsset: 'audio/fase2/licao04/10.mp3',
    ),
  ],
);

// ---------------------------------------------------------------------------
// BLOCO 5 — Contractions | Sound Training (reforço negativo)
// ---------------------------------------------------------------------------

const licao05 = Lesson(
  id: 'fase2-licao05',
  title: 'Reforçando o não',
  objective: 'Mais uma rodada das contrações negativas — repetição é '
      'prática oral, não conteúdo repetido.',
  microSkill: 'Som das contrações — reforço negativo',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "She isn't.",
      translation: 'contração de "she is not"',
      example: "She isn't.",
      exampleTranslation: 'contração de "she is not"',
      audioAsset: 'audio/fase2/licao05/01.mp3',
    ),
    LessonItem(
      text: "It isn't.",
      translation: 'contração de "it is not"',
      example: "It isn't.",
      exampleTranslation: 'contração de "it is not"',
      audioAsset: 'audio/fase2/licao05/02.mp3',
    ),
    LessonItem(
      text: "We aren't.",
      translation: 'contração de "we are not"',
      example: "We aren't.",
      exampleTranslation: 'contração de "we are not"',
      audioAsset: 'audio/fase2/licao05/03.mp3',
    ),
    LessonItem(
      text: "They aren't.",
      translation: 'contração de "they are not"',
      example: "They aren't.",
      exampleTranslation: 'contração de "they are not"',
      audioAsset: 'audio/fase2/licao05/04.mp3',
    ),
    LessonItem(
      text: "I'm not.",
      translation: 'contração de "I am not"',
      example: "I'm not.",
      exampleTranslation: 'contração de "I am not"',
      audioAsset: 'audio/fase2/licao05/05.mp3',
    ),
    LessonItem(
      text: "You aren't.",
      translation: 'contração de "you are not"',
      example: "You aren't.",
      exampleTranslation: 'contração de "you are not"',
      audioAsset: 'audio/fase2/licao05/06.mp3',
    ),
    LessonItem(
      text: "He isn't.",
      translation: 'contração de "he is not"',
      example: "He isn't.",
      exampleTranslation: 'contração de "he is not"',
      audioAsset: 'audio/fase2/licao05/07.mp3',
    ),
    LessonItem(
      text: "She isn't.",
      translation: 'contração de "she is not"',
      example: "She isn't.",
      exampleTranslation: 'contração de "she is not"',
      audioAsset: 'audio/fase2/licao05/08.mp3',
    ),
    LessonItem(
      text: "We aren't.",
      translation: 'contração de "we are not"',
      example: "We aren't.",
      exampleTranslation: 'contração de "we are not"',
      audioAsset: 'audio/fase2/licao05/09.mp3',
    ),
    LessonItem(
      text: "They aren't.",
      translation: 'contração de "they are not"',
      example: "They aren't.",
      exampleTranslation: 'contração de "they are not"',
      audioAsset: 'audio/fase2/licao05/10.mp3',
    ),
  ],
);

// ---------------------------------------------------------------------------
// BLOCO 6 — Affirmative Sentences | Contractions
// ---------------------------------------------------------------------------

const licao06 = Lesson(
  id: 'fase2-licao06',
  title: 'Contraído e afirmativo',
  objective: 'Agora as contrações dentro de frases afirmativas de '
      "verdade: I'm happy, you're busy.",
  microSkill: 'Contrações em frases afirmativas',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I'm happy.",
      translation: 'Eu estou feliz.',
      example: "I'm happy.",
      exampleTranslation: 'Eu estou feliz.',
      audioAsset: 'audio/fase2/licao06/01.mp3',
    ),
    LessonItem(
      text: "I'm calm.",
      translation: 'Eu estou calmo(a).',
      example: "I'm calm.",
      exampleTranslation: 'Eu estou calmo(a).',
      audioAsset: 'audio/fase2/licao06/02.mp3',
    ),
    LessonItem(
      text: "I'm tired.",
      translation: 'Eu estou cansado(a).',
      example: "I'm tired.",
      exampleTranslation: 'Eu estou cansado(a).',
      audioAsset: 'audio/fase2/licao06/03.mp3',
    ),
    LessonItem(
      text: "You're confident.",
      translation: 'Você está confiante.',
      example: "You're confident.",
      exampleTranslation: 'Você está confiante.',
      audioAsset: 'audio/fase2/licao06/04.mp3',
    ),
    LessonItem(
      text: "You're busy.",
      translation: 'Você está ocupado(a).',
      example: "You're busy.",
      exampleTranslation: 'Você está ocupado(a).',
      audioAsset: 'audio/fase2/licao06/05.mp3',
    ),
    LessonItem(
      text: "He's friendly.",
      translation: 'Ele é simpático.',
      example: "He's friendly.",
      exampleTranslation: 'Ele é simpático.',
      audioAsset: 'audio/fase2/licao06/06.mp3',
    ),
    LessonItem(
      text: "She's nervous.",
      translation: 'Ela está nervosa.',
      example: "She's nervous.",
      exampleTranslation: 'Ela está nervosa.',
      audioAsset: 'audio/fase2/licao06/07.mp3',
    ),
    LessonItem(
      text: "It's important.",
      translation: 'Isso é importante.',
      example: "It's important.",
      exampleTranslation: 'Isso é importante.',
      audioAsset: 'audio/fase2/licao06/08.mp3',
    ),
    LessonItem(
      text: "We're ready.",
      translation: 'Nós estamos prontos.',
      example: "We're ready.",
      exampleTranslation: 'Nós estamos prontos.',
      audioAsset: 'audio/fase2/licao06/09.mp3',
    ),
    LessonItem(
      text: "They're excited.",
      translation: 'Eles estão animados.',
      example: "They're excited.",
      exampleTranslation: 'Eles estão animados.',
      audioAsset: 'audio/fase2/licao06/10.mp3',
    ),
  ],
);

// ---------------------------------------------------------------------------
// BLOCO 7 — Negative Sentences | Contractions
// ---------------------------------------------------------------------------

const licao07 = Lesson(
  id: 'fase2-licao07',
  title: 'Contraído e negativo',
  objective: 'As mesmas frases, na negativa contraída: '
      "I'm not, you aren't, he isn't.",
  microSkill: 'Contrações em frases negativas',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I'm not sad.",
      translation: 'Eu não estou triste.',
      example: "I'm not sad.",
      exampleTranslation: 'Eu não estou triste.',
      audioAsset: 'audio/fase2/licao07/01.mp3',
    ),
    LessonItem(
      text: "I'm not nervous.",
      translation: 'Eu não estou nervoso(a).',
      example: "I'm not nervous.",
      exampleTranslation: 'Eu não estou nervoso(a).',
      audioAsset: 'audio/fase2/licao07/02.mp3',
    ),
    LessonItem(
      text: "I'm not energetic.",
      translation: 'Eu não estou cheio(a) de energia.',
      example: "I'm not energetic.",
      exampleTranslation: 'Eu não estou cheio(a) de energia.',
      audioAsset: 'audio/fase2/licao07/03.mp3',
    ),
    LessonItem(
      text: "You aren't insecure.",
      translation: 'Você não está inseguro(a).',
      example: "You aren't insecure.",
      exampleTranslation: 'Você não está inseguro(a).',
      audioAsset: 'audio/fase2/licao07/04.mp3',
    ),
    LessonItem(
      text: "You aren't free.",
      translation: 'Você não está livre.',
      example: "You aren't free.",
      exampleTranslation: 'Você não está livre.',
      audioAsset: 'audio/fase2/licao07/05.mp3',
    ),
    LessonItem(
      text: "He isn't unfriendly.",
      translation: 'Ele não é antipático.',
      example: "He isn't unfriendly.",
      exampleTranslation: 'Ele não é antipático.',
      audioAsset: 'audio/fase2/licao07/06.mp3',
    ),
    LessonItem(
      text: "She isn't calm.",
      translation: 'Ela não está calma.',
      example: "She isn't calm.",
      exampleTranslation: 'Ela não está calma.',
      audioAsset: 'audio/fase2/licao07/07.mp3',
    ),
    LessonItem(
      text: "It isn't irrelevant.",
      translation: 'Isso não é irrelevante.',
      example: "It isn't irrelevant.",
      exampleTranslation: 'Isso não é irrelevante.',
      audioAsset: 'audio/fase2/licao07/08.mp3',
    ),
    LessonItem(
      text: "We aren't unprepared.",
      translation: 'Nós não estamos despreparados.',
      example: "We aren't unprepared.",
      exampleTranslation: 'Nós não estamos despreparados.',
      audioAsset: 'audio/fase2/licao07/09.mp3',
    ),
    LessonItem(
      text: "They aren't bored.",
      translation: 'Eles não estão entediados.',
      example: "They aren't bored.",
      exampleTranslation: 'Eles não estão entediados.',
      audioAsset: 'audio/fase2/licao07/10.mp3',
    ),
  ],
);

// ---------------------------------------------------------------------------
// BLOCO 8 — Contrast | Contractions
// ---------------------------------------------------------------------------

const licao08 = Lesson(
  id: 'fase2-licao08',
  title: 'Contraste contraído',
  objective: 'Contraste final, tudo contraído — a versão que um falante '
      'nativo realmente usa no dia a dia.',
  microSkill: 'Contrações — contraste',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I'm happy.",
      translation: 'Eu estou feliz.',
      example: "I'm not sad.",
      exampleTranslation: 'Eu não estou triste.',
      audioAsset: 'audio/fase2/licao06/01.mp3',
    ),
    LessonItem(
      text: "I'm calm.",
      translation: 'Eu estou calmo(a).',
      example: "I'm not nervous.",
      exampleTranslation: 'Eu não estou nervoso(a).',
      audioAsset: 'audio/fase2/licao06/02.mp3',
    ),
    LessonItem(
      text: "I'm tired.",
      translation: 'Eu estou cansado(a).',
      example: "I'm not energetic.",
      exampleTranslation: 'Eu não estou cheio(a) de energia.',
      audioAsset: 'audio/fase2/licao06/03.mp3',
    ),
    LessonItem(
      text: "You're confident.",
      translation: 'Você está confiante.',
      example: "You aren't insecure.",
      exampleTranslation: 'Você não está inseguro(a).',
      audioAsset: 'audio/fase2/licao06/04.mp3',
    ),
    LessonItem(
      text: "You're busy.",
      translation: 'Você está ocupado(a).',
      example: "You aren't free.",
      exampleTranslation: 'Você não está livre.',
      audioAsset: 'audio/fase2/licao06/05.mp3',
    ),
    LessonItem(
      text: "He's friendly.",
      translation: 'Ele é simpático.',
      example: "He isn't unfriendly.",
      exampleTranslation: 'Ele não é antipático.',
      audioAsset: 'audio/fase2/licao06/06.mp3',
    ),
    LessonItem(
      text: "She's nervous.",
      translation: 'Ela está nervosa.',
      example: "She isn't calm.",
      exampleTranslation: 'Ela não está calma.',
      audioAsset: 'audio/fase2/licao06/07.mp3',
    ),
    LessonItem(
      text: "It's important.",
      translation: 'Isso é importante.',
      example: "It isn't irrelevant.",
      exampleTranslation: 'Isso não é irrelevante.',
      audioAsset: 'audio/fase2/licao06/08.mp3',
    ),
    LessonItem(
      text: "We're ready.",
      translation: 'Nós estamos prontos.',
      example: "We aren't unprepared.",
      exampleTranslation: 'Nós não estamos despreparados.',
      audioAsset: 'audio/fase2/licao06/09.mp3',
    ),
    LessonItem(
      text: "They're excited.",
      translation: 'Eles estão animados.',
      example: "They aren't bored.",
      exampleTranslation: 'Eles não estão entediados.',
      audioAsset: 'audio/fase2/licao06/10.mp3',
    ),
  ],
);
