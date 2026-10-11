import '../models/lesson.dart';
import '../models/trail.dart';

/// Lições da Trilha 2 ("Sons do inglês real" = Fase 2 do currículo),
/// organizadas pelas armadilhas de som do brasileiro — ver
/// docs/curriculo-fase2.md.
///
/// Zona 1 — Fim de palavra: o "i" fantasma, s- inicial, L/M/N/NG finais, -ED.
/// Zona 2 — Vogais que o português junta: pares mínimos.
/// Zona 3 — Consoantes traiçoeiras: R inicial e final, T/D sem chiado, TH.
/// Zona 4 — Ritmo e música da frase: schwa, força, palavras fracas, can/can't,
/// entonação de perguntas.
///
/// Mesmo formato da Trilha 1: cada zona tem 5 lições obrigatórias, uma
/// revisão (reaproveita os áudios da zona) e um bônus opcional
/// (`Lesson.bonus`), que nunca é pré-requisito. Ids sequenciais
/// (`fase2-licao01..28`), sem lacunas.
///
/// O item ensina pelo som, nunca pela letra: ouvir → repetir → feedback →
/// Livro Aberto (texto, IPA, fonética PT-BR e a `soundTip`, o "zoom" no ponto
/// difícil) → regravar. A fonética PT-BR aqui nunca escreve o erro que a lição
/// combate (sem "i" depois de consoante final, sem "u" no L final, etc.) —
/// quando o português não tem a letra certa, a dica de som explica.
///
/// Critério: o mesmo calibrado na Trilha 1 (accuracy ≥ 75 + fonema mínimo ≥
/// 65); a Zona 4 (ritmo/entonação) exige também prosódia ≥ 70, como as lições
/// de ritmo da Trilha 1. ⚠️ Ainda sem calibração com vozes brasileiras reais
/// nestas armadilhas — o Azure não avalia vogal INSERIDA (o "i" fantasma não é
/// um fonema do texto de referência), então ela só aparece indiretamente
/// (prosódia/fonema vizinho). Ajustar com dados de beta, não por opinião.
///
/// Áudio: `tool/gen_lesson_audio.sh` (função `gen2`) — o nome do arquivo é o
/// texto só com letras, dígitos e apóstrofo, espaços viram "_".
///
/// IPA e fonética são aproximações (inglês americano) — revisar com ouvido
/// nativo.
const fase2Zones = [
  Zone('Zona 1 — Fim de palavra', [
    fase2Licao01, fase2Licao02, fase2Licao03, fase2Licao04,
    fase2Licao05, fase2Licao06, fase2Licao07,
  ]),
  Zone('Zona 2 — Vogais que o português junta', [
    fase2Licao08, fase2Licao09, fase2Licao10, fase2Licao11,
    fase2Licao12, fase2Licao13, fase2Licao14,
  ]),
  Zone('Zona 3 — Consoantes traiçoeiras', [
    fase2Licao15, fase2Licao16, fase2Licao17, fase2Licao18,
    fase2Licao19, fase2Licao20, fase2Licao21,
  ]),
  Zone('Zona 4 — Ritmo e música da frase', [
    fase2Licao22, fase2Licao23, fase2Licao24, fase2Licao25,
    fase2Licao26, fase2Licao27, fase2Licao28,
  ]),
];

// ---------------------------------------------------------------------------
// ZONA 1 — FIM DE PALAVRA
// ---------------------------------------------------------------------------

/// Lição 1 — O "i" fantasma: Final em consoante, sem vogal extra.
const fase2Licao01 = Lesson(
  id: 'fase2-licao01',
  title: 'O "i" fantasma',
  objective: 'Você vai terminar palavras como "big" e "book" no som certo, '
      'sem a vogal extra que o português coloca depois da última consoante.',
  microSkill: 'Final em consoante, sem vogal extra',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'big',
      translation: 'grande',
      example: 'This is a big day for me.',
      exampleTranslation: 'Este é um grande dia para mim.',
      audioAsset: 'audio/fase2/licao01/big.mp3',
      ipa: '/bɪɡ/',
      phonetic: 'BÍG',
      soundTip: 'Termine com o fundo da língua colado no céu da boca e pare '
          'ali, sem abrir a boca de novo: big, não "bigui".',
    ),
    LessonItem(
      text: 'book',
      translation: 'livro / reservar',
      example: 'I want to book a table for two.',
      exampleTranslation: 'Quero reservar uma mesa para dois.',
      audioAsset: 'audio/fase2/licao01/book.mp3',
      ipa: '/bʊk/',
      phonetic: 'BÚK',
      soundTip: 'Trave o ar com o fundo da língua no céu da boca e corte o '
          'som. Nada de vogal depois: book, não "buqui".',
    ),
    LessonItem(
      text: 'keep',
      translation: 'manter / guardar / ficar com',
      example: 'You can keep the change.',
      exampleTranslation: 'Pode ficar com o troco.',
      audioAsset: 'audio/fase2/licao01/keep.mp3',
      ipa: '/kiːp/',
      phonetic: 'KÍP',
      soundTip: 'Feche os lábios no final e segure o ar um instante. Se a '
          'boca reabrir, nasce uma vogal: keep, não "kípi".',
    ),
    LessonItem(
      text: 'club',
      translation: 'clube / balada',
      example: 'We went to a club last night.',
      exampleTranslation: 'Fomos a uma balada ontem à noite.',
      audioAsset: 'audio/fase2/licao01/club.mp3',
      ipa: '/klʌb/',
      phonetic: 'KLÂB',
      soundTip: 'Feche os lábios no final com a voz ainda vibrando e não '
          'reabra a boca: club, não "clâbi".',
    ),
    LessonItem(
      text: 'Good luck.',
      translation: 'boa sorte',
      example: 'Good luck with your interview.',
      exampleTranslation: 'Boa sorte na sua entrevista.',
      audioAsset: 'audio/fase2/licao01/Good_luck.mp3',
      ipa: '/ɡʊd ˈlʌk/',
      phonetic: 'gud LÂK',
      soundTip: 'Encoste a ponta da língua atrás dos dentes no fim de "good" '
          'e termine "luck" travando no fundo da língua, sem vogal: não "gudi '
          'lâqui".',
    ),
  ],
);

/// Lição 2 — S sem "e" na frente: S + consoante no início, sem "e" antes.
const fase2Licao02 = Lesson(
  id: 'fase2-licao02',
  title: 'S sem "e" na frente',
  objective: 'Você vai começar palavras como "stay" e "space" direto no ssss, '
      'sem o "e" que o português coloca na frente.',
  microSkill: 'S + consoante no início, sem "e" antes',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'stay',
      translation: 'ficar / se hospedar',
      example: 'I want to stay one more day.',
      exampleTranslation: 'Quero ficar mais um dia.',
      audioAsset: 'audio/fase2/licao02/stay.mp3',
      ipa: '/steɪ/',
      phonetic: 'STÊI',
      soundTip: 'Comece com um ssss longo, como o som de uma cobra, e passe '
          'direto para o resto, sem vogal antes: stay, não "istêi".',
    ),
    LessonItem(
      text: 'space',
      translation: 'espaço',
      example: 'There is no space in my bag.',
      exampleTranslation: 'Não tem espaço na minha mala.',
      audioAsset: 'audio/fase2/licao02/space.mp3',
      ipa: '/speɪs/',
      phonetic: 'SPÊIS',
      soundTip: 'Faça o ssss com os dentes quase fechados e só depois junte '
          'os lábios para soltar o resto: space, não "ispêis".',
    ),
    LessonItem(
      text: 'snack',
      translation: 'lanche / petisco',
      example: 'I need a quick snack.',
      exampleTranslation: 'Preciso de um lanche rápido.',
      audioAsset: 'audio/fase2/licao02/snack.mp3',
      ipa: '/snæk/',
      phonetic: 'SNÉK',
      soundTip: 'Sopre o ssss e passe direto para o som pelo nariz, sem abrir '
          'a boca antes. No fim, trave o ar: snack, não "isnéqui".',
    ),
    LessonItem(
      text: 'skip',
      translation: 'pular / deixar de fazer',
      example: "Don't skip breakfast.",
      exampleTranslation: 'Não pule o café da manhã.',
      audioAsset: 'audio/fase2/licao02/skip.mp3',
      ipa: '/skɪp/',
      phonetic: 'SKÍP',
      soundTip: 'Comece no ssss com a boca quase fechada, trave no fundo da '
          'língua e termine de lábios fechados: skip, não "isquípi".',
    ),
    LessonItem(
      text: 'Please speak slowly.',
      translation: 'por favor, fale devagar',
      example: 'Please speak slowly, my English is basic.',
      exampleTranslation: 'Por favor, fale devagar, meu inglês é básico.',
      audioAsset: 'audio/fase2/licao02/Please_speak_slowly.mp3',
      ipa: '/pliːz spiːk ˈsloʊli/',
      phonetic: 'plíz spík SLÔU-li',
      soundTip: 'Saia do zumbido de "please" direto para o ssss de "speak", '
          'sem "i" no meio. Em "slowly", o mesmo: não "islôuli".',
    ),
  ],
);

/// Lição 3 — L no final: L final com a língua encostada.
const fase2Licao03 = Lesson(
  id: 'fase2-licao03',
  title: 'L no final',
  objective: 'Você vai fechar palavras como "feel" e "people" com a ponta da '
      'língua encostada no lugar certo, sem transformar o final em "u".',
  microSkill: 'L final com a língua encostada',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'feel',
      translation: 'sentir / se sentir',
      example: 'I feel tired today.',
      exampleTranslation: 'Estou me sentindo cansado hoje.',
      audioAsset: 'audio/fase2/licao03/feel.mp3',
      ipa: '/fiːl/',
      phonetic: 'FÍL',
      soundTip: 'No final, encoste a ponta da língua atrás dos dentes de cima '
          'e deixe ela lá até o som acabar: feel, não "fiu".',
    ),
    LessonItem(
      text: 'tell',
      translation: 'contar / dizer',
      example: 'Can you tell me the time?',
      exampleTranslation: 'Pode me dizer que horas são?',
      audioAsset: 'audio/fase2/licao03/tell.mp3',
      ipa: '/tɛl/',
      phonetic: 'TÉL',
      soundTip: 'Termine com a ponta da língua colada logo atrás dos dentes '
          'de cima, sem arredondar os lábios: tell, não "téu".',
    ),
    LessonItem(
      text: 'file',
      translation: 'arquivo',
      example: 'Can you send me the file?',
      exampleTranslation: 'Pode me mandar o arquivo?',
      audioAsset: 'audio/fase2/licao03/file.mp3',
      ipa: '/faɪl/',
      phonetic: 'FÁIL',
      soundTip: 'No final, suba a ponta da língua até atrás dos dentes de '
          'cima e segure ali: file, não "faiu".',
    ),
    LessonItem(
      text: 'people',
      translation: 'pessoas / gente',
      example: 'There are too many people here.',
      exampleTranslation: 'Tem gente demais aqui.',
      audioAsset: 'audio/fase2/licao03/people.mp3',
      ipa: '/ˈpiːpəl/',
      phonetic: 'PÍ-pel',
      soundTip: 'Depois de fechar os lábios pela segunda vez, vá direto para '
          'a língua encostada atrás dos dentes, quase sem vogal: não "pípou".',
    ),
    LessonItem(
      text: "I'll call you.",
      translation: 'eu te ligo',
      example: "I'll call you after the meeting.",
      exampleTranslation: 'Eu te ligo depois da reunião.',
      audioAsset: "audio/fase2/licao03/I'll_call_you.mp3",
      ipa: '/aɪl ˈkɔːl ju/',
      phonetic: 'ail KÓL iu',
      soundTip: 'Nos dois finais, deixe a ponta da língua encostada atrás dos '
          'dentes de cima até o som acabar: não "aiu cóu iu".',
    ),
  ],
);

