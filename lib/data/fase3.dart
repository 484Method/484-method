import '../models/lesson.dart';
import '../models/trail.dart';

/// Lições da Trilha 3 ("Frases prontas do dia a dia" = Fase 3 do
/// currículo): chunks que saem no automático, com o inglês falado de verdade
/// (ligação entre palavras, palavras fracas) — ver docs/curriculo-fase3.md.
///
/// Zona 1 — Respostas automáticas. Zona 2 — Pedir, oferecer e combinar.
/// Zona 3 — Puxar e manter conversa. Zona 4 — A fala ligada (connected
/// speech, primeiro pelo ouvido e depois na boca; exige prosódia ≥ 70).
///
/// Mesmo formato das Trilhas 1 e 2: cada zona tem 5 lições obrigatórias, uma
/// revisão (reaproveita os áudios da zona) e um bônus opcional
/// (`Lesson.bonus`), que nunca é pré-requisito. Ids sequenciais
/// (`fase3-licao01..28`), sem lacunas. Títulos sem inglês escrito (o aluno
/// vê o título antes de ouvir).
///
/// Critério: accuracy ≥ 75 + fonema mínimo ≥ 65 (o calibrado nas Trilhas 1 e
/// 2). ⚠️ Frase ligada (gonna, didja) pode pontuar abaixo do texto padrão no
/// Azure: calibrar com vozes brasileiras reais (evento attempt_assessed).
///
/// Áudio: `tool/gen_lesson_audio.sh` (função `gen3`) — o nome do arquivo é o
/// texto só com letras, dígitos e apóstrofo, espaços viram "_".
///
/// IPA e fonética são aproximações (inglês americano) — revisar com ouvido
/// nativo.
const fase3Zones = [
  Zone('Zona 1 — Respostas automáticas', [
    fase3Licao01, fase3Licao02, fase3Licao03, fase3Licao04,
    fase3Licao05, fase3Licao06, fase3Licao07,
  ]),
  Zone('Zona 2 — Pedir, oferecer e combinar', [
    fase3Licao08, fase3Licao09, fase3Licao10, fase3Licao11,
    fase3Licao12, fase3Licao13, fase3Licao14,
  ]),
  Zone('Zona 3 — Puxar e manter conversa', [
    fase3Licao15, fase3Licao16, fase3Licao17, fase3Licao18,
    fase3Licao19, fase3Licao20, fase3Licao21,
  ]),
  Zone('Zona 4 — A fala ligada', [
    fase3Licao22, fase3Licao23, fase3Licao24, fase3Licao25,
    fase3Licao26, fase3Licao27, fase3Licao28,
  ]),
];

// ---------------------------------------------------------------------------
// ZONA 1 — RESPOSTAS AUTOMÁTICAS
// ---------------------------------------------------------------------------

/// Lição 1 — Topar na hora: Concordar e aceitar convite.
const fase3Licao01 = Lesson(
  id: 'fase3-licao01',
  title: 'Topar na hora',
  objective: 'Você vai concordar e aceitar um convite com uma resposta curta '
      'que sai na hora, sem pensar na frase.',
  microSkill: 'Concordar e aceitar convite',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Sounds good.',
      translation: 'Fechado. / Pode ser.',
      example: 'Lunch at noon? Sounds good.',
      exampleTranslation: 'Almoço ao meio-dia? Fechado.',
      audioAsset: 'audio/fase3/licao01/Sounds_good.mp3',
      ipa: '/saʊnz ˈɡʊd/',
      phonetic: 'sáunz GÚD',
      soundTip: 'Fale como uma palavra só: a força cai em GOOD e o sounds sai '
          'curto, quase engolido, com o d sumindo antes do z.',
    ),
    LessonItem(
      text: 'Sure thing.',
      translation: 'Claro. / Pode deixar.',
      example: 'Can you send me the file? Sure thing.',
      exampleTranslation: 'Pode me mandar o arquivo? Pode deixar.',
      audioAsset: 'audio/fase3/licao01/Sure_thing.mp3',
      ipa: '/ˌʃʊr ˈθɪŋ/',
      phonetic: 'shur THÍNG',
      soundTip: 'Ponta da língua entre os dentes no thing, soprando ar, e '
          'termine no fundo da boca, sem abrir vogal depois.',
    ),
    LessonItem(
      text: 'Works for me.',
      translation: 'Pra mim está ótimo.',
      example: 'Friday at three? Works for me.',
      exampleTranslation: 'Sexta às três? Pra mim está ótimo.',
      audioAsset: 'audio/fase3/licao01/Works_for_me.mp3',
      ipa: '/ˈwɝks fɚ mi/',
      phonetic: 'UÉRKS fâr mi',
      soundTip: 'A força fica em WORKS, com o r enrolado e a boca em bico no '
          'começo. O for vira um fâr rápido, sem o.',
    ),
    LessonItem(
      text: "Let's do it.",
      translation: 'Bora. / Vamos nessa.',
      example: "Want to try the new place? Let's do it.",
      exampleTranslation: 'Quer experimentar o lugar novo? Bora.',
      audioAsset: "audio/fase3/licao01/Let's_do_it.mp3",
      ipa: '/ˌlɛts ˈdu ɪt/',
      phonetic: 'léts DÚ it',
      soundTip: 'A força cai em DO. O it final é curtinho e termina no t '
          'preso na ponta da língua, sem vogal depois.',
    ),
    LessonItem(
      text: 'Count me in.',
      translation: 'Tô dentro.',
      example: "We're playing soccer on Sunday. Count me in.",
      exampleTranslation: 'Vamos jogar futebol no domingo. Tô dentro.',
      audioAsset: 'audio/fase3/licao01/Count_me_in.mp3',
      ipa: '/ˌkaʊnt mi ˈɪn/',
      phonetic: 'káunt mi ÍN',
      soundTip: 'Três palavras num sopro só, com a força em IN. O t do count '
          'quase some, e o n final fica com a língua no céu da boca.',
    ),
  ],
);

/// Lição 2 — Agradecer e responder ao obrigado: Agradecer e responder.
const fase3Licao02 = Lesson(
  id: 'fase3-licao02',
  title: 'Agradecer e responder ao obrigado',
  objective: 'Você vai agradecer de jeito natural e responder sem travar '
      'quando alguém agradece a você.',
  microSkill: 'Agradecer e responder',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Thanks a lot.',
      translation: 'Muito obrigado.',
      example: 'Thanks a lot for the ride.',
      exampleTranslation: 'Muito obrigado pela carona.',
      audioAsset: 'audio/fase3/licao02/Thanks_a_lot.mp3',
      ipa: '/ˈθæŋks ə ˈlɑt/',
      phonetic: 'THÉNKS â LÁT',
      soundTip: 'Ligue o s no a: thanksa. A força cai em LOT, com a boca bem '
          'aberta, e o t final fica preso, sem vogal depois.',
    ),
    LessonItem(
      text: 'I really appreciate it.',
      translation: 'Agradeço muito mesmo.',
      example: 'Thanks for staying late. I really appreciate it.',
      exampleTranslation: 'Obrigado por ficar até mais tarde. Agradeço muito '
          'mesmo.',
      audioAsset: 'audio/fase3/licao02/I_really_appreciate_it.mp3',
      ipa: '/aɪ ˈrɪli əˈpriʃiˌeɪɾɪt/',
      phonetic: 'ai RÍ-li â-PRÍ-shi-ei-dit',
      soundTip: 'A força maior fica em PRE de appreciate. O t de appreciate '
          'it vira um r rápido, e o it se cola na palavra anterior.',
    ),
    LessonItem(
      text: "You're welcome.",
      translation: 'De nada.',
      example: "Thanks for the coffee! You're welcome.",
      exampleTranslation: 'Obrigado pelo café! De nada.',
      audioAsset: "audio/fase3/licao02/You're_welcome.mp3",
      ipa: '/jɚ ˈwɛlkəm/',
      phonetic: 'iâr UÉL-kâm',
      soundTip: "O you're sai fraco e rápido. A força vai em WEL, com o l "
          'tocando o céu da boca, e o come final quase some.',
    ),
    LessonItem(
      text: 'No worries.',
      translation: 'Imagina. / Tranquilo.',
      example: 'Sorry for the delay. No worries.',
      exampleTranslation: 'Desculpa a demora. Tranquilo.',
      audioAsset: 'audio/fase3/licao02/No_worries.mp3',
      ipa: '/noʊ ˈwɝiz/',
      phonetic: 'nôu UÉ-riz',
      soundTip: 'A força está em WOR, com a boca em bico e o r enrolado, sem '
          'tocar os dentes. O s final vibra como um z.',
    ),
    LessonItem(
      text: 'My pleasure.',
      translation: 'Foi um prazer.',
      example: 'Thanks for helping me move. My pleasure.',
      exampleTranslation: 'Obrigado por me ajudar na mudança. Foi um prazer.',
      audioAsset: 'audio/fase3/licao02/My_pleasure.mp3',
      ipa: '/maɪ ˈplɛʒɚ/',
      phonetic: 'mai PLÉ-jâr',
      soundTip: 'A força vai em PLEA. O meio soa como o j de já, e o final é '
          'um r enrolado curto, sem virar u.',
    ),
  ],
);

/// Lição 3 — Não entendi, repete?: Pedir repetição.
const fase3Licao03 = Lesson(
  id: 'fase3-licao03',
  title: 'Não entendi, repete?',
  objective: 'Você vai avisar que não entendeu e pedir para a pessoa repetir '
      'ou ir mais devagar, sem ficar calado.',
  microSkill: 'Pedir repetição',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Sorry, what was that?',
      translation: 'Desculpa, o que você disse?',
      example: 'The meeting moved to... Sorry, what was that?',
      exampleTranslation: 'A reunião mudou para... Desculpa, o que você disse?',
      audioAsset: 'audio/fase3/licao03/Sorry_what_was_that.mp3',
      ipa: '/ˈsɑri wʌt wəz ˈðæt/',
      phonetic: 'SÁ-ri, uât uâz DHÉT',
      soundTip: 'A força cai em SO e em THAT. O what was sai colado e fraco '
          'no meio, e o th é a língua tocando os dentes de cima.',
    ),
    LessonItem(
      text: 'Could you say that again?',
      translation: 'Pode repetir?',
      example: "Sorry, could you say that again? It's loud in here.",
      exampleTranslation: 'Desculpa, pode repetir? Está barulhento aqui.',
      audioAsset: 'audio/fase3/licao03/Could_you_say_that_again.mp3',
      ipa: '/kʊdʒu ˈseɪ ðæt əˈɡɛn/',
      phonetic: 'kú-dju SÊI thét â-GUÉN',
      soundTip: 'Could you vira uma palavra só, kudju. A força está em SAY e '
          'em GAIN, e o again termina em n, sem vogal no fim.',
    ),
    LessonItem(
      text: "I didn't catch that.",
      translation: 'Não peguei o que você falou.',
      example: "Sorry, I didn't catch that. What's your name?",
      exampleTranslation: 'Desculpa, não peguei. Qual é o seu nome?',
      audioAsset: "audio/fase3/licao03/I_didn't_catch_that.mp3",
      ipa: '/aɪ ˈdɪdn̩t ˈkætʃ ðæt/',
      phonetic: 'ai DÍ-dnt KÉTCH thét',
      soundTip: "O didn't fica sem vogal no meio: o d passa direto para o n "
          'pelo nariz. A força maior cai em CATCH, com a boca bem aberta.',
    ),
    LessonItem(
      text: 'What do you mean?',
      translation: 'Como assim?',
      example: 'We need to start over. What do you mean?',
      exampleTranslation: 'Precisamos começar de novo. Como assim?',
      audioAsset: 'audio/fase3/licao03/What_do_you_mean.mp3',
      ipa: '/ˌwʌɾəjə ˈmin/',
      phonetic: 'uâ-dâ-iâ MÍN',
      soundTip: 'What do you vira um bloco só e fraco, uadaia. Toda a força '
          'vai para MEAN, com o i longo e o n final bem fechado.',
    ),
    LessonItem(
      text: 'Can you slow down a bit?',
      translation: 'Pode falar mais devagar?',
      example: 'You talk fast! Can you slow down a bit?',
      exampleTranslation: 'Você fala rápido! Pode falar mais devagar?',
      audioAsset: 'audio/fase3/licao03/Can_you_slow_down_a_bit.mp3',
      ipa: '/kən ju ˈsloʊ ˈdaʊn ə ˈbɪt/',
      phonetic: 'kân iu SLÔU DÁUN â BÍT',
      soundTip: 'O can fica fraco, kân. Ligue o down no a: downa. O s do slow '
          'começa direto, sem vogal na frente.',
    ),
  ],
);

