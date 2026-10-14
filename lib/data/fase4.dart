import '../models/lesson.dart';
import '../models/trail.dart';

/// Lições da Trilha 4 ("Estruturas em fala" = Fase 4 do currículo):
/// perguntas, negativas e tempos verbais aprendidos como FALA, pelo molde que
/// se repete de ouvido, sem explicação gramatical, ver
/// docs/curriculo-fase4.md.
///
/// Zona 1 — Perguntas do dia a dia. Zona 2 — Dizer não. Zona 3 — Contar o
/// que aconteceu. Zona 4 — Agora, planos e experiências.
///
/// Mesmo formato das Trilhas 2 e 3: cada zona tem 5 lições obrigatórias, uma
/// revisão (reaproveita os áudios da zona) e um bônus opcional
/// (`Lesson.bonus`), que nunca é pré-requisito. Ids sequenciais
/// (`fase4-licao01..28`), sem lacunas. Títulos sem inglês escrito (o aluno
/// vê o título antes de ouvir).
///
/// Critério: accuracy ≥ 75 + fonema mínimo ≥ 65 (o calibrado nas trilhas
/// anteriores).
///
/// Áudio: `tool/gen_lesson_audio.sh` (função `gen4`), o nome do arquivo é o
/// texto só com letras, dígitos e apóstrofo, espaços viram "_".
///
/// IPA e fonética são aproximações (inglês americano), revisar com ouvido
/// nativo.
const fase4Zones = [
  Zone('Zona 1 — Perguntas do dia a dia', [
    fase4Licao01,
    fase4Licao02,
    fase4Licao03,
    fase4Licao04,
    fase4Licao05,
    fase4Licao06,
    fase4Licao07,
  ]),
  Zone('Zona 2 — Dizer não', [
    fase4Licao08,
    fase4Licao09,
    fase4Licao10,
    fase4Licao11,
    fase4Licao12,
    fase4Licao13,
    fase4Licao14,
  ]),
  Zone('Zona 3 — Contar o que aconteceu', [
    fase4Licao15,
    fase4Licao16,
    fase4Licao17,
    fase4Licao18,
    fase4Licao19,
    fase4Licao20,
    fase4Licao21,
  ]),
  Zone('Zona 4 — Agora, planos e experiências', [
    fase4Licao22,
    fase4Licao23,
    fase4Licao24,
    fase4Licao25,
    fase4Licao26,
    fase4Licao27,
    fase4Licao28,
  ]),
];

// ---------------------------------------------------------------------------
// ZONA 1 — PERGUNTAS DO DIA A DIA
// ---------------------------------------------------------------------------

/// Lição 1 — Perguntar sobre a rotina: do/does em pergunta sim/não.
const fase4Licao01 = Lesson(
  id: 'fase4-licao01',
  title: 'Perguntar sobre a rotina',
  objective:
      'Você vai perguntar sobre a rotina e os hábitos de alguém com '
      'perguntas curtas de sim ou não, que saem num fôlego só.',
  microSkill: 'do/does em pergunta sim/não',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Do you cook?',
      translation: 'Você cozinha?',
      example: 'A: Do you cook? B: Only on weekends.',
      exampleTranslation: 'A: Você cozinha? B: Só no fim de semana.',
      audioAsset: 'audio/fase4/licao01/Do_you_cook.mp3',
      ipa: '/dəjə ˈkʊk/',
      phonetic: 'dâ-iâ KÚK?',
      soundTip:
          'Do you sai colado e fraco, quase dâ-iâ. A força toda vai em '
          'COOK, com o k final seco, e a voz sobe no fim.',
    ),
    LessonItem(
      text: 'Does it hurt?',
      translation: 'Está doendo?',
      example: 'A: Does it hurt? B: Only when I walk.',
      exampleTranslation: 'A: Está doendo? B: Só quando eu ando.',
      audioAsset: 'audio/fase4/licao01/Does_it_hurt.mp3',
      ipa: '/dəzɪt ˈhɝt/',
      phonetic: 'dâ-zit RRÂRT?',
      soundTip:
          'Does it vira uma palavra só, dâ-zit. Em HURT o h é só um '
          'sopro de ar e o r enrola direto no t, sem vogal no meio.',
    ),
    LessonItem(
      text: 'Do you have kids?',
      translation: 'Você tem filhos?',
      example: 'A: Do you have kids? B: Yes, two girls.',
      exampleTranslation: 'A: Você tem filhos? B: Tenho, duas meninas.',
      audioAsset: 'audio/fase4/licao01/Do_you_have_kids.mp3',
      ipa: '/dəjə ˈhæv ˈkɪdz/',
      phonetic: 'dâ-iâ RRÉV KÍDZ?',
      soundTip:
          'Have é um sopro com a boca bem aberta, rrév. Kids termina em '
          'dz zumbindo, sem vogal depois, e a voz sobe no fim.',
    ),
    LessonItem(
      text: 'Does she live near here?',
      translation: 'Ela mora aqui perto?',
      example: 'A: Does she live near here? B: Yeah, just around the corner.',
      exampleTranslation:
          'A: Ela mora aqui perto? B: Mora, logo ali na '
          'esquina.',
      audioAsset: 'audio/fase4/licao01/Does_she_live_near_here.mp3',
      ipa: '/dəʒ ʃi ˈlɪv nɪr ˈhɪr/',
      phonetic: 'dâ-shi LÍV nír RRÍR?',
      soundTip:
          'Does she gruda num dâ-shi rápido. O v de live encosta no '
          'near sem vogal no meio, e a voz sobe em HERE.',
    ),
    LessonItem(
      text: 'Do they speak English?',
      translation: 'Eles falam inglês?',
      example: 'A: Do they speak English there? B: Most people do.',
      exampleTranslation: 'A: Lá eles falam inglês? B: A maioria fala.',
      audioAsset: 'audio/fase4/licao01/Do_they_speak_English.mp3',
      ipa: '/də ðeɪ ˈspik ˈɪŋɡlɪʃ/',
      phonetic: 'dâ thêi SPÍK ÍN-glish?',
      soundTip:
          'Em they a ponta da língua toca os dentes. Speak começa '
          'direto no s, sem vogal antes, e a voz sobe em ENGLISH.',
    ),
  ],
);

/// Lição 2 — Perguntar se é ou se está: is/are em pergunta sim/não.
const fase4Licao02 = Lesson(
  id: 'fase4-licao02',
  title: 'Perguntar se é ou se está',
  objective:
      'Você vai perguntar se alguém está bem, de quem é uma coisa ou '
      'como é um lugar, com perguntas curtas de sim ou não.',
  microSkill: 'is/are em pergunta sim/não',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Are you okay?',
      translation: 'Você está bem?',
      example: 'You look tired. Are you okay?',
      exampleTranslation: 'Você parece cansado. Está tudo bem?',
      audioAsset: 'audio/fase4/licao02/Are_you_okay.mp3',
      ipa: '/ɚ jə oʊˈkeɪ/',
      phonetic: 'âr-iâ ôu-KÊI?',
      soundTip:
          'Are you sai fraco e colado, âr-iâ. A força vai no KAY de '
          'okay e a voz sobe no fim.',
    ),
    LessonItem(
      text: 'Is this yours?',
      translation: 'Isso é seu?',
      example: 'I found a phone on the table. Is this yours?',
      exampleTranslation: 'Achei um celular na mesa. É seu?',
      audioAsset: 'audio/fase4/licao02/Is_this_yours.mp3',
      ipa: '/ɪz ðɪs ˈjɔrz/',
      phonetic: 'iz this IÓRZ?',
      soundTip:
          'Em this a ponta da língua encosta nos dentes. A força cai em '
          'YOURS, que termina em z zumbindo, e a voz sobe.',
    ),
    LessonItem(
      text: 'Are you new here?',
      translation: 'Você é novo aqui?',
      example: "A: Are you new here? B: Yes, it's my first week.",
      exampleTranslation:
          'A: Você é novo aqui? B: Sou, é minha primeira '
          'semana.',
      audioAsset: 'audio/fase4/licao02/Are_you_new_here.mp3',
      ipa: '/ɚ jə ˈnu ˈhɪr/',
      phonetic: 'âr-iâ NÚ RRÍR?',
      soundTip:
          'New é um nú limpo, sem i no meio. Here começa com um sopro, '
          'rrír, termina com r enrolado, e a voz sobe.',
    ),
    LessonItem(
      text: 'Is she your sister?',
      translation: 'Ela é sua irmã?',
      example: "A: Is she your sister? B: No, she's my cousin.",
      exampleTranslation: 'A: Ela é sua irmã? B: Não, é minha prima.',
      audioAsset: 'audio/fase4/licao02/Is_she_your_sister.mp3',
      ipa: '/ɪʒ ʃi jɚ ˈsɪstɚ/',
      phonetic: 'i-shi iâr SÍS-ter?',
      soundTip:
          'Is she vira i-shi, sem z no meio. Your fica fraco, iâr, e a '
          'força cai no SIS de sister, com o r final enrolado.',
    ),
    LessonItem(
      text: 'Is it always this busy?',
      translation: 'Aqui é sempre cheio assim?',
      example: 'A: Is it always this busy? B: Only on Fridays.',
      exampleTranslation: 'A: Aqui é sempre cheio assim? B: Só às sextas.',
      audioAsset: 'audio/fase4/licao02/Is_it_always_this_busy.mp3',
      ipa: '/ɪzɪt ˈɔlweɪz ðɪs ˈbɪzi/',
      phonetic: 'i-zit ÓL-uêiz this BÍ-zi?',
      soundTip:
          'Is it gruda em i-zit. A força vai no ÓL de always e no BÍ de '
          'busy, que soa com z. A voz sobe no fim.',
    ),
  ],
);

/// Lição 3 — Perguntar onde, quando e quem: where/when/who/which no presente.
const fase4Licao03 = Lesson(
  id: 'fase4-licao03',
  title: 'Perguntar onde, quando e quem',
  objective:
      'Você vai perguntar onde a pessoa mora, quem é alguém, quando '
      'algo começa e qual ela prefere, com a voz descendo no fim.',
  microSkill: 'where/when/who/which no presente',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "Who's that?",
      translation: 'Quem é esse?',
      example: "A: Who's that? B: My new boss.",
      exampleTranslation: 'A: Quem é esse? B: Meu chefe novo.',
      audioAsset: "audio/fase4/licao03/Who's_that.mp3",
      ipa: '/huz ˈðæt/',
      phonetic: 'rruz THÉT?',
      soundTip:
          "Who's é um sopro curto, rruz, colado no that. Língua nos "
          'dentes em THAT, e a voz desce no fim.',
    ),
    LessonItem(
      text: 'Where do you live?',
      translation: 'Onde você mora?',
      example: 'A: Where do you live? B: Downtown, near the park.',
      exampleTranslation: 'A: Onde você mora? B: No centro, perto do parque.',
      audioAsset: 'audio/fase4/licao03/Where_do_you_live.mp3',
      ipa: '/ˈwɛr dəjə ˈlɪv/',
      phonetic: 'UÉR dâ-iâ LÍV?',
      soundTip:
          'Where do you sai num fôlego, uér-dâ-iâ. Live é curto e o v '
          'final vibra no lábio de baixo. A voz desce no fim.',
    ),
    LessonItem(
      text: 'When does it start?',
      translation: 'Começa quando?',
      example: 'A: When does it start? B: At eight.',
      exampleTranslation: 'A: Começa quando? B: Às oito.',
      audioAsset: 'audio/fase4/licao03/When_does_it_start.mp3',
      ipa: '/ˈwɛn dəzɪt ˈstɑrt/',
      phonetic: 'UÉN dâ-zit STÁRT?',
      soundTip:
          'Does it vira dâ-zit. Start começa direto no s, sem vogal '
          'antes, e o t final fica preso na língua. A voz desce.',
    ),
    LessonItem(
      text: 'Which one do you want?',
      translation: 'Qual você quer?',
      example: 'A: Which one do you want? B: The blue one.',
      exampleTranslation: 'A: Qual você quer? B: O azul.',
      audioAsset: 'audio/fase4/licao03/Which_one_do_you_want.mp3',
      ipa: '/ˈwɪtʃ wʌn dəjə ˈwɑnt/',
      phonetic: 'UÍTCH uân dâ-iâ UÁNT?',
      soundTip:
          'A força vai em WHICH e em WANT; one do you passa rápido no '
          'meio. O t de want quase some, e a voz desce.',
    ),
    LessonItem(
      text: 'What time do you get up?',
      translation: 'Que horas você levanta?',
      example: 'A: What time do you get up? B: Around six thirty.',
      exampleTranslation: 'A: Que horas você levanta? B: Lá pelas seis e meia.',
      audioAsset: 'audio/fase4/licao03/What_time_do_you_get_up.mp3',
      ipa: '/wʌt ˈtaɪm dəjə ˌɡɛɾ ˈʌp/',
      phonetic: 'uât TÁIM dâ-iâ gué-RÂP?',
      soundTip:
          'Get up liga num só: o t vira um r rápido, gué-râp. A força '
          'fica em TIME e em UP, e a voz desce no fim.',
    ),
  ],
);