/// Lição 4 — M, N e NG no final: Fechar os finais nasais.
const fase2Licao04 = Lesson(
  id: 'fase2-licao04',
  title: 'M, N e NG no final',
  objective: 'Você vai fechar de verdade os finais nasais: lábios fechados em '
      '"time", ponta da língua em "phone" e fundo da língua em "going", sem '
      'só anasalar a vogal.',
  microSkill: 'Fechar os finais nasais',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'time',
      translation: 'tempo / hora / vez',
      example: "I don't have time today.",
      exampleTranslation: 'Não tenho tempo hoje.',
      audioAsset: 'audio/fase2/licao04/time.mp3',
      ipa: '/taɪm/',
      phonetic: 'TÁIM',
      soundTip: 'No final, feche os lábios e deixe o som vibrar pelo nariz '
          'com a boca fechada. Só anasalar a vogal não basta: não "tãi".',
    ),
    LessonItem(
      text: 'phone',
      translation: 'telefone / celular',
      example: 'My phone is almost dead.',
      exampleTranslation: 'Meu celular está quase sem bateria.',
      audioAsset: 'audio/fase2/licao04/phone.mp3',
      ipa: '/foʊn/',
      phonetic: 'FÔUN',
      soundTip: 'No final, encoste a ponta da língua atrás dos dentes de cima '
          'e deixe o som sair pelo nariz: phone, não "fôu" anasalado.',
    ),
    LessonItem(
      text: 'young',
      translation: 'jovem',
      example: 'She is young but very smart.',
      exampleTranslation: 'Ela é jovem, mas muito inteligente.',
      audioAsset: 'audio/fase2/licao04/young.mp3',
      ipa: '/jʌŋ/',
      phonetic: 'IÂNG',
      soundTip: 'Termine com o fundo da língua colado no céu da boca e o som '
          'saindo pelo nariz. Não solte depois: young, não "iãngui".',
    ),
    LessonItem(
      text: 'going',
      translation: 'indo',
      example: 'Where are you going?',
      exampleTranslation: 'Aonde você está indo?',
      audioAsset: 'audio/fase2/licao04/going.mp3',
      ipa: '/ˈɡoʊɪŋ/',
      phonetic: 'GÔU-ing',
      soundTip: 'No final, suba o fundo da língua até o céu da boca e segure '
          'o som pelo nariz, sem "gui" e sem virar "in": não "gôuin".',
    ),
    LessonItem(
      text: "I'm leaving soon.",
      translation: 'vou sair daqui a pouco',
      example: "I'm leaving soon, do you need anything?",
      exampleTranslation: 'Vou sair daqui a pouco, precisa de alguma coisa?',
      audioAsset: "audio/fase2/licao04/I'm_leaving_soon.mp3",
      ipa: '/aɪm ˈliːvɪŋ suːn/',
      phonetic: 'aim LÍ-ving sún',
      soundTip: 'Três finais nasais: lábios fechados em "I\'m", fundo da '
          'língua no céu da boca em "leaving" e ponta da língua nos dentes em '
          '"soon".',
    ),
  ],
);

/// Lição 5 — -ED do passado: Final do passado sem sílaba extra.
const fase2Licao05 = Lesson(
  id: 'fase2-licao05',
  title: '-ED do passado',
  objective: 'Você vai falar o passado do jeito curto: na maioria dos verbos '
      'o final é só um som colado à palavra, não uma sílaba a mais.',
  microSkill: 'Final do passado sem sílaba extra',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'watched',
      translation: 'assistiu / assisti',
      example: 'We watched a movie last night.',
      exampleTranslation: 'Assistimos a um filme ontem à noite.',
      audioAsset: 'audio/fase2/licao05/watched.mp3',
      ipa: '/wɑːtʃt/',
      phonetic: 'UÓTCHT',
      soundTip: 'Uma sílaba só: depois do chiado, só um estalo seco da ponta '
          'da língua atrás dos dentes, sem voz: watched, não "uótchedi".',
    ),
    LessonItem(
      text: 'played',
      translation: 'jogou / tocou',
      example: 'They played soccer on Sunday.',
      exampleTranslation: 'Eles jogaram futebol no domingo.',
      audioAsset: 'audio/fase2/licao05/played.mp3',
      ipa: '/pleɪd/',
      phonetic: 'PLÊID',
      soundTip: 'Uma sílaba só: no fim, encoste a ponta da língua atrás dos '
          'dentes com a voz ainda soando e pare. Não "plêied".',
    ),
    LessonItem(
      text: 'moved',
      translation: 'se mudou / mudou',
      example: 'We moved to a new apartment.',
      exampleTranslation: 'Nós nos mudamos para um apartamento novo.',
      audioAsset: 'audio/fase2/licao05/moved.mp3',
      ipa: '/muːvd/',
      phonetic: 'MÚVD',
      soundTip: 'Deixe o lábio de baixo vibrando nos dentes de cima e feche '
          'com a ponta da língua atrás dos dentes. Uma sílaba: não "múvedi".',
    ),
    LessonItem(
      text: 'ended',
      translation: 'terminou / acabou',
      example: 'The meeting ended late.',
      exampleTranslation: 'A reunião terminou tarde.',
      audioAsset: 'audio/fase2/licao05/ended.mp3',
      ipa: '/ˈɛndɪd/',
      phonetic: 'ÉN-did',
      soundTip: 'Aqui o final vira sílaba, porque "end" já termina com a '
          'língua atrás dos dentes. Faça curta e fraca, sem chiado: não '
          '"éndjidi".',
    ),
    LessonItem(
      text: 'I cooked and cleaned.',
      translation: 'eu cozinhei e limpei',
      example: 'Yesterday I cooked and cleaned all day.',
      exampleTranslation: 'Ontem eu cozinhei e limpei o dia todo.',
      audioAsset: 'audio/fase2/licao05/I_cooked_and_cleaned.mp3',
      ipa: '/aɪ ˈkʊkt ən ˈkliːnd/',
      phonetic: 'ai KÚKT en KLÍND',
      soundTip: 'Dois passados, nenhuma sílaba extra: "cooked" fecha com um '
          'estalo seco, "cleaned" com a língua nos dentes e voz. Não '
          '"cuquédi".',
    ),
  ],
);

/// Lição 6 (revisão) — Revisão de sons — Zona 1: Progresso visível.
const fase2Licao06 = Lesson(
  id: 'fase2-licao06',
  title: 'Revisão de sons — Zona 1',
  objective: 'Uma palavra de cada lição que você já fez nesta zona. Veja se o '
      'começo e o fim das palavras continuam limpos, sem vogal extra.',
  microSkill: 'Progresso visível',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'big',
      translation: 'grande',
      example: 'This bag is too big.',
      exampleTranslation: 'Esta mala é grande demais.',
      audioAsset: 'audio/fase2/licao01/big.mp3',
      ipa: '/bɪɡ/',
      phonetic: 'BÍG',
      soundTip: 'Termine com o fundo da língua colado no céu da boca e pare '
          'ali, sem abrir a boca de novo: big, não "bigui".',
    ),
    LessonItem(
      text: 'stay',
      translation: 'ficar / se hospedar',
      example: 'How long are you going to stay?',
      exampleTranslation: 'Quanto tempo você vai ficar?',
      audioAsset: 'audio/fase2/licao02/stay.mp3',
      ipa: '/steɪ/',
      phonetic: 'STÊI',
      soundTip: 'Comece com um ssss longo, como o som de uma cobra, e passe '
          'direto para o resto, sem vogal antes: stay, não "istêi".',
    ),
    LessonItem(
      text: 'people',
      translation: 'pessoas / gente',
      example: 'I meet new people at work.',
      exampleTranslation: 'Conheço gente nova no trabalho.',
      audioAsset: 'audio/fase2/licao03/people.mp3',
      ipa: '/ˈpiːpəl/',
      phonetic: 'PÍ-pel',
      soundTip: 'Depois de fechar os lábios pela segunda vez, vá direto para '
          'a língua encostada atrás dos dentes, quase sem vogal: não "pípou".',
    ),
    LessonItem(
      text: 'going',
      translation: 'indo',
      example: "I'm going to the gym.",
      exampleTranslation: 'Estou indo para a academia.',
      audioAsset: 'audio/fase2/licao04/going.mp3',
      ipa: '/ˈɡoʊɪŋ/',
      phonetic: 'GÔU-ing',
      soundTip: 'No final, suba o fundo da língua até o céu da boca e segure '
          'o som pelo nariz, sem "gui" e sem virar "in": não "gôuin".',
    ),
    LessonItem(
      text: 'watched',
      translation: 'assistiu / assisti',
      example: 'I watched the game with friends.',
      exampleTranslation: 'Assisti ao jogo com amigos.',
      audioAsset: 'audio/fase2/licao05/watched.mp3',
      ipa: '/wɑːtʃt/',
      phonetic: 'UÓTCHT',
      soundTip: 'Uma sílaba só: depois do chiado, só um estalo seco da ponta '
          'da língua atrás dos dentes, sem voz: watched, não "uótchedi".',
    ),
  ],
);

/// Lição 7 — BÔNUS — Desafio: finais difíceis: Grupos de consoantes no final.
const fase2Licao07 = Lesson(
  id: 'fase2-licao07',
  title: 'Desafio: finais difíceis',
  objective: 'Bônus opcional — finais com duas ou três consoantes seguidas, '
      'como "changed" e "next". Não precisa fazer para concluir a Trilha 2.',
  microSkill: 'Grupos de consoantes no final',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: 'desk',
      translation: 'mesa de trabalho / balcão',
      example: 'My desk is a mess.',
      exampleTranslation: 'Minha mesa está uma bagunça.',
      audioAsset: 'audio/fase2/licao07/desk.mp3',
      ipa: '/dɛsk/',
      phonetic: 'DÉSK',
      soundTip: 'Depois do ssss, trave o ar com o fundo da língua no céu da '
          'boca e pare ali, sem vogal: desk, não "désqui".',
    ),
    LessonItem(
      text: 'next',
      translation: 'próximo',
      example: 'See you next week.',
      exampleTranslation: 'Até a semana que vem.',
      audioAsset: 'audio/fase2/licao07/next.mp3',
      ipa: '/nɛkst/',
      phonetic: 'NÉKST',
      soundTip: 'Três sons colados no final: trava no fundo da língua, ssss e '
          'a ponta nos dentes. Nenhuma vogal entre eles: não "nékisti".',
    ),
    LessonItem(
      text: 'changed',
      translation: 'mudou / mudei',
      example: 'I changed my plans.',
      exampleTranslation: 'Mudei meus planos.',
      audioAsset: 'audio/fase2/licao07/changed.mp3',
      ipa: '/tʃeɪndʒd/',
      phonetic: 'TCHÊINDJD',
      soundTip: 'Uma sílaba só: depois do "dj", encoste a ponta da língua '
          'atrás dos dentes com a voz ainda soando e pare. Não "tchêindjedi".',
    ),
    LessonItem(
      text: 'world',
      translation: 'mundo',
      example: 'She travels around the world.',
      exampleTranslation: 'Ela viaja pelo mundo.',
      audioAsset: 'audio/fase2/licao07/world.mp3',
      ipa: '/wɜːrld/',
      phonetic: 'UÉRLD',
      soundTip: 'Depois da vogal, curve a língua para trás e, sem soltar, '
          'encoste a ponta atrás dos dentes e feche. Uma sílaba: não "uôrdi".',
    ),
    LessonItem(
      text: 'I helped a friend.',
      translation: 'eu ajudei um amigo',
      example: 'I helped a friend move last weekend.',
      exampleTranslation: 'Ajudei um amigo na mudança no fim de semana '
          'passado.',
      audioAsset: 'audio/fase2/licao07/I_helped_a_friend.mp3',
      ipa: '/aɪ ˈhɛlpt ə ˈfrɛnd/',
      phonetic: 'ai RRÉLPT a FRÉND',
      soundTip: 'Em "helped", língua nos dentes, lábios fechados e um estalo '
          'seco que já emenda no "a". Termine "friend" com a língua presa: '
          'não "rrélpidi".',
    ),
  ],
);