/// Lição 4 — Pedir desculpa e tranquilizar: Desculpar-se e tranquilizar.
const fase3Licao04 = Lesson(
  id: 'fase3-licao04',
  title: 'Pedir desculpa e tranquilizar',
  objective: 'Você vai pedir desculpa por uma falha pequena e tranquilizar '
      'quem se desculpa com você, numa resposta curta.',
  microSkill: 'Desculpar-se e tranquilizar',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'My bad.',
      translation: 'Foi mal.',
      example: 'You took my seat. Oh, my bad.',
      exampleTranslation: 'Você pegou meu lugar. Ah, foi mal.',
      audioAsset: 'audio/fase3/licao04/My_bad.mp3',
      ipa: '/maɪ ˈbæd/',
      phonetic: 'mai BÉD',
      soundTip: 'A força cai em BAD, com a boca bem aberta como num é largo. '
          'O d final fica preso na ponta da língua, sem vogal depois.',
    ),
    LessonItem(
      text: 'Sorry about that.',
      translation: 'Desculpa por isso.',
      example: 'I sent you the wrong file. Sorry about that.',
      exampleTranslation: 'Te mandei o arquivo errado. Desculpa por isso.',
      audioAsset: 'audio/fase3/licao04/Sorry_about_that.mp3',
      ipa: '/ˈsɑri əˈbaʊt ðæt/',
      phonetic: 'SÁ-ri â-BÁUT thét',
      soundTip: 'A força maior fica em SOR. O t do about quase não solta ar e '
          'já emenda no that, com a língua nos dentes.',
    ),
    LessonItem(
      text: "Sorry I'm late.",
      translation: 'Desculpa o atraso.',
      example: "Sorry I'm late. The traffic was terrible.",
      exampleTranslation: 'Desculpa o atraso. O trânsito estava horrível.',
      audioAsset: "audio/fase3/licao04/Sorry_I'm_late.mp3",
      ipa: '/ˈsɑri aɪm ˈleɪt/',
      phonetic: 'SÁ-ri aim LÊIT',
      soundTip: "O I'm sai fraco, colado no sorry. A força cai em LATE, e o t "
          'final fica preso, sem virar tchi.',
    ),
    LessonItem(
      text: "Don't worry about it.",
      translation: 'Não esquenta. / Não se preocupa.',
      example: "I forgot your book again. Don't worry about it.",
      exampleTranslation: 'Esqueci seu livro de novo. Não esquenta.',
      audioAsset: "audio/fase3/licao04/Don't_worry_about_it.mp3",
      ipa: '/ˌdoʊnt ˈwɝi əˈbaʊɾɪt/',
      phonetic: 'dôunt UÉ-ri â-BÁU-dit',
      soundTip: 'About it vira uma palavra só, abaudit: o t do meio vira um r '
          "rápido. O t do don't quase some antes do worry.",
    ),
    LessonItem(
      text: "It's all good.",
      translation: 'Tá tudo certo. / De boa.',
      example: "Sorry I missed your call. It's all good.",
      exampleTranslation: 'Desculpa, perdi sua ligação. De boa.',
      audioAsset: "audio/fase3/licao04/It's_all_good.mp3",
      ipa: '/ɪts ˌɔl ˈɡʊd/',
      phonetic: 'its ól GÚD',
      soundTip: 'Ligue o s no all: itsall. O l do all fica com a língua no '
          'céu da boca, sem virar u, e a força maior vai para GOOD.',
    ),
  ],
);

/// Lição 5 — Reagir ao que o outro conta: Reagir a notícias.
const fase3Licao05 = Lesson(
  id: 'fase3-licao05',
  title: 'Reagir ao que o outro conta',
  objective: 'Você vai reagir na hora a uma notícia, com surpresa, alegria ou '
      'empatia, para a conversa não morrer no seu silêncio.',
  microSkill: 'Reagir a notícias',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'No way!',
      translation: 'Não acredito!',
      example: 'I got the job! No way!',
      exampleTranslation: 'Consegui o emprego! Não acredito!',
      audioAsset: 'audio/fase3/licao05/No_way.mp3',
      ipa: '/ˈnoʊ ˈweɪ/',
      phonetic: 'NÔU UÊI',
      soundTip: 'As duas palavras são fortes, mas a voz sobe e desce em WAY '
          'para mostrar surpresa. O w começa com a boca em bico.',
    ),
    LessonItem(
      text: 'Good for you!',
      translation: 'Que bom pra você!',
      example: 'I finally finished my course. Good for you!',
      exampleTranslation: 'Finalmente terminei meu curso. Que bom pra você!',
      audioAsset: 'audio/fase3/licao05/Good_for_you.mp3',
      ipa: '/ˈɡʊd fɚ ju/',
      phonetic: 'GÚD fâr iu',
      soundTip: 'A força fica em GOOD. O for vira um fâr bem curto e o you '
          'fecha a frase leve, sem pausa entre as palavras.',
    ),
    LessonItem(
      text: "That's too bad.",
      translation: 'Que pena.',
      example: "The concert was canceled. That's too bad.",
      exampleTranslation: 'O show foi cancelado. Que pena.',
      audioAsset: "audio/fase3/licao05/That's_too_bad.mp3",
      ipa: '/ðæts tu ˈbæd/',
      phonetic: 'théts tu BÉD',
      soundTip: "Comece com a língua tocando os dentes no that's. A força cai "
          'em BAD, e a voz desce no final, num tom de pena.',
    ),
    LessonItem(
      text: "I'm so sorry to hear that.",
      translation: 'Sinto muito.',
      example: "My dad is in the hospital. I'm so sorry to hear that.",
      exampleTranslation: 'Meu pai está no hospital. Sinto muito.',
      audioAsset: "audio/fase3/licao05/I'm_so_sorry_to_hear_that.mp3",
      ipa: '/aɪm ˈsoʊ ˈsɑri tə ˈhɪr ðæt/',
      phonetic: 'aim SÔU SÁ-ri tâ RRÍR thét',
      soundTip: 'O to vira um tâ fraquinho. O h do hear é só um sopro, como o '
          'rr de carro, e a voz desce devagar até o that.',
    ),
    LessonItem(
      text: "That's awesome!",
      translation: 'Que demais!',
      example: "We're having a baby! That's awesome!",
      exampleTranslation: 'Vamos ter um bebê! Que demais!',
      audioAsset: "audio/fase3/licao05/That's_awesome.mp3",
      ipa: '/ðæts ˈɔsəm/',
      phonetic: 'théts Ó-sâm',
      soundTip: 'Ligue o s no awesome: thatsawesome. A força cai em AW, com a '
          'boca aberta, e o some final sai fraco e termina em m.',
    ),
  ],
);

/// Lição 6 (revisão) — Revisão: respostas automáticas: Revisão da zona.
const fase3Licao06 = Lesson(
  id: 'fase3-licao06',
  title: 'Revisão: respostas automáticas',
  objective: 'Você vai repetir as respostas rápidas da zona em situações '
      'novas, até elas saírem sem pensar.',
  microSkill: 'Revisão da zona',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Sounds good.',
      translation: 'Fechado. / Pode ser.',
      example: "Let's meet at the station. Sounds good.",
      exampleTranslation: 'Vamos nos encontrar na estação. Fechado.',
      audioAsset: 'audio/fase3/licao01/Sounds_good.mp3',
      ipa: '/saʊnz ˈɡʊd/',
      phonetic: 'sáunz GÚD',
      soundTip: 'Fale como uma palavra só: a força cai em GOOD e o sounds sai '
          'curto, quase engolido, com o d sumindo antes do z.',
    ),
    LessonItem(
      text: 'I really appreciate it.',
      translation: 'Agradeço muito mesmo.',
      example: "I'll cover your shift tomorrow. I really appreciate it.",
      exampleTranslation: 'Eu cubro seu turno amanhã. Agradeço muito mesmo.',
      audioAsset: 'audio/fase3/licao02/I_really_appreciate_it.mp3',
      ipa: '/aɪ ˈrɪli əˈpriʃiˌeɪɾɪt/',
      phonetic: 'ai RÍ-li â-PRÍ-shi-ei-dit',
      soundTip: 'A força maior fica em PRE de appreciate. O t de appreciate '
          'it vira um r rápido, e o it se cola na palavra anterior.',
    ),
    LessonItem(
      text: 'Sorry, what was that?',
      translation: 'Desculpa, o que você disse?',
      example: 'Your table is ready in... Sorry, what was that?',
      exampleTranslation: 'Sua mesa fica pronta em... Desculpa, o que você '
          'disse?',
      audioAsset: 'audio/fase3/licao03/Sorry_what_was_that.mp3',
      ipa: '/ˈsɑri wʌt wəz ˈðæt/',
      phonetic: 'SÁ-ri, uât uâz DHÉT',
      soundTip: 'A força cai em SO e em THAT. O what was sai colado e fraco '
          'no meio, e o th é a língua tocando os dentes de cima.',
    ),
    LessonItem(
      text: "Don't worry about it.",
      translation: 'Não esquenta. / Não se preocupa.',
      example: "Sorry, I spilled some water. Don't worry about it.",
      exampleTranslation: 'Desculpa, derrubei um pouco de água. Não esquenta.',
      audioAsset: "audio/fase3/licao04/Don't_worry_about_it.mp3",
      ipa: '/ˌdoʊnt ˈwɝi əˈbaʊɾɪt/',
      phonetic: 'dôunt UÉ-ri â-BÁU-dit',
      soundTip: 'About it vira uma palavra só, abaudit: o t do meio vira um r '
          "rápido. O t do don't quase some antes do worry.",
    ),
    LessonItem(
      text: 'No way!',
      translation: 'Não acredito!',
      example: "I'm moving to Canada next month. No way!",
      exampleTranslation: 'Vou me mudar pro Canadá mês que vem. Não acredito!',
      audioAsset: 'audio/fase3/licao05/No_way.mp3',
      ipa: '/ˈnoʊ ˈweɪ/',
      phonetic: 'NÔU UÊI',
      soundTip: 'As duas palavras são fortes, mas a voz sobe e desce em WAY '
          'para mostrar surpresa. O w começa com a boca em bico.',
    ),
  ],
);