/// Lição 4 — Perguntar quanto e quanto tempo: how much/many/long/far/often.
const fase4Licao04 = Lesson(
  id: 'fase4-licao04',
  title: 'Perguntar quanto e quanto tempo',
  objective:
      'Você vai perguntar quanto, quantos, quanto tempo, a que '
      'distância e com que frequência, sem travar no começo da pergunta.',
  microSkill: 'how much/many/long/far/often',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'How much do you need?',
      translation: 'De quanto você precisa?',
      example: 'A: How much do you need? B: Just twenty dollars.',
      exampleTranslation: 'A: De quanto você precisa? B: Só vinte dólares.',
      audioAsset: 'audio/fase4/licao04/How_much_do_you_need.mp3',
      ipa: '/ˌhaʊ ˈmʌtʃ dəjə ˈnid/',
      phonetic: 'rráu MÂTCH dâ-iâ NÍD?',
      soundTip:
          'Much é mâtch, com a boca meio aberta. Do you passa fraco no '
          'meio, dâ-iâ, e a força volta em NEED, com o d final leve.',
    ),
    LessonItem(
      text: 'How long does it take?',
      translation: 'Quanto tempo leva?',
      example: 'A: How long does it take? B: About twenty minutes.',
      exampleTranslation: 'A: Quanto tempo leva? B: Uns vinte minutos.',
      audioAsset: 'audio/fase4/licao04/How_long_does_it_take.mp3',
      ipa: '/ˌhaʊ ˈlɔŋ dəzɪt ˈteɪk/',
      phonetic: 'rráu LÓN dâ-zit TÊIK?',
      soundTip:
          'Long termina no fundo da boca, sem estourar o g. Does it '
          'vira dâ-zit, e a força final cai em TAKE.',
    ),
    LessonItem(
      text: 'How far is your office?',
      translation: 'Seu escritório fica a que distância?',
      example: 'A: How far is your office? B: Ten minutes by bike.',
      exampleTranslation:
          'A: Seu escritório fica a que distância? B: Dez '
          'minutos de bicicleta.',
      audioAsset: 'audio/fase4/licao04/How_far_is_your_office.mp3',
      ipa: '/ˌhaʊ ˈfɑr ɪz jɚ ˈɔfɪs/',
      phonetic: 'rráu FÁ-riz iâr Ó-fis?',
      soundTip:
          'O r de far liga no is: fá-riz. Your fica fraco, iâr, e a '
          'força cai no Ó de office, que termina em s.',
    ),
    LessonItem(
      text: 'How often do you work out?',
      translation: 'Você treina com que frequência?',
      example: 'A: How often do you work out? B: Three times a week.',
      exampleTranslation:
          'A: Você treina com que frequência? B: Três vezes '
          'por semana.',
      audioAsset: 'audio/fase4/licao04/How_often_do_you_work_out.mp3',
      ipa: '/ˌhaʊ ˈɔfən dəjə ˌwɝk ˈaʊt/',
      phonetic: 'rráu Ó-fân dâ-iâ uêr-KÁUT?',
      soundTip:
          'Often sai sem t: Ó-fân. Work out liga num só, uêr-káut, com '
          'o k passando direto pro out. A voz desce no fim.',
    ),
    LessonItem(
      text: 'How many languages do you speak?',
      translation: 'Quantos idiomas você fala?',
      example:
          'A: How many languages do you speak? B: Two, Portuguese and '
          'Spanish.',
      exampleTranslation:
          'A: Quantos idiomas você fala? B: Dois, português e '
          'espanhol.',
      audioAsset: 'audio/fase4/licao04/How_many_languages_do_you_speak.mp3',
      ipa: '/ˌhaʊ ˈmɛni ˈlæŋɡwɪdʒɪz dəjə ˈspik/',
      phonetic: 'rráu MÉ-ni LÉN-guí-djiz dâ-iâ SPÍK?',
      soundTip:
          'Many é MÉ-ni, com e aberto. Languages tem força no LAN e '
          'termina em djiz. Speak começa direto no s, sem vogal antes.',
    ),
  ],
);

/// Lição 5 — Tirar dúvida e confirmar: perguntas para entender e confirmar.
const fase4Licao05 = Lesson(
  id: 'fase4-licao05',
  title: 'Tirar dúvida e confirmar',
  objective:
      'Você vai perguntar o que uma palavra quer dizer, como se '
      'escreve, como se diz e se entendeu certo, sem precisar mudar para o '
      'português.',
  microSkill: 'perguntas para entender e confirmar',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Is that right?',
      translation: 'É isso mesmo?',
      example: 'A: So the meeting is at ten. Is that right? B: Yes, exactly.',
      exampleTranslation:
          'A: Então a reunião é às dez. É isso mesmo? B: '
          'Isso, exatamente.',
      audioAsset: 'audio/fase4/licao05/Is_that_right.mp3',
      ipa: '/ɪz ðæt ˈraɪt/',
      phonetic: 'iz thét RÁIT?',
      soundTip:
          'Is that sai fraco e rápido, com o t de that preso, sem '
          'vogal. A força cai em RIGHT, com r enrolado, e a voz sobe.',
    ),
    LessonItem(
      text: 'Which one is better?',
      translation: 'Qual é melhor?',
      example: 'A: Which one is better? B: This one, for sure.',
      exampleTranslation: 'A: Qual é melhor? B: Esse, com certeza.',
      audioAsset: 'audio/fase4/licao05/Which_one_is_better.mp3',
      ipa: '/ˈwɪtʃ wʌn ɪz ˈbɛɾɚ/',
      phonetic: 'UÍTCH uâ-niz BÉ-rer?',
      soundTip:
          'One is liga em uâ-niz. Em better o tt vira um r rápido, '
          'BÉ-rer, com r enrolado no fim, e a voz desce.',
    ),
    LessonItem(
      text: 'What does this word mean?',
      translation: 'O que essa palavra quer dizer?',
      example: 'A: What does this word mean? B: It means fast.',
      exampleTranslation:
          'A: O que essa palavra quer dizer? B: Quer dizer '
          'rápido.',
      audioAsset: 'audio/fase4/licao05/What_does_this_word_mean.mp3',
      ipa: '/wʌt dəz ðɪs ˈwɝd ˈmin/',
      phonetic: 'uât dâz this UÉRD MÍN?',
      soundTip:
          'Does this sai rápido e fraco. Word tem boca em bico, r '
          'enrolado e d leve no fim. A voz desce em MEAN.',
    ),
    LessonItem(
      text: 'How do you spell that?',
      translation: 'Como se escreve isso?',
      example: 'A: My last name is Pereira. B: How do you spell that?',
      exampleTranslation: 'A: Meu sobrenome é Pereira. B: Como se escreve?',
      audioAsset: 'audio/fase4/licao05/How_do_you_spell_that.mp3',
      ipa: '/ˌhaʊ dəjə ˈspɛl ðæt/',
      phonetic: 'rráu dâ-iâ SPÉL thét?',
      soundTip:
          'Spell começa direto no s, sem vogal antes, e o l final fica '
          'com a ponta da língua no céu da boca. A força cai em SPELL.',
    ),
    LessonItem(
      text: 'How do you say this in English?',
      translation: 'Como se diz isso em inglês?',
      example:
          "A: How do you say saudade in English? B: There's no exact "
          'word.',
      exampleTranslation:
          'A: Como se diz saudade em inglês? B: Não existe '
          'uma palavra exata.',
      audioAsset: 'audio/fase4/licao05/How_do_you_say_this_in_English.mp3',
      ipa: '/ˌhaʊ dəjə ˈseɪ ðɪs ɪn ˈɪŋɡlɪʃ/',
      phonetic: 'rráu dâ-iâ SÊI this in ÍN-glish?',
      soundTip:
          'Do you fica fraco no meio, dâ-iâ. A força cai em SAY e no ÍN '
          'de English, e this in liga sem pausa.',
    ),
  ],
);

/// Lição 6 (revisão) — Revisão: perguntas do dia a dia: revisão dos moldes de pergunta.
const fase4Licao06 = Lesson(
  id: 'fase4-licao06',
  title: 'Revisão: perguntas do dia a dia',
  objective:
      'Você vai juntar as perguntas da zona e fazer cada uma num '
      'fôlego só, com a voz subindo ou descendo no lugar certo.',
  microSkill: 'revisão dos moldes de pergunta',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Does it hurt?',
      translation: 'Está doendo?',
      example: 'A: I hit my knee. B: Does it hurt?',
      exampleTranslation: 'A: Bati o joelho. B: Está doendo?',
      audioAsset: 'audio/fase4/licao01/Does_it_hurt.mp3',
      ipa: '/dəzɪt ˈhɝt/',
      phonetic: 'dâ-zit RRÂRT?',
      soundTip:
          'Does it vira uma palavra só, dâ-zit. Em HURT o h é só um '
          'sopro de ar e o r enrola direto no t, sem vogal no meio.',
    ),
    LessonItem(
      text: 'Is it always this busy?',
      translation: 'Aqui é sempre cheio assim?',
      example:
          'A: Wow, look at the line. Is it always this busy? B: Pretty '
          'much.',
      exampleTranslation:
          'A: Nossa, olha a fila. Aqui é sempre cheio assim? '
          'B: Quase sempre.',
      audioAsset: 'audio/fase4/licao02/Is_it_always_this_busy.mp3',
      ipa: '/ɪzɪt ˈɔlweɪz ðɪs ˈbɪzi/',
      phonetic: 'i-zit ÓL-uêiz this BÍ-zi?',
      soundTip:
          'Is it gruda em i-zit. A força vai no ÓL de always e no BÍ de '
          'busy, que soa com z. A voz sobe no fim.',
    ),
    LessonItem(
      text: 'What time do you get up?',
      translation: 'Que horas você levanta?',
      example: 'A: What time do you get up on weekends? B: Late, around ten.',
      exampleTranslation:
          'A: Que horas você levanta no fim de semana? B: '
          'Tarde, lá pelas dez.',
      audioAsset: 'audio/fase4/licao03/What_time_do_you_get_up.mp3',
      ipa: '/wʌt ˈtaɪm dəjə ˌɡɛɾ ˈʌp/',
      phonetic: 'uât TÁIM dâ-iâ gué-RÂP?',
      soundTip:
          'Get up liga num só: o t vira um r rápido, gué-râp. A força '
          'fica em TIME e em UP, e a voz desce no fim.',
    ),
    LessonItem(
      text: 'How long does it take?',
      translation: 'Quanto tempo leva?',
      example: 'A: I take the train to work. B: How long does it take?',
      exampleTranslation:
          'A: Eu vou de trem para o trabalho. B: Quanto tempo '
          'leva?',
      audioAsset: 'audio/fase4/licao04/How_long_does_it_take.mp3',
      ipa: '/ˌhaʊ ˈlɔŋ dəzɪt ˈteɪk/',
      phonetic: 'rráu LÓN dâ-zit TÊIK?',
      soundTip:
          'Long termina no fundo da boca, sem estourar o g. Does it '
          'vira dâ-zit, e a força final cai em TAKE.',
    ),
    LessonItem(
      text: 'How do you say this in English?',
      translation: 'Como se diz isso em inglês?',
      example: "A: How do you say this in English? B: That's a stapler.",
      exampleTranslation:
          'A: Como se diz isso em inglês? B: Isso é um '
          'grampeador.',
      audioAsset: 'audio/fase4/licao05/How_do_you_say_this_in_English.mp3',
      ipa: '/ˌhaʊ dəjə ˈseɪ ðɪs ɪn ˈɪŋɡlɪʃ/',
      phonetic: 'rráu dâ-iâ SÊI this in ÍN-glish?',
      soundTip:
          'Do you fica fraco no meio, dâ-iâ. A força cai em SAY e no ÍN '
          'de English, e this in liga sem pausa.',
    ),
  ],
);