// ---------------------------------------------------------------------------
// ZONA 2 — VOGAIS QUE O PORTUGUÊS JUNTA
// ---------------------------------------------------------------------------

/// Lição 8 — "ship" × "sheep": i curto × i longo.
const fase2Licao08 = Lesson(
  id: 'fase2-licao08',
  title: '"ship" × "sheep"',
  objective: 'Você vai separar o i curto e relaxado do i longo e esticado — é '
      'essa diferença que faz "ship" (navio) não virar "sheep" (ovelha).',
  microSkill: 'i curto × i longo',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'ship',
      translation: 'navio; enviar (mercadoria)',
      example: 'We ship all orders on Monday.',
      exampleTranslation: 'Nós enviamos todos os pedidos na segunda.',
      audioAsset: 'audio/fase2/licao08/ship.mp3',
      ipa: '/ʃɪp/',
      phonetic: 'CHÍP',
      soundTip: 'Faça um i curto e relaxado, quase um "ê", sem sorrir. Corte '
          'rápido e feche os lábios no fim: ship, não "chiip".',
    ),
    LessonItem(
      text: 'sheep',
      translation: 'ovelha',
      example: 'There are sheep on the farm near my house.',
      exampleTranslation: 'Tem ovelhas na fazenda perto da minha casa.',
      audioAsset: 'audio/fase2/licao08/sheep.mp3',
      ipa: '/ʃiːp/',
      phonetic: 'CHÍIP',
      soundTip: 'Sorria de leve, língua alta e firme, e estique o i o dobro '
          'do tempo do "ship". Feche os lábios no fim sem soltar vogal.',
    ),
    LessonItem(
      text: 'sit',
      translation: 'sentar(-se)',
      example: 'Please sit down and relax.',
      exampleTranslation: 'Por favor, sente-se e relaxe.',
      audioAsset: 'audio/fase2/licao08/sit.mp3',
      ipa: '/sɪt/',
      phonetic: 'SÍT',
      soundTip: 'Lábios soltos, sem sorriso, e um i bem curto puxando para o '
          '"ê". Pare a língua atrás dos dentes no fim: sit, não "siti".',
    ),
    LessonItem(
      text: 'seat',
      translation: 'assento, lugar',
      example: 'Is this seat taken?',
      exampleTranslation: 'Este lugar está ocupado?',
      audioAsset: 'audio/fase2/licao08/seat.mp3',
      ipa: '/siːt/',
      phonetic: 'SÍIT',
      soundTip: 'Lábios esticados como num sorriso e i longo e firme; só '
          'então encoste a língua atrás dos dentes. Curto demais, vira "sit" '
          '(sentar).',
    ),
    LessonItem(
      text: 'Is it cheap to ship?',
      translation: 'é barato enviar?',
      example: 'Is it cheap to ship a box to Brazil?',
      exampleTranslation: 'É barato mandar uma caixa para o Brasil?',
      audioAsset: 'audio/fase2/licao08/Is_it_cheap_to_ship.mp3',
      ipa: '/ɪz ɪt ˈtʃiːp tə ˈʃɪp/',
      phonetic: 'iz it TCHÍIP te CHÍP',
      soundTip: '"Is", "it" e "ship" saem curtos e relaxados; só "cheap" '
          'sorri e estica. Deixe essa única vogal longa bem clara na frase.',
    ),
  ],
);

/// Lição 9 — "full" × "fool": u curto × u longo.
const fase2Licao09 = Lesson(
  id: 'fase2-licao09',
  title: '"full" × "fool"',
  objective: 'Você vai separar o u curto e solto do u longo e arredondado — a '
      'diferença entre "full" (cheio) e "fool" (bobo), "pull" (puxar) e '
      '"pool" (piscina).',
  microSkill: 'u curto × u longo',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'full',
      translation: 'cheio, lotado',
      example: 'The restaurant is full tonight.',
      exampleTranslation: 'O restaurante está lotado hoje à noite.',
      audioAsset: 'audio/fase2/licao09/full.mp3',
      ipa: '/fʊl/',
      phonetic: 'FÚL',
      soundTip: 'Faça um u curto e frouxo, a meio caminho do "ô", sem bico '
          'nos lábios. Corte logo e termine com a ponta da língua atrás dos '
          'dentes.',
    ),
    LessonItem(
      text: 'fool',
      translation: 'bobo, tolo',
      example: 'I felt like a fool in the meeting.',
      exampleTranslation: 'Eu me senti um bobo na reunião.',
      audioAsset: 'audio/fase2/licao09/fool.mp3',
      ipa: '/fuːl/',
      phonetic: 'FÚUL',
      soundTip: 'Faça bico e estique o u o dobro do tempo; só então encoste a '
          'língua atrás dos dentes. Curto demais, quem ouve entende "full" '
          '(cheio).',
    ),
    LessonItem(
      text: 'pull',
      translation: 'puxar',
      example: "Pull the door, don't push it.",
      exampleTranslation: 'Puxe a porta, não empurre.',
      audioAsset: 'audio/fase2/licao09/pull.mp3',
      ipa: '/pʊl/',
      phonetic: 'PÚL',
      soundTip: 'Faça um u rápido e frouxo, sem bico, e termine com a ponta '
          'da língua atrás dos dentes. Se esticar, vira "pool" (piscina).',
    ),
    LessonItem(
      text: 'pool',
      translation: 'piscina',
      example: 'The hotel has a big pool.',
      exampleTranslation: 'O hotel tem uma piscina grande.',
      audioAsset: 'audio/fase2/licao09/pool.mp3',
      ipa: '/puːl/',
      phonetic: 'PÚUL',
      soundTip: 'Lábios em bico bem redondo e u longo antes de levar a língua '
          'para trás dos dentes. Segure a vogal: ela é o dobro da de "pull".',
    ),
    LessonItem(
      text: 'I cook good food.',
      translation: 'eu cozinho comida boa.',
      example: 'My friends say I cook good food.',
      exampleTranslation: 'Meus amigos dizem que eu cozinho comida boa.',
      audioAsset: 'audio/fase2/licao09/I_cook_good_food.mp3',
      ipa: '/aɪ ˈkʊk ˈɡʊd ˈfuːd/',
      phonetic: 'ai KÚK GÚD FÚUD',
      soundTip: '"Cook" e "good" têm o u curto e frouxo; "food" pede bico e u '
          'longo. Sinta os lábios avançarem só na última palavra.',
    ),
  ],
);

/// Lição 10 — "bad" × "bed": Boca bem aberta × "é" comum.
const fase2Licao10 = Lesson(
  id: 'fase2-licao10',
  title: '"bad" × "bed"',
  objective: 'Você vai abrir a boca num som que o português não tem — o que '
      'separa "bad" (ruim) de "bed" (cama) e "sad" (triste) de "said" '
      '(disse).',
  microSkill: 'Boca bem aberta × "é" comum',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'bad',
      translation: 'ruim',
      example: 'It was a bad day at work.',
      exampleTranslation: 'Foi um dia ruim no trabalho.',
      audioAsset: 'audio/fase2/licao10/bad.mp3',
      ipa: '/bæd/',
      phonetic: 'BÉÉD',
      soundTip: 'Abaixe bem o queixo, mais do que no "é", com a língua baixa '
          'e na frente. Uma vogal só, mais longa: bad, não "béd" (cama).',
    ),
    LessonItem(
      text: 'bed',
      translation: 'cama',
      example: 'I usually go to bed at eleven.',
      exampleTranslation: 'Eu costumo ir para a cama às onze.',
      audioAsset: 'audio/fase2/licao10/bed.mp3',
      ipa: '/bɛd/',
      phonetic: 'BÉD',
      soundTip: 'Aqui vale o "é" do português, curto e de boca meio aberta. '
          'Termine com a língua presa atrás dos dentes: bed, não "bédi".',
    ),
    LessonItem(
      text: 'sad',
      translation: 'triste',
      example: 'She was sad to leave her job.',
      exampleTranslation: 'Ela ficou triste de deixar o emprego.',
      audioAsset: 'audio/fase2/licao10/sad.mp3',
      ipa: '/sæd/',
      phonetic: 'SÉÉD',
      soundTip: 'Queixo bem para baixo, língua baixa e na frente, e mais '
          'duração na vogal. Com a boca só meio aberta, quem ouve entende '
          '"said" (disse).',
    ),
    LessonItem(
      text: 'said',
      translation: 'disse (passado de "say")',
      example: 'He said the meeting is at ten.',
      exampleTranslation: 'Ele disse que a reunião é às dez.',
      audioAsset: 'audio/fase2/licao10/said.mp3',
      ipa: '/sɛd/',
      phonetic: 'SÉD',
      soundTip: 'Vogal curta, boca meio aberta, igual ao "é" de "café". A '
          'escrita engana: não é "sêid", é um "é" só e rápido.',
    ),
    LessonItem(
      text: 'I left my bag.',
      translation: 'eu esqueci minha bolsa.',
      example: 'I think I left my bag in the taxi.',
      exampleTranslation: 'Acho que esqueci minha bolsa no táxi.',
      audioAsset: 'audio/fase2/licao10/I_left_my_bag.mp3',
      ipa: '/aɪ ˈlɛft maɪ ˈbæɡ/',
      phonetic: 'ai LÉFT mai BÉÉG',
      soundTip: '"Left" tem o "é" comum, de boca meio aberta; em "bag" o '
          'queixo cai bem mais. Deixe a boca abrir de verdade na última '
          'palavra.',
    ),
  ],
);