/// Lição 7 — BÔNUS — Bônus: respostas mais completas: Respostas longas e naturais.
const fase3Licao07 = Lesson(
  id: 'fase3-licao07',
  title: 'Bônus: respostas mais completas',
  objective: 'Você vai usar versões mais longas das respostas rápidas, que '
      'soam mais naturais numa conversa de verdade.',
  microSkill: 'Respostas longas e naturais',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: 'Sounds like a plan to me.',
      translation: 'Pra mim, fechou.',
      example: 'Dinner at eight, then a movie? Sounds like a plan to me.',
      exampleTranslation: 'Jantar às oito e depois um filme? Pra mim, fechou.',
      audioAsset: 'audio/fase3/licao07/Sounds_like_a_plan_to_me.mp3',
      ipa: '/ˈsaʊnz laɪk ə ˈplæn tə mi/',
      phonetic: 'SÁUNZ lai-kâ PLÉN tâ mi',
      soundTip: 'Like a vira laika, colado. A força cai em SOUNDS e em PLAN, '
          'e o to me sai fraco e rápido no fim.',
    ),
    LessonItem(
      text: 'Thanks so much, I owe you one.',
      translation: 'Valeu demais, fico te devendo essa.',
      example: 'You fixed my laptop? Thanks so much, I owe you one.',
      exampleTranslation: 'Você consertou meu notebook? Valeu demais, fico te '
          'devendo essa.',
      audioAsset: 'audio/fase3/licao07/Thanks_so_much_I_owe_you_one.mp3',
      ipa: '/ˈθæŋks soʊ ˈmʌtʃ aɪ ˈoʊ jə ˈwʌn/',
      phonetic: 'THÉNKS sôu MÂTCH, ai ÔU iâ UÂN',
      soundTip: 'Force MUCH, OWE e ONE. O you no meio sai fraco, iâ, ligando '
          'o owe no one sem pausa.',
    ),
    LessonItem(
      text: 'Sorry, could you say that one more time?',
      translation: 'Desculpa, pode repetir mais uma vez?',
      example: 'The code is four, seven... Sorry, could you say that one more '
          'time?',
      exampleTranslation: 'O código é quatro, sete... Desculpa, pode repetir '
          'mais uma vez?',
      audioAsset:
          'audio/fase3/licao07/Sorry_could_you_say_that_one_more_time.mp3',
      ipa: '/ˈsɑri kʊdʒu ˈseɪ ðæt ˈwʌn mɔr ˈtaɪm/',
      phonetic: 'SÁ-ri kú-dju SÊI thét UÂN mór TÁIM',
      soundTip: 'Could you vira kudju. O fim tem três batidas fortes, ONE, '
          'MORE, TIME, e o r de more fica enrolado, sem virar u.',
    ),
    LessonItem(
      text: 'No worries at all, it happens.',
      translation: 'Tranquilo, acontece.',
      example: 'Sorry, I forgot to call you back. No worries at all, it '
          'happens.',
      exampleTranslation: 'Desculpa, esqueci de te ligar de volta. Tranquilo, '
          'acontece.',
      audioAsset: 'audio/fase3/licao07/No_worries_at_all_it_happens.mp3',
      ipa: '/noʊ ˈwɝiz əˈɾɔl ɪt ˈhæpənz/',
      phonetic: 'nôu UÉ-riz â-DÓL, it RRÉ-pânz',
      soundTip: 'Worries at all vira worriesadall: o t vira um r rápido. O h '
          'do happens é só um sopro, e a força cai em HAP.',
    ),
    LessonItem(
      text: "Wow, that's great news. Congratulations!",
      translation: 'Nossa, que notícia boa. Parabéns!',
      example: "I passed the exam! Wow, that's great news. Congratulations!",
      exampleTranslation: 'Passei na prova! Nossa, que notícia boa. Parabéns!',
      audioAsset:
          "audio/fase3/licao07/Wow_that's_great_news_Congratulations.mp3",
      ipa: '/waʊ ðæts ˈɡreɪt ˈnuz kənˌɡrætʃəˈleɪʃənz/',
      phonetic: 'uáu, théts GRÊIT NÚZ. kân-gré-tchâ-LÊI-shânz',
      soundTip: 'Em congratulations a força maior cai em LA, e o con do '
          'começo sai fraco. O news termina vibrando como z.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// ZONA 2 — PEDIR, OFERECER E COMBINAR
// ---------------------------------------------------------------------------

/// Lição 8 — Pedir com educação: Pedidos educados ligados.
const fase3Licao08 = Lesson(
  id: 'fase3-licao08',
  title: 'Pedir com educação',
  objective: 'Você vai pedir favores e coisas do dia a dia com educação, numa '
      'frase só, sem montar palavra por palavra.',
  microSkill: 'Pedidos educados ligados',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Could you close the door, please?',
      translation: 'Você pode fechar a porta, por favor?',
      example: "It's cold in here. Could you close the door, please?",
      exampleTranslation: 'Tá frio aqui. Pode fechar a porta, por favor?',
      audioAsset: 'audio/fase3/licao08/Could_you_close_the_door_please.mp3',
      ipa: '/kʊdʒə ˈkloʊz ðə ˈdɔr ˈpliz/',
      phonetic: 'kudja KLÔUZ tha DÓR, PLÍZ',
      soundTip: 'Could you sai junto e fraco, kudja. Força em CLOSE e DOOR; o '
          'close termina zumbindo, como z, e o door fecha com a língua '
          'enrolada.',
    ),
    LessonItem(
      text: 'Could you send me the file?',
      translation: 'Você pode me mandar o arquivo?',
      example: 'Could you send me the file before lunch?',
      exampleTranslation: 'Você pode me mandar o arquivo antes do almoço?',
      audioAsset: 'audio/fase3/licao08/Could_you_send_me_the_file.mp3',
      ipa: '/kʊdʒə ˈsɛnd mi ðə ˈfaɪl/',
      phonetic: 'kudja SÉND mi tha FÁIL',
      soundTip: 'Comece rápido em kudja e bata forte em SEND e FILE. O the '
          'sai curtinho e o L final fecha com a língua no céu da boca.',
    ),
    LessonItem(
      text: 'Can you give me a ride?',
      translation: 'Você me dá uma carona?',
      example: 'My car is in the shop. Can you give me a ride?',
      exampleTranslation: 'Meu carro está na oficina. Você me dá uma carona?',
      audioAsset: 'audio/fase3/licao08/Can_you_give_me_a_ride.mp3',
      ipa: '/kən jə ˈɡɪv mi ə ˈraɪd/',
      phonetic: 'kenia GUÍV mi a RÁID',
      soundTip: 'O can fica fraco, quase ken. Ligue give me a numa frase só e '
          'no ride enrole a língua para trás, sem raspar a garganta.',
    ),
    LessonItem(
      text: 'Would you mind waiting a second?',
      translation: 'Você se importa de esperar um segundinho?',
      example: "Would you mind waiting a second? I'm almost done.",
      exampleTranslation: 'Se importa de esperar um segundinho? Já estou '
          'quase terminando.',
      audioAsset: 'audio/fase3/licao08/Would_you_mind_waiting_a_second.mp3',
      ipa: '/wʊdʒə ˈmaɪnd ˈweɪɾɪŋ ə ˈsɛkənd/',
      phonetic: 'uudja MÁIND UÊI-rin a SÉ-kend',
      soundTip: 'Would you vira uudja, sem pausa. No waiting o t vira um r '
          'leve, de toque rápido, e o fim de second fecha no d sem vogal '
          'depois.',
    ),
    LessonItem(
      text: 'Could I get the check, please?',
      translation: 'Pode trazer a conta, por favor?',
      example: "We're all set. Could I get the check, please?",
      exampleTranslation: 'Já terminamos. Pode trazer a conta, por favor?',
      audioAsset: 'audio/fase3/licao08/Could_I_get_the_check_please.mp3',
      ipa: '/kʊd aɪ ˈɡɛt ðə ˈtʃɛk ˈpliz/',
      phonetic: 'ku-dai GUÉT tha TCHÉK, PLÍZ',
      soundTip: 'Ligue could e I: ku-dai. O t de get trava sem soltar ar '
          'antes do the, e o please termina zumbindo, não em sse.',
    ),
  ],
);

/// Lição 9 — Oferecer ajuda: Ofertas de ajuda prontas.
const fase3Licao09 = Lesson(
  id: 'fase3-licao09',
  title: 'Oferecer ajuda',
  objective: 'Você vai oferecer ajuda de um jeito natural, com o começo da '
      'frase curto e ligado.',
  microSkill: 'Ofertas de ajuda prontas',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Do you want me to help?',
      translation: 'Quer que eu ajude?',
      example: 'That box looks heavy. Do you want me to help?',
      exampleTranslation: 'Essa caixa parece pesada. Quer que eu ajude?',
      audioAsset: 'audio/fase3/licao09/Do_you_want_me_to_help.mp3',
      ipa: '/dʒə ˈwɑn mi tə ˈhɛlp/',
      phonetic: 'dja UÓN mi ta RRÉLP',
      soundTip: 'Do you encolhe para dja e o t de want quase some antes do '
          'me. A força vai em WANT e HELP, que fecha com os lábios no p.',
    ),
    LessonItem(
      text: 'Let me get that for you.',
      translation: 'Deixa que eu pego pra você.',
      example: 'Your hands are full. Let me get that for you.',
      exampleTranslation: 'Suas mãos estão ocupadas. Deixa que eu pego pra '
          'você.',
      audioAsset: 'audio/fase3/licao09/Let_me_get_that_for_you.mp3',
      ipa: '/ˈlɛmi ˈɡɛt ðæt fər ju/',
      phonetic: 'LÉ-mi GUÉT thét fer iu',
      soundTip: 'Let me vira lemi, uma palavra só. O t de get e o de that '
          'travam sem soltar ar, e o for you sai fraco e rápido.',
    ),
    LessonItem(
      text: 'Do you need a hand?',
      translation: 'Precisa de uma mão?',
      example: 'You look lost. Do you need a hand?',
      exampleTranslation: 'Você parece perdido. Precisa de uma mão?',
      audioAsset: 'audio/fase3/licao09/Do_you_need_a_hand.mp3',
      ipa: '/dʒə ˈnid ə ˈhænd/',
      phonetic: 'dja NÍ-da RRÉND',
      soundTip: 'Need e a se grudam, ni-da. Em hand, o h é só um sopro leve e '
          'a vogal abre bem, como no é de pé, mais aberto.',
    ),
    LessonItem(
      text: 'I can drive you home.',
      translation: 'Eu posso te levar em casa.',
      example: "It's late. I can drive you home.",
      exampleTranslation: 'Está tarde. Eu posso te levar em casa.',
      audioAsset: 'audio/fase3/licao09/I_can_drive_you_home.mp3',
      ipa: '/aɪ kən ˈdraɪv jə ˈhoʊm/',
      phonetic: 'ai ken DRÁIV ia RRÔUM',
      soundTip: 'O can fica fraco, ken, e a força vai em DRIVE e HOME. Ligue '
          'drive you sem vogal no meio e feche os lábios no m final.',
    ),
    LessonItem(
      text: 'Let me know if you need anything.',
      translation: 'Se precisar de alguma coisa, me avisa.',
      example: 'Welcome to the team! Let me know if you need anything.',
      exampleTranslation: 'Bem-vindo à equipe! Se precisar de alguma coisa, '
          'me avisa.',
      audioAsset: 'audio/fase3/licao09/Let_me_know_if_you_need_anything.mp3',
      ipa: '/ˈlɛmi ˈnoʊ ɪf ju ˈnid ˈɛniˌθɪŋ/',
      phonetic: 'LÉ-mi NÔU if iu NÍD É-ni-thing',
      soundTip: 'Lemi NÔU sai junto, com a força em KNOW. No anything, a '
          'ponta da língua toca de leve os dentes de cima e sopra, e o final '
          'fica no nariz, sem gue.',
    ),
  ],
);

/// Lição 10 — Pedir permissão: Pedidos de permissão ligados.
const fase3Licao10 = Lesson(
  id: 'fase3-licao10',
  title: 'Pedir permissão',
  objective: 'Você vai pedir licença para fazer algo com frases prontas, '
      'ligando as palavras pequenas do começo.',
  microSkill: 'Pedidos de permissão ligados',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Do you mind if I sit here?',
      translation: 'Posso sentar aqui?',
      example: 'Do you mind if I sit here? All the other seats are taken.',
      exampleTranslation: 'Posso sentar aqui? Todos os outros lugares estão '
          'ocupados.',
      audioAsset: 'audio/fase3/licao10/Do_you_mind_if_I_sit_here.mp3',
      ipa: '/dʒə ˈmaɪnd ɪf aɪ ˈsɪt ˈhɪr/',
      phonetic: 'dja MÁIN-di-fai SÍT RRÍR',
      soundTip: 'Mind if I vira uma corrente só: main-di-fai. O t de sit '
          'trava sem soltar ar e o here termina com a língua enrolada, sem '
          'vogal.',
    ),
    LessonItem(
      text: 'Is it okay if I leave early?',
      translation: 'Tudo bem se eu sair mais cedo?',
      example: "I have a doctor's appointment. Is it okay if I leave early?",
      exampleTranslation: 'Tenho consulta médica. Tudo bem se eu sair mais '
          'cedo?',
      audioAsset: 'audio/fase3/licao10/Is_it_okay_if_I_leave_early.mp3',
      ipa: '/ɪz ɪt oʊˈkeɪ ɪf aɪ ˈliv ˈɝli/',
      phonetic: 'i-zi-tou-KÊI if ai LÍV ÂR-li',
      soundTip: 'Is it okay sai grudado, i-zi-tou-KAY. No leave segure o i '
          'longo e termine vibrando o v; em early a língua enrola logo no '
          'começo.',
    ),
    LessonItem(
      text: 'Can I borrow your pen?',
      translation: 'Você me empresta sua caneta?',
      example: 'Oh no, I forgot mine. Can I borrow your pen?',
      exampleTranslation: 'Ah não, esqueci a minha. Você me empresta sua '
          'caneta?',
      audioAsset: 'audio/fase3/licao10/Can_I_borrow_your_pen.mp3',
      ipa: '/kən aɪ ˈbɑroʊ jər ˈpɛn/',
      phonetic: 'ke-nai BÁ-rou iur PÉN',
      soundTip: 'Can I se liga: ke-nai. A força vai em BOR, com a língua '
          'curvada no r sem tocar o céu da boca, e o pen fecha no n, sem i.',
    ),
    LessonItem(
      text: 'Mind if I open the window?',
      translation: 'Posso abrir a janela?',
      example: "It's hot in here. Mind if I open the window?",
      exampleTranslation: 'Está quente aqui. Posso abrir a janela?',
      audioAsset: 'audio/fase3/licao10/Mind_if_I_open_the_window.mp3',
      ipa: '/ˈmaɪnd ɪf aɪ ˈoʊpən ðə ˈwɪndoʊ/',
      phonetic: 'MÁIN-di-fai ÔU-pen tha UÍN-dou',
      soundTip: 'Comece direto em mind, sem do you. Main-di-fai sai numa '
          'respiração, e a força cai em O de open e em WIN de window.',
    ),
    LessonItem(
      text: 'May I ask you something?',
      translation: 'Posso te perguntar uma coisa?',
      example: "May I ask you something? It's about the meeting.",
      exampleTranslation: 'Posso te perguntar uma coisa? É sobre a reunião.',
      audioAsset: 'audio/fase3/licao10/May_I_ask_you_something.mp3',
      ipa: '/meɪ aɪ ˈæsk ju ˈsʌmθɪŋ/',
      phonetic: 'mêi ai ÉS-kiu SÂM-thing',
      soundTip: 'Ask you se gruda: és-kiu, sem vogal entre o s e o k. Em '
          'something a língua toca os dentes de leve e o final soa pelo '
          'nariz.',
    ),
  ],
);