/// Lição 7 — BÔNUS — Bônus: perguntar com mais jeito: perguntas indiretas e longas.
const fase4Licao07 = Lesson(
  id: 'fase4-licao07',
  title: 'Bônus: perguntar com mais jeito',
  objective:
      'Você vai fazer perguntas mais longas e educadas, do tipo você '
      'sabe onde ou pode me dizer, sem perder o fio no meio da frase.',
  microSkill: 'perguntas indiretas e longas',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: 'Do you know where she lives?',
      translation: 'Você sabe onde ela mora?',
      example: 'A: Do you know where she lives? B: Somewhere near the beach.',
      exampleTranslation:
          'A: Você sabe onde ela mora? B: Em algum lugar '
          'perto da praia.',
      audioAsset: 'audio/fase4/licao07/Do_you_know_where_she_lives.mp3',
      ipa: '/dəjə ˈnoʊ wɛr ʃi ˈlɪvz/',
      phonetic: 'dâ-iâ NÔU uér shi LÍVZ?',
      soundTip:
          'Do you know sai num fôlego, dâ-iâ-nôu. Lives termina em vz '
          'zumbindo, sem vogal depois, e a voz sobe no fim.',
    ),
    LessonItem(
      text: "Do you know if he's here today?",
      translation: 'Você sabe se ele veio hoje?',
      example:
          "A: Do you know if he's here today? B: I think he's working "
          'from home.',
      exampleTranslation:
          'A: Você sabe se ele veio hoje? B: Acho que ele '
          'está trabalhando de casa.',
      audioAsset: "audio/fase4/licao07/Do_you_know_if_he's_here_today.mp3",
      ipa: '/dəjə ˈnoʊ ɪf iz ˈhɪr təˈdeɪ/',
      phonetic: 'dâ-iâ NÔU i-fiz RRÍR tâ-DÊI?',
      soundTip:
          "O h de he's some na fala ligada: if he's vira i-fiz. Here "
          'tem sopro e r enrolado, e a voz sobe em DAY.',
    ),
    LessonItem(
      text: 'Could you tell me how this works?',
      translation: 'Pode me explicar como isso funciona?',
      example:
          'A: Could you tell me how this works? B: Sure, just press the '
          'green button.',
      exampleTranslation:
          'A: Pode me explicar como isso funciona? B: Claro, '
          'é só apertar o botão verde.',
      audioAsset: 'audio/fase4/licao07/Could_you_tell_me_how_this_works.mp3',
      ipa: '/kʊdʒə ˈtɛl mi ˌhaʊ ðɪs ˈwɝks/',
      phonetic: 'kú-djâ TÉL mi rráu this UÉRKS?',
      soundTip:
          'Could you vira kú-djâ, com o d e o y fundidos. Tell me cola '
          'num só, e works tem r enrolado e ks no fim.',
    ),
    LessonItem(
      text: 'Can you tell me what time it opens?',
      translation: 'Pode me dizer que horas abre?',
      example: 'A: Can you tell me what time it opens? B: At nine on Sundays.',
      exampleTranslation:
          'A: Pode me dizer que horas abre? B: Às nove no '
          'domingo.',
      audioAsset: 'audio/fase4/licao07/Can_you_tell_me_what_time_it_opens.mp3',
      ipa: '/kən jə ˈtɛl mi ˌwʌt ˈtaɪm ɪɾ ˈoʊpənz/',
      phonetic: 'kân-iâ TÉL mi uât TÁI-mi-RÔU-pânz?',
      soundTip:
          'Can sai fraco, kân. Time it opens liga tudo, '
          'tái-mi-rôu-pânz: o t vira um r rápido e a força cai no Ô de opens.',
    ),
    LessonItem(
      text: 'Do you mind if I ask what you do?',
      translation: 'Posso perguntar com o que você trabalha?',
      example:
          "A: Do you mind if I ask what you do? B: Not at all, I'm a "
          'nurse.',
      exampleTranslation:
          'A: Posso perguntar com o que você trabalha? B: '
          'Claro, sou enfermeira.',
      audioAsset: 'audio/fase4/licao07/Do_you_mind_if_I_ask_what_you_do.mp3',
      ipa: '/dəjə ˈmaɪnd ɪf aɪ ˈæsk ˈwʌtʃə ˈdu/',
      phonetic: 'dâ-iâ MÁIN-di-fai ÉSK UÂ-tchâ DÚ?',
      soundTip:
          'Mind if I cola em máin-di-fai. What you vira uâ-tchâ, e a '
          'força final cai em DO, com a voz subindo.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// ZONA 2 — DIZER NÃO
// ---------------------------------------------------------------------------

/// Lição 8 — Dizer o que você não faz: I/you/we/they don't + verbo.
const fase4Licao08 = Lesson(
  id: 'fase4-licao08',
  title: 'Dizer o que você não faz',
  objective:
      'Você vai dizer o que você não faz no dia a dia, com o não curto '
      'e forte, sem travar no meio da frase.',
  microSkill: "I/you/we/they don't + verbo",
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I don't drink coffee.",
      translation: 'Eu não tomo café.',
      example: "A: Want a cup? B: No, thanks. I don't drink coffee.",
      exampleTranslation:
          'A: Quer uma xícara? B: Não, obrigado. Eu não tomo '
          'café.',
      audioAsset: "audio/fase4/licao08/I_don't_drink_coffee.mp3",
      ipa: '/aɪ ˈdoʊn(t) ˈdrɪŋk ˈkɔfi/',
      phonetic: 'ai DÔUN(t) DRÍNK KÓ-fi',
      soundTip:
          "O t do don't quase não sai: a língua toca o céu da boca e já "
          "pula pro drink. A força vai em DON'T e em COF.",
    ),
    LessonItem(
      text: "I don't live here.",
      translation: 'Eu não moro aqui.',
      example: "Sorry, I have no idea where that is. I don't live here.",
      exampleTranslation:
          'Desculpa, não faço ideia de onde fica. Eu não moro '
          'aqui.',
      audioAsset: "audio/fase4/licao08/I_don't_live_here.mp3",
      ipa: '/aɪ ˈdoʊn(t) ˈlɪv ˈhɪr/',
      phonetic: 'ai DÔUN(t) LÍV RRÍR',
      soundTip:
          "Don't e live levam força, e o t some entre os dois. Live é "
          'curto e termina vibrando no v; o here é só um sopro com r '
          'enrolado.',
    ),
    LessonItem(
      text: "They don't know each other.",
      translation: 'Eles não se conhecem.',
      example: "Let me introduce them. They don't know each other.",
      exampleTranslation: 'Deixa eu apresentar os dois. Eles não se conhecem.',
      audioAsset: "audio/fase4/licao08/They_don't_know_each_other.mp3",
      ipa: '/ðeɪ ˈdoʊn(t) ˈnoʊ iˈtʃʌðɚ/',
      phonetic: 'thêi DÔUN(t) NÔU i-TCHÂ-ther',
      soundTip:
          "O t do don't some antes do know. Each other vira um bloco "
          'só, i-tchâ-ther, com a língua entre os dentes no th e o r enrolado '
          'no fim.',
    ),
    LessonItem(
      text: "We don't work on Sundays.",
      translation: 'A gente não trabalha aos domingos.',
      example: "A: Are you open tomorrow? B: No, we don't work on Sundays.",
      exampleTranslation:
          'A: Vocês abrem amanhã? B: Não, a gente não '
          'trabalha aos domingos.',
      audioAsset: "audio/fase4/licao08/We_don't_work_on_Sundays.mp3",
      ipa: '/wi ˈdoʊn(t) ˈwɝk ɑn ˈsʌndeɪz/',
      phonetic: 'ui DÔUN(t) UÉR-kan SÂN-deiz',
      soundTip:
          "Work on se liga: uér-kan, o k gruda na vogal. O t do don't "
          'fica mudo, e o Sundays termina zumbindo, como z.',
    ),
    LessonItem(
      text: "You don't need a car here.",
      translation: 'Aqui você não precisa de carro.',
      example: "Everything is close. You don't need a car here.",
      exampleTranslation: 'Tudo é perto. Aqui você não precisa de carro.',
      audioAsset: "audio/fase4/licao08/You_don't_need_a_car_here.mp3",
      ipa: '/ju ˈdoʊn(t) ˈnid ə ˈkɑr hɪr/',
      phonetic: 'iu DÔUN(t) NÍ-dâ KÁR rrír',
      soundTip:
          "Need a vira ní-dâ, numa batida só. O t do don't some antes "
          "do n, e a força fica em DON'T, NEED e CAR, com o r enrolado.",
    ),
  ],
);

/// Lição 9 — O que alguém não faz: he/she/it doesn't + verbo.
const fase4Licao09 = Lesson(
  id: 'fase4-licao09',
  title: 'O que alguém não faz',
  objective:
      'Você vai dizer o que outra pessoa ou uma coisa não faz, como '
      'alguém que não dirige ou algo que não funciona.',
  microSkill: "he/she/it doesn't + verbo",
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "It doesn't work.",
      translation: 'Não funciona.',
      example: "Don't use that machine. It doesn't work.",
      exampleTranslation: 'Não usa essa máquina. Ela não funciona.',
      audioAsset: "audio/fase4/licao09/It_doesn't_work.mp3",
      ipa: '/ɪt ˈdʌzn̩(t) ˈwɝk/',
      phonetic: 'it DÂ-zn(t) UÉRK',
      soundTip:
          "Doesn't é DÂ-zn: o z passa direto pro n pelo nariz, sem "
          'vogal no meio, e o t final quase some. Força em DOES e WORK.',
    ),
    LessonItem(
      text: "He doesn't drive.",
      translation: 'Ele não dirige.',
      example: "He doesn't drive, so I always pick him up.",
      exampleTranslation: 'Ele não dirige, então eu sempre busco ele.',
      audioAsset: "audio/fase4/licao09/He_doesn't_drive.mp3",
      ipa: '/hi ˈdʌzn̩(t) ˈdraɪv/',
      phonetic: 'rri DÂ-zn(t) DRÁIV',
      soundTip:
          "O he é só um sopro rápido. Doesn't sai DÂ-zn, com o t mudo, "
          'e o drive termina vibrando no v, dentes no lábio de baixo.',
    ),
    LessonItem(
      text: "It doesn't matter.",
      translation: 'Não importa.',
      example: "A: Red or blue? B: It doesn't matter.",
      exampleTranslation: 'A: Vermelho ou azul? B: Tanto faz.',
      audioAsset: "audio/fase4/licao09/It_doesn't_matter.mp3",
      ipa: '/ɪt ˈdʌzn̩(t) ˈmæɾɚ/',
      phonetic: 'it DÂ-zn(t) MÉ-rer',
      soundTip:
          'No matter o t vira um r leve, de toque rápido: mé-rer. O '
          "doesn't fica DÂ-zn, e a voz desce no fim, sem drama.",
    ),
    LessonItem(
      text: "She doesn't eat meat.",
      translation: 'Ela não come carne.',
      example: "Let's order the veggie pizza. She doesn't eat meat.",
      exampleTranslation:
          'Vamos pedir a pizza vegetariana. Ela não come '
          'carne.',
      audioAsset: "audio/fase4/licao09/She_doesn't_eat_meat.mp3",
      ipa: '/ʃi ˈdʌzn̩(t) ˈit ˈmit/',
      phonetic: 'shi DÂ-zn(t) ÍT MÍT',
      soundTip:
          "Doesn't fica DÂ-zn, com um corte leve antes do eat. Eat e "
          'meat têm o mesmo i longo, e o t final trava sem soltar ar.',
    ),
    LessonItem(
      text: "My boss doesn't speak Portuguese.",
      translation: 'Meu chefe não fala português.',
      example: "Write the email in English. My boss doesn't speak Portuguese.",
      exampleTranslation:
          'Escreve o e-mail em inglês. Meu chefe não fala '
          'português.',
      audioAsset: "audio/fase4/licao09/My_boss_doesn't_speak_Portuguese.mp3",
      ipa: '/maɪ ˈbɔs ˈdʌzn̩(t) ˈspik ˌpɔrtʃəˈɡiz/',
      phonetic: 'mai BÓS DÂ-zn(t) SPÍK pór-tchâ-GUÍZ',
      soundTip:
          "Boss termina num s limpo e doesn't no n, com o t mudo. Em "
          'Portuguese a força cai no fim, GUÍZ, que termina zumbindo.',
    ),
  ],
);

/// Lição 10 — Não sou, não está, não tem: I'm not / isn't / aren't.
const fase4Licao10 = Lesson(
  id: 'fase4-licao10',
  title: 'Não sou, não está, não tem',
  objective:
      'Você vai dizer que algo não é, não está ou não existe, como não '
      'ter certeza ou não ser daqui.',
  microSkill: "I'm not / isn't / aren't",
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I'm not sure.",
      translation: 'Não tenho certeza.',
      example: "A: Is the store open today? B: I'm not sure.",
      exampleTranslation: 'A: A loja abre hoje? B: Não tenho certeza.',
      audioAsset: "audio/fase4/licao10/I'm_not_sure.mp3",
      ipa: '/aɪm ˈnɑt ˈʃʊr/',
      phonetic: 'aim NÁT SHÚR',
      soundTip:
          'Na negação a força cai no NOT, com a boca aberta, e o t '
          'trava sem soltar ar. Sure começa com um chiado e fecha no r '
          'enrolado.',
    ),
    LessonItem(
      text: "It isn't far.",
      translation: 'Não é longe.',
      example: "We can walk. It isn't far.",
      exampleTranslation: 'Dá pra ir a pé. Não é longe.',
      audioAsset: "audio/fase4/licao10/It_isn't_far.mp3",
      ipa: '/ɪˈɾɪzn̩(t) ˈfɑr/',
      phonetic: 'i-RÍ-zn(t) FÁR',
      soundTip:
          "It isn't vira uma palavra só: i-rí-zn, o t do it vira um r "
          "leve. O isn't fecha no n, t quase mudo, e far termina no r "
          'enrolado.',
    ),
    LessonItem(
      text: "They aren't ready.",
      translation: 'Eles não estão prontos.',
      example: "Let's wait a bit. They aren't ready.",
      exampleTranslation: 'Vamos esperar um pouco. Eles não estão prontos.',
      audioAsset: "audio/fase4/licao10/They_aren't_ready.mp3",
      ipa: '/ðeɪ ˈɑrn(t) ˈrɛdi/',
      phonetic: 'thêi ÁRN(t) RÉ-di',
      soundTip:
          "Aren't é uma sílaba só, ÁRN, com a língua enrolada e o t "
          'mudo. Do n passe direto pro r de ready, sem vogal entre eles.',
    ),
    LessonItem(
      text: "I'm not from around here.",
      translation: 'Não sou daqui.',
      example: "A: Where's the bank? B: Sorry, I'm not from around here.",
      exampleTranslation: 'A: Onde fica o banco? B: Desculpa, não sou daqui.',
      audioAsset: "audio/fase4/licao10/I'm_not_from_around_here.mp3",
      ipa: '/aɪm ˈnɑt frəməˈraʊnd ˈhɪr/',
      phonetic: 'aim NÁT frâ-mâ-RÁUND RRÍR',
      soundTip:
          'From around se liga: frâ-mâ-RÁUND, o m gruda na vogal. A '
          'força fica em NOT, ROUND e HERE, e o t do not trava sem soltar ar.',
    ),
    LessonItem(
      text: "There isn't any milk left.",
      translation: 'Não tem mais leite.',
      example: "Can you buy some on your way home? There isn't any milk left.",
      exampleTranslation:
          'Você pode comprar no caminho de casa? Não tem mais '
          'leite.',
      audioAsset: "audio/fase4/licao10/There_isn't_any_milk_left.mp3",
      ipa: '/ðɛˈrɪzn̩(t) ˌɛni ˈmɪlk ˈlɛft/',
      phonetic: 'thé-RÍ-zn(t) é-ni MÍLK LÉFT',
      soundTip:
          "There isn't se liga: the-rí-zn, o r gruda no i. Força em IS, "
          'MILK e LEFT; o L de milk fica com a ponta da língua no céu da '
          'boca.',
    ),
  ],
);