/// Lição 11 — "cup" × "cop": "â" curto × "á" aberto.
const fase2Licao11 = Lesson(
  id: 'fase2-licao11',
  title: '"cup" × "cop"',
  objective: 'Você vai separar o "â" curto e neutro do "á" bem aberto — para '
      '"cup" (xícara) não virar "cop" (policial) e sorte não virar fechadura.',
  microSkill: '"â" curto × "á" aberto',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'cup',
      translation: 'xícara',
      example: 'Can I have a cup of tea?',
      exampleTranslation: 'Pode me dar uma xícara de chá?',
      audioAsset: 'audio/fase2/licao11/cup.mp3',
      ipa: '/kʌp/',
      phonetic: 'KÂP',
      soundTip: 'Boca pouco aberta e relaxada, um "â" curto como o "a" fraco '
          'do fim de "casa". Se o queixo cair para "á", o americano entende '
          '"cop".',
    ),
    LessonItem(
      text: 'cop',
      translation: 'policial (informal)',
      example: 'A cop stopped my car last night.',
      exampleTranslation: 'Um policial parou meu carro ontem à noite.',
      audioAsset: 'audio/fase2/licao11/cop.mp3',
      ipa: '/kɑːp/',
      phonetic: 'KÁP',
      soundTip: 'Abra bem a boca, queixo para baixo, como no "á" de "pá", e '
          'deixe a vogal um pouco mais longa que a de "cup".',
    ),
    LessonItem(
      text: 'luck',
      translation: 'sorte',
      example: 'Wish me luck for tomorrow.',
      exampleTranslation: 'Me deseje sorte para amanhã.',
      audioAsset: 'audio/fase2/licao11/luck.mp3',
      ipa: '/lʌk/',
      phonetic: 'LÂK',
      soundTip: 'Um "â" rápido, com a boca quase fechada e a língua relaxada '
          'no meio. Termine no fundo da boca sem soltar vogal: luck, não '
          '"láki".',
    ),
    LessonItem(
      text: 'lock',
      translation: 'trancar; fechadura',
      example: 'Did you lock the car?',
      exampleTranslation: 'Você trancou o carro?',
      audioAsset: 'audio/fase2/licao11/lock.mp3',
      ipa: '/lɑːk/',
      phonetic: 'LÁK',
      soundTip: 'Queixo bem para baixo e um "á" aberto antes de fechar no '
          'fundo da boca. É a abertura da boca que separa trancar de sorte.',
    ),
    LessonItem(
      text: 'I got lucky.',
      translation: 'eu tive sorte.',
      example: 'I got lucky and found a cheap flight.',
      exampleTranslation: 'Eu tive sorte e achei um voo barato.',
      audioAsset: 'audio/fase2/licao11/I_got_lucky.mp3',
      ipa: '/aɪ ˈɡɑːt ˈlʌki/',
      phonetic: 'ai GÁT LÂ-ki',
      soundTip: 'Em "got" a boca abre bem, como no "á"; em "lucky" ela quase '
          'fecha num "â" curto. Sinta o queixo subir de uma palavra para a '
          'outra.',
    ),
  ],
);

/// Lição 12 — "work" × "walk": Vogal com R × "ó" aberto.
const fase2Licao12 = Lesson(
  id: 'fase2-licao12',
  title: '"work" × "walk"',
  objective: 'Você vai fazer a vogal com R do inglês, de língua enrolada, e '
      'separá-la do "ó" aberto — para "work" (trabalhar) não virar "walk" '
      '(caminhar).',
  microSkill: 'Vogal com R × "ó" aberto',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'work',
      translation: 'trabalhar; trabalho',
      example: 'I work from home on Fridays.',
      exampleTranslation: 'Eu trabalho de casa às sextas.',
      audioAsset: 'audio/fase2/licao12/work.mp3',
      ipa: '/wɜːrk/',
      phonetic: 'UÉRK',
      soundTip: 'Comece com os lábios em bico e logo enrole a língua para '
          'trás, como no R caipira, durante a vogal toda. Nada de "ó": work, '
          'não "uórk".',
    ),
    LessonItem(
      text: 'walk',
      translation: 'caminhar, andar a pé',
      example: 'I walk my dog every morning.',
      exampleTranslation: 'Eu passeio com meu cachorro toda manhã.',
      audioAsset: 'audio/fase2/licao12/walk.mp3',
      ipa: '/wɔːk/',
      phonetic: 'UÓK',
      soundTip: 'Boca aberta e arredondada num "ó" longo, com a língua solta '
          'e sem R. Não há som de l aqui: walk, não "uólk".',
    ),
    LessonItem(
      text: 'shirt',
      translation: 'camisa',
      example: 'I need a clean shirt for tomorrow.',
      exampleTranslation: 'Preciso de uma camisa limpa para amanhã.',
      audioAsset: 'audio/fase2/licao12/shirt.mp3',
      ipa: '/ʃɜːrt/',
      phonetic: 'CHÉRT',
      soundTip: 'Logo depois do "ch", enrole a língua para trás e segure esse '
          'R durante toda a vogal. Sem "ó" no meio: shirt, não "chórt".',
    ),
    LessonItem(
      text: 'short',
      translation: 'curto; baixo (de altura)',
      example: 'The meeting was short today.',
      exampleTranslation: 'A reunião foi curta hoje.',
      audioAsset: 'audio/fase2/licao12/short.mp3',
      ipa: '/ʃɔːrt/',
      phonetic: 'CHÓRT',
      soundTip: 'Primeiro um "ó" arredondado, não muito aberto; só no fim a '
          'língua enrola para o R. Em "shirt" o R começa logo, aqui ele chega '
          'depois.',
    ),
    LessonItem(
      text: 'I walk to work.',
      translation: 'eu vou a pé para o trabalho.',
      example: 'On sunny days I walk to work.',
      exampleTranslation: 'Nos dias de sol eu vou a pé para o trabalho.',
      audioAsset: 'audio/fase2/licao12/I_walk_to_work.mp3',
      ipa: '/aɪ ˈwɔːk tə ˈwɜːrk/',
      phonetic: 'ai UÓK te UÉRK',
      soundTip: '"Walk" abre a boca num "ó" sem R; "work" já sai com a língua '
          'enrolada. Se as duas soarem iguais, a frase perde o sentido.',
    ),
  ],
);

/// Lição 13 (revisão) — Revisão de sons — Zona 2: Vogais separadas, progresso visível.
const fase2Licao13 = Lesson(
  id: 'fase2-licao13',
  title: 'Revisão de sons — Zona 2',
  objective: 'Uma palavra de cada lição deste bloco — veja se as vogais que o '
      'português junta já saem separadas na sua boca.',
  microSkill: 'Vogais separadas, progresso visível',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'seat',
      translation: 'assento, lugar',
      example: 'Please take a seat.',
      exampleTranslation: 'Por favor, sente-se.',
      audioAsset: 'audio/fase2/licao08/seat.mp3',
      ipa: '/siːt/',
      phonetic: 'SÍIT',
      soundTip: 'Lábios esticados como num sorriso e i longo e firme; só '
          'então encoste a língua atrás dos dentes. Curto demais, vira "sit" '
          '(sentar).',
    ),
    LessonItem(
      text: 'pool',
      translation: 'piscina',
      example: 'Is there a pool at the hotel?',
      exampleTranslation: 'Tem piscina no hotel?',
      audioAsset: 'audio/fase2/licao09/pool.mp3',
      ipa: '/puːl/',
      phonetic: 'PÚUL',
      soundTip: 'Lábios em bico bem redondo e u longo antes de levar a língua '
          'para trás dos dentes. Segure a vogal: ela é o dobro da de "pull".',
    ),
    LessonItem(
      text: 'bad',
      translation: 'ruim',
      example: 'The traffic is really bad today.',
      exampleTranslation: 'O trânsito está muito ruim hoje.',
      audioAsset: 'audio/fase2/licao10/bad.mp3',
      ipa: '/bæd/',
      phonetic: 'BÉÉD',
      soundTip: 'Abaixe bem o queixo, mais do que no "é", com a língua baixa '
          'e na frente. Uma vogal só, mais longa: bad, não "béd" (cama).',
    ),
    LessonItem(
      text: 'cup',
      translation: 'xícara',
      example: 'I drink a cup of tea every morning.',
      exampleTranslation: 'Eu tomo uma xícara de chá toda manhã.',
      audioAsset: 'audio/fase2/licao11/cup.mp3',
      ipa: '/kʌp/',
      phonetic: 'KÂP',
      soundTip: 'Boca pouco aberta e relaxada, um "â" curto como o "a" fraco '
          'do fim de "casa". Se o queixo cair para "á", o americano entende '
          '"cop".',
    ),
    LessonItem(
      text: 'work',
      translation: 'trabalhar; trabalho',
      example: 'I start work at nine.',
      exampleTranslation: 'Eu começo a trabalhar às nove.',
      audioAsset: 'audio/fase2/licao12/work.mp3',
      ipa: '/wɜːrk/',
      phonetic: 'UÉRK',
      soundTip: 'Comece com os lábios em bico e logo enrole a língua para '
          'trás, como no R caipira, durante a vogal toda. Nada de "ó": work, '
          'não "uórk".',
    ),
  ],
);