/// Lição 11 — Combinar dia e hora: Combinar horários rápido.
const fase3Licao11 = Lesson(
  id: 'fase3-licao11',
  title: 'Combinar dia e hora',
  objective: 'Você vai sugerir e confirmar dia e horário sem travar, com a '
      'força nas palavras que importam.',
  microSkill: 'Combinar horários rápido',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Does Friday work for you?',
      translation: 'Sexta fica bom pra você?',
      example: "I can't do Thursday. Does Friday work for you?",
      exampleTranslation: 'Quinta não dá pra mim. Sexta fica bom pra você?',
      audioAsset: 'audio/fase3/licao11/Does_Friday_work_for_you.mp3',
      ipa: '/dəz ˈfraɪdeɪ ˈwɝk fər ju/',
      phonetic: 'dâz FRÁI-dei UÂRK fer iu',
      soundTip: 'O does fica fraco e curto, dâz. A força vai em FRI e WORK, '
          'com a língua enrolada no r de work, e o for you sai rapidinho.',
    ),
    LessonItem(
      text: 'How about tomorrow morning?',
      translation: 'Que tal amanhã de manhã?',
      example: "I'm busy today. How about tomorrow morning?",
      exampleTranslation: 'Hoje estou ocupado. Que tal amanhã de manhã?',
      audioAsset: 'audio/fase3/licao11/How_about_tomorrow_morning.mp3',
      ipa: '/haʊ əˈbaʊt təˈmɑroʊ ˈmɔrnɪŋ/',
      phonetic: 'rráu a-BÁUT ta-MÁ-rou MÓR-ning',
      soundTip: 'How about sai ligado, rráu-a-BAUT, e o t trava sem soltar '
          'ar. Tomorrow começa fraco, ta, e a força vai em MOR.',
    ),
    LessonItem(
      text: 'What time works for you?',
      translation: 'Que horário fica bom pra você?',
      example: "Let's have a call this week. What time works for you?",
      exampleTranslation: 'Vamos fazer uma ligação essa semana. Que horário '
          'fica bom pra você?',
      audioAsset: 'audio/fase3/licao11/What_time_works_for_you.mp3',
      ipa: '/wʌt ˈtaɪm ˈwɝks fər ju/',
      phonetic: 'uât TÁIM UÂRKS fer iu',
      soundTip: 'O t de what se junta ao de time: um t só, forte, em TIME. Em '
          'works a língua enrola no r e o s final sai seco, sem vogal.',
    ),
    LessonItem(
      text: "Let's meet at six.",
      translation: 'Vamos nos encontrar às seis.',
      example: "Let's meet at six, in front of the station.",
      exampleTranslation: 'Vamos nos encontrar às seis, na frente da estação.',
      audioAsset: "audio/fase3/licao11/Let's_meet_at_six.mp3",
      ipa: '/lɛts ˈmiɾ ət ˈsɪks/',
      phonetic: 'léts MÍ-rat SÍKS',
      soundTip: 'Meet at vira mi-rat: o t entre vogais é um toque rápido da '
          'língua, quase um r. O at fica fraco e six termina seco no ks.',
    ),
    LessonItem(
      text: "I'm free after three.",
      translation: 'Estou livre depois das três.',
      example: "I have meetings all morning, but I'm free after three.",
      exampleTranslation: 'Tenho reuniões a manhã toda, mas estou livre '
          'depois das três.',
      audioAsset: "audio/fase3/licao11/I'm_free_after_three.mp3",
      ipa: '/aɪm ˈfri ˈæftər ˈθri/',
      phonetic: 'aim FRÍ ÉF-ter THRÍ',
      soundTip: 'Em three a ponta da língua sai entre os dentes e sopra, '
          "depois enrola para o r. Feche os lábios no m de I'm antes do free.",
    ),
  ],
);

/// Lição 12 — Recusar ou adiar com jeito: Recusa educada pronta.
const fase3Licao12 = Lesson(
  id: 'fase3-licao12',
  title: 'Recusar ou adiar com jeito',
  objective: 'Você vai dizer não ou deixar para depois com educação, sem soar '
      'seco nem enrolar.',
  microSkill: 'Recusa educada pronta',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I'd love to, but I can't.",
      translation: 'Eu adoraria, mas não posso.',
      example: "Dinner on Saturday? I'd love to, but I can't.",
      exampleTranslation: 'Jantar no sábado? Eu adoraria, mas não posso.',
      audioAsset: "audio/fase3/licao12/I'd_love_to_but_I_can't.mp3",
      ipa: '/aɪd ˈlʌv tə bət aɪ ˈkænt/',
      phonetic: 'aid LÂV ta, bâ-tai KÉNT',
      soundTip: 'Love to sai junto, com o to fraco. But I se liga, bâ-tai, e '
          "o can't abre bem a vogal e termina no t: é isso que o separa de "
          'can.',
    ),
    LessonItem(
      text: 'Maybe next time.',
      translation: 'Fica pra próxima.',
      example: "I'm too tired tonight. Maybe next time.",
      exampleTranslation: 'Estou cansado demais hoje. Fica pra próxima.',
      audioAsset: 'audio/fase3/licao12/Maybe_next_time.mp3',
      ipa: '/ˈmeɪbi ˈnɛks taɪm/',
      phonetic: 'MÊI-bi NÉKS taim',
      soundTip: 'O t de next some antes de time: NÉKS taim. A força maior cai '
          'em NEXT, e o m final fecha os lábios, sem virar vogal.',
    ),
    LessonItem(
      text: 'Can we do it another day?',
      translation: 'A gente pode fazer outro dia?',
      example: "I'm not feeling well. Can we do it another day?",
      exampleTranslation: 'Não estou me sentindo bem. A gente pode fazer '
          'outro dia?',
      audioAsset: 'audio/fase3/licao12/Can_we_do_it_another_day.mp3',
      ipa: '/kən wi ˈdu ɪt əˈnʌðər ˈdeɪ/',
      phonetic: 'ken ui DÚ-it a-NÂ-ther DÊI',
      soundTip: 'Do it se gruda, du-it. Em another o th vibra com a língua '
          'entre os dentes e a força cai em NO; o day fecha a frase, forte.',
    ),
    LessonItem(
      text: "I'm a bit busy right now.",
      translation: 'Estou meio ocupado agora.',
      example: "Can I call you back? I'm a bit busy right now.",
      exampleTranslation: 'Posso te ligar depois? Estou meio ocupado agora.',
      audioAsset: "audio/fase3/licao12/I'm_a_bit_busy_right_now.mp3",
      ipa: '/aɪm ə ˈbɪt ˈbɪzi ˌraɪt ˈnaʊ/',
      phonetic: 'ai-ma BÍT BÍ-zi rái NÁU',
      soundTip: "I'm a vira ai-ma, colado. O t de bit e o de right travam sem "
          'soltar ar, e o s de busy sai zumbindo, como z.',
    ),
    LessonItem(
      text: "I'll get back to you.",
      translation: 'Eu te dou um retorno.',
      example: "Let me check my schedule and I'll get back to you.",
      exampleTranslation: 'Deixa eu ver minha agenda e te dou um retorno.',
      audioAsset: "audio/fase3/licao12/I'll_get_back_to_you.mp3",
      ipa: '/aɪl ɡɛt ˈbæk tə ju/',
      phonetic: 'ail guét BÉK ta iu',
      soundTip: "I'll termina com a língua no céu da boca, sem virar u. O t "
          'de get trava antes do back, que leva a força e abre bem a vogal.',
    ),
  ],
);

/// Lição 13 (revisão) — Revisão: pedir, oferecer e combinar: Revisão de pedidos e combinados.
const fase3Licao13 = Lesson(
  id: 'fase3-licao13',
  title: 'Revisão: pedir, oferecer e combinar',
  objective: 'Você vai repetir uma frase de cada lição desta zona e conferir '
      'se elas já saem ligadas, no automático.',
  microSkill: 'Revisão de pedidos e combinados',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Could you send me the file?',
      translation: 'Você pode me mandar o arquivo?',
      example: "I can't find the report. Could you send me the file?",
      exampleTranslation: 'Não acho o relatório. Você pode me mandar o '
          'arquivo?',
      audioAsset: 'audio/fase3/licao08/Could_you_send_me_the_file.mp3',
      ipa: '/kʊdʒə ˈsɛnd mi ðə ˈfaɪl/',
      phonetic: 'kudja SÉND mi tha FÁIL',
      soundTip: 'Comece rápido em kudja e bata forte em SEND e FILE. O the '
          'sai curtinho e o L final fecha com a língua no céu da boca.',
    ),
    LessonItem(
      text: 'Let me get that for you.',
      translation: 'Deixa que eu pego pra você.',
      example: 'The door is heavy. Let me get that for you.',
      exampleTranslation: 'A porta é pesada. Deixa que eu abro pra você.',
      audioAsset: 'audio/fase3/licao09/Let_me_get_that_for_you.mp3',
      ipa: '/ˈlɛmi ˈɡɛt ðæt fər ju/',
      phonetic: 'LÉ-mi GUÉT thét fer iu',
      soundTip: 'Let me vira lemi, uma palavra só. O t de get e o de that '
          'travam sem soltar ar, e o for you sai fraco e rápido.',
    ),
    LessonItem(
      text: 'Do you mind if I sit here?',
      translation: 'Posso sentar aqui?',
      example: 'Excuse me, do you mind if I sit here?',
      exampleTranslation: 'Com licença, posso sentar aqui?',
      audioAsset: 'audio/fase3/licao10/Do_you_mind_if_I_sit_here.mp3',
      ipa: '/dʒə ˈmaɪnd ɪf aɪ ˈsɪt ˈhɪr/',
      phonetic: 'dja MÁIN-di-fai SÍT RRÍR',
      soundTip: 'Mind if I vira uma corrente só: main-di-fai. O t de sit '
          'trava sem soltar ar e o here termina com a língua enrolada, sem '
          'vogal.',
    ),
    LessonItem(
      text: 'Does Friday work for you?',
      translation: 'Sexta fica bom pra você?',
      example: 'We need to talk about the project. Does Friday work for you?',
      exampleTranslation: 'Precisamos falar do projeto. Sexta fica bom pra '
          'você?',
      audioAsset: 'audio/fase3/licao11/Does_Friday_work_for_you.mp3',
      ipa: '/dəz ˈfraɪdeɪ ˈwɝk fər ju/',
      phonetic: 'dâz FRÁI-dei UÂRK fer iu',
      soundTip: 'O does fica fraco e curto, dâz. A força vai em FRI e WORK, '
          'com a língua enrolada no r de work, e o for you sai rapidinho.',
    ),
    LessonItem(
      text: "I'd love to, but I can't.",
      translation: 'Eu adoraria, mas não posso.',
      example: "A trip to the beach? I'd love to, but I can't.",
      exampleTranslation: 'Uma viagem pra praia? Eu adoraria, mas não posso.',
      audioAsset: "audio/fase3/licao12/I'd_love_to_but_I_can't.mp3",
      ipa: '/aɪd ˈlʌv tə bət aɪ ˈkænt/',
      phonetic: 'aid LÂV ta, bâ-tai KÉNT',
      soundTip: 'Love to sai junto, com o to fraco. But I se liga, bâ-tai, e '
          "o can't abre bem a vogal e termina no t: é isso que o separa de "
          'can.',
    ),
  ],
);