/// Lição 11 — Não posso, não vai, não precisa: can't / won't / shouldn't / don't have to.
const fase4Licao11 = Lesson(
  id: 'fase4-licao11',
  title: 'Não posso, não vai, não precisa',
  objective:
      'Você vai dizer que não consegue, que algo não vai acontecer e '
      'que alguém não precisa ou não deveria fazer algo.',
  microSkill: "can't / won't / shouldn't / don't have to",
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I can't hear you.",
      translation: 'Não estou te ouvindo.',
      example: "The music is too loud. I can't hear you.",
      exampleTranslation: 'A música está alta demais. Não estou te ouvindo.',
      audioAsset: "audio/fase4/licao11/I_can't_hear_you.mp3",
      ipa: '/aɪ ˈkæn(t) ˈhɪr jə/',
      phonetic: 'ai KÉN(t) RRÍR-iâ',
      soundTip:
          "Can't leva força e boca bem aberta, KÉN, com o t quase mudo. "
          'É essa força que mostra o não; o you sai fraco, iâ.',
    ),
    LessonItem(
      text: "It won't take long.",
      translation: 'Não vai demorar.',
      example: "Wait here, please. It won't take long.",
      exampleTranslation: 'Espera aqui, por favor. Não vai demorar.',
      audioAsset: "audio/fase4/licao11/It_won't_take_long.mp3",
      ipa: '/ɪt ˈwoʊn(t) ˈteɪk ˈlɔŋ/',
      phonetic: 'it UÔUN(t) TÊIK LÓN',
      soundTip:
          "Won't soa UÔUN, com a boca bem redonda e força; o t dele se "
          'junta ao t de take. Long termina no nariz, sem g solto.',
    ),
    LessonItem(
      text: "You don't have to pay.",
      translation: 'Você não precisa pagar.',
      example: "It's free. You don't have to pay.",
      exampleTranslation: 'É de graça. Você não precisa pagar.',
      audioAsset: "audio/fase4/licao11/You_don't_have_to_pay.mp3",
      ipa: '/ju ˈdoʊn(t) ˈhæftə ˈpeɪ/',
      phonetic: 'iu DÔUN(t) RRÉF-tâ PÊI',
      soundTip:
          "Have to vira RRÉF-tâ, com f. O t do don't quase some antes "
          "do have, e a força vai em DON'T, HAVE e PAY.",
    ),
    LessonItem(
      text: "I can't make it tonight.",
      translation: 'Hoje à noite eu não consigo ir.',
      example: "Sorry, I can't make it tonight. How about Friday?",
      exampleTranslation:
          'Desculpa, hoje à noite eu não consigo ir. Que tal '
          'sexta?',
      audioAsset: "audio/fase4/licao11/I_can't_make_it_tonight.mp3",
      ipa: '/aɪ ˈkæn(t) ˈmeɪkɪt təˈnaɪt/',
      phonetic: 'ai KÉN(t) MÊI-kit tâ-NÁIT',
      soundTip:
          "Make it se liga: MÊI-kit. O can't tem boca aberta e força, "
          'com o t mudo, e o to de tonight é só um tâ curto.',
    ),
    LessonItem(
      text: "You shouldn't walk alone at night.",
      translation: 'Você não deveria andar sozinho à noite.',
      example: "This area isn't safe. You shouldn't walk alone at night.",
      exampleTranslation:
          'Esta região não é segura. Você não deveria andar '
          'sozinho à noite.',
      audioAsset: "audio/fase4/licao11/You_shouldn't_walk_alone_at_night.mp3",
      ipa: '/ju ˈʃʊdn̩(t) ˈwɔk əˈloʊnət ˈnaɪt/',
      phonetic: 'iu SHÚ-dn(t) UÓK â-LÔU-nât NÁIT',
      soundTip:
          "Shouldn't é SHÚ-dn, o d solta pelo nariz, sem vogal. O L de "
          'walk é mudo, e alone at se liga: â-lôu-nât.',
    ),
  ],
);

/// Lição 12 — Nunca, nada, ninguém: never / nothing / nobody / yet.
const fase4Licao12 = Lesson(
  id: 'fase4-licao12',
  title: 'Nunca, nada, ninguém',
  objective:
      'Você vai usar nunca, nada, ninguém, ainda não e não mais em '
      'frases curtas que saem prontas.',
  microSkill: 'never / nothing / nobody / yet',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Not really.',
      translation: 'Não muito.',
      example: 'A: Are you hungry? B: Not really.',
      exampleTranslation: 'A: Tá com fome? B: Não muito.',
      audioAsset: 'audio/fase4/licao12/Not_really.mp3',
      ipa: '/ˈnɑt ˈrɪli/',
      phonetic: 'NÁT RÍ-li',
      soundTip:
          'O t do not trava sem soltar ar e já entra o r de really, com '
          'a língua enrolada lá atrás. A voz desce no fim, num tom tranquilo.',
    ),
    LessonItem(
      text: "I'm not done yet.",
      translation: 'Ainda não terminei.',
      example: "Give me five more minutes. I'm not done yet.",
      exampleTranslation: 'Me dá mais cinco minutos. Ainda não terminei.',
      audioAsset: "audio/fase4/licao12/I'm_not_done_yet.mp3",
      ipa: '/aɪm ˈnɑt ˈdʌn ˈjɛt/',
      phonetic: 'aim NÁT DÂN IÉT',
      soundTip:
          'Em not done o t trava e o d já começa, sem vogal entre eles. '
          'Yet começa como um i rápido e fecha no t, sem soltar ar.',
    ),
    LessonItem(
      text: 'I never eat breakfast.',
      translation: 'Eu nunca tomo café da manhã.',
      example: "I'm not hungry in the morning. I never eat breakfast.",
      exampleTranslation:
          'Não sinto fome de manhã. Eu nunca tomo café da '
          'manhã.',
      audioAsset: 'audio/fase4/licao12/I_never_eat_breakfast.mp3',
      ipa: '/aɪ ˈnɛvəˈrit ˈbrɛkfəst/',
      phonetic: 'ai NÉ-vâ-RÍT BRÉK-fâst',
      soundTip:
          'Never eat se liga: né-vâ-rít, o r enrolado gruda no eat. Em '
          'breakfast a força é em BREAK, e o fast sai fraco, fâst.',
    ),
    LessonItem(
      text: "There's nothing to worry about.",
      translation: 'Não tem com o que se preocupar.',
      example: "The test results are fine. There's nothing to worry about.",
      exampleTranslation:
          'Os resultados do exame estão normais. Não tem com '
          'o que se preocupar.',
      audioAsset: "audio/fase4/licao12/There's_nothing_to_worry_about.mp3",
      ipa: '/ðɛrz ˈnʌθɪŋ tə ˈwɝi əˈbaʊt/',
      phonetic: 'thérz NÂ-thin tâ UÉ-ri â-BÁUT',
      soundTip:
          'Em nothing a língua sai entre os dentes, sem virar f nem t. '
          'O to fica fraco, tâ, e a força vai em NOTH e WOR.',
    ),
    LessonItem(
      text: 'Nobody uses cash anymore.',
      translation: 'Ninguém mais usa dinheiro vivo.',
      example: 'Do they take cards? Nobody uses cash anymore.',
      exampleTranslation:
          'Eles aceitam cartão? Ninguém mais usa dinheiro '
          'vivo.',
      audioAsset: 'audio/fase4/licao12/Nobody_uses_cash_anymore.mp3',
      ipa: '/ˈnoʊˌbɑdi ˈjuzəz ˈkæʃ ˌɛniˈmɔr/',
      phonetic: 'NÔU-bá-di IÚ-zâz KÉSH é-ni-MÓR',
      soundTip:
          'Uses termina zumbindo, iú-zâz. Anymore é uma palavra só, com '
          'a força no MORE e o r enrolado no fim.',
    ),
  ],
);

/// Lição 13 (revisão) — Revisão: dizer não: Revisão da zona.
const fase4Licao13 = Lesson(
  id: 'fase4-licao13',
  title: 'Revisão: dizer não',
  objective:
      'Você vai repetir uma frase de cada lição da zona em situações '
      'novas, até o não sair no automático.',
  microSkill: 'Revisão da zona',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "They don't know each other.",
      translation: 'Eles não se conhecem.',
      example: "It's their first meeting. They don't know each other.",
      exampleTranslation: 'É a primeira reunião deles. Eles não se conhecem.',
      audioAsset: "audio/fase4/licao08/They_don't_know_each_other.mp3",
      ipa: '/ðeɪ ˈdoʊn(t) ˈnoʊ iˈtʃʌðɚ/',
      phonetic: 'thêi DÔUN(t) NÔU i-TCHÂ-ther',
      soundTip:
          "O t do don't some antes do know. Each other vira um bloco "
          'só, i-tchâ-ther, com a língua entre os dentes no th e o r enrolado '
          'no fim.',
    ),
    LessonItem(
      text: "It doesn't matter.",
      translation: 'Não importa.',
      example: "A: Should I sit here or there? B: It doesn't matter.",
      exampleTranslation: 'A: Eu sento aqui ou ali? B: Não importa.',
      audioAsset: "audio/fase4/licao09/It_doesn't_matter.mp3",
      ipa: '/ɪt ˈdʌzn̩(t) ˈmæɾɚ/',
      phonetic: 'it DÂ-zn(t) MÉ-rer',
      soundTip:
          'No matter o t vira um r leve, de toque rápido: mé-rer. O '
          "doesn't fica DÂ-zn, e a voz desce no fim, sem drama.",
    ),
    LessonItem(
      text: "I'm not from around here.",
      translation: 'Não sou daqui.',
      example: "I'm not from around here, but I think it's that way.",
      exampleTranslation: 'Não sou daqui, mas acho que é por ali.',
      audioAsset: "audio/fase4/licao10/I'm_not_from_around_here.mp3",
      ipa: '/aɪm ˈnɑt frəməˈraʊnd ˈhɪr/',
      phonetic: 'aim NÁT frâ-mâ-RÁUND RRÍR',
      soundTip:
          'From around se liga: frâ-mâ-RÁUND, o m gruda na vogal. A '
          'força fica em NOT, ROUND e HERE, e o t do not trava sem soltar ar.',
    ),
    LessonItem(
      text: "You don't have to pay.",
      translation: 'Você não precisa pagar.',
      example: "The museum is free on Tuesdays. You don't have to pay.",
      exampleTranslation:
          'O museu é de graça às terças. Você não precisa '
          'pagar.',
      audioAsset: "audio/fase4/licao11/You_don't_have_to_pay.mp3",
      ipa: '/ju ˈdoʊn(t) ˈhæftə ˈpeɪ/',
      phonetic: 'iu DÔUN(t) RRÉF-tâ PÊI',
      soundTip:
          "Have to vira RRÉF-tâ, com f. O t do don't quase some antes "
          "do have, e a força vai em DON'T, HAVE e PAY.",
    ),
    LessonItem(
      text: 'I never eat breakfast.',
      translation: 'Eu nunca tomo café da manhã.',
      example: 'A: Want some toast? B: No, thanks. I never eat breakfast.',
      exampleTranslation:
          'A: Quer uma torrada? B: Não, obrigado. Eu nunca '
          'tomo café da manhã.',
      audioAsset: 'audio/fase4/licao12/I_never_eat_breakfast.mp3',
      ipa: '/aɪ ˈnɛvəˈrit ˈbrɛkfəst/',
      phonetic: 'ai NÉ-vâ-RÍT BRÉK-fâst',
      soundTip:
          'Never eat se liga: né-vâ-rít, o r enrolado gruda no eat. Em '
          'breakfast a força é em BREAK, e o fast sai fraco, fâst.',
    ),
  ],
);