/// Lição 14 — BÔNUS — Desafio: pares na mesma frase: Os dois sons do par na mesma frase.
const fase2Licao14 = Lesson(
  id: 'fase2-licao14',
  title: 'Desafio: pares na mesma frase',
  objective: 'Bônus opcional — os dois sons de cada par lado a lado, na mesma '
      'frase. Não precisa fazer para concluir a Trilha 2.',
  microSkill: 'Os dois sons do par na mesma frase',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: 'Please sit back in your seat.',
      translation: 'por favor, volte a se sentar no seu lugar.',
      example: 'We are landing soon, so please sit back in your seat.',
      exampleTranslation: 'Vamos pousar em breve, então, por favor, volte a '
          'se sentar no seu lugar.',
      audioAsset: 'audio/fase2/licao14/Please_sit_back_in_your_seat.mp3',
      ipa: '/pliːz ˈsɪt ˈbæk ɪn jɔːr ˈsiːt/',
      phonetic: 'pliz SÍT BÉK in iór SÍIT',
      soundTip: '"Please" e "seat" sorriem e esticam; "sit" sai curto e '
          'relaxado no meio. Deixe a diferença de duração bem audível.',
    ),
    LessonItem(
      text: 'His pool is full.',
      translation: 'a piscina dele está cheia.',
      example: 'His pool is full of leaves again.',
      exampleTranslation: 'A piscina dele está cheia de folhas de novo.',
      audioAsset: 'audio/fase2/licao14/His_pool_is_full.mp3',
      ipa: '/hɪz ˈpuːl ɪz ˈfʊl/',
      phonetic: 'rriz PÚUL iz FÚL',
      soundTip: 'Bico e u longo em "pool"; u curto e frouxo em "full". Se os '
          'dois saírem do mesmo tamanho, a frase vira ruído para quem ouve.',
    ),
    LessonItem(
      text: 'She said she was sad.',
      translation: 'ela disse que estava triste.',
      example: 'After the call she said she was sad.',
      exampleTranslation: 'Depois da ligação, ela disse que estava triste.',
      audioAsset: 'audio/fase2/licao14/She_said_she_was_sad.mp3',
      ipa: '/ʃi ˈsɛd ʃi wəz ˈsæd/',
      phonetic: 'chi SÉD chi uez SÉÉD',
      soundTip: '"Said" é um "é" curto e meio aberto; em "sad" o queixo cai '
          'bem mais. Mesmo começo, bocas diferentes.',
    ),
    LessonItem(
      text: 'One cup is not much.',
      translation: 'uma xícara não é muito.',
      example: 'I drink a lot of coffee, so one cup is not much.',
      exampleTranslation: 'Eu tomo muito café, então uma xícara não é muito.',
      audioAsset: 'audio/fase2/licao14/One_cup_is_not_much.mp3',
      ipa: '/wʌn ˈkʌp ɪz ˈnɑːt ˈmʌtʃ/',
      phonetic: 'uân KÂP iz NÁT MÂTCH',
      soundTip: '"One", "cup" e "much" pedem o "â" curto de boca quase '
          'fechada; só "not" abre num "á". Marque bem essa única abertura.',
    ),
    LessonItem(
      text: 'My shirt was too short.',
      translation: 'minha camisa ficou curta demais.',
      example: 'My shirt was too short, so I bought a new one.',
      exampleTranslation: 'Minha camisa ficou curta demais, então comprei uma '
          'nova.',
      audioAsset: 'audio/fase2/licao14/My_shirt_was_too_short.mp3',
      ipa: '/maɪ ˈʃɜːrt wəz ˈtuː ˈʃɔːrt/',
      phonetic: 'mai CHÉRT uez TÚ CHÓRT',
      soundTip: '"Shirt" já sai com a língua enrolada desde o começo; em '
          '"short" vem primeiro o "ó" e só depois o R.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// ZONA 3 — CONSOANTES TRAIÇOEIRAS
// ---------------------------------------------------------------------------

/// Lição 15 — R do começo não é H: R inicial com a língua curvada.
const fase2Licao15 = Lesson(
  id: 'fase2-licao15',
  title: 'R do começo não é H',
  objective: 'Você vai começar palavras com o R do inglês — língua curvada, '
      'sem raspar a garganta — para "red" não virar "rréd".',
  microSkill: 'R inicial com a língua curvada',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'red',
      translation: 'vermelho',
      example: 'I prefer red wine.',
      exampleTranslation: 'Eu prefiro vinho tinto.',
      audioAsset: 'audio/fase2/licao15/red.mp3',
      ipa: '/rɛd/',
      phonetic: 'RÉD',
      soundTip: 'Comece com a ponta da língua curvada para trás, sem encostar '
          'em nada, como o R caipira de "porta": red, não "rréd".',
    ),
    LessonItem(
      text: 'right',
      translation: 'certo / direita',
      example: 'Turn right at the next corner.',
      exampleTranslation: 'Vire à direita na próxima esquina.',
      audioAsset: 'audio/fase2/licao15/right.mp3',
      ipa: '/raɪt/',
      phonetic: 'RÁIT',
      soundTip: 'Lábios um pouco arredondados e língua recuada, sem tocar o '
          'céu da boca. Nada de ar raspando na garganta: right, não "rráit".',
    ),
    LessonItem(
      text: 'really',
      translation: 'mesmo / de verdade',
      example: 'I really need a break.',
      exampleTranslation: 'Eu preciso muito de uma pausa.',
      audioAsset: 'audio/fase2/licao15/really.mp3',
      ipa: '/ˈrɪli/',
      phonetic: 'RÍ-li',
      soundTip: 'A força vai no começo: língua puxada para trás e solta, sem '
          'raspar a garganta; depois a ponta sobe para o "li": really, não '
          '"rríli".',
    ),
    LessonItem(
      text: 'run',
      translation: 'correr',
      example: 'I run every morning before work.',
      exampleTranslation: 'Eu corro toda manhã antes do trabalho.',
      audioAsset: 'audio/fase2/licao15/run.mp3',
      ipa: '/rʌn/',
      phonetic: 'RÂN',
      soundTip: 'Faça um R caipira curto antes da vogal, garganta relaxada e '
          'sem atrito: run, não "rrân".',
    ),
    LessonItem(
      text: "It's raining right now.",
      translation: 'está chovendo agora mesmo.',
      example: "It's raining right now, so take an umbrella.",
      exampleTranslation: 'Está chovendo agora, então leve um guarda-chuva.',
      audioAsset: "audio/fase2/licao15/It's_raining_right_now.mp3",
      ipa: '/ɪts ˈreɪnɪŋ raɪt ˈnaʊ/',
      phonetic: 'its RÊI-ning rait NÁU',
      soundTip: 'Dois começos com R: em raining e em right, deixe a língua '
          'curvada para trás antes da vogal, sem nenhum raspar na garganta.',
    ),
  ],
);

/// Lição 16 — R no meio e no fim: R depois de vogal, sem sumir.
const fase2Licao16 = Lesson(
  id: 'fase2-licao16',
  title: 'R no meio e no fim',
  objective: 'O R americano depois de vogal não some, não raspa e não é '
      'batido. Você vai segurá-lo no meio e no fim das palavras.',
  microSkill: 'R depois de vogal, sem sumir',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'car',
      translation: 'carro',
      example: 'My car is in the parking lot.',
      exampleTranslation: 'Meu carro está no estacionamento.',
      audioAsset: 'audio/fase2/licao16/car.mp3',
      ipa: '/kɑːr/',
      phonetic: 'KÁR',
      soundTip: 'Depois da vogal, curve a ponta da língua para trás e segure '
          'o som com voz, sem tocar o céu da boca: car, não "ká" nem "kárr" '
          'raspado.',
    ),
    LessonItem(
      text: 'more',
      translation: 'mais',
      example: 'Can I have more time?',
      exampleTranslation: 'Posso ter mais tempo?',
      audioAsset: 'audio/fase2/licao16/more.mp3',
      ipa: '/mɔːr/',
      phonetic: 'MÓR',
      soundTip: 'Termine com os lábios arredondados e a língua puxada para '
          'trás, com voz até o fim: more, não "mó" nem com o R batido de '
          '"caro".',
    ),
    LessonItem(
      text: 'very',
      translation: 'muito',
      example: 'The meeting was very long.',
      exampleTranslation: 'A reunião foi muito longa.',
      audioAsset: 'audio/fase2/licao16/very.mp3',
      ipa: '/ˈvɛri/',
      phonetic: 'VÉ-ri',
      soundTip: 'No meio, a língua não bate no céu da boca como em "vera": '
          'ela só se curva para trás enquanto a voz continua.',
    ),
    LessonItem(
      text: 'corner',
      translation: 'esquina / canto',
      example: "There's a pharmacy on the corner.",
      exampleTranslation: 'Tem uma farmácia na esquina.',
      audioAsset: 'audio/fase2/licao16/corner.mp3',
      ipa: '/ˈkɔːrnər/',
      phonetic: 'KÓR-ner',
      soundTip: 'A língua se curva para trás duas vezes, no meio e no fim, '
          'sem bater em nada: corner, não o "córner" do futebol.',
    ),
    LessonItem(
      text: 'Where is my car?',
      translation: 'onde está meu carro?',
      example: 'Where is my car? I parked it here.',
      exampleTranslation: 'Onde está meu carro? Eu estacionei aqui.',
      audioAsset: 'audio/fase2/licao16/Where_is_my_car.mp3',
      ipa: '/wɛr ɪz maɪ ˈkɑːr/',
      phonetic: 'uér iz mai KÁR',
      soundTip: 'Segure a língua curvada no fim de where e de car, com voz, '
          'sem engolir o som nem raspar a garganta.',
    ),
  ],
);

/// Lição 17 — T e D sem chiado: T e D limpos antes do som de "i".
const fase2Licao17 = Lesson(
  id: 'fase2-licao17',
  title: 'T e D sem chiado',
  objective: 'Você vai falar "city", "idea" e "different" com a ponta da '
      'língua limpa, sem o chiado de "tchi" e "dji" do português.',
  microSkill: 'T e D limpos antes do som de "i"',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'team',
      translation: 'equipe / time',
      example: 'Our team works from home on Fridays.',
      exampleTranslation: 'Nossa equipe trabalha de casa às sextas.',
      audioAsset: 'audio/fase2/licao17/team.mp3',
      ipa: '/tiːm/',
      phonetic: 'TÍM',
      soundTip: 'Encoste a ponta da língua atrás dos dentes de cima e solte '
          'limpo, sem chiar: team, não "tchim".',
    ),
    LessonItem(
      text: 'different',
      translation: 'diferente',
      example: 'This plan is different from the last one.',
      exampleTranslation: 'Este plano é diferente do anterior.',
      audioAsset: 'audio/fase2/licao17/different.mp3',
      ipa: '/ˈdɪfrənt/',
      phonetic: 'DÍF-rent',
      soundTip: 'A força vai no começo: ponta da língua firme atrás dos '
          'dentes de cima, solte seco antes da vogal: different, não '
          '"djíferent".',
    ),
    LessonItem(
      text: 'idea',
      translation: 'ideia',
      example: "That's a great idea.",
      exampleTranslation: 'Essa é uma ótima ideia.',
      audioAsset: 'audio/fase2/licao17/idea.mp3',
      ipa: '/aɪˈdiːə/',
      phonetic: 'ai-DÍ-a',
      soundTip: 'Na sílaba forte, a ponta da língua toca atrás dos dentes e '
          'solta reto, sem chiado: idea, não "aidjía".',
    ),
    LessonItem(
      text: 'city',
      translation: 'cidade',
      example: 'I live in a big city.',
      exampleTranslation: 'Eu moro numa cidade grande.',
      audioAsset: 'audio/fase2/licao17/city.mp3',
      ipa: '/ˈsɪti/',
      phonetic: 'SÍ-ti',
      soundTip: 'No meio, só um toque rápido da ponta da língua atrás dos '
          'dentes, parecido com o r de "caro", sem chiar: city, não "sítchi".',
    ),
    LessonItem(
      text: "It's a different city.",
      translation: 'é uma cidade diferente.',
      example: "At night, it's a different city.",
      exampleTranslation: 'À noite, é uma cidade diferente.',
      audioAsset: "audio/fase2/licao17/It's_a_different_city.mp3",
      ipa: '/ɪts ə ˈdɪfrənt ˈsɪti/',
      phonetic: 'its e DÍF-rent SÍ-ti',
      soundTip: 'Dois pontos de atenção: o começo de different e o meio de '
          'city. A ponta da língua toca atrás dos dentes e solta, sem chiado.',
    ),
  ],
);

/// Lição 18 — TH sem voz: Língua entre os dentes, só ar.
const fase2Licao18 = Lesson(
  id: 'fase2-licao18',
  title: 'TH sem voz',
  objective: 'Você vai fazer o som de "think" e "thanks" com a língua entre '
      'os dentes e só ar — sem virar "fink", "tenks" ou "senks".',
  microSkill: 'Língua entre os dentes, só ar',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'think',
      translation: 'pensar / achar',
      example: 'I think we need more time.',
      exampleTranslation: 'Acho que precisamos de mais tempo.',
      audioAsset: 'audio/fase2/licao18/think.mp3',
      ipa: '/θɪŋk/',
      phonetic: 'THÍNK',
      soundTip: 'Ponta da língua levemente entre os dentes e sopre, sem voz, '
          'antes de abrir a vogal: think, não "fink" nem "tink".',
    ),
    LessonItem(
      text: 'thanks',
      translation: 'obrigado(a)',
      example: 'Thanks for the help today.',
      exampleTranslation: 'Obrigado pela ajuda hoje.',
      audioAsset: 'audio/fase2/licao18/thanks.mp3',
      ipa: '/θæŋks/',
      phonetic: 'THÉNKS',
      soundTip: 'Comece com a língua aparecendo um pouco entre os dentes e um '
          'sopro de ar, sem vibrar a garganta: thanks, não "tenks" nem '
          '"senks".',
    ),
    LessonItem(
      text: 'nothing',
      translation: 'nada',
      example: "There's nothing in the fridge.",
      exampleTranslation: 'Não tem nada na geladeira.',
      audioAsset: 'audio/fase2/licao18/nothing.mp3',
      ipa: '/ˈnʌθɪŋ/',
      phonetic: 'NÂ-thing',
      soundTip: 'No meio da palavra, a ponta da língua vai rápido até os '
          'dentes e o ar passa por cima dela, sem voz: nothing, não "nâfin".',
    ),
    LessonItem(
      text: 'both',
      translation: 'ambos / os dois',
      example: 'Both options work for me.',
      exampleTranslation: 'As duas opções funcionam pra mim.',
      audioAsset: 'audio/fase2/licao18/both.mp3',
      ipa: '/boʊθ/',
      phonetic: 'BÔUTH',
      soundTip: 'Termine com a língua entre os dentes soltando só ar, sem '
          'vogal depois: both, não "bôuf" nem "bôuti".',
    ),
    LessonItem(
      text: "I think it's nothing.",
      translation: 'acho que não é nada.',
      example: "Don't worry, I think it's nothing.",
      exampleTranslation: 'Não se preocupe, acho que não é nada.',
      audioAsset: "audio/fase2/licao18/I_think_it's_nothing.mp3",
      ipa: '/aɪ ˈθɪŋk ɪts ˈnʌθɪŋ/',
      phonetic: 'ai THÍNK its NÂ-thing',
      soundTip: 'Mesma posição duas vezes: língua entre os dentes e sopro sem '
          'voz em think e no meio de nothing, sem virar "fink" nem "nâtin".',
    ),
  ],
);