/// Lição 14 — BÔNUS — Bônus: pedidos e combinados longos: Chunks longos de combinar.
const fase3Licao14 = Lesson(
  id: 'fase3-licao14',
  title: 'Bônus: pedidos e combinados longos',
  objective: 'Você vai juntar pedido, oferta e horário em frases mais longas, '
      'mantendo o ritmo ligado do começo ao fim.',
  microSkill: 'Chunks longos de combinar',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: 'Would you mind sending me the details later?',
      translation: 'Você se importa de me mandar os detalhes depois?',
      example: "I'm driving now. Would you mind sending me the details later?",
      exampleTranslation: 'Estou dirigindo agora. Você se importa de me '
          'mandar os detalhes depois?',
      audioAsset:
          'audio/fase3/licao14/Would_you_mind_sending_me_the_details_later.mp3',
      ipa: '/wʊdʒə ˈmaɪnd ˈsɛndɪŋ mi ðə ˈditeɪlz ˈleɪɾər/',
      phonetic: 'uudja MÁIND SÉN-ding mi tha DÍ-teilz LÊI-rer',
      soundTip: 'Uudja MIND sai sem pausa. No later o t vira um toque rápido, '
          'quase r, e o r final enrola a língua sem raspar.',
    ),
    LessonItem(
      text: 'Do you want me to pick you up?',
      translation: 'Quer que eu te busque?',
      example: 'Your flight lands at nine. Do you want me to pick you up?',
      exampleTranslation: 'Seu voo chega às nove. Quer que eu te busque?',
      audioAsset: 'audio/fase3/licao14/Do_you_want_me_to_pick_you_up.mp3',
      ipa: '/dʒə ˈwɑn mi tə ˈpɪk jə ˈʌp/',
      phonetic: 'dja UÓN mi ta PÍ-kia ÂP',
      soundTip: 'Pick you up vira pi-kia-ÂP, tudo ligado. A força vai em PICK '
          'e UP, e o p final fecha os lábios sem soltar vogal.',
    ),
    LessonItem(
      text: 'Is it okay if I bring a friend?',
      translation: 'Tudo bem se eu levar um amigo?',
      example: 'Thanks for the invite! Is it okay if I bring a friend?',
      exampleTranslation: 'Obrigado pelo convite! Tudo bem se eu levar um '
          'amigo?',
      audioAsset: 'audio/fase3/licao14/Is_it_okay_if_I_bring_a_friend.mp3',
      ipa: '/ɪz ɪt oʊˈkeɪ ɪf aɪ ˈbrɪŋ ə ˈfrɛnd/',
      phonetic: 'i-zi-tou-KÊI if ai BRÍN-ga FRÉND',
      soundTip: 'Bring a se liga, brin-ga, com o ng no fundo da boca. Friend '
          'fecha no d, com a ponta da língua atrás dos dentes, sem i depois.',
    ),
    LessonItem(
      text: 'How does next Tuesday afternoon sound to you?',
      translation: 'Que tal na próxima terça à tarde?',
      example: "I'm out this week. How does next Tuesday afternoon sound to "
          'you?',
      exampleTranslation: 'Estou fora essa semana. Que tal na próxima terça à '
          'tarde?',
      audioAsset: 'audio/fase3/licao14/How_does_next_Tuesday_afternoon_sound_to_you.mp3',
      ipa: '/haʊ dəz nɛks ˈtuzdeɪ ˌæftərˈnun ˈsaʊnd tə ju/',
      phonetic: 'rráu dâz néks TÚZ-dei éf-ter-NÚN SÁUND ta iu',
      soundTip: 'How does sai fraco e rápido. O t de next some antes de '
          'Tuesday, e em afternoon a força vai no fim, NOON, com o u longo.',
    ),
    LessonItem(
      text: "I'd love to, but can we make it Saturday?",
      translation: 'Eu adoraria, mas dá pra ser no sábado?',
      example: "Lunch on Friday? I'd love to, but can we make it Saturday?",
      exampleTranslation: 'Almoço na sexta? Eu adoraria, mas dá pra ser no '
          'sábado?',
      audioAsset:
          "audio/fase3/licao14/I'd_love_to_but_can_we_make_it_Saturday.mp3",
      ipa: '/aɪd ˈlʌv tə bət kən wi ˈmeɪk ɪt ˈsæɾərˌdeɪ/',
      phonetic: 'aid LÂV ta, bât ken ui MÊI-kit SÉ-rer-dei',
      soundTip: 'Make it se gruda, mei-kit. Em Saturday o t vira um toque '
          'rápido, quase r, e a força fica no SA, com a vogal bem aberta.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// ZONA 3 — PUXAR E MANTER CONVERSA
// ---------------------------------------------------------------------------

/// Lição 15 — Perguntar sobre a pessoa: Perguntas de apresentação.
const fase3Licao15 = Lesson(
  id: 'fase3-licao15',
  title: 'Perguntar sobre a pessoa',
  objective: 'Você vai fazer as perguntas básicas para conhecer alguém, sobre '
      'trabalho e origem, sem montar a frase na cabeça.',
  microSkill: 'Perguntas de apresentação',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'What do you do?',
      translation: 'Você trabalha com quê?',
      example: "So, what do you do? I'm an engineer.",
      exampleTranslation: 'E aí, você trabalha com quê? Sou engenheiro.',
      audioAsset: 'audio/fase3/licao15/What_do_you_do.mp3',
      ipa: '/ˌwʌdəjə ˈdu/',
      phonetic: 'uâ-dâ-iâ DU',
      soundTip: 'Fale como uma palavra só: o primeiro do quase some e a força '
          'cai toda no último DO, no fim.',
    ),
    LessonItem(
      text: 'Where do you work?',
      translation: 'Onde você trabalha?',
      example: 'Where do you work? At a bank downtown.',
      exampleTranslation: 'Onde você trabalha? Num banco no centro.',
      audioAsset: 'audio/fase3/licao15/Where_do_you_work.mp3',
      ipa: '/ˈwɛr dəjə ˈwɝk/',
      phonetic: 'UÉR dâ-iâ UÉRK',
      soundTip: 'Força no WHERE e no WORK; o do you passa rápido no meio. No '
          'work, a língua enrola para trás, sem virar uórqui.',
    ),
    LessonItem(
      text: 'Where did you grow up?',
      translation: 'Onde você cresceu?',
      example: 'Where did you grow up? In a small town near Curitiba.',
      exampleTranslation: 'Onde você cresceu? Numa cidade pequena perto de '
          'Curitiba.',
      audioAsset: 'audio/fase3/licao15/Where_did_you_grow_up.mp3',
      ipa: '/ˈwɛr dɪdʒə ɡroʊ ˈʌp/',
      phonetic: 'UÉR di-djâ grôu ÂP',
      soundTip: 'O did you se junta num didja rápido; grow e up se ligam, e a '
          'força fica no UP, fechando os lábios no p.',
    ),
    LessonItem(
      text: 'How long have you lived here?',
      translation: 'Há quanto tempo você mora aqui?',
      example: 'How long have you lived here? About five years.',
      exampleTranslation: 'Há quanto tempo você mora aqui? Uns cinco anos.',
      audioAsset: 'audio/fase3/licao15/How_long_have_you_lived_here.mp3',
      ipa: '/ˈhaʊ ˈlɔŋ əv jə ˈlɪvd ˈhɪr/',
      phonetic: 'RRÁU LÓN âv-iâ LÍVD RRÍR',
      soundTip: 'O have you vira um âv-iâ curto, sem força; o lived fecha num '
          'd leve colado, sem livedi, e o h do here é só um sopro, sem raspar '
          'a garganta.',
    ),
    LessonItem(
      text: 'What brings you here?',
      translation: 'O que te traz aqui?',
      example: "What brings you here? I'm here for a conference.",
      exampleTranslation: 'O que te traz aqui? Vim para uma conferência.',
      audioAsset: 'audio/fase3/licao15/What_brings_you_here.mp3',
      ipa: '/wʌt ˈbrɪŋz jə ˈhɪr/',
      phonetic: 'uât BRÍNZ iâ RRÍR',
      soundTip: 'O brings termina em zumbido, com o fundo da língua no céu da '
          'boca antes do z; o you fica fraco e cola no here.',
    ),
  ],
);

/// Lição 16 — Fim de semana e rotina: Perguntas sobre rotina.
const fase3Licao16 = Lesson(
  id: 'fase3-licao16',
  title: 'Fim de semana e rotina',
  objective: 'Você vai puxar assunto sobre o fim de semana e o dia a dia da '
      'pessoa com perguntas prontas e curtas.',
  microSkill: 'Perguntas sobre rotina',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'How was your weekend?',
      translation: 'Como foi seu fim de semana?',
      example: 'Hey, how was your weekend? Pretty quiet.',
      exampleTranslation: 'E aí, como foi seu fim de semana? Bem tranquilo.',
      audioAsset: 'audio/fase3/licao16/How_was_your_weekend.mp3',
      ipa: '/ˈhaʊ wəz jər ˈwikɛnd/',
      phonetic: 'RRÁU uâz iâr UÍK-end',
      soundTip: 'Was e your saem curtos e fracos; a força cai no WEEK, com i '
          'longo, e o end fecha no d, sem vogal depois.',
    ),
    LessonItem(
      text: 'Did you do anything fun?',
      translation: 'Fez alguma coisa legal?',
      example: 'Did you do anything fun on Saturday?',
      exampleTranslation: 'Você fez alguma coisa legal no sábado?',
      audioAsset: 'audio/fase3/licao16/Did_you_do_anything_fun.mp3',
      ipa: '/dɪdʒə ˈdu ˈɛniθɪŋ ˈfʌn/',
      phonetic: 'di-djâ DU É-ni-thing FÂN',
      soundTip: 'Did you vira um didja rápido; no anything a ponta da língua '
          'passa entre os dentes, sem fing nem ting.',
    ),
    LessonItem(
      text: 'What are you up to?',
      translation: 'O que você anda fazendo?',
      example: 'Long time no see! What are you up to these days?',
      exampleTranslation: 'Quanto tempo! O que você anda fazendo esses dias?',
      audioAsset: 'audio/fase3/licao16/What_are_you_up_to.mp3',
      ipa: '/ˈwʌɾər jə ˈʌp tu/',
      phonetic: 'UÂ-dâr iâ ÂP tu',
      soundTip: 'O t de what vira um toque leve, quase um d, e cola no are; a '
          'força fica no UP, e o to sai curto no fim.',
    ),
    LessonItem(
      text: "How's your week going?",
      translation: 'Como está indo a sua semana?',
      example: "How's your week going? Busy, but good.",
      exampleTranslation: 'Como está indo a sua semana? Corrida, mas boa.',
      audioAsset: "audio/fase3/licao16/How's_your_week_going.mp3",
      ipa: '/ˈhaʊz jər ˈwik ˈɡoʊɪŋ/',
      phonetic: 'RRÁUZ iâr UÍK GÔU-ing',
      soundTip: "O how's termina em zumbido e cola no your, que fica fraco; o "
          'going termina no fundo da língua, sem goin nem gôuingui.',
    ),
    LessonItem(
      text: 'What do you do for fun?',
      translation: 'O que você faz para se divertir?',
      example: 'What do you do for fun? I play soccer on Sundays.',
      exampleTranslation: 'O que você faz para se divertir? Jogo futebol aos '
          'domingos.',
      audioAsset: 'audio/fase3/licao16/What_do_you_do_for_fun.mp3',
      ipa: '/ˌwʌdəjə ˈdu fər ˈfʌn/',
      phonetic: 'uâ-dâ-iâ DU fâr FÂN',
      soundTip: 'O primeiro do some no meio, o for vira um fâr curto; a força '
          'fica no DU e no FUN, e o fun termina com a língua no céu da boca.',
    ),
  ],
);

/// Lição 17 — Devolver a pergunta e concordar: Devolver e concordar.
const fase3Licao17 = Lesson(
  id: 'fase3-licao17',
  title: 'Devolver a pergunta e concordar',
  objective: 'Você vai devolver a pergunta e concordar com o outro em poucas '
      'palavras, mantendo a conversa andando.',
  microSkill: 'Devolver e concordar',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'What about you?',
      translation: 'E você?',
      example: "I'm from Recife. What about you?",
      exampleTranslation: 'Eu sou do Recife. E você?',
      audioAsset: 'audio/fase3/licao17/What_about_you.mp3',
      ipa: '/ˌwʌɾəˌbaʊt ˈju/',
      phonetic: 'uâ-dâ-báut IÚ',
      soundTip: 'What e about se ligam num toque leve de d; o about perde a '
          'força e a voz sobe no YOU, que é onde está a pergunta.',
    ),
    LessonItem(
      text: 'Me too.',
      translation: 'Eu também.',
      example: 'I love this place. Me too.',
      exampleTranslation: 'Eu adoro este lugar. Eu também.',
      audioAsset: 'audio/fase3/licao17/Me_too.mp3',
      ipa: '/ˈmi ˈtu/',
      phonetic: 'mi TÚ',
      soundTip: 'O too sai com ar no t e lábios arredondados, sem virar tchu; '
          'a força fica nele e a voz desce no fim.',
    ),
    LessonItem(
      text: 'Me neither.',
      translation: 'Eu também não.',
      example: "I don't like the cold. Me neither.",
      exampleTranslation: 'Eu não gosto do frio. Eu também não.',
      audioAsset: 'audio/fase3/licao17/Me_neither.mp3',
      ipa: '/ˈmi ˈniðər/',
      phonetic: 'mi NÍ-thâr',
      soundTip: 'Força no NEI, com i longo; no meio, a ponta da língua vibra '
          'entre os dentes, sem nider nem nizer.',
    ),
    LessonItem(
      text: 'Same here.',
      translation: 'Comigo também.',
      example: "I'm so tired today. Same here.",
      exampleTranslation: 'Estou muito cansado hoje. Comigo também.',
      audioAsset: 'audio/fase3/licao17/Same_here.mp3',
      ipa: '/ˈseɪm ˈhɪr/',
      phonetic: 'sêim RRÍR',
      soundTip: 'Feche os lábios no m do same e já solte o ar do here; o here '
          'sai com sopro, não com R de garganta.',
    ),
    LessonItem(
      text: 'That makes sense.',
      translation: 'Faz sentido.',
      example: 'We start earlier on Fridays. Oh, that makes sense.',
      exampleTranslation: 'A gente começa mais cedo às sextas. Ah, faz '
          'sentido.',
      audioAsset: 'audio/fase3/licao17/That_makes_sense.mp3',
      ipa: '/ˈðæt meɪks ˈsɛns/',
      phonetic: 'thét mêiks SÉNS',
      soundTip: 'Língua entre os dentes no that, sem dét; o t dele quase some '
          'antes do makes, e a força cai no SENSE, que termina em s, sem '
          'vogal.',
    ),
  ],
);