/// Lição 14 — BÔNUS — Bônus: recusar e discordar com educação: Recusa e discordância educada.
const fase4Licao14 = Lesson(
  id: 'fase4-licao14',
  title: 'Bônus: recusar e discordar com educação',
  objective:
      'Você vai recusar e discordar com educação em frases mais '
      'longas, dando o motivo sem soar seco.',
  microSkill: 'Recusa e discordância educada',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: "That's not exactly what I mean.",
      translation: 'Não é bem isso que eu quero dizer.',
      example: "That's not exactly what I mean. Let me explain.",
      exampleTranslation:
          'Não é bem isso que eu quero dizer. Deixa eu '
          'explicar.',
      audioAsset: "audio/fase4/licao14/That's_not_exactly_what_I_mean.mp3",
      ipa: '/ðæts ˈnɑt ɪɡˈzæk(t)li wʌɾaɪ ˈmin/',
      phonetic: 'théts NÁT ig-ZÉK-li uâ-rai MÍN',
      soundTip:
          'O t do not trava e já entra o exactly, com força no ZÉK. '
          'What I vira uâ-rai, o t vira um r leve, e a frase fecha forte em '
          'MEAN.',
    ),
    LessonItem(
      text: "I don't think that's a good idea.",
      translation: 'Acho que não é uma boa ideia.',
      example: "Driving in this rain? I don't think that's a good idea.",
      exampleTranslation:
          'Dirigir com essa chuva? Acho que não é uma boa '
          'ideia.',
      audioAsset: "audio/fase4/licao14/I_don't_think_that's_a_good_idea.mp3",
      ipa: '/aɪ ˈdoʊn(t) ˈθɪŋk ðæts ə ˈɡʊd aɪˈdiə/',
      phonetic: 'ai DÔUN(t) THÍNK théts â GÚD ai-DÍ-â',
      soundTip:
          "O t do don't quase some antes do think, que sai com a língua "
          "entre os dentes. Força em DON'T, GOOD e no DE de idea.",
    ),
    LessonItem(
      text: "I can't stay long, I work early tomorrow.",
      translation: 'Não posso ficar muito, trabalho cedo amanhã.',
      example:
          "A: Stay for dinner! B: I can't stay long, I work early "
          'tomorrow.',
      exampleTranslation:
          'A: Fica pro jantar! B: Não posso ficar muito, '
          'trabalho cedo amanhã.',
      audioAsset:
          "audio/fase4/licao14/I_can't_stay_long_I_work_early_tomorrow.mp3",
      ipa: '/aɪ ˈkæn(t) ˈsteɪ ˈlɔŋ aɪ ˈwɝˈkɝli təˈmɑroʊ/',
      phonetic: 'ai KÉN(t) STÊI LÓN, ai UÉR-KÉR-li tâ-MÁ-rôu',
      soundTip:
          "Can't com boca aberta e força, t mudo, e o stay começa "
          'direto no s, sem vogal antes. Work early se liga: uér-kér-li.',
    ),
    LessonItem(
      text: "I see your point, but I don't agree.",
      translation: 'Entendo seu ponto, mas não concordo.',
      example: "I see your point, but I don't agree. The price is too high.",
      exampleTranslation:
          'Entendo seu ponto, mas não concordo. O preço está '
          'alto demais.',
      audioAsset: "audio/fase4/licao14/I_see_your_point_but_I_don't_agree.mp3",
      ipa: '/aɪ ˈsi jɚ ˈpɔɪnt bəɾaɪ ˈdoʊn(t) əˈɡri/',
      phonetic: 'ai SÍ iâr PÓINT, bâ-rai DÔUN(t) â-GRÍ',
      soundTip:
          "But I vira bâ-rai, com um r leve. Força em POINT, DON'T e "
          "GREE; o t do don't é só um corte rápido antes do agree.",
    ),
    LessonItem(
      text: "I'd rather not talk about it right now.",
      translation: 'Prefiro não falar disso agora.',
      example:
          "A: Is everything okay at work? B: I'd rather not talk about "
          'it right now.',
      exampleTranslation:
          'A: Está tudo bem no trabalho? B: Prefiro não falar '
          'disso agora.',
      audioAsset:
          "audio/fase4/licao14/I'd_rather_not_talk_about_it_right_now.mp3",
      ipa: '/aɪd ˈræðɚ ˈnɑt ˈtɔk əˈbaʊɾɪt ˈraɪt ˈnaʊ/',
      phonetic: 'aid RÉ-thâr NÁT TÓK â-BÁU-rit RÁIT NÁU',
      soundTip:
          'Rather leva a língua entre os dentes no th. O t de not se '
          'junta ao t de talk, e about it vira â-báu-rit, com um r leve.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// ZONA 3 — CONTAR O QUE ACONTECEU
// ---------------------------------------------------------------------------

/// Lição 15 — Contar o que você fez: passado irregular afirmativo.
const fase4Licao15 = Lesson(
  id: 'fase4-licao15',
  title: 'Contar o que você fez',
  objective:
      'Você vai contar em frases curtas o que fez, encontrou ou ouviu, '
      'com os verbos que mais aparecem quando alguém relata o dia.',
  microSkill: 'passado irregular afirmativo',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'I went home early.',
      translation: 'Fui para casa cedo.',
      example: 'I was tired, so I went home early.',
      exampleTranslation: 'Eu estava cansado, então fui para casa cedo.',
      audioAsset: 'audio/fase4/licao15/I_went_home_early.mp3',
      ipa: '/aɪ ˈwɛnt hoʊm ˈɝli/',
      phonetic: 'ai UÉNT rrôum ÂR-li',
      soundTip:
          'Força em WENT e EAR; o t de went é só a língua encostando, '
          'sem virar uenti. Early começa com a língua enrolada para trás.',
    ),
    LessonItem(
      text: 'I found my keys.',
      translation: 'Achei minhas chaves.',
      example: 'Good news: I found my keys in the car.',
      exampleTranslation: 'Boa notícia: achei minhas chaves no carro.',
      audioAsset: 'audio/fase4/licao15/I_found_my_keys.mp3',
      ipa: '/aɪ ˈfaʊnd maɪ ˈkiz/',
      phonetic: 'ai FÁUND mai KÍZ',
      soundTip:
          'Found fecha num d leve colado no my, sem faundi. Keys '
          'termina zumbindo, z e não s.',
    ),
    LessonItem(
      text: 'She told me everything.',
      translation: 'Ela me contou tudo.',
      example: "Don't worry, she told me everything.",
      exampleTranslation: 'Fica tranquilo, ela me contou tudo.',
      audioAsset: 'audio/fase4/licao15/She_told_me_everything.mp3',
      ipa: '/ʃi ˈtoʊld mi ˈɛvriθɪŋ/',
      phonetic: 'shi TÔULD mi ÉV-ri-thing',
      soundTip:
          'No told, a ponta da língua sobe para o L antes do d, sem '
          'virar tou. No th, a língua aparece entre os dentes e o ar sai.',
    ),
    LessonItem(
      text: 'We made it on time.',
      translation: 'A gente chegou a tempo.',
      example: 'The traffic was bad, but we made it on time.',
      exampleTranslation: 'O trânsito estava ruim, mas a gente chegou a tempo.',
      audioAsset: 'audio/fase4/licao15/We_made_it_on_time.mp3',
      ipa: '/wi ˈmeɪɾɪɾɑn ˈtaɪm/',
      phonetic: 'ui MÊI-ri-ran TÁIM',
      soundTip:
          'Made it on vira um bloco só, com o d e o t batendo de leve '
          'como o r de caro. A força fica em MADE e TIME.',
    ),
    LessonItem(
      text: 'They left without me.',
      translation: 'Eles foram embora sem mim.',
      example: 'I was five minutes late and they left without me.',
      exampleTranslation: 'Atrasei cinco minutos e eles foram embora sem mim.',
      audioAsset: 'audio/fase4/licao15/They_left_without_me.mp3',
      ipa: '/ðeɪ ˈlɛft wɪˈðaʊt mi/',
      phonetic: 'thêi LÉFT ui-THÁUT mi',
      soundTip:
          'Left termina seco no ft, sem lefti. Em without, a língua '
          'toca os dentes no th e a força cai no THOUT.',
    ),
  ],
);

/// Lição 16 — Dizer como foi e onde estava: was / were.
const fase4Licao16 = Lesson(
  id: 'fase4-licao16',
  title: 'Dizer como foi e onde estava',
  objective:
      'Você vai dizer como foi uma experiência e onde você ou outras '
      'pessoas estavam, e perguntar o mesmo a alguém.',
  microSkill: 'was / were',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Where were you?',
      translation: 'Onde você estava?',
      example: 'Where were you? I called you three times.',
      exampleTranslation: 'Onde você estava? Te liguei três vezes.',
      audioAsset: 'audio/fase4/licao16/Where_were_you.mp3',
      ipa: '/ˈwɛr wɚ ju/',
      phonetic: 'UÉR uâr iu',
      soundTip:
          'Força só no WHERE; o were sai curto e fraco, quase uâr, com '
          'a língua enrolada, e cola no you. A voz desce no fim.',
    ),
    LessonItem(
      text: 'It was amazing.',
      translation: 'Foi incrível.',
      example: 'A: How was the concert? B: It was amazing.',
      exampleTranslation: 'A: Como foi o show? B: Foi incrível.',
      audioAsset: 'audio/fase4/licao16/It_was_amazing.mp3',
      ipa: '/ɪt wəz əˈmeɪzɪŋ/',
      phonetic: 'it uâz â-MÊI-zing',
      soundTip:
          'It was sai fraco e rápido; was termina zumbindo e cola no a '
          'de amazing. Toda a força vai em MAY.',
    ),
    LessonItem(
      text: 'How was the trip?',
      translation: 'Como foi a viagem?',
      example: 'Welcome back! How was the trip?',
      exampleTranslation: 'Bem-vindo de volta! Como foi a viagem?',
      audioAsset: 'audio/fase4/licao16/How_was_the_trip.mp3',
      ipa: '/ˈhaʊ wəz ðə ˈtrɪp/',
      phonetic: 'RRÁU uâz thâ TRÍP',
      soundTip:
          'Was e the passam rápidos no meio; a força fica em HOW e '
          'TRIP. Trip fecha os lábios no p, sem tripi.',
    ),
    LessonItem(
      text: 'We were at home.',
      translation: 'A gente estava em casa.',
      example: 'A: Where were you guys? B: We were at home.',
      exampleTranslation: 'A: Onde vocês estavam? B: A gente estava em casa.',
      audioAsset: 'audio/fase4/licao16/We_were_at_home.mp3',
      ipa: '/wi wɚ ət ˈhoʊm/',
      phonetic: 'ui uâr ât RRÔUM',
      soundTip:
          'We were at sai num murmúrio rápido, com a língua enrolada no '
          'r. Só HOME tem força, e o h é só um sopro leve.',
    ),
    LessonItem(
      text: 'The traffic was terrible.',
      translation: 'O trânsito estava horrível.',
      example: "Sorry I'm late, the traffic was terrible.",
      exampleTranslation: 'Desculpa o atraso, o trânsito estava horrível.',
      audioAsset: 'audio/fase4/licao16/The_traffic_was_terrible.mp3',
      ipa: '/ðə ˈtræfɪk wəz ˈtɛrəbəl/',
      phonetic: 'thâ TRÉ-fik uâz TÉ-râ-bâl',
      soundTip:
          'Força em TRA e TE; was fica fraco no meio. Terrible tem três '
          'sílabas curtas e termina num L com a língua no céu da boca.',
    ),
  ],
);

/// Lição 17 — Perguntar o que a pessoa fez: perguntas com did.
const fase4Licao17 = Lesson(
  id: 'fase4-licao17',
  title: 'Perguntar o que a pessoa fez',
  objective:
      'Você vai perguntar se a pessoa fez algo, quando, onde e como '
      'foi, no ritmo rápido em que essas perguntas saem na conversa.',
  microSkill: 'perguntas com did',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Did you see it?',
      translation: 'Você viu?',
      example: 'Did you see it? The game was crazy.',
      exampleTranslation: 'Você viu? O jogo foi uma loucura.',
      audioAsset: 'audio/fase4/licao17/Did_you_see_it.mp3',
      ipa: '/dɪdʒə ˈsi ɪt/',
      phonetic: 'di-djâ SÍ-it',
      soundTip:
          'Did you vira um didja rápido e sem força; a força cai em '
          'SEE, que se liga no it. A voz sobe no fim.',
    ),
    LessonItem(
      text: 'Did you sleep well?',
      translation: 'Você dormiu bem?',
      example: 'Good morning! Did you sleep well?',
      exampleTranslation: 'Bom dia! Você dormiu bem?',
      audioAsset: 'audio/fase4/licao17/Did_you_sleep_well.mp3',
      ipa: '/dɪdʒə ˈslip ˈwɛl/',
      phonetic: 'di-djâ SLÍP UÉL',
      soundTip:
          'Sleep começa direto no s, sem isleep, e o i é longo. Well '
          'termina com a língua no céu da boca. A voz sobe no fim.',
    ),
    LessonItem(
      text: 'How did it go?',
      translation: 'Como foi?',
      example: 'You had the interview today, right? How did it go?',
      exampleTranslation: 'Você teve a entrevista hoje, né? Como foi?',
      audioAsset: 'audio/fase4/licao17/How_did_it_go.mp3',
      ipa: '/ˈhaʊ dɪɾɪt ˈɡoʊ/',
      phonetic: 'RRÁU di-rit GÔU',
      soundTip:
          'Did it vira um bloco só, com o d do meio batendo leve como o '
          'r de caro. Força em HOW e GO, e a voz desce no fim.',
    ),
    LessonItem(
      text: 'When did you get here?',
      translation: 'Quando você chegou?',
      example: "Hey, when did you get here? I didn't see you come in.",
      exampleTranslation: 'Ei, quando você chegou? Não te vi entrar.',
      audioAsset: 'audio/fase4/licao17/When_did_you_get_here.mp3',
      ipa: '/ˈwɛn dɪdʒə ɡɛt ˈhɪr/',
      phonetic: 'UÉN di-djâ guét RRÍR',
      soundTip:
          'Did you vira didja, fraco. O t de get só trava o ar antes do '
          'here, sem gueti. Força em WHEN e HERE.',
    ),
    LessonItem(
      text: 'Where did you buy it?',
      translation: 'Onde você comprou?',
      example: 'I love your jacket. Where did you buy it?',
      exampleTranslation: 'Adorei sua jaqueta. Onde você comprou?',
      audioAsset: 'audio/fase4/licao17/Where_did_you_buy_it.mp3',
      ipa: '/ˈwɛr dɪdʒə ˈbaɪ ɪt/',
      phonetic: 'UÉR di-djâ BÁI-it',
      soundTip:
          'Didja passa rápido no meio; buy e it se ligam num bloco só. '
          'O t final fica quase mudo, sem iti.',
    ),
  ],
);

/// Lição 18 — Dizer o que não aconteceu: didn't / wasn't / weren't.
const fase4Licao18 = Lesson(
  id: 'fase4-licao18',
  title: 'Dizer o que não aconteceu',
  objective:
      'Você vai dizer o que não fez, não sabia ou não estava '
      'acontecendo, sem travar na hora de negar.',
  microSkill: "didn't / wasn't / weren't",
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I didn't know.",
      translation: 'Eu não sabia.',
      example: "A: The meeting was canceled. B: Really? I didn't know.",
      exampleTranslation: 'A: A reunião foi cancelada. B: Sério? Eu não sabia.',
      audioAsset: "audio/fase4/licao18/I_didn't_know.mp3",
      ipa: '/aɪ ˈdɪdn̩t ˈnoʊ/',
      phonetic: 'ai DÍ-dnt NÔU',
      soundTip:
          "Didn't tem só uma vogal: depois do d, o som passa pelo "
          'nariz, sem dident. O t final quase some antes do know.',
    ),
    LessonItem(
      text: "It wasn't my fault.",
      translation: 'Não foi culpa minha.',
      example: "It wasn't my fault. The printer stopped working.",
      exampleTranslation:
          'Não foi culpa minha. A impressora parou de '
          'funcionar.',
      audioAsset: "audio/fase4/licao18/It_wasn't_my_fault.mp3",
      ipa: '/ɪt ˈwʌzn̩t maɪ ˈfɔlt/',
      phonetic: 'it UÂ-znt mai FÓLT',
      soundTip:
          "Wasn't sai num zumbido que vai direto para o nariz, sem "
          'uazenti. Fault tem L de verdade antes do t, sem virar fout.',
    ),
    LessonItem(
      text: "They weren't home.",
      translation: 'Eles não estavam em casa.',
      example: "We went to see them, but they weren't home.",
      exampleTranslation: 'Fomos visitar, mas eles não estavam em casa.',
      audioAsset: "audio/fase4/licao18/They_weren't_home.mp3",
      ipa: '/ðeɪ ˈwɝnt ˈhoʊm/',
      phonetic: 'thêi UÂRNT RRÔUM',
      soundTip:
          "Weren't é uma sílaba só, com a língua enrolada no r e o t "
          'quase mudo. Home começa com um sopro leve, sem raspar.',
    ),
    LessonItem(
      text: "We didn't have time.",
      translation: 'A gente não teve tempo.',
      example: "We didn't have time to see the museum.",
      exampleTranslation: 'A gente não teve tempo de ver o museu.',
      audioAsset: "audio/fase4/licao18/We_didn't_have_time.mp3",
      ipa: '/wi ˈdɪdn̩ hæv ˈtaɪm/',
      phonetic: 'ui DÍ-dn rrév TÁIM',
      soundTip:
          "O t de didn't some antes do have; o have sai rápido, só um "
          'sopro e o v. Força em DID e TIME.',
    ),
    LessonItem(
      text: "I didn't sleep at all.",
      translation: 'Não dormi nada.',
      example: "The neighbors had a party and I didn't sleep at all.",
      exampleTranslation: 'Os vizinhos fizeram festa e eu não dormi nada.',
      audioAsset: "audio/fase4/licao18/I_didn't_sleep_at_all.mp3",
      ipa: '/aɪ ˈdɪdn̩t ˈslip əˈɾɔl/',
      phonetic: 'ai DÍ-dnt SLÍ-pâ-RÓL',
      soundTip:
          'Sleep at all vira um bloco: o p se liga no at, e o t bate '
          'leve como o r de caro. A força final vai em ALL.',
    ),
  ],
);