/// Lição 19 — TH com voz: Língua entre os dentes, com voz.
const fase2Licao19 = Lesson(
  id: 'fase2-licao19',
  title: 'TH com voz',
  objective: 'A mesma posição de língua da lição anterior, agora com a '
      'garganta vibrando: "this", "they" e "other" sem virar "dis", "dêi" ou '
      '"âder".',
  microSkill: 'Língua entre os dentes, com voz',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'they',
      translation: 'eles / elas',
      example: 'They work in the same office.',
      exampleTranslation: 'Eles trabalham no mesmo escritório.',
      audioAsset: 'audio/fase2/licao19/they.mp3',
      ipa: '/ðeɪ/',
      phonetic: 'THÊI',
      soundTip: 'Língua levemente entre os dentes, como em think, mas com a '
          'garganta vibrando: they, não "dêi" nem "zêi".',
    ),
    LessonItem(
      text: 'this',
      translation: 'este / isto',
      example: 'Is this seat free?',
      exampleTranslation: 'Este lugar está livre?',
      audioAsset: 'audio/fase2/licao19/this.mp3',
      ipa: '/ðɪs/',
      phonetic: 'THÍS',
      soundTip: 'Ponta da língua de leve na borda dos dentes de cima, com '
          'voz: this, não "dis". Mão no pescoço: tem que vibrar.',
    ),
    LessonItem(
      text: 'other',
      translation: 'outro',
      example: 'Use the other door, please.',
      exampleTranslation: 'Use a outra porta, por favor.',
      audioAsset: 'audio/fase2/licao19/other.mp3',
      ipa: '/ˈʌðər/',
      phonetic: 'Â-ther',
      soundTip: 'No meio, a língua avança até os dentes sem cortar a voz e '
          'depois recua curvada para o fim: other, não "âder".',
    ),
    LessonItem(
      text: 'together',
      translation: 'juntos',
      example: "Let's have lunch together.",
      exampleTranslation: 'Vamos almoçar juntos.',
      audioAsset: 'audio/fase2/licao19/together.mp3',
      ipa: '/təˈɡɛðər/',
      phonetic: 'te-GUÉ-ther',
      soundTip: 'A força vai no meio da palavra; logo depois, a língua toca '
          'os dentes com voz e termina curvada para trás: together, não '
          '"teguéder".',
    ),
    LessonItem(
      text: 'This is the other one.',
      translation: 'este é o outro.',
      example: 'Not that one. This is the other one.',
      exampleTranslation: 'Esse não. Este aqui é o outro.',
      audioAsset: 'audio/fase2/licao19/This_is_the_other_one.mp3',
      ipa: '/ðɪs ɪz ði ˈʌðər wʌn/',
      phonetic: 'this iz thi Â-ther uân',
      soundTip: 'Três vezes a mesma posição: em this, the e other, língua '
          'entre os dentes e garganta vibrando. Nada de "dis iz de âder".',
    ),
  ],
);

/// Lição 20 (revisão) — Revisão de sons — Zona 3: Os sons da zona juntos.
const fase2Licao20 = Lesson(
  id: 'fase2-licao20',
  title: 'Revisão de sons — Zona 3',
  objective: 'Um item de cada lição desta zona — o R, o T e D sem chiado e os '
      'dois TH. Veja como está sua pronúncia até aqui.',
  microSkill: 'Os sons da zona juntos',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'right',
      translation: 'certo / direita',
      example: 'Is this the right address?',
      exampleTranslation: 'Este é o endereço certo?',
      audioAsset: 'audio/fase2/licao15/right.mp3',
      ipa: '/raɪt/',
      phonetic: 'RÁIT',
      soundTip: 'Lábios um pouco arredondados e língua recuada, sem tocar o '
          'céu da boca. Nada de ar raspando na garganta: right, não "rráit".',
    ),
    LessonItem(
      text: 'car',
      translation: 'carro',
      example: 'I usually go to work by car.',
      exampleTranslation: 'Normalmente eu vou trabalhar de carro.',
      audioAsset: 'audio/fase2/licao16/car.mp3',
      ipa: '/kɑːr/',
      phonetic: 'KÁR',
      soundTip: 'Depois da vogal, curve a ponta da língua para trás e segure '
          'o som com voz, sem tocar o céu da boca: car, não "ká" nem "kárr" '
          'raspado.',
    ),
    LessonItem(
      text: 'different',
      translation: 'diferente',
      example: 'We have very different opinions.',
      exampleTranslation: 'Temos opiniões muito diferentes.',
      audioAsset: 'audio/fase2/licao17/different.mp3',
      ipa: '/ˈdɪfrənt/',
      phonetic: 'DÍF-rent',
      soundTip: 'A força vai no começo: ponta da língua firme atrás dos '
          'dentes de cima, solte seco antes da vogal: different, não '
          '"djíferent".',
    ),
    LessonItem(
      text: 'think',
      translation: 'pensar / achar',
      example: 'What do you think about it?',
      exampleTranslation: 'O que você acha disso?',
      audioAsset: 'audio/fase2/licao18/think.mp3',
      ipa: '/θɪŋk/',
      phonetic: 'THÍNK',
      soundTip: 'Ponta da língua levemente entre os dentes e sopre, sem voz, '
          'antes de abrir a vogal: think, não "fink" nem "tink".',
    ),
    LessonItem(
      text: 'together',
      translation: 'juntos',
      example: 'We work together on this project.',
      exampleTranslation: 'Nós trabalhamos juntos neste projeto.',
      audioAsset: 'audio/fase2/licao19/together.mp3',
      ipa: '/təˈɡɛðər/',
      phonetic: 'te-GUÉ-ther',
      soundTip: 'A força vai no meio da palavra; logo depois, a língua toca '
          'os dentes com voz e termina curvada para trás: together, não '
          '"teguéder".',
    ),
  ],
);