/// Lição 18 — Ganhar tempo para pensar: Preencher a pausa.
const fase3Licao18 = Lesson(
  id: 'fase3-licao18',
  title: 'Ganhar tempo para pensar',
  objective: 'Você vai usar frases curtas para ganhar alguns segundos '
      'enquanto pensa, em vez de travar em silêncio.',
  microSkill: 'Preencher a pausa',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Let me think.',
      translation: 'Deixa eu pensar.',
      example: 'Which one is better? Hmm, let me think.',
      exampleTranslation: 'Qual é melhor? Hum, deixa eu pensar.',
      audioAsset: 'audio/fase3/licao18/Let_me_think.mp3',
      ipa: '/ˈlɛmi ˈθɪŋk/',
      phonetic: 'lé-mi THÍNK',
      soundTip: 'Let me vira um lémi só, sem o t; no think, a ponta da língua '
          'fica entre os dentes, sem tink nem fink.',
    ),
    LessonItem(
      text: 'Good question.',
      translation: 'Boa pergunta.',
      example: 'Why did you choose this job? Good question.',
      exampleTranslation: 'Por que você escolheu esse trabalho? Boa pergunta.',
      audioAsset: 'audio/fase3/licao18/Good_question.mp3',
      ipa: '/ˈɡʊd ˈkwɛstʃən/',
      phonetic: 'gud KUÉS-tchân',
      soundTip: 'A força cai no QUES; o fim vira um tchân curto e fraco. O '
          'good fecha no d e encosta no question, sem gudi.',
    ),
    LessonItem(
      text: 'Hold on a second.',
      translation: 'Espera um segundo.',
      example: "Hold on a second, I'm checking my calendar.",
      exampleTranslation: 'Espera um segundo, estou olhando minha agenda.',
      audioAsset: 'audio/fase3/licao18/Hold_on_a_second.mp3',
      ipa: '/ˈhoʊld ˈɔn ə ˈsɛkənd/',
      phonetic: 'RRÔUL-dó-nâ SÉ-kând',
      soundTip: 'Tudo ligado: o d do hold puxa o on, e o on cola no a, '
          'virando dónâ. A força cai no SEC, e o second fecha no d.',
    ),
    LessonItem(
      text: 'How can I put it?',
      translation: 'Como posso dizer?',
      example: "It's not bad, it's just... how can I put it? Different.",
      exampleTranslation: 'Não é ruim, é só... como posso dizer? Diferente.',
      audioAsset: 'audio/fase3/licao18/How_can_I_put_it.mp3',
      ipa: '/ˈhaʊ kən aɪ ˈpʊt ɪt/',
      phonetic: 'RRÁU kâ-nai PÚ-dit',
      soundTip: 'O can fica fraco e cola no I, virando kânai; o put e o it se '
          'ligam num toque leve de d, com a força no PUT.',
    ),
    LessonItem(
      text: "It's hard to say.",
      translation: 'É difícil dizer.',
      example: "Will the project be late? It's hard to say.",
      exampleTranslation: 'O projeto vai atrasar? É difícil dizer.',
      audioAsset: "audio/fase3/licao18/It's_hard_to_say.mp3",
      ipa: '/ɪts ˈhɑrd tə ˈseɪ/',
      phonetic: 'its RRÁRD tâ SÊI',
      soundTip: 'O hard começa com sopro e termina com a língua enrolada '
          'antes do d; o to vira um tâ curto e a força fecha no SAY.',
    ),
  ],
);

/// Lição 19 — Encerrar a conversa com educação: Despedidas educadas.
const fase3Licao19 = Lesson(
  id: 'fase3-licao19',
  title: 'Encerrar a conversa com educação',
  objective: 'Você vai encerrar uma conversa de forma educada e natural, sem '
      'sair de repente.',
  microSkill: 'Despedidas educadas',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'I should get going.',
      translation: 'Preciso ir andando.',
      example: "Wow, it's late. I should get going.",
      exampleTranslation: 'Nossa, está tarde. Preciso ir andando.',
      audioAsset: 'audio/fase3/licao19/I_should_get_going.mp3',
      ipa: '/aɪ ʃəd ˈɡɛt ˈɡoʊɪŋ/',
      phonetic: 'ai shud GUÉT GÔU-ing',
      soundTip: 'O should fica fraco e o l não aparece; o t de get quase '
          'some, preso antes do going, e o going termina no fundo da língua.',
    ),
    LessonItem(
      text: 'Talk to you later.',
      translation: 'Falo com você depois.',
      example: 'I have to run. Talk to you later!',
      exampleTranslation: 'Tenho que correr. Falo com você depois!',
      audioAsset: 'audio/fase3/licao19/Talk_to_you_later.mp3',
      ipa: '/ˈtɔk tə jə ˈleɪɾər/',
      phonetic: 'TÓK tâ-iâ LÊI-dâr',
      soundTip: 'O l de talk não se fala; to you vira um tâ-iâ rápido, e o t '
          'de later vira um toque leve, quase um d.',
    ),
    LessonItem(
      text: 'It was nice talking to you.',
      translation: 'Foi bom conversar com você.',
      example: 'It was nice talking to you. See you next week!',
      exampleTranslation: 'Foi bom conversar com você. Até semana que vem!',
      audioAsset: 'audio/fase3/licao19/It_was_nice_talking_to_you.mp3',
      ipa: '/ɪt wəz ˈnaɪs ˈtɔkɪŋ tə jə/',
      phonetic: 'it uâz NÁIS TÓ-king tâ-iâ',
      soundTip: 'It was passa rápido e fraco; a força fica no NICE e no TALK, '
          'e o talking termina no fundo da língua, sem vogal depois.',
    ),
    LessonItem(
      text: "Let's keep in touch.",
      translation: 'Vamos manter contato.',
      example: "Here's my number. Let's keep in touch.",
      exampleTranslation: 'Aqui está meu número. Vamos manter contato.',
      audioAsset: "audio/fase3/licao19/Let's_keep_in_touch.mp3",
      ipa: '/ˈlɛts ˈkip ɪn ˈtʌtʃ/',
      phonetic: 'léts KÍ-pin TÂTCH',
      soundTip: 'O p do keep puxa o in, virando kípin; a força fecha no '
          'TOUCH, que termina num tch seco, sem tchi.',
    ),
    LessonItem(
      text: 'Have a good one.',
      translation: 'Tenha um bom dia.',
      example: 'Thanks for your help. Have a good one!',
      exampleTranslation: 'Obrigado pela ajuda. Tenha um bom dia!',
      audioAsset: 'audio/fase3/licao19/Have_a_good_one.mp3',
      ipa: '/ˈhæv ə ˈɡʊd wʌn/',
      phonetic: 'RRÉ-vâ GÚD uân',
      soundTip: 'Have e a se ligam num révâ só, com sopro no começo; a força '
          'cai no GOOD, e o one sai curto, sem virar uóni.',
    ),
  ],
);

/// Lição 20 (revisão) — Revisão: puxar e manter conversa: Revisão da zona.
const fase3Licao20 = Lesson(
  id: 'fase3-licao20',
  title: 'Revisão: puxar e manter conversa',
  objective: 'Você vai revisar uma frase de cada lição da zona, agora em '
      'situações novas, para ver o que já sai no automático.',
  microSkill: 'Revisão da zona',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'What do you do?',
      translation: 'Você trabalha com quê?',
      example: 'Nice to meet you. What do you do?',
      exampleTranslation: 'Prazer em te conhecer. Você trabalha com quê?',
      audioAsset: 'audio/fase3/licao15/What_do_you_do.mp3',
      ipa: '/ˌwʌdəjə ˈdu/',
      phonetic: 'uâ-dâ-iâ DU',
      soundTip: 'Fale como uma palavra só: o primeiro do quase some e a força '
          'cai toda no último DO, no fim.',
    ),
    LessonItem(
      text: 'How was your weekend?',
      translation: 'Como foi seu fim de semana?',
      example: 'Good morning! How was your weekend?',
      exampleTranslation: 'Bom dia! Como foi seu fim de semana?',
      audioAsset: 'audio/fase3/licao16/How_was_your_weekend.mp3',
      ipa: '/ˈhaʊ wəz jər ˈwikɛnd/',
      phonetic: 'RRÁU uâz iâr UÍK-end',
      soundTip: 'Was e your saem curtos e fracos; a força cai no WEEK, com i '
          'longo, e o end fecha no d, sem vogal depois.',
    ),
    LessonItem(
      text: 'What about you?',
      translation: 'E você?',
      example: "I'm doing great. What about you?",
      exampleTranslation: 'Estou ótimo. E você?',
      audioAsset: 'audio/fase3/licao17/What_about_you.mp3',
      ipa: '/ˌwʌɾəˌbaʊt ˈju/',
      phonetic: 'uâ-dâ-báut IÚ',
      soundTip: 'What e about se ligam num toque leve de d; o about perde a '
          'força e a voz sobe no YOU, que é onde está a pergunta.',
    ),
    LessonItem(
      text: 'Let me think.',
      translation: 'Deixa eu pensar.',
      example: "What's my favorite movie? Let me think.",
      exampleTranslation: 'Qual é meu filme favorito? Deixa eu pensar.',
      audioAsset: 'audio/fase3/licao18/Let_me_think.mp3',
      ipa: '/ˈlɛmi ˈθɪŋk/',
      phonetic: 'lé-mi THÍNK',
      soundTip: 'Let me vira um lémi só, sem o t; no think, a ponta da língua '
          'fica entre os dentes, sem tink nem fink.',
    ),
    LessonItem(
      text: 'I should get going.',
      translation: 'Preciso ir andando.',
      example: 'My bus is coming. I should get going.',
      exampleTranslation: 'Meu ônibus está chegando. Preciso ir andando.',
      audioAsset: 'audio/fase3/licao19/I_should_get_going.mp3',
      ipa: '/aɪ ʃəd ˈɡɛt ˈɡoʊɪŋ/',
      phonetic: 'ai shud GUÉT GÔU-ing',
      soundTip: 'O should fica fraco e o l não aparece; o t de get quase '
          'some, preso antes do going, e o going termina no fundo da língua.',
    ),
  ],
);