/// Lição 19 — Dizer quando foi e o que veio depois: marcadores de tempo e sequência.
const fase4Licao19 = Lesson(
  id: 'fase4-licao19',
  title: 'Dizer quando foi e o que veio depois',
  objective:
      'Você vai situar no tempo o que aconteceu e contar a sequência '
      'dos fatos, como numa conversa sobre o seu dia ou a sua semana.',
  microSkill: 'marcadores de tempo e sequência',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'It happened last night.',
      translation: 'Aconteceu ontem à noite.',
      example: 'A: When was the accident? B: It happened last night.',
      exampleTranslation:
          'A: Quando foi o acidente? B: Aconteceu ontem à '
          'noite.',
      audioAsset: 'audio/fase4/licao19/It_happened_last_night.mp3',
      ipa: '/ɪt ˈhæpənd læs ˈnaɪt/',
      phonetic: 'it RRÉ-pând lés NÁIT',
      soundTip:
          'Happened tem duas sílabas e termina num d leve, sem '
          'happenedi. O t de last some antes do night.',
    ),
    LessonItem(
      text: 'I saw her yesterday.',
      translation: 'Eu vi ela ontem.',
      example: "A: How's Anna doing? B: Good, I saw her yesterday.",
      exampleTranslation: 'A: Como a Anna está? B: Bem, vi ela ontem.',
      audioAsset: 'audio/fase4/licao19/I_saw_her_yesterday.mp3',
      ipa: '/aɪ ˈsɔ ɚ ˈjɛstɚdeɪ/',
      phonetic: 'ai SÓ-âr IÉS-târ-dêi',
      soundTip:
          'O h de her some e ele cola no saw. Yesterday tem força só no '
          'YES, e o meio sai com a língua enrolada.',
    ),
    LessonItem(
      text: 'After that, we got lost.',
      translation: 'Depois disso, a gente se perdeu.',
      example: 'We left the hotel at nine. After that, we got lost.',
      exampleTranslation:
          'Saímos do hotel às nove. Depois disso, a gente se '
          'perdeu.',
      audioAsset: 'audio/fase4/licao19/After_that_we_got_lost.mp3',
      ipa: '/ˈæftɚ ˈðæt wi ɡɑt ˈlɔst/',
      phonetic: 'ÉF-târ THÉT, ui gat LÓST',
      soundTip:
          'After abre bem a boca no A e enrola a língua no fim. Faça '
          'uma pausa curta depois de that; o t de got só trava o ar.',
    ),
    LessonItem(
      text: 'First we ate, then we left.',
      translation: 'Primeiro a gente comeu, depois foi embora.',
      example: 'First we ate, then we left. We were back by ten.',
      exampleTranslation:
          'Primeiro a gente comeu, depois foi embora. '
          'Voltamos às dez.',
      audioAsset: 'audio/fase4/licao19/First_we_ate_then_we_left.mp3',
      ipa: '/ˈfɝst wi ˈeɪt ðɛn wi ˈlɛft/',
      phonetic: 'FÂRST ui ÊIT, thén ui LÉFT',
      soundTip:
          'Duas partes com o mesmo ritmo: força em FIRST e ATE, depois '
          'em THEN e LEFT. Ate termina seco no t, sem eiti.',
    ),
    LessonItem(
      text: 'I called you two days ago.',
      translation: 'Te liguei dois dias atrás.',
      example: "I called you two days ago, but you didn't answer.",
      exampleTranslation: 'Te liguei dois dias atrás, mas você não atendeu.',
      audioAsset: 'audio/fase4/licao19/I_called_you_two_days_ago.mp3',
      ipa: '/aɪ ˈkɔld jə ˈtu ˈdeɪz əˈɡoʊ/',
      phonetic: 'ai KÓLD iâ TU DÊI-zâ-GÔU',
      soundTip:
          'Called fecha num L e d leves, sem colledi. Days ago se liga '
          'num bloco, com o z colado no a. Força final em GO.',
    ),
  ],
);

/// Lição 20 (revisão) — Revisão: contar o que aconteceu: revisão do passado.
const fase4Licao20 = Lesson(
  id: 'fase4-licao20',
  title: 'Revisão: contar o que aconteceu',
  objective:
      'Você vai juntar o que treinou nesta zona: contar o que fez, '
      'como foi, perguntar, negar e dizer quando aconteceu.',
  microSkill: 'revisão do passado',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'We made it on time.',
      translation: 'A gente chegou a tempo.',
      example: 'We left late, but we made it on time.',
      exampleTranslation: 'A gente saiu tarde, mas chegou a tempo.',
      audioAsset: 'audio/fase4/licao15/We_made_it_on_time.mp3',
      ipa: '/wi ˈmeɪɾɪɾɑn ˈtaɪm/',
      phonetic: 'ui MÊI-ri-ran TÁIM',
      soundTip:
          'Made it on vira um bloco só, com o d e o t batendo de leve '
          'como o r de caro. A força fica em MADE e TIME.',
    ),
    LessonItem(
      text: 'How was the trip?',
      translation: 'Como foi a viagem?',
      example: 'A: How was the trip? B: Long, but really fun.',
      exampleTranslation: 'A: Como foi a viagem? B: Longa, mas bem divertida.',
      audioAsset: 'audio/fase4/licao16/How_was_the_trip.mp3',
      ipa: '/ˈhaʊ wəz ðə ˈtrɪp/',
      phonetic: 'RRÁU uâz thâ TRÍP',
      soundTip:
          'Was e the passam rápidos no meio; a força fica em HOW e '
          'TRIP. Trip fecha os lábios no p, sem tripi.',
    ),
    LessonItem(
      text: 'When did you get here?',
      translation: 'Quando você chegou?',
      example: 'A: When did you get here? B: About an hour ago.',
      exampleTranslation:
          'A: Quando você chegou? B: Faz mais ou menos uma '
          'hora.',
      audioAsset: 'audio/fase4/licao17/When_did_you_get_here.mp3',
      ipa: '/ˈwɛn dɪdʒə ɡɛt ˈhɪr/',
      phonetic: 'UÉN di-djâ guét RRÍR',
      soundTip:
          'Did you vira didja, fraco. O t de get só trava o ar antes do '
          'here, sem gueti. Força em WHEN e HERE.',
    ),
    LessonItem(
      text: "I didn't know.",
      translation: 'Eu não sabia.',
      example: "Sorry, I didn't know you were busy.",
      exampleTranslation: 'Desculpa, eu não sabia que você estava ocupado.',
      audioAsset: "audio/fase4/licao18/I_didn't_know.mp3",
      ipa: '/aɪ ˈdɪdn̩t ˈnoʊ/',
      phonetic: 'ai DÍ-dnt NÔU',
      soundTip:
          "Didn't tem só uma vogal: depois do d, o som passa pelo "
          'nariz, sem dident. O t final quase some antes do know.',
    ),
    LessonItem(
      text: 'I called you two days ago.',
      translation: 'Te liguei dois dias atrás.',
      example: "A: Why didn't you call me? B: I called you two days ago!",
      exampleTranslation:
          'A: Por que você não me ligou? B: Te liguei dois '
          'dias atrás!',
      audioAsset: 'audio/fase4/licao19/I_called_you_two_days_ago.mp3',
      ipa: '/aɪ ˈkɔld jə ˈtu ˈdeɪz əˈɡoʊ/',
      phonetic: 'ai KÓLD iâ TU DÊI-zâ-GÔU',
      soundTip:
          'Called fecha num L e d leves, sem colledi. Days ago se liga '
          'num bloco, com o z colado no a. Força final em GO.',
    ),
  ],
);

/// Lição 21 — BÔNUS — Bônus: uma pequena história: mini-história no passado.
const fase4Licao21 = Lesson(
  id: 'fase4-licao21',
  title: 'Bônus: uma pequena história',
  objective:
      'Você vai contar um acontecimento inteiro em frases mais longas, '
      'ligando o que houve, o problema e como terminou.',
  microSkill: 'mini-história no passado',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: 'What did you do after the meeting?',
      translation: 'O que você fez depois da reunião?',
      example:
          'What did you do after the meeting? Did you go back to the '
          'office?',
      exampleTranslation:
          'O que você fez depois da reunião? Voltou para o '
          'escritório?',
      audioAsset: 'audio/fase4/licao21/What_did_you_do_after_the_meeting.mp3',
      ipa: '/ˌwʌɾɪdʒə ˈdu ˈæftɚ ðə ˈmiɾɪŋ/',
      phonetic: 'uâ-ri-djâ DU ÉF-târ thâ MÍ-ring',
      soundTip:
          'What did you vira um bloco rápido, uaridja; a força vai em '
          'DO. No meeting, o t bate leve como o r de caro.',
    ),
    LessonItem(
      text: "I didn't see your message until this morning.",
      translation: 'Só vi sua mensagem hoje de manhã.',
      example: "Sorry, I didn't see your message until this morning.",
      exampleTranslation: 'Desculpa, só vi sua mensagem hoje de manhã.',
      audioAsset:
          "audio/fase4/licao21/I_didn't_see_your_message_until_this_morning.mp3",
      ipa: '/aɪ ˈdɪdn̩ ˈsi jɚ ˈmɛsɪdʒ ənˈtɪl ðɪs ˈmɔrnɪŋ/',
      phonetic: 'ai DÍ-dn SÍ iâr MÉ-sidj ân-TÍL this MÓR-ning',
      soundTip:
          'Your sai fraco, quase iâr. Message termina num dj curto, sem '
          'messagi. Until tem força no TIL, com L no fim.',
    ),
    LessonItem(
      text: 'I missed the bus, so I took a taxi.',
      translation: 'Perdi o ônibus, então peguei um táxi.',
      example: 'I missed the bus, so I took a taxi to work.',
      exampleTranslation:
          'Perdi o ônibus, então peguei um táxi para o '
          'trabalho.',
      audioAsset: 'audio/fase4/licao21/I_missed_the_bus_so_I_took_a_taxi.mp3',
      ipa: '/aɪ ˈmɪst ðə ˈbʌs soʊ aɪ ˈtʊk ə ˈtæksi/',
      phonetic: 'ai MÍST thâ BÂS, sôu ai TÚ-kâ TÉK-si',
      soundTip:
          'Missed termina em st, sem missedi. Took a se liga num túka '
          'rápido. Pausa curta depois de bus, e a força final vai em TAXI.',
    ),
    LessonItem(
      text: 'When I got home, I found the door open.',
      translation: 'Quando cheguei em casa, encontrei a porta aberta.',
      example:
          'When I got home, I found the door open, so I called the '
          'police.',
      exampleTranslation:
          'Quando cheguei em casa, encontrei a porta aberta, '
          'então chamei a polícia.',
      audioAsset:
          'audio/fase4/licao21/When_I_got_home_I_found_the_door_open.mp3',
      ipa: '/wɛn aɪ ˈɡɑt ˈhoʊm aɪ ˈfaʊnd ðə ˈdɔr ˈoʊpən/',
      phonetic: 'uén ai GÁT RRÔUM, ai FÁUND thâ DÓR ÔU-pân',
      soundTip:
          'A voz fica no alto em HOME, avisando que tem continuação, e '
          'desce em OPEN. O t de got só trava o ar, sem gáti.',
    ),
    LessonItem(
      text: 'We got there late, but it was worth it.',
      translation: 'A gente chegou tarde, mas valeu a pena.',
      example: 'The line was huge. We got there late, but it was worth it.',
      exampleTranslation:
          'A fila estava enorme. A gente chegou tarde, mas '
          'valeu a pena.',
      audioAsset:
          'audio/fase4/licao21/We_got_there_late_but_it_was_worth_it.mp3',
      ipa: '/wi ˈɡɑt ðɛr ˈleɪt bəɾɪt wəz ˈwɝθɪt/',
      phonetic: 'ui GÁT thér LÊIT, bâ-rit-uâz UÂR-thit',
      soundTip:
          'But it vira bârit, com o t batendo leve. Worth it se liga: '
          'língua entre os dentes no th e já entra no it. Força em WORTH.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// ZONA 4 — AGORA, PLANOS E EXPERIÊNCIAS
// ---------------------------------------------------------------------------

/// Lição 22 — Dizer o que está fazendo agora: I'm ...ing / what are you doing.
const fase4Licao22 = Lesson(
  id: 'fase4-licao22',
  title: 'Dizer o que está fazendo agora',
  objective:
      'Você vai dizer o que está fazendo neste momento e perguntar o '
      'que a outra pessoa está fazendo.',
  microSkill: "I'm ...ing / what are you doing",
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I'm driving.",
      translation: 'Estou dirigindo.',
      example: "A: Can you talk? B: Not now, I'm driving.",
      exampleTranslation: 'A: Pode falar? B: Agora não, estou dirigindo.',
      audioAsset: "audio/fase4/licao22/I'm_driving.mp3",
      ipa: '/aɪm ˈdraɪvɪŋ/',
      phonetic: 'aim DRÁI-ving',
      soundTip:
          "I'm sai curto e colado. Força em DRI, com o r de língua "
          'curvada sem tocar o céu da boca, e o ing termina no fundo da '
          'língua, sem gui.',
    ),
    LessonItem(
      text: 'What are you doing?',
      translation: 'O que você está fazendo?',
      example: 'Hey, what are you doing? Do you want to go for a walk?',
      exampleTranslation: 'Oi, o que você está fazendo? Quer dar uma volta?',
      audioAsset: 'audio/fase4/licao22/What_are_you_doing.mp3',
      ipa: '/ˌwʌɾɚjə ˈduɪŋ/',
      phonetic: 'uá-râr-iâ DÚ-ing?',
      soundTip:
          'What are you vira um bloco rápido e fraco, uárâriâ, com o t '
          'virando um r leve. A força cai em DO e a voz desce no fim.',
    ),
    LessonItem(
      text: "It's raining again.",
      translation: 'Está chovendo de novo.',
      example: "It's raining again. Don't forget your umbrella.",
      exampleTranslation: 'Está chovendo de novo. Não esquece o guarda-chuva.',
      audioAsset: "audio/fase4/licao22/It's_raining_again.mp3",
      ipa: '/ɪts ˈreɪnɪŋ əˈɡɛn/',
      phonetic: 'its RÊI-ning â-GUÉN',
      soundTip:
          "It's sai curto, colado no raining. O r começa com a língua "
          'curvada, sem rr de garganta. Força em RAIN e em GAIN, que fecha no '
          'n.',
    ),
    LessonItem(
      text: "I'm working on it.",
      translation: 'Já estou cuidando disso.',
      example: "A: Is the report ready? B: Not yet, I'm working on it.",
      exampleTranslation:
          'A: O relatório está pronto? B: Ainda não, já estou '
          'cuidando disso.',
      audioAsset: "audio/fase4/licao22/I'm_working_on_it.mp3",
      ipa: '/aɪm ˈwɝkɪŋ ɑn ɪt/',
      phonetic: 'aim UÉR-king á-nit',
      soundTip:
          'Força em WOR, com a boca em bico e o r enrolado. On it se '
          'liga num á-nit rápido, e o t final fica preso, sem vogal depois.',
    ),
    LessonItem(
      text: 'Are you still waiting outside?',
      translation: 'Você ainda está esperando lá fora?',
      example: "Are you still waiting outside? I'm coming down now.",
      exampleTranslation:
          'Você ainda está esperando lá fora? Já estou '
          'descendo.',
      audioAsset: 'audio/fase4/licao22/Are_you_still_waiting_outside.mp3',
      ipa: '/ɚ jə ˈstɪl ˈweɪɾɪŋ ˌaʊtˈsaɪd/',
      phonetic: 'âr-iâ STÍL UÊI-ring aut-SÁID?',
      soundTip:
          'Are you sai fraco, âr-iâ. Still começa direto no s, sem i '
          'antes, e o t de waiting vira um r leve. A voz sobe no fim.',
    ),
  ],
);