/// Lição 21 — BÔNUS — Desafio: TH e R juntos: TH e R na mesma palavra.
const fase2Licao21 = Lesson(
  id: 'fase2-licao21',
  title: 'Desafio: TH e R juntos',
  objective: 'Bônus opcional — palavras e uma frase que juntam TH e R no '
      'mesmo fôlego. Não precisa fazer para concluir a Trilha 2.',
  microSkill: 'TH e R na mesma palavra',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: 'three',
      translation: 'três',
      example: 'I have three meetings today.',
      exampleTranslation: 'Tenho três reuniões hoje.',
      audioAsset: 'audio/fase2/licao21/three.mp3',
      ipa: '/θriː/',
      phonetic: 'THRÍ',
      soundTip: 'Comece com a língua entre os dentes e um sopro sem voz, e só '
          'então recue a língua curvada para trás: three, não "tri" nem '
          '"fri".',
    ),
    LessonItem(
      text: 'north',
      translation: 'norte',
      example: 'The hotel is north of the city.',
      exampleTranslation: 'O hotel fica ao norte da cidade.',
      audioAsset: 'audio/fase2/licao21/north.mp3',
      ipa: '/nɔːrθ/',
      phonetic: 'NÓRTH',
      soundTip: 'Curve a língua para trás depois da vogal e, sem parar, '
          'avance a ponta até os dentes soltando só ar: north, não "nórti".',
    ),
    LessonItem(
      text: 'rather',
      translation: 'preferir (em "I\'d rather")',
      example: "I'd rather stay home tonight.",
      exampleTranslation: 'Prefiro ficar em casa hoje à noite.',
      audioAsset: 'audio/fase2/licao21/rather.mp3',
      ipa: '/ˈræðər/',
      phonetic: 'RÉ-ther',
      soundTip: 'Comece com a língua curvada, sem raspar; no meio ela vai aos '
          'dentes com voz e no fim volta a curvar: rather, não "rréder".',
    ),
    LessonItem(
      text: 'birthday',
      translation: 'aniversário',
      example: 'When is your birthday?',
      exampleTranslation: 'Quando é seu aniversário?',
      audioAsset: 'audio/fase2/licao21/birthday.mp3',
      ipa: '/ˈbɜːrθdeɪ/',
      phonetic: 'BÉRTH-dêi',
      soundTip: 'Segure a língua curvada na primeira sílaba e depois leve a '
          'ponta aos dentes soltando ar sem voz: birthday, não "bérfdei".',
    ),
    LessonItem(
      text: "My brother's birthday is on the third.",
      translation: 'o aniversário do meu irmão é no dia três.',
      example: "My brother's birthday is on the third. Let's celebrate.",
      exampleTranslation: 'O aniversário do meu irmão é no dia três. Vamos '
          'comemorar.',
      audioAsset:
          "audio/fase2/licao21/My_brother's_birthday_is_on_the_third.mp3",
      ipa: '/maɪ ˈbrʌðərz ˈbɜːrθdeɪ ɪz ɑːn ðə ˈθɜːrd/',
      phonetic: 'mai BRÂ-therz BÉRTH-dêi iz án the THÉRD',
      soundTip: 'Vá devagar: brother com voz no meio, birthday e third com '
          'sopro sem voz, e o R sempre curvado, nunca raspado.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// ZONA 4 — RITMO E MÚSICA DA FRASE
// ---------------------------------------------------------------------------

/// Lição 22 — A vogal fraca: Vogal fraca nas sílabas sem força.
const fase2Licao22 = Lesson(
  id: 'fase2-licao22',
  title: 'A vogal fraca',
  objective: 'Você vai encolher as sílabas sem força num "â" rápido — o '
      'detalhe que faz seu inglês soar natural, e não soletrado.',
  microSkill: 'Vogal fraca nas sílabas sem força',
  approvalThreshold: 75,
  minProsody: 70,
  items: [
    LessonItem(
      text: 'about',
      translation: 'sobre / cerca de',
      example: 'I will call you in about an hour.',
      exampleTranslation: 'Eu te ligo em cerca de uma hora.',
      audioAsset: 'audio/fase2/licao22/about.mp3',
      ipa: '/əˈbaʊt/',
      phonetic: 'â-BÁUT',
      soundTip: 'Comece com um "â" curtinho e solto, quase sumindo, e jogue a '
          'força toda no BÁUT. Não é "ê-báut" nem um "a" aberto.',
    ),
    LessonItem(
      text: 'today',
      translation: 'hoje',
      example: 'I have a lot of work today.',
      exampleTranslation: 'Tenho muito trabalho hoje.',
      audioAsset: 'audio/fase2/licao22/today.mp3',
      ipa: '/təˈdeɪ/',
      phonetic: 'tâ-DÊI',
      soundTip: 'O começo vira um "tâ" rápido e sem força, não "tu" '
          'caprichado; a voz só cresce no DÊI.',
    ),
    LessonItem(
      text: 'seven',
      translation: 'sete',
      example: 'The store opens at seven.',
      exampleTranslation: 'A loja abre às sete.',
      audioAsset: 'audio/fase2/licao22/seven.mp3',
      ipa: '/ˈsɛvən/',
      phonetic: 'SÉ-vân',
      soundTip: 'Toda a força no SÉ; o final encolhe num "ân" curto, com a '
          'ponta da língua tocando atrás dos dentes no fim. Não é "sé-vém".',
    ),
    LessonItem(
      text: 'breakfast',
      translation: 'café da manhã',
      example: 'We have breakfast at eight.',
      exampleTranslation: 'A gente toma café da manhã às oito.',
      audioAsset: 'audio/fase2/licao22/breakfast.mp3',
      ipa: '/ˈbrɛkfəst/',
      phonetic: 'BRÉK-fâst',
      soundTip: 'A força fica no BRÉK; a segunda parte encolhe num "fâst" '
          'rápido, nada de "fést" aberto. Feche no t sem soltar vogal.',
    ),
    LessonItem(
      text: 'Breakfast is at seven.',
      translation: 'o café da manhã é às sete.',
      example: 'Breakfast is at seven, so set your alarm.',
      exampleTranslation: 'O café da manhã é às sete, então põe o despertador.',
      audioAsset: 'audio/fase2/licao22/Breakfast_is_at_seven.mp3',
      ipa: '/ˈbrɛkfəst ɪz ət ˈsɛvən/',
      phonetic: 'BRÉK-fâst iz ât SÉ-vân',
      soundTip: 'Só BRÉK e SÉ levam força; todo o resto passa rápido e baixo, '
          'com "â" curtinho, como se a frase fosse uma palavra só.',
    ),
  ],
);

/// Lição 23 — A força da frase: Força nas palavras que dão o sentido.
const fase2Licao23 = Lesson(
  id: 'fase2-licao23',
  title: 'A força da frase',
  objective: 'Você vai dar força só às palavras que carregam o sentido e '
      'passar rápido pelas pequenas — é isso que dá ritmo de inglês à sua '
      'frase.',
  microSkill: 'Força nas palavras que dão o sentido',
  approvalThreshold: 75,
  minProsody: 70,
  items: [
    LessonItem(
      text: 'I need a break.',
      translation: 'preciso de uma pausa.',
      example: 'I need a break after this call.',
      exampleTranslation: 'Preciso de uma pausa depois desta ligação.',
      audioAsset: 'audio/fase2/licao23/I_need_a_break.mp3',
      ipa: '/aɪ ˈniːd ə ˈbreɪk/',
      phonetic: 'ai NÍD â BRÊIK',
      soundTip: 'A força vai em NEED e BREAK; o "a" do meio é só um "â" de '
          'passagem. Feche o break no k, sem "brêiki".',
    ),
    LessonItem(
      text: 'I work from home.',
      translation: 'eu trabalho de casa.',
      example: 'I work from home on Fridays.',
      exampleTranslation: 'Eu trabalho de casa às sextas.',
      audioAsset: 'audio/fase2/licao23/I_work_from_home.mp3',
      ipa: '/aɪ ˈwɜːrk frəm ˈhoʊm/',
      phonetic: 'ai UÉRK frâm RRÔUM',
      soundTip: 'Bata forte em WORK e HOME; o from encolhe num "frâm" rápido '
          'entre os dois. Termine com os lábios fechados no m.',
    ),
    LessonItem(
      text: "Let's grab some lunch.",
      translation: 'vamos almoçar.',
      example: "Let's grab some lunch after the meeting.",
      exampleTranslation: 'Vamos almoçar depois da reunião.',
      audioAsset: "audio/fase2/licao23/Let's_grab_some_lunch.mp3",
      ipa: '/lɛts ˈɡræb səm ˈlʌntʃ/',
      phonetic: 'léts GRÉB sâm LÂNTCH',
      soundTip: 'A força fica em GRAB e LUNCH; o some quase some, vira "sâm". '
          'Cole o b do grab no some, sem "grébi".',
    ),
    LessonItem(
      text: 'Pick me up at six.',
      translation: 'me busca às seis.',
      example: 'Can you pick me up at six tomorrow?',
      exampleTranslation: 'Você pode me buscar às seis amanhã?',
      audioAsset: 'audio/fase2/licao23/Pick_me_up_at_six.mp3',
      ipa: '/ˈpɪk mi ˈʌp ət ˈsɪks/',
      phonetic: 'PÍK mi ÂP ât SÍKS',
      soundTip: 'PICK, UP e SIX levam a força, e o SIX é o mais forte de '
          'todos; me e at passam rapidinho no meio.',
    ),
    LessonItem(
      text: 'Call me when you land.',
      translation: 'me liga quando pousar.',
      example: 'Have a good flight and call me when you land.',
      exampleTranslation: 'Boa viagem, e me liga quando pousar.',
      audioAsset: 'audio/fase2/licao23/Call_me_when_you_land.mp3',
      ipa: '/ˈkɔːl mi wɛn ju ˈlænd/',
      phonetic: 'KÓL mi uén iu LÉND',
      soundTip: 'A força fica em CALL e LAND, no começo e no fim; me, when e '
          'you correm baixinho no meio, sem pausa.',
    ),
  ],
);

/// Lição 24 — Palavras pequenas, som pequeno: Formas fracas: to, for, of, and, at.
const fase2Licao24 = Lesson(
  id: 'fase2-licao24',
  title: 'Palavras pequenas, som pequeno',
  objective: 'Você vai encolher to, for, of, and e at como no inglês falado '
      'de verdade — e parar de travar a frase dando a mesma força a cada '
      'palavra.',
  microSkill: 'Formas fracas: to, for, of, and, at',
  approvalThreshold: 75,
  minProsody: 70,
  items: [
    LessonItem(
      text: 'a cup of coffee',
      translation: 'uma xícara de café',
      example: 'I start every day with a cup of coffee.',
      exampleTranslation: 'Eu começo todo dia com uma xícara de café.',
      audioAsset: 'audio/fase2/licao24/a_cup_of_coffee.mp3',
      ipa: '/ə ˈkʌp əv ˈkɔːfi/',
      phonetic: 'â KÂP âv CÓ-fi',
      soundTip: 'O of vira um "âv" bem curto, grudado no cup, sem "óf" '
          'separado e forte. A força fica em CUP e CO.',
    ),
    LessonItem(
      text: 'black and white',
      translation: 'preto e branco',
      example: 'The old photos are all black and white.',
      exampleTranslation: 'As fotos antigas são todas em preto e branco.',
      audioAsset: 'audio/fase2/licao24/black_and_white.mp3',
      ipa: '/ˈblæk ən ˈwaɪt/',
      phonetic: 'BLÉK ân UÁIT',
      soundTip: 'O and encolhe num "ân" rápido entre as duas palavras fortes, '
          'sem "énd" caprichado: as três saem num bloco só.',
    ),
    LessonItem(
      text: 'I need to go.',
      translation: 'eu preciso ir.',
      example: 'Sorry, I need to go. My bus is here.',
      exampleTranslation: 'Desculpa, preciso ir. Meu ônibus chegou.',
      audioAsset: 'audio/fase2/licao24/I_need_to_go.mp3',
      ipa: '/aɪ ˈniːd tə ˈɡoʊ/',
      phonetic: 'ai NÍD tâ GÔU',
      soundTip: 'O to vira "tâ", rápido e sem força, não "tu"; o d do need só '
          'encosta e já emenda nele. A força fica em NEED e GO.',
    ),
    LessonItem(
      text: "It's for you.",
      translation: 'é pra você.',
      example: "This gift? It's for you.",
      exampleTranslation: 'Este presente? É pra você.',
      audioAsset: "audio/fase2/licao24/It's_for_you.mp3",
      ipa: '/ɪts fər ˈjuː/',
      phonetic: 'its fâr IÚ',
      soundTip: 'O for encolhe num "fâr" curtinho, sem "fór" aberto; quem '
          'leva a força da frase é o you, no fim.',
    ),
    LessonItem(
      text: "I'm at work.",
      translation: 'estou no trabalho.',
      example: "Sorry, I can't talk now. I'm at work.",
      exampleTranslation: 'Desculpa, não posso falar agora. Estou no trabalho.',
      audioAsset: "audio/fase2/licao24/I'm_at_work.mp3",
      ipa: '/aɪm ət ˈwɜːrk/',
      phonetic: 'aim ât UÉRK',
      soundTip: 'O at vira um "ât" rápido e grudado no work, sem "éti". A '
          'força toda vai no WORK.',
    ),
  ],
);

/// Lição 25 — "can" × "can't": can fraco × can't forte.
const fase2Licao25 = Lesson(
  id: 'fase2-licao25',
  title: '"can" × "can\'t"',
  objective: 'Você vai fazer o "can" e o "can\'t" soarem diferentes de verdade '
      '— pra ninguém entender o contrário do que você quis dizer.',
  microSkill: "can fraco × can't forte",
  approvalThreshold: 75,
  minProsody: 70,
  items: [
    LessonItem(
      text: 'I can come.',
      translation: 'eu posso ir.',
      example: 'Yes, I can come to your party.',
      exampleTranslation: 'Sim, posso ir na sua festa.',
      audioAsset: 'audio/fase2/licao25/I_can_come.mp3',
      ipa: '/aɪ kən ˈkʌm/',
      phonetic: 'ai kân KÂM',
      soundTip: 'No afirmativo o can é fraco e rápido, um "kân" sem força; a '
          'força vai toda no come.',
    ),
    LessonItem(
      text: "I can't come.",
      translation: 'não posso ir.',
      example: "Sorry, I can't come tonight.",
      exampleTranslation: 'Desculpa, não posso ir hoje à noite.',
      audioAsset: "audio/fase2/licao25/I_can't_come.mp3",
      ipa: '/aɪ ˈkænt ˈkʌm/',
      phonetic: 'ai KÉNT KÂM',
      soundTip: 'No negativo o can\'t é forte: boca bem aberta no "é" e um t '
          'que só trava o ar, sem soltar vogal. Não é "kéntchi".',
    ),
    LessonItem(
      text: 'I can wait.',
      translation: 'eu posso esperar.',
      example: 'No rush. I can wait.',
      exampleTranslation: 'Sem pressa. Eu posso esperar.',
      audioAsset: 'audio/fase2/licao25/I_can_wait.mp3',
      ipa: '/aɪ kən ˈweɪt/',
      phonetic: 'ai kân UÊIT',
      soundTip: 'O can passa rápido, um "kân" quase engolido, e a força cai '
          'no WAIT. Se você caprichar no can, ele soa como negativo.',
    ),
    LessonItem(
      text: "I can't do it.",
      translation: 'não consigo fazer isso.',
      example: "I'm sorry, I can't do it this week.",
      exampleTranslation: 'Sinto muito, não consigo fazer isso esta semana.',
      audioAsset: "audio/fase2/licao25/I_can't_do_it.mp3",
      ipa: '/aɪ ˈkænt ˈduː ɪt/',
      phonetic: 'ai KÉNT DÚ it',
      soundTip: 'Aqui o can\'t leva força e um "é" bem aberto; o t trava o ar '
          'e o do vem logo em seguida, sem vogal no meio.',
    ),
    LessonItem(
      text: 'We can go now.',
      translation: 'podemos ir agora.',
      example: 'The rain stopped, so we can go now.',
      exampleTranslation: 'A chuva parou, então podemos ir agora.',
      audioAsset: 'audio/fase2/licao25/We_can_go_now.mp3',
      ipa: '/wi kən ˈɡoʊ ˈnaʊ/',
      phonetic: 'ui kân GÔU NÁU',
      soundTip: 'Mesmo no meio da frase o can fica fraco, um "kân" de '
          'passagem; quem leva a força são go e now.',
    ),
  ],
);

/// Lição 26 — Perguntas: sobe ou desce: Melodia: sobe no sim/não, desce no wh-.
const fase2Licao26 = Lesson(
  id: 'fase2-licao26',
  title: 'Perguntas: sobe ou desce',
  objective: 'Você vai dar a melodia certa às perguntas: a voz sobe no fim '
      'das de sim ou não e desce nas que começam com where, what, how e '
      'companhia.',
  microSkill: 'Melodia: sobe no sim/não, desce no wh-',
  approvalThreshold: 75,
  minProsody: 70,
  items: [
    LessonItem(
      text: 'Are you hungry?',
      translation: 'você está com fome?',
      example: 'Are you hungry? I can make some pasta.',
      exampleTranslation: 'Está com fome? Posso fazer um macarrão.',
      audioAsset: 'audio/fase2/licao26/Are_you_hungry.mp3',
      ipa: '/ər ju ˈhʌŋɡri/',
      phonetic: 'âr iu RRÂN-gri',
      soundTip: 'Pergunta de sim ou não: a voz sobe a partir do HUN e termina '
          'lá em cima. O are e o you passam rápidos.',
    ),
    LessonItem(
      text: 'Is it far from here?',
      translation: 'é longe daqui?',
      example: 'Is it far from here? Can we walk?',
      exampleTranslation: 'É longe daqui? Dá pra ir a pé?',
      audioAsset: 'audio/fase2/licao26/Is_it_far_from_here.mp3',
      ipa: '/ɪz ɪt ˈfɑːr frəm ˈhɪr/',
      phonetic: 'iz it FÁR frâm RRÍR',
      soundTip: 'Pergunta de sim ou não: a voz sobe a partir do far e termina '
          'lá no alto no here. Se ela descer no fim, soa como afirmação.',
    ),
    LessonItem(
      text: 'Where are you from?',
      translation: 'de onde você é?',
      example: 'Nice to meet you. Where are you from?',
      exampleTranslation: 'Prazer. De onde você é?',
      audioAsset: 'audio/fase2/licao26/Where_are_you_from.mp3',
      ipa: '/wɛr ər ju ˈfrʌm/',
      phonetic: 'uér âr iu FRÂM',
      soundTip: 'Pergunta com where: a voz sobe até o from e desce nele, como '
          'numa afirmação. Termine com os lábios fechados no m.',
    ),
    LessonItem(
      text: 'What time is it?',
      translation: 'que horas são?',
      example: "What time is it? I think I'm late.",
      exampleTranslation: 'Que horas são? Acho que estou atrasado.',
      audioAsset: 'audio/fase2/licao26/What_time_is_it.mp3',
      ipa: '/wʌt ˈtaɪm ɪz ɪt/',
      phonetic: 'uât TÁIM iz it',
      soundTip: 'Pergunta com what: o ponto alto é o TIME, e depois a voz '
          'desce até o fim. Não suba no it.',
    ),
    LessonItem(
      text: 'Do you like it?',
      translation: 'você gostou?',
      example: 'I made this cake. Do you like it?',
      exampleTranslation: 'Eu fiz este bolo. Você gostou?',
      audioAsset: 'audio/fase2/licao26/Do_you_like_it.mp3',
      ipa: '/du ju ˈlaɪk ɪt/',
      phonetic: 'du iu LÁIK it',
      soundTip: 'Sim ou não de novo: a voz sobe a partir do LIKE e o it '
          'termina lá no alto. O do e o you passam rápidos.',
    ),
  ],
);

/// Lição 27 (revisão) — Revisão de sons — Zona 4: Progresso visível.
const fase2Licao27 = Lesson(
  id: 'fase2-licao27',
  title: 'Revisão de sons — Zona 4',
  objective: 'Uma frase de cada lição desta zona — confira se a vogal fraca, '
      'a força da frase e a melodia já saem sem pensar.',
  microSkill: 'Progresso visível',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Breakfast is at seven.',
      translation: 'o café da manhã é às sete.',
      example: "Don't be late. Breakfast is at seven.",
      exampleTranslation: 'Não se atrase. O café da manhã é às sete.',
      audioAsset: 'audio/fase2/licao22/Breakfast_is_at_seven.mp3',
      ipa: '/ˈbrɛkfəst ɪz ət ˈsɛvən/',
      phonetic: 'BRÉK-fâst iz ât SÉ-vân',
      soundTip: 'Só BRÉK e SÉ levam força; todo o resto passa rápido e baixo, '
          'com "â" curtinho, como se a frase fosse uma palavra só.',
    ),
    LessonItem(
      text: "Let's grab some lunch.",
      translation: 'vamos almoçar.',
      example: "I'm hungry. Let's grab some lunch.",
      exampleTranslation: 'Estou com fome. Vamos almoçar.',
      audioAsset: "audio/fase2/licao23/Let's_grab_some_lunch.mp3",
      ipa: '/lɛts ˈɡræb səm ˈlʌntʃ/',
      phonetic: 'léts GRÉB sâm LÂNTCH',
      soundTip: 'A força fica em GRAB e LUNCH; o some quase some, vira "sâm". '
          'Cole o b do grab no some, sem "grébi".',
    ),
    LessonItem(
      text: 'a cup of coffee',
      translation: 'uma xícara de café',
      example: 'Would you like a cup of coffee?',
      exampleTranslation: 'Você aceita uma xícara de café?',
      audioAsset: 'audio/fase2/licao24/a_cup_of_coffee.mp3',
      ipa: '/ə ˈkʌp əv ˈkɔːfi/',
      phonetic: 'â KÂP âv CÓ-fi',
      soundTip: 'O of vira um "âv" bem curto, grudado no cup, sem "óf" '
          'separado e forte. A força fica em CUP e CO.',
    ),
    LessonItem(
      text: "I can't come.",
      translation: 'não posso ir.',
      example: "I can't come today, but maybe next week.",
      exampleTranslation: 'Não posso ir hoje, mas talvez semana que vem.',
      audioAsset: "audio/fase2/licao25/I_can't_come.mp3",
      ipa: '/aɪ ˈkænt ˈkʌm/',
      phonetic: 'ai KÉNT KÂM',
      soundTip: 'No negativo o can\'t é forte: boca bem aberta no "é" e um t '
          'que só trava o ar, sem soltar vogal. Não é "kéntchi".',
    ),
    LessonItem(
      text: 'Where are you from?',
      translation: 'de onde você é?',
      example: 'Hi, nice to meet you. Where are you from?',
      exampleTranslation: 'Oi, prazer. De onde você é?',
      audioAsset: 'audio/fase2/licao26/Where_are_you_from.mp3',
      ipa: '/wɛr ər ju ˈfrʌm/',
      phonetic: 'uér âr iu FRÂM',
      soundTip: 'Pergunta com where: a voz sobe até o from e desce nele, como '
          'numa afirmação. Termine com os lábios fechados no m.',
    ),
  ],
);