/// Lição 21 — BÔNUS — Bônus: perguntas de acompanhamento: Perguntas de acompanhamento.
const fase3Licao21 = Lesson(
  id: 'fase3-licao21',
  title: 'Bônus: perguntas de acompanhamento',
  objective: 'Você vai fazer perguntas mais longas que mostram interesse e '
      'fazem a outra pessoa continuar falando.',
  microSkill: 'Perguntas de acompanhamento',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: 'How did you get into that?',
      translation: 'Como você começou com isso?',
      example: 'You teach yoga? How did you get into that?',
      exampleTranslation: 'Você dá aula de ioga? Como você começou com isso?',
      audioAsset: 'audio/fase3/licao21/How_did_you_get_into_that.mp3',
      ipa: '/ˈhaʊ dɪdʒə ˈɡɛɾ ˌɪntə ˈðæt/',
      phonetic: 'RRÁU di-djâ GUÉ-din-tâ THÉT',
      soundTip: 'Did you vira didja; o t de get vira um toque leve e cola no '
          'into. A força fecha no THAT, com a língua entre os dentes.',
    ),
    LessonItem(
      text: 'What do you like most about it?',
      translation: 'Do que você mais gosta nisso?',
      example: 'You moved to Lisbon? What do you like most about it?',
      exampleTranslation: 'Você se mudou para Lisboa? Do que você mais gosta '
          'lá?',
      audioAsset: 'audio/fase3/licao21/What_do_you_like_most_about_it.mp3',
      ipa: '/ˌwʌdəjə ˈlaɪk ˈmoʊst əˈbaʊɾ ɪt/',
      phonetic: 'uâ-dâ-iâ LÁIK MÔUST â-BÁU-dit',
      soundTip: 'O começo passa rápido; força no LIKE e no MOST. O t de most '
          'quase some, e about e it se ligam num toque leve de d.',
    ),
    LessonItem(
      text: 'How long have you been doing that?',
      translation: 'Há quanto tempo você faz isso?',
      example: 'You run every morning? How long have you been doing that?',
      exampleTranslation: 'Você corre toda manhã? Há quanto tempo você faz '
          'isso?',
      audioAsset: 'audio/fase3/licao21/How_long_have_you_been_doing_that.mp3',
      ipa: '/ˈhaʊ ˈlɔŋ əv jə bɪn ˈduɪŋ ˈðæt/',
      phonetic: 'RRÁU LÓN âv-iâ bin DÚ-ing THÉT',
      soundTip: 'Have you been passa rápido e fraco, quase âv-iâ-bin; a força '
          'volta no DOING e no THAT, com a língua entre os dentes.',
    ),
    LessonItem(
      text: 'What was the best part of the trip?',
      translation: 'Qual foi a melhor parte da viagem?',
      example: 'You went to Chile? What was the best part of the trip?',
      exampleTranslation: 'Você foi para o Chile? Qual foi a melhor parte da '
          'viagem?',
      audioAsset: 'audio/fase3/licao21/What_was_the_best_part_of_the_trip.mp3',
      ipa: '/wʌt wəz ðə ˈbɛst ˈpɑrt əv ðə ˈtrɪp/',
      phonetic: 'uât uâz thâ BÉST PÁR-dâv thâ TRÍP',
      soundTip: 'O t de best some antes do part; part e of se ligam num '
          'párdâv. Os the ficam fracos, com a língua entre os dentes.',
    ),
    LessonItem(
      text: 'Oh really? What happened next?',
      translation: 'Sério? E o que aconteceu depois?',
      example: 'And then the power went out. Oh really? What happened next?',
      exampleTranslation: 'E aí faltou luz. Sério? E o que aconteceu depois?',
      audioAsset: 'audio/fase3/licao21/Oh_really_What_happened_next.mp3',
      ipa: '/oʊ ˈrɪli | ˈwʌt ˈhæpənd ˈnɛkst/',
      phonetic: 'ôu RÍ-li? uât RRÉ-pând NÉKST',
      soundTip: 'No really, a voz sobe, mostrando surpresa. O happened fecha '
          'no d sem pênedi, e o next termina num t seco.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// ZONA 4 — A FALA LIGADA
// ---------------------------------------------------------------------------

/// Lição 22 — Vou, quero, tenho que: going/want/have to reduzidos.
const fase3Licao22 = Lesson(
  id: 'fase3-licao22',
  title: 'Vou, quero, tenho que',
  objective: 'Você vai falar vou, quero e tenho que do jeito que soam na '
      'conversa de verdade, encolhidos e colados no verbo.',
  microSkill: 'going/want/have to reduzidos',
  approvalThreshold: 75,
  minProsody: 70,
  items: [
    LessonItem(
      text: "I'm going to call you later.",
      translation: 'Vou te ligar mais tarde.',
      example: "I'm in a meeting now. I'm going to call you later.",
      exampleTranslation: 'Tô numa reunião agora. Te ligo mais tarde.',
      audioAsset: "audio/fase3/licao22/I'm_going_to_call_you_later.mp3",
      ipa: '/aɪm ˈɡʌnə ˈkɔl jə ˈleɪɾɚ/',
      phonetic: 'aim GÂ-nâ KÓL iâ LÊI-râr',
      soundTip: 'O going to encolhe num GÂ-nâ rápido, sem tu. A força vai em '
          'CALL e LA; no later, o t do meio vira um r leve, como em caro.',
    ),
    LessonItem(
      text: 'I want to go home.',
      translation: 'Quero ir pra casa.',
      example: "It's late and I'm tired. I want to go home.",
      exampleTranslation: 'Tá tarde e eu tô cansado. Quero ir pra casa.',
      audioAsset: 'audio/fase3/licao22/I_want_to_go_home.mp3',
      ipa: '/aɪ ˈwɑnə ɡoʊ ˈhoʊm/',
      phonetic: 'ai UÁ-nâ gôu RRÔUM',
      soundTip: 'O want to vira um UÁ-nâ só: o t some e o to vira um â curto. '
          'Força em WAN e HOME, e feche os lábios no m no final.',
    ),
    LessonItem(
      text: 'I have to work tomorrow.',
      translation: 'Tenho que trabalhar amanhã.',
      example: "I can't stay out late. I have to work tomorrow.",
      exampleTranslation: 'Não posso ficar até tarde. Tenho que trabalhar '
          'amanhã.',
      audioAsset: 'audio/fase3/licao22/I_have_to_work_tomorrow.mp3',
      ipa: '/aɪ ˈhæftə ˈwɝk təˈmɑroʊ/',
      phonetic: 'ai RRÉF-tâ UÉRK tâ-MÁ-rôu',
      soundTip: 'Aqui o have to soa RRÉF-tâ, com f e não v. Sopre o h como um '
          'ar leve, sem rr de garganta forte. Força em HAVE, WORK e MA.',
    ),
    LessonItem(
      text: 'Do you want to come?',
      translation: 'Quer vir?',
      example: "We're going out for pizza. Do you want to come?",
      exampleTranslation: 'A gente vai sair pra comer pizza. Quer vir?',
      audioAsset: 'audio/fase3/licao22/Do_you_want_to_come.mp3',
      ipa: '/də jə ˈwɑnə ˈkʌm/',
      phonetic: 'dâ-iâ UÁ-nâ KÂM',
      soundTip: 'Do you passa voando num dâ-iâ, want to vira UÁ-nâ. Só WAN e '
          'COME levam força; feche a boca no m do come, sem vogal depois.',
    ),
    LessonItem(
      text: "We're going to be late.",
      translation: 'A gente vai se atrasar.',
      example: "Hurry up, we're going to be late for the movie.",
      exampleTranslation: 'Anda logo, a gente vai se atrasar pro filme.',
      audioAsset: "audio/fase3/licao22/We're_going_to_be_late.mp3",
      ipa: '/wɪr ˈɡʌnə bi ˈleɪt/',
      phonetic: 'uír GÂ-nâ bi LÊIT',
      soundTip: "We're sai curtinho, quase um uír. O going to vira GÂ-nâ e a "
          'força final cai em LATE, fechado no t, sem soltar vogal depois.',
    ),
  ],
);

/// Lição 23 — Perguntas que se fundem: Do you / Did you fundidos.
const fase3Licao23 = Lesson(
  id: 'fase3-licao23',
  title: 'Perguntas que se fundem',
  objective: 'Você vai juntar o começo das perguntas mais comuns num bloco '
      'só, rápido e baixo, deixando a força no verbo que importa.',
  microSkill: 'Do you / Did you fundidos',
  approvalThreshold: 75,
  minProsody: 70,
  items: [
    LessonItem(
      text: 'What do you think?',
      translation: 'O que você acha?',
      example: 'I like the blue one. What do you think?',
      exampleTranslation: 'Eu gosto da azul. O que você acha?',
      audioAsset: 'audio/fase3/licao23/What_do_you_think.mp3',
      ipa: '/ˌwʌɾəjə ˈθɪŋk/',
      phonetic: 'uâ-râ-iâ THÍNK',
      soundTip: 'What do you sai como uma palavra só, uâ-râ-iâ, com o t e o d '
          'virando um r leve. Toda a força fica em THINK, língua entre os '
          'dentes.',
    ),
    LessonItem(
      text: 'Did you get my message?',
      translation: 'Recebeu minha mensagem?',
      example: 'Did you get my message about the meeting?',
      exampleTranslation: 'Recebeu minha mensagem sobre a reunião?',
      audioAsset: 'audio/fase3/licao23/Did_you_get_my_message.mp3',
      ipa: '/ˈdɪdʒə ˈɡɛt maɪ ˈmɛsɪdʒ/',
      phonetic: 'DÍ-djâ GUÉT mai MÉ-sidj',
      soundTip: 'Did you funde num DÍ-djâ, o d encontra o y e vira dj. Força '
          'em DID, GET e ME; o get fecha no t sem vogal, colado no my.',
    ),
    LessonItem(
      text: 'Do you need anything?',
      translation: 'Precisa de alguma coisa?',
      example: "I'm going to the store. Do you need anything?",
      exampleTranslation: 'Vou no mercado. Precisa de alguma coisa?',
      audioAsset: 'audio/fase3/licao23/Do_you_need_anything.mp3',
      ipa: '/djə ˈnid ˈɛniˌθɪŋ/',
      phonetic: 'djâ NÍ-dé-ni-thing',
      soundTip: 'Do you encolhe num djâ bem curto. O d do need gruda no '
          'anything, como se fosse uma palavra só. Força em NEED e no E de '
          'anything.',
    ),
    LessonItem(
      text: 'What did you say?',
      translation: 'O que você disse?',
      example: "Sorry, it's loud in here. What did you say?",
      exampleTranslation: 'Desculpa, tá barulhento aqui. O que você disse?',
      audioAsset: 'audio/fase3/licao23/What_did_you_say.mp3',
      ipa: '/ˌwʌɾɪdʒə ˈseɪ/',
      phonetic: 'uâ-ri-djâ SÊI',
      soundTip: 'As três primeiras palavras viram uâ-ri-djâ, rápido e baixo: '
          'o t vira um r leve e did you vira djâ. A força toda cai em SAY.',
    ),
    LessonItem(
      text: 'Did you have lunch?',
      translation: 'Você já almoçou?',
      example: "Did you have lunch? I'm going to the cafeteria.",
      exampleTranslation: 'Você já almoçou? Tô indo pro refeitório.',
      audioAsset: 'audio/fase3/licao23/Did_you_have_lunch.mp3',
      ipa: '/dɪdʒə ˈhæv ˈlʌntʃ/',
      phonetic: 'di-djâ RRÉV LÂNTCH',
      soundTip: 'Did you funde num DÍ-djâ. Força em HAVE e LUNCH, e o lunch '
          'termina em tch, sem vogal depois.',
    ),
  ],
);

/// Lição 24 — A consoante que gruda na vogal: Ligação consoante e vogal.
const fase3Licao24 = Lesson(
  id: 'fase3-licao24',
  title: 'A consoante que gruda na vogal',
  objective: 'Você vai emendar a consoante do fim de uma palavra na vogal da '
      'seguinte, sem pausa e sem vogal extra no meio.',
  microSkill: 'Ligação consoante e vogal',
  approvalThreshold: 75,
  minProsody: 70,
  items: [
    LessonItem(
      text: 'Turn it off.',
      translation: 'Desliga isso.',
      example: 'The TV is too loud. Can you turn it off?',
      exampleTranslation: 'A TV tá alta demais. Pode desligar?',
      audioAsset: 'audio/fase3/licao24/Turn_it_off.mp3',
      ipa: '/ˌtɝnɪˈɾɔf/',
      phonetic: 'târ-ni-RÓF',
      soundTip: 'Cole as três palavras: o n do turn gruda no it e o t do it '
          'vira um r leve antes do off. Soa târ-ni-RÓF, com a força no OFF.',
    ),
    LessonItem(
      text: 'Pick it up.',
      translation: 'Pega isso.',
      example: 'You dropped your pen. Pick it up.',
      exampleTranslation: 'Você derrubou sua caneta. Pega ela.',
      audioAsset: 'audio/fase3/licao24/Pick_it_up.mp3',
      ipa: '/ˌpɪkɪˈɾʌp/',
      phonetic: 'pi-ki-RÂP',
      soundTip: 'O k do pick passa direto pro it e o t vira um r leve antes '
          'do up: pi-ki-RÂP. Força no UP, fechado no p, sem soltar vogal.',
    ),
    LessonItem(
      text: 'Come on in.',
      translation: 'Pode entrar.',
      example: 'Hi, the door is open. Come on in.',
      exampleTranslation: 'Oi, a porta tá aberta. Pode entrar.',
      audioAsset: 'audio/fase3/licao24/Come_on_in.mp3',
      ipa: '/ˌkʌmɑˈnɪn/',
      phonetic: 'kâ-mâ-NÍN',
      soundTip: 'O m do come vai pro on e o n do on vai pro in: kâ-mâ-NÍN, '
          'sem pausa. A força fica no IN, com a língua tocando atrás dos '
          'dentes.',
    ),
    LessonItem(
      text: 'Check it out.',
      translation: 'Dá uma olhada.',
      example: "There's a new coffee place downtown. Check it out.",
      exampleTranslation: 'Abriu um café novo no centro. Dá uma olhada.',
      audioAsset: 'audio/fase3/licao24/Check_it_out.mp3',
      ipa: '/ˌtʃɛkɪˈɾaʊt/',
      phonetic: 'tché-ki-RÁUT',
      soundTip: 'O k do check passa pro it e o t do it vira um r leve antes '
          'do out. Força no OUT e feche no t sem soltar vogal no final.',
    ),
    LessonItem(
      text: 'Fill it out.',
      translation: 'Preencha.',
      example: "Here's the form. Just fill it out and sign it.",
      exampleTranslation: 'Aqui está o formulário. É só preencher e assinar.',
      audioAsset: 'audio/fase3/licao24/Fill_it_out.mp3',
      ipa: '/ˌfɪlɪˈɾaʊt/',
      phonetic: 'fi-li-RÁUT',
      soundTip: 'O L do fill passa direto pro it e o t do it vira um r leve '
          'antes do out: fi-li-RÁUT. Força no OUT, fechado no t.',
    ),
  ],
);

/// Lição 25 — Palavras que encolhem: Of e and reduzidos.
const fase3Licao25 = Lesson(
  id: 'fase3-licao25',
  title: 'Palavras que encolhem',
  objective: 'Você vai encolher as palavrinhas de ligação até quase sumirem e '
      'deixar a força nas palavras que dão o sentido.',
  microSkill: 'Of e and reduzidos',
  approvalThreshold: 75,
  minProsody: 70,
  items: [
    LessonItem(
      text: "I'm kind of tired.",
      translation: 'Tô meio cansado.',
      example: "I'm kind of tired, I'm going to bed early.",
      exampleTranslation: 'Tô meio cansado, vou dormir cedo.',
      audioAsset: "audio/fase3/licao25/I'm_kind_of_tired.mp3",
      ipa: '/aɪm ˈkaɪndə ˈtaɪɚd/',
      phonetic: 'aim KÁIN-dâ TÁI-ârd',
      soundTip: 'O kind of vira KÁIN-dâ: o of perde o f e encolhe num â '
          'colado no kind. Força em KIND e TI, e o tired fecha no d.',
    ),
    LessonItem(
      text: "That's a lot of work.",
      translation: 'É muito trabalho.',
      example: "Five reports in one day? That's a lot of work.",
      exampleTranslation: 'Cinco relatórios num dia? É muito trabalho.',
      audioAsset: "audio/fase3/licao25/That's_a_lot_of_work.mp3",
      ipa: '/ðæts ə ˈlɑɾə ˈwɝk/',
      phonetic: 'théts â LÁ-râ UÉRK',
      soundTip: 'A lot of vira â LÁ-râ: o t vira um r leve e o of encolhe num '
          "â. Força em LOT e WORK; ponta da língua entre os dentes no that's.",
    ),
    LessonItem(
      text: 'Can I get a cup of tea?',
      translation: 'Pode me ver um chá?',
      example: 'Can I get a cup of tea with milk, please?',
      exampleTranslation: 'Pode me ver um chá com leite, por favor?',
      audioAsset: 'audio/fase3/licao25/Can_I_get_a_cup_of_tea.mp3',
      ipa: '/kən aɪ ˈɡɛɾə ˈkʌpə ˈti/',
      phonetic: 'kâ-nai GUÉ-râ KÂ-pâ TÍ',
      soundTip: 'Tudo liga: can I vira kâ-nai, get a vira GUÉ-râ e cup of '
          'vira KÂ-pâ, sem o f. Força em GET, CUP e TEA.',
    ),
    LessonItem(
      text: 'Salt and pepper, please.',
      translation: 'Sal e pimenta, por favor.',
      example: 'Could you pass the salt and pepper, please?',
      exampleTranslation: 'Você pode me passar o sal e a pimenta, por favor?',
      audioAsset: 'audio/fase3/licao25/Salt_and_pepper_please.mp3',
      ipa: '/ˈsɔlt n ˈpɛpɚ ˈpliz/',
      phonetic: 'SÓLT-n PÉ-pâr PLÍZ',
      soundTip: 'O and encolhe até sobrar só o n, colado no salt. Força em '
          'SALT, PE e PLEASE; mantenha o l do salt com a língua no céu da '
          'boca.',
    ),
    LessonItem(
      text: "I'm out of time.",
      translation: 'Tô sem tempo.',
      example: "Sorry, I'm out of time. Let's talk tomorrow.",
      exampleTranslation: 'Desculpa, tô sem tempo. Vamos falar amanhã.',
      audioAsset: "audio/fase3/licao25/I'm_out_of_time.mp3",
      ipa: '/aɪm ˈaʊɾə ˈtaɪm/',
      phonetic: 'ai-MÁU-râ TÁIM',
      soundTip: "O m do I'm gruda no out, e out of vira MÁU-râ: o t vira um r "
          'leve e o of encolhe num â. Força em OUT e TIME.',
    ),
  ],
);

/// Lição 26 — A força na frase pronta: Força só no conteúdo.
const fase3Licao26 = Lesson(
  id: 'fase3-licao26',
  title: 'A força na frase pronta',
  objective: 'Você vai dizer frases prontas do dia a dia batendo forte só nas '
      'palavras de sentido e passando rápido pelas pequenas.',
  microSkill: 'Força só no conteúdo',
  approvalThreshold: 75,
  minProsody: 70,
  items: [
    LessonItem(
      text: 'Nice to meet you.',
      translation: 'Prazer em te conhecer.',
      example: "Hi, I'm Ana. Nice to meet you.",
      exampleTranslation: 'Oi, eu sou a Ana. Prazer.',
      audioAsset: 'audio/fase3/licao26/Nice_to_meet_you.mp3',
      ipa: '/ˈnaɪs tə ˈmit ju/',
      phonetic: 'NÁIS tâ MÍT-iu',
      soundTip: 'Força em NICE e MEET; o to vira um tâ de passagem e o you '
          'sai baixinho, colado no meet. Nada de dar a mesma força às quatro.',
    ),
    LessonItem(
      text: 'Thanks for coming.',
      translation: 'Obrigado por ter vindo.',
      example: 'Thanks for coming, it was great to see you.',
      exampleTranslation: 'Obrigado por ter vindo, foi ótimo te ver.',
      audioAsset: 'audio/fase3/licao26/Thanks_for_coming.mp3',
      ipa: '/ˈθæŋks fɚ ˈkʌmɪŋ/',
      phonetic: 'THÉNKS fâr KÂ-ming',
      soundTip: 'Força em THANKS e CO; o for encolhe num fâr rápido no meio. '
          'Termine o coming no ng, com o fundo da língua, sem soltar um gui.',
    ),
    LessonItem(
      text: 'Have a good weekend.',
      translation: 'Bom fim de semana.',
      example: 'See you on Monday. Have a good weekend.',
      exampleTranslation: 'Até segunda. Bom fim de semana.',
      audioAsset: 'audio/fase3/licao26/Have_a_good_weekend.mp3',
      ipa: '/ˈhævə ˌɡʊd ˈwikɛnd/',
      phonetic: 'RRÉ-vâ gud UÍK-end',
      soundTip: 'Have a vira RRÉ-vâ, ligado. A maior força cai em WEEK; o '
          'good passa curto e fecha no d, colado no weekend, sem gudi.',
    ),
    LessonItem(
      text: 'Let me know by Friday.',
      translation: 'Me avisa até sexta.',
      example: 'Think about it and let me know by Friday.',
      exampleTranslation: 'Pensa e me avisa até sexta.',
      audioAsset: 'audio/fase3/licao26/Let_me_know_by_Friday.mp3',
      ipa: '/ˈlɛmi ˈnoʊ baɪ ˈfraɪdeɪ/',
      phonetic: 'LÉ-mi NÔU bai FRÁI-dêi',
      soundTip: 'Let me vira LÉ-mi, sem o t. Força em LET, KNOW e FRI; o by '
          'passa rápido. Curve a língua no r de Friday, sem rr de garganta.',
    ),
    LessonItem(
      text: "Sorry, I'm running late.",
      translation: 'Desculpa, tô atrasado.',
      example: "Sorry, I'm running late. I'll be there in ten minutes.",
      exampleTranslation: 'Desculpa, tô atrasado. Chego em dez minutos.',
      audioAsset: "audio/fase3/licao26/Sorry_I'm_running_late.mp3",
      ipa: '/ˈsɑri aɪm ˈrʌnɪŋ ˈleɪt/',
      phonetic: 'SÁ-ri aim RÂ-ning LÊIT',
      soundTip: "Força em SO, RUN e LATE; o I'm passa curtinho. O r de "
          'running começa com a língua curvada, sem rr de garganta, e o late '
          'fecha no t.',
    ),
  ],
);

/// Lição 27 (revisão) — Revisão: a fala ligada: Revisão da Zona 4.
const fase3Licao27 = Lesson(
  id: 'fase3-licao27',
  title: 'Revisão: a fala ligada',
  objective: 'Você vai juntar tudo da zona: palavras que encolhem, que se '
      'fundem e que grudam, numa frase de cada lição.',
  microSkill: 'Revisão da Zona 4',
  approvalThreshold: 75,
  minProsody: 70,
  items: [
    LessonItem(
      text: "I'm going to call you later.",
      translation: 'Vou te ligar mais tarde.',
      example: "I'm driving now. I'm going to call you later.",
      exampleTranslation: 'Tô dirigindo agora. Te ligo mais tarde.',
      audioAsset: "audio/fase3/licao22/I'm_going_to_call_you_later.mp3",
      ipa: '/aɪm ˈɡʌnə ˈkɔl jə ˈleɪɾɚ/',
      phonetic: 'aim GÂ-nâ KÓL iâ LÊI-râr',
      soundTip: 'O going to encolhe num GÂ-nâ rápido, sem tu. A força vai em '
          'CALL e LA; no later, o t do meio vira um r leve, como em caro.',
    ),
    LessonItem(
      text: 'What do you think?',
      translation: 'O que você acha?',
      example: 'Should we leave at eight? What do you think?',
      exampleTranslation: 'A gente sai às oito? O que você acha?',
      audioAsset: 'audio/fase3/licao23/What_do_you_think.mp3',
      ipa: '/ˌwʌɾəjə ˈθɪŋk/',
      phonetic: 'uâ-râ-iâ THÍNK',
      soundTip: 'What do you sai como uma palavra só, uâ-râ-iâ, com o t e o d '
          'virando um r leve. Toda a força fica em THINK, língua entre os '
          'dentes.',
    ),
    LessonItem(
      text: 'Turn it off.',
      translation: 'Desliga isso.',
      example: "If you're not using the light, turn it off.",
      exampleTranslation: 'Se não tá usando a luz, desliga.',
      audioAsset: 'audio/fase3/licao24/Turn_it_off.mp3',
      ipa: '/ˌtɝnɪˈɾɔf/',
      phonetic: 'târ-ni-RÓF',
      soundTip: 'Cole as três palavras: o n do turn gruda no it e o t do it '
          'vira um r leve antes do off. Soa târ-ni-RÓF, com a força no OFF.',
    ),
    LessonItem(
      text: "I'm kind of tired.",
      translation: 'Tô meio cansado.',
      example: "Can we stay in tonight? I'm kind of tired.",
      exampleTranslation: 'Dá pra gente ficar em casa hoje? Tô meio cansado.',
      audioAsset: "audio/fase3/licao25/I'm_kind_of_tired.mp3",
      ipa: '/aɪm ˈkaɪndə ˈtaɪɚd/',
      phonetic: 'aim KÁIN-dâ TÁI-ârd',
      soundTip: 'O kind of vira KÁIN-dâ: o of perde o f e encolhe num â '
          'colado no kind. Força em KIND e TI, e o tired fecha no d.',
    ),
    LessonItem(
      text: 'Nice to meet you.',
      translation: 'Prazer em te conhecer.',
      example: "Nice to meet you. I've heard a lot about you.",
      exampleTranslation: 'Prazer. Já ouvi falar muito de você.',
      audioAsset: 'audio/fase3/licao26/Nice_to_meet_you.mp3',
      ipa: '/ˈnaɪs tə ˈmit ju/',
      phonetic: 'NÁIS tâ MÍT-iu',
      soundTip: 'Força em NICE e MEET; o to vira um tâ de passagem e o you '
          'sai baixinho, colado no meet. Nada de dar a mesma força às quatro.',
    ),
  ],
);

/// Lição 28 — BÔNUS — Bônus: várias ligações numa frase: Várias ligações seguidas.
const fase3Licao28 = Lesson(
  id: 'fase3-licao28',
  title: 'Bônus: várias ligações numa frase',
  objective: 'Você vai encarar frases mais longas com várias ligações '
      'seguidas, mantendo o ritmo sem travar no meio.',
  microSkill: 'Várias ligações seguidas',
  approvalThreshold: 75,
  minProsody: 70,
  bonus: true,
  items: [
    LessonItem(
      text: "I'm going to pick it up after work.",
      translation: 'Vou buscar depois do trabalho.',
      example: "Your package is at the office? I'm going to pick it up after "
          'work.',
      exampleTranslation: 'Sua encomenda tá no escritório? Vou buscar depois '
          'do trabalho.',
      audioAsset: "audio/fase3/licao28/I'm_going_to_pick_it_up_after_work.mp3",
      ipa: '/aɪm ˈɡʌnə ˌpɪkɪˈɾʌp ˈæftɚ ˈwɝk/',
      phonetic: 'aim GÂ-nâ pi-ki-RÂP ÉF-târ UÉRK',
      soundTip: 'Duas ligações seguidas: going to vira GÂ-nâ e pick it up '
          'vira pi-ki-RÂP. Força em GO, UP, AF e WORK; o resto passa rápido.',
    ),
    LessonItem(
      text: 'What do you want to do tonight?',
      translation: 'O que você quer fazer hoje à noite?',
      example: "It's Friday! What do you want to do tonight?",
      exampleTranslation: 'É sexta! O que você quer fazer hoje à noite?',
      audioAsset: 'audio/fase3/licao28/What_do_you_want_to_do_tonight.mp3',
      ipa: '/ˈwʌɾəjə ˈwɑnə ˈdu təˈnaɪt/',
      phonetic: 'UÂ-râ-iâ UÁ-nâ DU tâ-NÁIT',
      soundTip: 'What do you vira UÂ-râ-iâ e want to vira UÁ-nâ. Força em '
          'WHAT, WANT, DO e NIGHT; o to de tonight é só um tâ curto.',
    ),
    LessonItem(
      text: 'Did you get a lot of work done?',
      translation: 'Conseguiu adiantar bastante trabalho?',
      example: 'You stayed at the office all day. Did you get a lot of work '
          'done?',
      exampleTranslation: 'Você ficou o dia todo no escritório. Conseguiu '
          'adiantar bastante coisa?',
      audioAsset: 'audio/fase3/licao28/Did_you_get_a_lot_of_work_done.mp3',
      ipa: '/ˈdɪdʒə ˈɡɛɾə ˈlɑɾə ˈwɝk ˈdʌn/',
      phonetic: 'DÍ-djâ GUÉ-râ LÁ-râ UÉRK DÂN',
      soundTip: 'Três fusões: did you vira DÍ-djâ, get a vira GUÉ-râ e a lot '
          'of vira LÁ-râ. Força em DID, GET, LOT, WORK e DONE, que sobe no '
          'fim.',
    ),
    LessonItem(
      text: 'I have to get up at six tomorrow.',
      translation: 'Tenho que acordar às seis amanhã.',
      example: "I can't stay long. I have to get up at six tomorrow.",
      exampleTranslation: 'Não posso ficar muito. Tenho que acordar às seis '
          'amanhã.',
      audioAsset: 'audio/fase3/licao28/I_have_to_get_up_at_six_tomorrow.mp3',
      ipa: '/aɪ ˈhæftə ˌɡɛɾʌp ət ˈsɪks təˈmɑroʊ/',
      phonetic: 'ai RRÉF-tâ gué-RÂ-pât SÍKS tâ-MÁ-rôu',
      soundTip: 'Have to vira RRÉF-tâ, e get up at liga tudo: gué-RÂ-pât, com '
          'o t do get virando um r leve. A força mais alta cai em SIX.',
    ),
    LessonItem(
      text: 'It was kind of a long day.',
      translation: 'Foi um dia meio puxado.',
      example: "It was kind of a long day, so I'm staying home tonight.",
      exampleTranslation: 'Foi um dia meio puxado, então vou ficar em casa '
          'hoje.',
      audioAsset: 'audio/fase3/licao28/It_was_kind_of_a_long_day.mp3',
      ipa: '/ɪt wəz ˈkaɪndəv ə ˈlɔŋ ˈdeɪ/',
      phonetic: 'it uâz KÁIN-dâ-vâ LÓNG DÊI',
      soundTip: 'It was passa rápido e baixo. Kind of a liga num KÁIN-dâ-vâ, '
          'com o v do of grudado no a. Força em KIND, LONG e DAY.',
    ),
  ],
);