/// Lição 23 — Contar planos com data: planos: I'm ...ing / going to.
const fase4Licao23 = Lesson(
  id: 'fase4-licao23',
  title: 'Contar planos com data',
  objective:
      'Você vai contar seus planos já marcados, com dia e hora, e '
      'perguntar os da outra pessoa, do jeito que se fala numa conversa.',
  microSkill: "planos: I'm ...ing / going to",
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I'm leaving tomorrow.",
      translation: 'Vou embora amanhã.',
      example: "I'm leaving tomorrow, but I'll be back next week.",
      exampleTranslation: 'Vou embora amanhã, mas volto semana que vem.',
      audioAsset: "audio/fase4/licao23/I'm_leaving_tomorrow.mp3",
      ipa: '/aɪm ˈlivɪŋ təˈmɑroʊ/',
      phonetic: 'aim LÍ-ving tâ-MÁ-rou',
      soundTip:
          'O i de leaving é longo, com o v vibrando entre lábio e '
          'dentes. Tomorrow começa fraco, tâ, e a força cai em MOR.',
    ),
    LessonItem(
      text: "We're flying on Monday.",
      translation: 'A gente viaja na segunda.',
      example: "We're flying on Monday, early in the morning.",
      exampleTranslation: 'A gente viaja na segunda, logo cedo.',
      audioAsset: "audio/fase4/licao23/We're_flying_on_Monday.mp3",
      ipa: '/wɪr ˈflaɪɪŋ ɑn ˈmʌndeɪ/',
      phonetic: 'uír FLÁI-ing an MÂN-dei',
      soundTip:
          "We're encolhe num uír curto. Força em FLY e em MON; o on "
          'fica fraco e se liga no Monday, que começa com a boca meio '
          'fechada, mân.',
    ),
    LessonItem(
      text: "I'm meeting a client at five.",
      translation: 'Vou encontrar um cliente às cinco.',
      example: "I can't talk later. I'm meeting a client at five.",
      exampleTranslation:
          'Não consigo falar mais tarde. Vou encontrar um '
          'cliente às cinco.',
      audioAsset: "audio/fase4/licao23/I'm_meeting_a_client_at_five.mp3",
      ipa: '/aɪm ˈmiɾɪŋ ə ˈklaɪənt ət ˈfaɪv/',
      phonetic: 'aim MÍ-ring â KLÁI-ânt ât FÁIV',
      soundTip:
          'O t de meeting vira um r leve, míring. O a e o at saem '
          'fracos; força em MEET, CLI e FIVE, que termina vibrando o v.',
    ),
    LessonItem(
      text: 'Are you coming on Friday?',
      translation: 'Você vem na sexta?',
      example: 'A: Are you coming on Friday? B: Of course. What time?',
      exampleTranslation: 'A: Você vem na sexta? B: Claro. Que horas?',
      audioAsset: 'audio/fase4/licao23/Are_you_coming_on_Friday.mp3',
      ipa: '/ɚ jə ˈkʌmɪŋ ɑn ˈfraɪdeɪ/',
      phonetic: 'âr-iâ KÂ-ming an FRÁI-dei?',
      soundTip:
          'Are you sai fraco, âr-iâ. Coming soa KÂ-ming, de boca meio '
          'aberta, nunca kó. O on fica fraco e a voz sobe em FRIDAY.',
    ),
    LessonItem(
      text: "We're going to move next year.",
      translation: 'A gente vai se mudar no ano que vem.',
      example: "We're going to move next year, maybe to another city.",
      exampleTranslation:
          'A gente vai se mudar no ano que vem, talvez pra '
          'outra cidade.',
      audioAsset: "audio/fase4/licao23/We're_going_to_move_next_year.mp3",
      ipa: '/wɪr ˈɡʌnə ˈmuv nɛks ˈjɪr/',
      phonetic: 'uír GÂ-nâ MÚV néks IÍR',
      soundTip:
          'Going to encolhe num GÂ-nâ. Move tem u longo e termina '
          'vibrando o v; em next year o t quase some e o x cola no year.',
    ),
  ],
);

/// Lição 24 — Decidir e prometer na hora: will / I'll na hora.
const fase4Licao24 = Lesson(
  id: 'fase4-licao24',
  title: 'Decidir e prometer na hora',
  objective:
      'Você vai decidir, prometer e se oferecer para algo na hora, com '
      'frases curtas que saem sem pensar.',
  microSkill: "will / I'll na hora",
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I'll do it.",
      translation: 'Deixa que eu faço.',
      example: "A: Someone has to call the bank. B: I'll do it.",
      exampleTranslation:
          'A: Alguém tem que ligar pro banco. B: Deixa que eu '
          'faço.',
      audioAsset: "audio/fase4/licao24/I'll_do_it.mp3",
      ipa: '/aɪl ˈdu ɪt/',
      phonetic: 'ail DÚ-it',
      soundTip:
          "No I'll, a ponta da língua sobe e encosta atrás dos dentes "
          'de cima, sem virar aiu. Do it se liga, dú-it, com a força no DO.',
    ),
    LessonItem(
      text: "I'll call you back.",
      translation: 'Eu te ligo de volta.',
      example: "I'm in a meeting. I'll call you back in ten minutes.",
      exampleTranslation:
          'Estou numa reunião. Te ligo de volta em dez '
          'minutos.',
      audioAsset: "audio/fase4/licao24/I'll_call_you_back.mp3",
      ipa: '/aɪl ˈkɔl jə ˈbæk/',
      phonetic: 'ail KÓL iâ BÉK',
      soundTip:
          "I'll e call terminam com a língua tocando o céu da boca, "
          'nunca em u. O you fica fraco, iâ, e back abre bem a boca.',
    ),
    LessonItem(
      text: "I'll send it tonight.",
      translation: 'Eu mando hoje à noite.',
      example: "A: Did you finish the report? B: Almost. I'll send it tonight.",
      exampleTranslation:
          'A: Você terminou o relatório? B: Quase. Mando hoje '
          'à noite.',
      audioAsset: "audio/fase4/licao24/I'll_send_it_tonight.mp3",
      ipa: '/aɪl ˈsɛnd ɪt təˈnaɪt/',
      phonetic: 'ail SÉN-dit tâ-NÁIT',
      soundTip:
          "Mantenha o L do I'll com a língua no céu da boca. Send it "
          'vira séndit, e tonight começa fraco, com força em NIGHT e o t '
          'final preso.',
    ),
    LessonItem(
      text: "Don't worry, I'll be there.",
      translation: 'Fica tranquilo, eu vou estar lá.',
      example: "A: The meeting starts at nine. B: Don't worry, I'll be there.",
      exampleTranslation:
          'A: A reunião começa às nove. B: Fica tranquilo, eu '
          'vou estar lá.',
      audioAsset: "audio/fase4/licao24/Don't_worry_I'll_be_there.mp3",
      ipa: '/ˈdoʊnt ˈwɝi aɪl bi ˈðɛr/',
      phonetic: 'DÔUNT UÉ-ri, ail bi THÉR',
      soundTip:
          "Worry soa UÉ-ri, com o r enrolado e sem ó aberto. I'll be "
          'sai fraco e ligado, com o L tocando o céu da boca; a força fecha '
          'em THERE.',
    ),
    LessonItem(
      text: "I think I'll stay home today.",
      translation: 'Acho que vou ficar em casa hoje.',
      example: "I'm really tired. I think I'll stay home today.",
      exampleTranslation:
          'Estou muito cansado. Acho que vou ficar em casa '
          'hoje.',
      audioAsset: "audio/fase4/licao24/I_think_I'll_stay_home_today.mp3",
      ipa: '/aɪ ˈθɪŋk aɪl ˈsteɪ ˈhoʊm təˈdeɪ/',
      phonetic: 'ai THÍNK ail STÊI RRÔUM tâ-DÊI',
      soundTip:
          "No think a língua sai entre os dentes. O L do I'll fica "
          'firme antes do stay, que começa direto no s, sem i. Home fecha nos '
          'lábios.',
    ),
  ],
);

/// Lição 25 — Contar o que você já viveu: have you ever / I've never / I've been.
const fase4Licao25 = Lesson(
  id: 'fase4-licao25',
  title: 'Contar o que você já viveu',
  objective:
      'Você vai perguntar se alguém já fez alguma coisa e contar o que '
      'você já fez ou nunca fez.',
  microSkill: "have you ever / I've never / I've been",
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I've been there.",
      translation: 'Já estive lá.',
      example: "A: Do you know Salvador? B: Yes, I've been there.",
      exampleTranslation: 'A: Você conhece Salvador? B: Conheço, já estive lá.',
      audioAsset: "audio/fase4/licao25/I've_been_there.mp3",
      ipa: '/aɪv bɪn ˈðɛr/',
      phonetic: 'aiv bin THÉR',
      soundTip:
          "O V do I've não some: o lábio de baixo encosta nos dentes de "
          'cima e vibra antes do been. A força fica toda em THERE.',
    ),
    LessonItem(
      text: "I've never tried it.",
      translation: 'Nunca experimentei.',
      example: "Sushi? No, I've never tried it.",
      exampleTranslation: 'Sushi? Não, nunca experimentei.',
      audioAsset: "audio/fase4/licao25/I've_never_tried_it.mp3",
      ipa: '/aɪv ˈnɛvɚ ˈtraɪd ɪt/',
      phonetic: 'aiv NÉ-vâr TRÁI-dit',
      soundTip:
          "I've never tem dois v vibrando no lábio; não troque nenhum "
          'por u. Tried it se liga, trái-dit, e o t final fica preso.',
    ),
    LessonItem(
      text: 'Have you ever seen snow?',
      translation: 'Você já viu neve?',
      example:
          'Have you ever seen snow? I saw it for the first time last '
          'year.',
      exampleTranslation:
          'Você já viu neve? Eu vi pela primeira vez no ano '
          'passado.',
      audioAsset: 'audio/fase4/licao25/Have_you_ever_seen_snow.mp3',
      ipa: '/həv jə ˈɛvɚ ˈsin ˈsnoʊ/',
      phonetic: 'rrâv-iâ É-vâr SÍN SNÔU?',
      soundTip:
          'Have you sai fraco, rrâv-iâ. Força em EV, SEEN e SNOW; o '
          'snow começa direto no s, sem i antes. A voz sobe no fim.',
    ),
    LessonItem(
      text: "I've been to New York twice.",
      translation: 'Já fui pra Nova York duas vezes.',
      example: "I've been to New York twice, but never in the winter.",
      exampleTranslation:
          'Já fui pra Nova York duas vezes, mas nunca no '
          'inverno.',
      audioAsset: "audio/fase4/licao25/I've_been_to_New_York_twice.mp3",
      ipa: '/aɪv bɪn tə nu ˈjɔrk ˈtwaɪs/',
      phonetic: 'aiv bin tâ nu IÓRK TUÁIS',
      soundTip:
          "I've been to passa rápido, com o v vibrando e o to fraco. "
          'Força em YORK, com o r enrolado, e em TWICE, que termina em s, sem '
          'vogal.',
    ),
    LessonItem(
      text: 'Have you ever been to Canada?',
      translation: 'Você já foi pro Canadá?',
      example: "Have you ever been to Canada? I'm thinking of going in July.",
      exampleTranslation:
          'Você já foi pro Canadá? Estou pensando em ir em '
          'julho.',
      audioAsset: 'audio/fase4/licao25/Have_you_ever_been_to_Canada.mp3',
      ipa: '/həv jə ˈɛvɚ bɪn tə ˈkænədə/',
      phonetic: 'rrâv-iâ É-vâr bin tâ KÉ-nâ-dâ?',
      soundTip:
          'Have you ever been to sai como um bloco só, com força só no '
          'EV. Canada tem força no CA, com a boca bem aberta, e o resto '
          'fraco.',
    ),
  ],
);