/// Lição 28 — BÔNUS — Desafio: tudo junto: Todas as armadilhas juntas, frase longa.
const fase2Licao28 = Lesson(
  id: 'fase2-licao28',
  title: 'Desafio: tudo junto',
  objective: 'Bônus opcional — frases mais longas que juntam as armadilhas '
      'das 4 zonas e fecham a Trilha 2. Não precisa fazer para concluir a '
      'Trilha 2.',
  microSkill: 'Todas as armadilhas juntas, frase longa',
  approvalThreshold: 75,
  minProsody: 70,
  bonus: true,
  items: [
    LessonItem(
      text: "I think I'll stay home tonight.",
      translation: 'acho que vou ficar em casa hoje à noite.',
      example: "I'm tired, so I think I'll stay home tonight.",
      exampleTranslation: 'Estou cansado, então acho que vou ficar em casa '
          'hoje à noite.',
      audioAsset: "audio/fase2/licao28/I_think_I'll_stay_home_tonight.mp3",
      ipa: '/aɪ ˈθɪŋk aɪl ˈsteɪ ˈhoʊm təˈnaɪt/',
      phonetic: 'ai THÍNK ail STÊI RRÔUM tâ-NÁIT',
      soundTip: 'Ponta da língua entre os dentes no think, sem "tink" nem '
          '"fink"; e o stay começa direto no s, sem "is" antes.',
    ),
    LessonItem(
      text: 'I worked from home all week.',
      translation: 'trabalhei de casa a semana toda.',
      example: 'I worked from home all week and missed the office.',
      exampleTranslation: 'Trabalhei de casa a semana toda e senti falta do '
          'escritório.',
      audioAsset: 'audio/fase2/licao28/I_worked_from_home_all_week.mp3',
      ipa: '/aɪ ˈwɜːrkt frəm ˈhoʊm ɔːl ˈwiːk/',
      phonetic: 'ai UÉRKT frâm RRÔUM ól UÍK',
      soundTip: 'O worked fecha num t seco colado no k, sem "uórkedi"; no '
          'all, a ponta da língua sobe e toca atrás dos dentes, sem virar '
          '"óu".',
    ),
    LessonItem(
      text: "I can't make it to the meeting.",
      translation: 'não vou conseguir ir à reunião.',
      example: "Sorry, I can't make it to the meeting today.",
      exampleTranslation: 'Desculpa, não vou conseguir ir à reunião hoje.',
      audioAsset: "audio/fase2/licao28/I_can't_make_it_to_the_meeting.mp3",
      ipa: '/aɪ ˈkænt ˈmeɪk ɪt tə ðə ˈmiːtɪŋ/',
      phonetic: 'ai KÉNT MÊIK it tâ thâ MÍ-ting',
      soundTip: 'O can\'t é forte, com "é" aberto; to e the passam rápidos, '
          'com a língua entre os dentes no the, sem "dâ".',
    ),
    LessonItem(
      text: 'What time does the store open?',
      translation: 'que horas a loja abre?',
      example: 'What time does the store open on Sunday?',
      exampleTranslation: 'Que horas a loja abre no domingo?',
      audioAsset: 'audio/fase2/licao28/What_time_does_the_store_open.mp3',
      ipa: '/wʌt ˈtaɪm dəz ðə ˈstɔːr ˈoʊpən/',
      phonetic: 'uât TÁIM dâz thâ STÓR ÔU-pân',
      soundTip: 'O store começa direto no s, sem "is"; o open termina num '
          '"pân" curto, e a voz desce nele, no fim da pergunta.',
    ),
    LessonItem(
      text: 'Is there a good place to eat here?',
      translation: 'tem algum lugar bom pra comer aqui?',
      example: 'Excuse me, is there a good place to eat here?',
      exampleTranslation: 'Com licença, tem algum lugar bom pra comer aqui?',
      audioAsset: 'audio/fase2/licao28/Is_there_a_good_place_to_eat_here.mp3',
      ipa: '/ɪz ðɛr ə ˈɡʊd ˈpleɪs tu ˈiːt ˈhɪr/',
      phonetic: 'iz thér â GÚD PLÊIS tu ÍT RRÍR',
      soundTip: 'Língua entre os dentes no there, sem "dér"; o to vira "tu" '
          'antes do eat, e a voz sobe no here, no fim, porque é pergunta de '
          'sim ou não.',
    ),
  ],
);