/// Lição 26 — Dizer desde quando: for, since, how long, already, just.
const fase4Licao26 = Lesson(
  id: 'fase4-licao26',
  title: 'Dizer desde quando',
  objective:
      'Você vai dizer há quanto tempo algo acontece, o que acabou de '
      'fazer e o que já resolveu.',
  microSkill: 'for, since, how long, already, just',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'I just got here.',
      translation: 'Acabei de chegar.',
      example: 'A: Have you been waiting long? B: No, I just got here.',
      exampleTranslation:
          'A: Faz tempo que você está esperando? B: Não, '
          'acabei de chegar.',
      audioAsset: 'audio/fase4/licao26/I_just_got_here.mp3',
      ipa: '/aɪ ˌdʒʌs ˈɡɑt ˈhɪr/',
      phonetic: 'ai djâs GÁT RRÍR',
      soundTip:
          'O t de just quase some antes do got, e o t de got fica '
          'preso, sem vogal. O here começa com um sopro leve e leva a força.',
    ),
    LessonItem(
      text: "I've already done it.",
      translation: 'Já fiz.',
      example: "A: Don't forget to pay the bill. B: I've already done it.",
      exampleTranslation: 'A: Não esquece de pagar a conta. B: Já fiz.',
      audioAsset: "audio/fase4/licao26/I've_already_done_it.mp3",
      ipa: '/aɪv ɔlˈrɛdi ˈdʌn ɪt/',
      phonetic: 'aiv ól-RÉ-di DÂ-nit',
      soundTip:
          "Segure o V do I've vibrando no lábio antes do already. Força "
          'em READ e em DONE; done it se liga num dâ-nit, com o t preso.',
    ),
    LessonItem(
      text: "I've known her for years.",
      translation: 'Conheço ela há anos.',
      example: "Ana? Sure, I've known her for years.",
      exampleTranslation: 'A Ana? Claro, conheço ela há anos.',
      audioAsset: "audio/fase4/licao26/I've_known_her_for_years.mp3",
      ipa: '/aɪv ˈnoʊn ɚ fɚ ˈjɪrz/',
      phonetic: 'aiv NÔU-nâr fâr IÍRZ',
      soundTip:
          'O h do her some e ele cola no known: nôu-nâr. O for fica '
          'fraco, fâr; força em KNOWN e YEARS, que termina zumbindo.',
    ),
    LessonItem(
      text: 'How long have you been waiting?',
      translation: 'Há quanto tempo você está esperando?',
      example:
          'Sorry, the traffic was terrible. How long have you been '
          'waiting?',
      exampleTranslation:
          'Desculpa, o trânsito estava horrível. Há quanto '
          'tempo você está esperando?',
      audioAsset: 'audio/fase4/licao26/How_long_have_you_been_waiting.mp3',
      ipa: '/ˈhaʊ ˈlɔŋ əv jə bɪn ˈweɪɾɪŋ/',
      phonetic: 'RRÁU LÓN âv-iâ bin UÊI-ring?',
      soundTip:
          'Have you been passa num bloco fraco, âv-iâ-bin. A força fica '
          'em HOW LONG e em WAIT, com o t virando r leve. A voz desce no fim.',
    ),
    LessonItem(
      text: "I've lived here since last year.",
      translation: 'Moro aqui desde o ano passado.',
      example: "I've lived here since last year, and I really like it.",
      exampleTranslation: 'Moro aqui desde o ano passado, e gosto muito.',
      audioAsset: "audio/fase4/licao26/I've_lived_here_since_last_year.mp3",
      ipa: '/aɪv ˈlɪvd hɪr sɪns ˈlæst ˈjɪr/',
      phonetic: 'aiv LÍVD rrír sins LÉST IÍR',
      soundTip:
          'Lived termina com o v e o d juntos, sem vogal entre eles. '
          'Here e since saem fracos e rápidos; força em LIVED, LAST e YEAR.',
    ),
  ],
);

/// Lição 27 (revisão) — Revisão: agora, planos e experiências: revisão da zona.
const fase4Licao27 = Lesson(
  id: 'fase4-licao27',
  title: 'Revisão: agora, planos e experiências',
  objective:
      'Você vai retomar uma frase de cada lição da zona e gravar de '
      'novo, agora com o molde já no ouvido.',
  microSkill: 'revisão da zona',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I'm working on it.",
      translation: 'Já estou cuidando disso.',
      example: "A: Did you fix the printer? B: I'm working on it.",
      exampleTranslation:
          'A: Você consertou a impressora? B: Já estou '
          'cuidando disso.',
      audioAsset: "audio/fase4/licao22/I'm_working_on_it.mp3",
      ipa: '/aɪm ˈwɝkɪŋ ɑn ɪt/',
      phonetic: 'aim UÉR-king á-nit',
      soundTip:
          'Força em WOR, com a boca em bico e o r enrolado. On it se '
          'liga num á-nit rápido, e o t final fica preso, sem vogal depois.',
    ),
    LessonItem(
      text: "I'm meeting a client at five.",
      translation: 'Vou encontrar um cliente às cinco.',
      example: "Let's talk tomorrow. I'm meeting a client at five.",
      exampleTranslation:
          'Vamos falar amanhã. Vou encontrar um cliente às '
          'cinco.',
      audioAsset: "audio/fase4/licao23/I'm_meeting_a_client_at_five.mp3",
      ipa: '/aɪm ˈmiɾɪŋ ə ˈklaɪənt ət ˈfaɪv/',
      phonetic: 'aim MÍ-ring â KLÁI-ânt ât FÁIV',
      soundTip:
          'O t de meeting vira um r leve, míring. O a e o at saem '
          'fracos; força em MEET, CLI e FIVE, que termina vibrando o v.',
    ),
    LessonItem(
      text: "Don't worry, I'll be there.",
      translation: 'Fica tranquilo, eu vou estar lá.',
      example:
          "A: Are you coming to my birthday? B: Don't worry, I'll be "
          'there.',
      exampleTranslation:
          'A: Você vem no meu aniversário? B: Fica tranquilo, '
          'eu vou estar lá.',
      audioAsset: "audio/fase4/licao24/Don't_worry_I'll_be_there.mp3",
      ipa: '/ˈdoʊnt ˈwɝi aɪl bi ˈðɛr/',
      phonetic: 'DÔUNT UÉ-ri, ail bi THÉR',
      soundTip:
          "Worry soa UÉ-ri, com o r enrolado e sem ó aberto. I'll be "
          'sai fraco e ligado, com o L tocando o céu da boca; a força fecha '
          'em THERE.',
    ),
    LessonItem(
      text: 'Have you ever been to Canada?',
      translation: 'Você já foi pro Canadá?',
      example:
          'A: Have you ever been to Canada? B: No, but my sister lives '
          'there.',
      exampleTranslation:
          'A: Você já foi pro Canadá? B: Não, mas minha irmã '
          'mora lá.',
      audioAsset: 'audio/fase4/licao25/Have_you_ever_been_to_Canada.mp3',
      ipa: '/həv jə ˈɛvɚ bɪn tə ˈkænədə/',
      phonetic: 'rrâv-iâ É-vâr bin tâ KÉ-nâ-dâ?',
      soundTip:
          'Have you ever been to sai como um bloco só, com força só no '
          'EV. Canada tem força no CA, com a boca bem aberta, e o resto '
          'fraco.',
    ),
    LessonItem(
      text: 'How long have you been waiting?',
      translation: 'Há quanto tempo você está esperando?',
      example: "I'm so sorry! How long have you been waiting?",
      exampleTranslation:
          'Desculpa mesmo! Há quanto tempo você está '
          'esperando?',
      audioAsset: 'audio/fase4/licao26/How_long_have_you_been_waiting.mp3',
      ipa: '/ˈhaʊ ˈlɔŋ əv jə bɪn ˈweɪɾɪŋ/',
      phonetic: 'RRÁU LÓN âv-iâ bin UÊI-ring?',
      soundTip:
          'Have you been passa num bloco fraco, âv-iâ-bin. A força fica '
          'em HOW LONG e em WAIT, com o t virando r leve. A voz desce no fim.',
    ),
  ],
);

/// Lição 28 — BÔNUS — Bônus: agora, antes e depois: tempos misturados.
const fase4Licao28 = Lesson(
  id: 'fase4-licao28',
  title: 'Bônus: agora, antes e depois',
  objective:
      'Você vai juntar o agora, o passado e o futuro numa mesma frase, '
      'como acontece numa conversa de verdade.',
  microSkill: 'tempos misturados',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: "Have you seen it yet? You'll love it.",
      translation: 'Você já viu? Vai adorar.',
      example:
          "That new movie is amazing. Have you seen it yet? You'll love "
          'it.',
      exampleTranslation:
          'Aquele filme novo é incrível. Você já viu? Vai '
          'adorar.',
      audioAsset: "audio/fase4/licao28/Have_you_seen_it_yet_You'll_love_it.mp3",
      ipa: '/həv jə ˈsin ɪt ˈjɛt jul ˈlʌv ɪt/',
      phonetic: 'rrâv-iâ SÍ-nit IÉT? iul LÂ-vit',
      soundTip:
          "Seen it se liga, sí-nit, e a voz sobe no YET. No you'll a "
          'língua toca o céu da boca e já emenda no love it, lâ-vit.',
    ),
    LessonItem(
      text: "I've never been there, but I'd love to go.",
      translation: 'Nunca fui, mas adoraria ir.',
      example:
          "A: Have you been to Japan? B: I've never been there, but I'd "
          'love to go.',
      exampleTranslation:
          'A: Você já foi pro Japão? B: Nunca fui, mas '
          'adoraria ir.',
      audioAsset:
          "audio/fase4/licao28/I've_never_been_there_but_I'd_love_to_go.mp3",
      ipa: '/aɪv ˈnɛvɚ bɪn ˈðɛr bət aɪd ˈlʌv tə ˈɡoʊ/',
      phonetic: 'aiv NÉ-vâr bin THÉR, bât aid LÂV tâ GÔU',
      soundTip:
          "Mantenha o v de I've e o d de I'd, curtos mas presentes. "
          'Força em NEV, THERE, LOVE e GO; o but e o to saem fracos.',
    ),
    LessonItem(
      text: "I'm still at work, so I'll text you later.",
      translation:
          'Ainda estou no trabalho, então te mando mensagem mais '
          'tarde.',
      example:
          "A: Can you talk now? B: I'm still at work, so I'll text you "
          'later.',
      exampleTranslation:
          'A: Pode falar agora? B: Ainda estou no trabalho, '
          'então te mando mensagem mais tarde.',
      audioAsset:
          "audio/fase4/licao28/I'm_still_at_work_so_I'll_text_you_later.mp3",
      ipa: '/aɪm ˈstɪl ət ˈwɝk soʊ aɪl ˈtɛkst jə ˈleɪɾɚ/',
      phonetic: 'aim STÍL ât UÉRK, sôu ail TÉKS-tiâ LÊI-râr',
      soundTip:
          "Still começa direto no s. O L do I'll toca o céu da boca "
          'antes do text, e text you vira téks-tiâ. No later o t vira um r '
          'leve.',
    ),
    LessonItem(
      text: "We got here on Monday and we're leaving tomorrow.",
      translation: 'A gente chegou na segunda e vai embora amanhã.',
      example:
          "We got here on Monday and we're leaving tomorrow, so we only "
          'have one more day.',
      exampleTranslation:
          'A gente chegou na segunda e vai embora amanhã, '
          'então só temos mais um dia.',
      audioAsset:
          "audio/fase4/licao28/We_got_here_on_Monday_and_we're_leaving_tomorrow.mp3",
      ipa: '/wi ˈɡɑt hɪr ɑn ˈmʌndeɪ ən wɪr ˈlivɪŋ təˈmɑroʊ/',
      phonetic: 'ui GÁT rrír an MÂN-dei ân uír LÍ-ving tâ-MÁ-rou',
      soundTip:
          'And vira um ân fraco, sem d. O t de got trava antes do here; '
          'força em GOT, MON, LEAV e MOR, e o i de leaving é longo.',
    ),
    LessonItem(
      text: "I've already made plans, so I'll pass this time.",
      translation: 'Já tenho compromisso, então dessa vez vou passar.',
      example:
          'A: Do you want to come to the party tonight? B: Thanks, but '
          "I've already made plans, so I'll pass this time.",
      exampleTranslation:
          'A: Quer vir na festa hoje à noite? B: Obrigado, '
          'mas já tenho compromisso, então dessa vez vou passar.',
      audioAsset:
          "audio/fase4/licao28/I've_already_made_plans_so_I'll_pass_this_time.mp3",
      ipa: '/aɪv ɔlˈrɛdi ˈmeɪd ˈplænz soʊ aɪl ˈpæs ðɪs ˈtaɪm/',
      phonetic: 'aiv ól-RÉ-di MÊID PLÉNZ, sôu ail PÉS this TÁIM',
      soundTip:
          "O V do I've e o L do I'll ficam firmes, sem virar u. O d de "
          'made trava sem vogal antes do plans. Força em READ, PLANS, PASS e '
          'TIME.',
    ),
  ],
);
