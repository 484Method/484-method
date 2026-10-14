import '../models/lesson.dart';
import '../models/trail.dart';

/// Lições da Trilha 5 ("Inglês para sobrevivência" = Fase 5 do currículo):
/// as frases que o aluno precisa DIZER para resolver a situação em viagem ou
/// morando fora, ver docs/curriculo-fase5.md.
///
/// Zona 1 — Restaurante e café. Zona 2 — Aeroporto e transporte. Zona 3 —
/// Hotel, direções e compras. Zona 4 — Saúde e emergências.
///
/// Mesmo formato das Trilhas 2–4: cada zona tem 5 lições obrigatórias, uma
/// revisão (reaproveita os áudios da zona) e um bônus opcional
/// (`Lesson.bonus`), que nunca é pré-requisito. Ids sequenciais
/// (`fase5-licao01..28`), sem lacunas. Títulos sem inglês escrito (o aluno
/// vê o título antes de ouvir).
///
/// Critério: accuracy ≥ 75 + fonema mínimo ≥ 65 (o calibrado nas trilhas
/// anteriores).
///
/// Áudio: `tool/gen_lesson_audio.sh` (função `gen5`), o nome do arquivo é o
/// texto só com letras, dígitos e apóstrofo, espaços viram "_".
///
/// IPA e fonética são aproximações (inglês americano), revisar com ouvido
/// nativo.
const fase5Zones = [
  Zone('Zona 1 — Restaurante e café', [
    fase5Licao01,
    fase5Licao02,
    fase5Licao03,
    fase5Licao04,
    fase5Licao05,
    fase5Licao06,
    fase5Licao07,
  ]),
  Zone('Zona 2 — Aeroporto e transporte', [
    fase5Licao08,
    fase5Licao09,
    fase5Licao10,
    fase5Licao11,
    fase5Licao12,
    fase5Licao13,
    fase5Licao14,
  ]),
  Zone('Zona 3 — Hotel, direções e compras', [
    fase5Licao15,
    fase5Licao16,
    fase5Licao17,
    fase5Licao18,
    fase5Licao19,
    fase5Licao20,
    fase5Licao21,
  ]),
  Zone('Zona 4 — Saúde e emergências', [
    fase5Licao22,
    fase5Licao23,
    fase5Licao24,
    fase5Licao25,
    fase5Licao26,
    fase5Licao27,
    fase5Licao28,
  ]),
];

// ---------------------------------------------------------------------------
// ZONA 1 — RESTAURANTE E CAFÉ
// ---------------------------------------------------------------------------

/// Lição 1 — Pedir uma mesa: Chegar e pedir mesa.
const fase5Licao01 = Lesson(
  id: 'fase5-licao01',
  title: 'Pedir uma mesa',
  objective:
      'Você vai chegar ao restaurante e pedir mesa, falar da reserva e '
      'escolher onde sentar.',
  microSkill: 'Chegar e pedir mesa',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Table for two, please.',
      translation: 'Mesa pra dois, por favor.',
      example: 'A: Hi, how many? B: Table for two, please.',
      exampleTranslation:
          'A: Oi, quantas pessoas? B: Mesa pra dois, por '
          'favor.',
      audioAsset: 'audio/fase5/licao01/Table_for_two_please.mp3',
      ipa: '/ˈteɪbəl fər ˈtu ˈpliz/',
      phonetic: 'TÊI-bâl fâr TÚ, PLÍZ',
      soundTip:
          'Força em TA e em TWO. O for sai fraco, quase fâr, e o L de '
          'table fecha com a língua no céu da boca, sem virar u.',
    ),
    LessonItem(
      text: 'We have a reservation.',
      translation: 'Temos uma reserva.',
      example: 'Good evening. We have a reservation for eight.',
      exampleTranslation: 'Boa noite. Temos uma reserva pras oito.',
      audioAsset: 'audio/fase5/licao01/We_have_a_reservation.mp3',
      ipa: '/wi ˈhæv ə ˌrɛzɚˈveɪʃən/',
      phonetic: 'ui RRÉ-vâ ré-zer-VÊI-shân',
      soundTip:
          'Have a se liga num RRÉ-vâ só. A força maior cai em VA, e o r '
          'do meio enrola a língua sem tocar o céu da boca.',
    ),
    LessonItem(
      text: 'Is there a table by the window?',
      translation: 'Tem uma mesa perto da janela?',
      example: 'A: Is there a table by the window? B: Sure, right this way.',
      exampleTranslation:
          'A: Tem uma mesa perto da janela? B: Claro, por '
          'aqui.',
      audioAsset: 'audio/fase5/licao01/Is_there_a_table_by_the_window.mp3',
      ipa: '/ɪz ðɛr ə ˈteɪbəl baɪ ðə ˈwɪndoʊ/',
      phonetic: 'iz dhér â TÊI-bâl bai dhâ UÍN-dou?',
      soundTip:
          'Is there sai ligado, com o th da língua entre os dentes. '
          'Força em TA e WIN, e a voz sobe no fim.',
    ),
    LessonItem(
      text: 'Can we sit outside?',
      translation: 'Dá pra sentar lá fora?',
      example: "It's a beautiful day. Can we sit outside?",
      exampleTranslation: 'O dia está lindo. Dá pra sentar lá fora?',
      audioAsset: 'audio/fase5/licao01/Can_we_sit_outside.mp3',
      ipa: '/kən wi ˌsɪɾ aʊtˈsaɪd/',
      phonetic: 'kân ui si-raut-SÁID',
      soundTip:
          'Can sai fraco, kân. O t de sit vira um toque leve, quase r, '
          'e cola no outside, que leva a força no SIDE e fecha no d, sem '
          'vogal.',
    ),
    LessonItem(
      text: 'How long is the wait?',
      translation: 'Quanto tempo de espera?',
      example: "A: There's a short wait. B: How long is the wait?",
      exampleTranslation:
          'A: Tem uma pequena espera. B: Quanto tempo de '
          'espera?',
      audioAsset: 'audio/fase5/licao01/How_long_is_the_wait.mp3',
      ipa: '/ˈhaʊ ˈlɔŋ ɪz ðə ˈweɪt/',
      phonetic: 'RRÁU LÓN iz tha UÊIT',
      soundTip:
          'O h de how é só um sopro. Is the passa rápido e fraco; a '
          'força fecha em WAIT, com a boca em bico no w e o t preso.',
    ),
  ],
);

/// Lição 2 — Fazer o pedido: Pedido e recomendação.
const fase5Licao02 = Lesson(
  id: 'fase5-licao02',
  title: 'Fazer o pedido',
  objective:
      'Você vai pedir o cardápio, pedir uma recomendação e dizer o que '
      'vai querer.',
  microSkill: 'Pedido e recomendação',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'What do you recommend?',
      translation: 'O que você recomenda?',
      example: 'Everything looks good. What do you recommend?',
      exampleTranslation: 'Tudo parece bom. O que você recomenda?',
      audioAsset: 'audio/fase5/licao02/What_do_you_recommend.mp3',
      ipa: '/ˈwʌt də jə ˌrɛkəˈmɛnd/',
      phonetic: 'UÂT dâ-iâ ré-kâ-MÉND',
      soundTip:
          'Do you vira um dâ-iâ rápido e fraco. A força vai em MEND, no '
          'fim, e o d final fecha sem soltar vogal.',
    ),
    LessonItem(
      text: 'What comes with that?',
      translation: 'O que acompanha?',
      example: 'A: The steak is great. B: What comes with that?',
      exampleTranslation: 'A: O bife é ótimo. B: O que acompanha?',
      audioAsset: 'audio/fase5/licao02/What_comes_with_that.mp3',
      ipa: '/ˈwʌt ˈkʌmz wɪð ˈðæt/',
      phonetic: 'UÂT KÂMZ uith THÉT',
      soundTip:
          'Comes termina zumbindo, como z. No with e no that a ponta da '
          'língua fica entre os dentes; a força fecha em THAT.',
    ),
    LessonItem(
      text: 'Could I see the menu?',
      translation: 'Posso ver o cardápio?',
      example: 'Excuse me, could I see the menu?',
      exampleTranslation: 'Com licença, posso ver o cardápio?',
      audioAsset: 'audio/fase5/licao02/Could_I_see_the_menu.mp3',
      ipa: '/kʊd aɪ ˈsi ðə ˈmɛnju/',
      phonetic: 'ku-dai SÍ tha MÉ-niu',
      soundTip:
          'Ligue could e I: ku-dai. A força vai em SEE e em ME; menu '
          'termina em iu, nunca em u seco.',
    ),
    LessonItem(
      text: "I'll have the chicken, please.",
      translation: 'Vou querer o frango, por favor.',
      example: "A: Are you ready to order? B: I'll have the chicken, please.",
      exampleTranslation:
          'A: Prontos pra pedir? B: Vou querer o frango, por '
          'favor.',
      audioAsset: "audio/fase5/licao02/I'll_have_the_chicken_please.mp3",
      ipa: '/aɪl ˈhæv ðə ˈtʃɪkən ˈpliz/',
      phonetic: 'ail RRÉV tha TCHÍ-kân, PLÍZ',
      soundTip:
          "O I'll fecha com a língua no céu da boca, sem virar u. Força "
          'em HAVE e CHI; o chicken termina no n, sem i no fim.',
    ),
    LessonItem(
      text: 'I need a few more minutes.',
      translation: 'Preciso de mais uns minutinhos.',
      example: 'A: Ready to order? B: Sorry, I need a few more minutes.',
      exampleTranslation:
          'A: Pronto pra pedir? B: Desculpa, preciso de mais '
          'uns minutinhos.',
      audioAsset: 'audio/fase5/licao02/I_need_a_few_more_minutes.mp3',
      ipa: '/aɪ ˈnid ə ˈfju mɔr ˈmɪnɪts/',
      phonetic: 'ai NÍ-dâ FIÚ mór MÍ-nits',
      soundTip:
          'Need a se liga num NÍ-dâ. Força em NEED, FEW e MI; o minutes '
          'fecha em ts, sem vogal depois, e o r de more enrola.',
    ),
  ],
);

/// Lição 3 — Ajustar o prato: Restrições e ajustes no prato.
const fase5Licao03 = Lesson(
  id: 'fase5-licao03',
  title: 'Ajustar o prato',
  objective:
      'Você vai avisar de alergias e pedir o prato sem um ingrediente, '
      'sem passar aperto.',
  microSkill: 'Restrições e ajustes no prato',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'No onions, please.',
      translation: 'Sem cebola, por favor.',
      example: "I'll have the burger. No onions, please.",
      exampleTranslation: 'Vou querer o hambúrguer. Sem cebola, por favor.',
      audioAsset: 'audio/fase5/licao03/No_onions_please.mp3',
      ipa: '/ˈnoʊ ˈʌnjənz ˈpliz/',
      phonetic: 'NÔU ÂN-iânz, PLÍZ',
      soundTip:
          'Onions começa com a boca meio aberta, ÂN, e não on. Termina '
          'zumbindo, como z, e o please também fecha em z.',
    ),
    LessonItem(
      text: 'Is it spicy?',
      translation: 'É apimentado?',
      example: 'A: Is it spicy? B: Just a little.',
      exampleTranslation: 'A: É apimentado? B: Só um pouquinho.',
      audioAsset: 'audio/fase5/licao03/Is_it_spicy.mp3',
      ipa: '/ɪz ɪt ˈspaɪsi/',
      phonetic: 'i-zit SPÁI-si',
      soundTip:
          'Is it vira uma palavra só, i-zit. Spicy começa direto no s, '
          'sem i antes; a força vai em SPI e a voz sobe no fim.',
    ),
    LessonItem(
      text: 'Does this have dairy?',
      translation: 'Isso leva leite ou derivados?',
      example: "I can't eat milk or cheese. Does this have dairy?",
      exampleTranslation:
          'Não posso comer leite nem queijo. Isso leva '
          'derivados de leite?',
      audioAsset: 'audio/fase5/licao03/Does_this_have_dairy.mp3',
      ipa: '/dəz ðɪs ˈhæv ˈdɛri/',
      phonetic: 'dâz this RRÉV DÉ-ri',
      soundTip:
          'Does sai fraco, dâz. A língua toca os dentes no this; força '
          'em HAVE e DAI, e o r de dairy enrola sem tocar o céu da boca.',
    ),
    LessonItem(
      text: "I'm allergic to peanuts.",
      translation: 'Tenho alergia a amendoim.',
      example: "I'm allergic to peanuts. Is there any in the sauce?",
      exampleTranslation: 'Tenho alergia a amendoim. Tem no molho?',
      audioAsset: "audio/fase5/licao03/I'm_allergic_to_peanuts.mp3",
      ipa: '/aɪm əˈlɝdʒɪk tə ˈpinʌts/',
      phonetic: 'aim â-LÉR-djik tâ PÍ-nâts',
      soundTip:
          'A força cai em LER, com o r enrolado, e em PEA. O to fica '
          'fraquinho, tâ, e o allergic termina no k, sem vogal depois.',
    ),
    LessonItem(
      text: 'Can I get it without cheese?',
      translation: 'Pode vir sem queijo?',
      example: 'The pasta looks great. Can I get it without cheese?',
      exampleTranslation: 'A massa parece ótima. Pode vir sem queijo?',
      audioAsset: 'audio/fase5/licao03/Can_I_get_it_without_cheese.mp3',
      ipa: '/kən aɪ ˈɡɛɾ ɪt wɪˈðaʊt ˈtʃiz/',
      phonetic: 'kâ-nai GUÉ-rit ui-THÁUT TCHÍZ',
      soundTip:
          'Can I vira kâ-nai e get it vira GUÉ-rit, com um toque leve. '
          'Língua entre os dentes no without; cheese termina zumbindo.',
    ),
  ],
);

/// Lição 4 — Reclamar com educação: Problemas educados na refeição.
const fase5Licao04 = Lesson(
  id: 'fase5-licao04',
  title: 'Reclamar com educação',
  objective:
      'Você vai resolver um problema na mesa, como prato errado, '
      'comida fria ou demora, sem soar grosso.',
  microSkill: 'Problemas educados na refeição',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I didn't order this.",
      translation: 'Eu não pedi isso.',
      example: "Excuse me, I didn't order this. I had the fish.",
      exampleTranslation: 'Com licença, eu não pedi isso. Eu pedi o peixe.',
      audioAsset: "audio/fase5/licao04/I_didn't_order_this.mp3",
      ipa: '/aɪ ˈdɪdənt ˈɔrdɚ ðɪs/',
      phonetic: 'ai DÍ-dânt ÓR-der this',
      soundTip:
          "Didn't fecha preso no n, quase sem soltar o t. Força em DID "
          'e OR, com o r enrolado; o this sai curto, língua nos dentes.',
    ),
    LessonItem(
      text: 'This is a little cold.',
      translation: 'Isso está meio frio.',
      example: 'Excuse me, this is a little cold. Could you warm it up?',
      exampleTranslation: 'Com licença, isso está meio frio. Pode esquentar?',
      audioAsset: 'audio/fase5/licao04/This_is_a_little_cold.mp3',
      ipa: '/ðɪs ɪz ə ˈlɪɾəl ˈkoʊld/',
      phonetic: 'this i-zâ LÍ-râl KÔULD',
      soundTip:
          'Is a vira i-zâ. O t de little vira um toque leve, quase r, e '
          'a força fecha em COLD, com o L dito antes do d.',
    ),
    LessonItem(
      text: 'Could we get some napkins?',
      translation: 'Pode trazer uns guardanapos?',
      example: 'Excuse me, could we get some napkins?',
      exampleTranslation: 'Com licença, pode trazer uns guardanapos?',
      audioAsset: 'audio/fase5/licao04/Could_we_get_some_napkins.mp3',
      ipa: '/kʊd wi ˈɡɛt səm ˈnæpkɪnz/',
      phonetic: 'kud ui GUÉT sâm NÉP-kinz',
      soundTip:
          'Some sai fraco, sâm. O t de get trava sem soltar ar; napkins '
          'abre bem o NAP e termina zumbindo, como z.',
    ),
    LessonItem(
      text: 'Could I get a clean fork?',
      translation: 'Pode me trazer um garfo limpo?',
      example: 'Sorry, this one is dirty. Could I get a clean fork?',
      exampleTranslation:
          'Desculpa, este está sujo. Pode me trazer um garfo '
          'limpo?',
      audioAsset: 'audio/fase5/licao04/Could_I_get_a_clean_fork.mp3',
      ipa: '/kʊd aɪ ˈɡɛɾə ˈklin ˈfɔrk/',
      phonetic: 'ku-dai GUÉ-râ KLÍN FÓRK',
      soundTip:
          'Get a vira GUÉ-râ, com toque leve. Clean começa colando k e '
          'L, sem vogal no meio; fork enrola o r e fecha no k.',
    ),
    LessonItem(
      text: "We're still waiting on our food.",
      translation: 'A gente ainda está esperando a comida.',
      example:
          "Excuse me, we're still waiting on our food. Is everything "
          'okay?',
      exampleTranslation:
          'Com licença, a gente ainda está esperando a '
          'comida. Está tudo certo?',
      audioAsset: "audio/fase5/licao04/We're_still_waiting_on_our_food.mp3",
      ipa: '/wɪr ˈstɪl ˈweɪɾɪŋ ɑn ɑr ˈfud/',
      phonetic: 'uír STÍL UÊI-rin an-ar FÚD',
      soundTip:
          'Still começa direto no s, sem i antes. O t de waiting vira '
          'um toque leve; on our sai junto e fraco, e a força fecha em FOOD.',
    ),
  ],
);

/// Lição 5 — Fechar a conta: Conta, gorjeta e pagamento.
const fase5Licao05 = Lesson(
  id: 'fase5-licao05',
  title: 'Fechar a conta',
  objective:
      'Você vai pedir para dividir a conta, perguntar da gorjeta e '
      'pagar do jeito que preferir.',
  microSkill: 'Conta, gorjeta e pagamento',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Keep the change.',
      translation: 'Pode ficar com o troco.',
      example: "A: Here's your change. B: That's okay, keep the change.",
      exampleTranslation:
          'A: Aqui está seu troco. B: Tudo bem, pode ficar '
          'com o troco.',
      audioAsset: 'audio/fase5/licao05/Keep_the_change.mp3',
      ipa: '/ˈkip ðə ˈtʃeɪndʒ/',
      phonetic: 'KÍP tha TCHÊINDJ',
      soundTip:
          'O p de keep trava sem soltar vogal antes do the. Change abre '
          'num êi e fecha em dj, sem i no fim.',
    ),
    LessonItem(
      text: 'Separate checks, please.',
      translation: 'Contas separadas, por favor.',
      example: 'A: Together or separate? B: Separate checks, please.',
      exampleTranslation:
          'A: Junto ou separado? B: Contas separadas, por '
          'favor.',
      audioAsset: 'audio/fase5/licao05/Separate_checks_please.mp3',
      ipa: '/ˈsɛprət ˈtʃɛks ˈpliz/',
      phonetic: 'SÉ-prât TCHÉKS, PLÍZ',
      soundTip:
          'Separate tem só duas batidas, SÉ-prât, com a força no começo '
          'e o t preso. Checks termina em ks, sem vogal depois.',
    ),
    LessonItem(
      text: 'Is the tip included?',
      translation: 'A gorjeta está incluída?',
      example: "A: Here's your check. B: Thanks. Is the tip included?",
      exampleTranslation:
          'A: Aqui está a conta. B: Obrigado. A gorjeta está '
          'incluída?',
      audioAsset: 'audio/fase5/licao05/Is_the_tip_included.mp3',
      ipa: '/ɪz ðə ˈtɪp ɪnˈkludɪd/',
      phonetic: 'iz tha TÍP in-KLÚ-did',
      soundTip:
          'Tip é seco, sem tchi: ponta da língua no t. Força em TIP e '
          'em CLU, e a voz sobe no fim da pergunta.',
    ),
    LessonItem(
      text: 'Can we split the check?',
      translation: 'Dá pra dividir a conta?',
      example: 'There are four of us. Can we split the check?',
      exampleTranslation: 'Somos quatro. Dá pra dividir a conta?',
      audioAsset: 'audio/fase5/licao05/Can_we_split_the_check.mp3',
      ipa: '/kən wi ˈsplɪt ðə ˈtʃɛk/',
      phonetic: 'kân ui SPLÍT tha TCHÉK',
      soundTip:
          'Split começa colado no s, sem i antes, e o t trava antes do '
          'the. Can sai fraco, kân; força em SPLIT e CHECK.',
    ),
    LessonItem(
      text: 'Do you take credit cards?',
      translation: 'Vocês aceitam cartão de crédito?',
      example: "A: That's forty dollars. B: Do you take credit cards?",
      exampleTranslation:
          'A: São quarenta dólares. B: Vocês aceitam cartão '
          'de crédito?',
      audioAsset: 'audio/fase5/licao05/Do_you_take_credit_cards.mp3',
      ipa: '/də jə ˈteɪk ˈkrɛdɪt ˌkɑrdz/',
      phonetic: 'dâ-iâ TÊIK KRÉ-dit kárdz',
      soundTip:
          'Do you sai rápido e fraco, dâ-iâ. Força em TAKE e CRE; o t '
          'de credit trava sem vogal e cards termina zumbindo, em dz.',
    ),
  ],
);

/// Lição 6 (revisão) — Revisão: restaurante e café: Revisão da zona.
const fase5Licao06 = Lesson(
  id: 'fase5-licao06',
  title: 'Revisão: restaurante e café',
  objective:
      'Você vai juntar as frases da zona, da chegada à conta, numa '
      'refeição completa.',
  microSkill: 'Revisão da zona',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Table for two, please.',
      translation: 'Mesa pra dois, por favor.',
      example: 'A: Just the two of you? B: Yes, table for two, please.',
      exampleTranslation: 'A: Só vocês dois? B: Sim, mesa pra dois, por favor.',
      audioAsset: 'audio/fase5/licao01/Table_for_two_please.mp3',
      ipa: '/ˈteɪbəl fər ˈtu ˈpliz/',
      phonetic: 'TÊI-bâl fâr TÚ, PLÍZ',
      soundTip:
          'Força em TA e em TWO. O for sai fraco, quase fâr, e o L de '
          'table fecha com a língua no céu da boca, sem virar u.',
    ),
    LessonItem(
      text: 'What do you recommend?',
      translation: 'O que você recomenda?',
      example: "It's my first time here. What do you recommend?",
      exampleTranslation: 'É minha primeira vez aqui. O que você recomenda?',
      audioAsset: 'audio/fase5/licao02/What_do_you_recommend.mp3',
      ipa: '/ˈwʌt də jə ˌrɛkəˈmɛnd/',
      phonetic: 'UÂT dâ-iâ ré-kâ-MÉND',
      soundTip:
          'Do you vira um dâ-iâ rápido e fraco. A força vai em MEND, no '
          'fim, e o d final fecha sem soltar vogal.',
    ),
    LessonItem(
      text: "I'm allergic to peanuts.",
      translation: 'Tenho alergia a amendoim.',
      example: "Just so you know, I'm allergic to peanuts.",
      exampleTranslation: 'Só pra avisar, tenho alergia a amendoim.',
      audioAsset: "audio/fase5/licao03/I'm_allergic_to_peanuts.mp3",
      ipa: '/aɪm əˈlɝdʒɪk tə ˈpinʌts/',
      phonetic: 'aim â-LÉR-djik tâ PÍ-nâts',
      soundTip:
          'A força cai em LER, com o r enrolado, e em PEA. O to fica '
          'fraquinho, tâ, e o allergic termina no k, sem vogal depois.',
    ),
    LessonItem(
      text: "I didn't order this.",
      translation: 'Eu não pedi isso.',
      example: "Sorry, I didn't order this. I asked for the pasta.",
      exampleTranslation: 'Desculpa, eu não pedi isso. Eu pedi a massa.',
      audioAsset: "audio/fase5/licao04/I_didn't_order_this.mp3",
      ipa: '/aɪ ˈdɪdənt ˈɔrdɚ ðɪs/',
      phonetic: 'ai DÍ-dânt ÓR-der this',
      soundTip:
          "Didn't fecha preso no n, quase sem soltar o t. Força em DID "
          'e OR, com o r enrolado; o this sai curto, língua nos dentes.',
    ),
    LessonItem(
      text: 'Can we split the check?',
      translation: 'Dá pra dividir a conta?',
      example: 'A: How would you like to pay? B: Can we split the check?',
      exampleTranslation:
          'A: Como vocês querem pagar? B: Dá pra dividir a '
          'conta?',
      audioAsset: 'audio/fase5/licao05/Can_we_split_the_check.mp3',
      ipa: '/kən wi ˈsplɪt ðə ˈtʃɛk/',
      phonetic: 'kân ui SPLÍT tha TCHÉK',
      soundTip:
          'Split começa colado no s, sem i antes, e o t trava antes do '
          'the. Can sai fraco, kân; força em SPLIT e CHECK.',
    ),
  ],
);

/// Lição 7 — BÔNUS — Bônus: café e pedidos maiores: Café pra viagem e pedidos longos.
const fase5Licao07 = Lesson(
  id: 'fase5-licao07',
  title: 'Bônus: café e pedidos maiores',
  objective:
      'Você vai pedir café para viagem do seu jeito e fazer pedidos '
      'mais longos sem travar.',
  microSkill: 'Café pra viagem e pedidos longos',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: 'Can I get a large iced coffee to go?',
      translation: 'Me vê um café gelado grande pra viagem?',
      example: 'A: What can I get you? B: Can I get a large iced coffee to go?',
      exampleTranslation:
          'A: O que vai ser? B: Me vê um café gelado grande '
          'pra viagem?',
      audioAsset: 'audio/fase5/licao07/Can_I_get_a_large_iced_coffee_to_go.mp3',
      ipa: '/kən aɪ ˈɡɛɾə ˈlɑrdʒ ˈaɪst ˈkɑfi tə ˈɡoʊ/',
      phonetic: 'kâ-nai GUÉ-râ LÁRDJ ÁIST KÁ-fi tâ GÔU',
      soundTip:
          'Get a vira GUÉ-râ. Iced coffee sai colado, com o t quase '
          'sumindo; coffee abre o KA, e o to go fecha com a voz subindo.',
    ),
    LessonItem(
      text: 'Could I get a medium latte with oat milk?',
      translation: 'Pode ser um latte médio com leite de aveia?',
      example: 'A: Anything else? B: Could I get a medium latte with oat milk?',
      exampleTranslation:
          'A: Mais alguma coisa? B: Pode ser um latte médio '
          'com leite de aveia?',
      audioAsset:
          'audio/fase5/licao07/Could_I_get_a_medium_latte_with_oat_milk.mp3',
      ipa: '/kʊd aɪ ˈɡɛɾə ˈmidiəm ˈlɑteɪ wɪð ˈoʊt ˈmɪlk/',
      phonetic: 'ku-dai GUÉ-râ MÍ-di-âm LÁ-tei uith ÔUT MÍLK',
      soundTip:
          'Medium soa MÍ-di-âm, com i, e latte abre o LA. O t de oat '
          'trava antes do milk, e o L de milk fica na língua antes do k.',
    ),
    LessonItem(
      text: 'Can I have the dressing on the side?',
      translation: 'Pode trazer o molho da salada à parte?',
      example:
          "I'll have the Caesar salad. Can I have the dressing on the "
          'side?',
      exampleTranslation:
          'Vou querer a salada Caesar. Pode trazer o molho à '
          'parte?',
      audioAsset: 'audio/fase5/licao07/Can_I_have_the_dressing_on_the_side.mp3',
      ipa: '/kən aɪ ˈhæv ðə ˈdrɛsɪŋ ɑn ðə ˈsaɪd/',
      phonetic: 'kâ-nai RRÉV tha DRÉ-sing ân tha SÁID',
      soundTip:
          'Can I vira kâ-nai. Dressing cola o d no r, sem vogal no '
          'meio; on the passa fraco, e a força fecha em SIDE, que termina no '
          'd.',
    ),
    LessonItem(
      text: 'Could you put the rest in a box?',
      translation: 'Pode embalar o que sobrou pra eu levar?',
      example:
          "A: Are you still working on that? B: I'm done. Could you put "
          'the rest in a box?',
      exampleTranslation:
          'A: Ainda está comendo? B: Terminei. Pode embalar o '
          'que sobrou pra eu levar?',
      audioAsset: 'audio/fase5/licao07/Could_you_put_the_rest_in_a_box.mp3',
      ipa: '/kʊdʒə ˈpʊt ðə ˈrɛst ɪn ə ˈbɑks/',
      phonetic: 'kú-djâ PÚT tha RÉST i-nâ BÁKS',
      soundTip:
          'Could you vira kú-djâ. O t de put trava antes do the; in a '
          'vira i-nâ, e box abre bem o BA e fecha em ks.',
    ),
    LessonItem(
      text: 'Excuse me, is there a restroom I can use?',
      translation: 'Com licença, tem um banheiro que eu possa usar?',
      example:
          'Excuse me, is there a restroom I can use? I just bought a '
          'coffee.',
      exampleTranslation:
          'Com licença, tem um banheiro que eu possa usar? '
          'Acabei de comprar um café.',
      audioAsset:
          'audio/fase5/licao07/Excuse_me_is_there_a_restroom_I_can_use.mp3',
      ipa: '/ɪkˈskjuz mi ɪz ðɛr ə ˈrɛstrum aɪ kən ˈjuz/',
      phonetic: 'ik-SKIÚZ mi, iz thé-râ RÉST-rum ai kân IÚZ',
      soundTip:
          'There a vira thé-râ, ligado. Força em REST e em USE, que '
          'termina zumbindo, como z; o can fica fraco, kân.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// ZONA 2 — AEROPORTO E TRANSPORTE
// ---------------------------------------------------------------------------

/// Lição 8 — Despachar a mala e escolher o assento: check-in: assento e bagagem.
const fase5Licao08 = Lesson(
  id: 'fase5-licao08',
  title: 'Despachar a mala e escolher o assento',
  objective:
      'Você vai pedir o assento que prefere, despachar a mala e '
      'confirmar se o voo está no horário.',
  microSkill: 'check-in: assento e bagagem',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Window seat, please.',
      translation: 'Janela, por favor.',
      example: 'A: Window or aisle? B: Window seat, please.',
      exampleTranslation: 'A: Janela ou corredor? B: Janela, por favor.',
      audioAsset: 'audio/fase5/licao08/Window_seat_please.mp3',
      ipa: '/ˈwɪndoʊ ˌsit ˈpliz/',
      phonetic: 'UÍN-dou sit, PLÍZ',
      soundTip:
          'Força em WIN e em PLEASE. Seat fecha seco no t, com a língua '
          'parada no céu da boca; please termina zumbindo, como z.',
    ),
    LessonItem(
      text: 'Just one bag.',
      translation: 'Só uma mala.',
      example: 'A: How many bags are you checking? B: Just one bag.',
      exampleTranslation: 'A: Quantas malas vai despachar? B: Só uma mala.',
      audioAsset: 'audio/fase5/licao08/Just_one_bag.mp3',
      ipa: '/ˈdʒʌs ˈwʌn ˈbæɡ/',
      phonetic: 'DJÂS UÂN BÉG',
      soundTip:
          'O t de just some antes do one: djâs uân. Bag abre bem a '
          'boca, quase é, e fecha no g sem soltar vogal depois.',
    ),
    LessonItem(
      text: 'Is the flight on time?',
      translation: 'O voo está no horário?',
      example: 'Is the flight on time, or is there a delay?',
      exampleTranslation: 'O voo está no horário ou tem atraso?',
      audioAsset: 'audio/fase5/licao08/Is_the_flight_on_time.mp3',
      ipa: '/ɪz ðə ˈflaɪɾ ɑn ˈtaɪm/',
      phonetic: 'iz dhâ FLÁI-rán TÁIM?',
      soundTip:
          'Flight e on se ligam: o t vira um r rápido, FLÁI-rán. Força '
          'em FLIGHT e TIME, e a voz sobe no fim da pergunta.',
    ),
    LessonItem(
      text: 'Is this bag too heavy?',
      translation: 'Essa mala está pesada demais?',
      example: 'Is this bag too heavy? I can take some things out.',
      exampleTranslation:
          'Essa mala está pesada demais? Posso tirar umas '
          'coisas.',
      audioAsset: 'audio/fase5/licao08/Is_this_bag_too_heavy.mp3',
      ipa: '/ɪz ðɪs ˈbæɡ ˈtu ˈhɛvi/',
      phonetic: 'iz dhis BÉG TU RRÉ-vi?',
      soundTip:
          'Heavy começa com ar saindo da garganta, como um rr suave. '
          'Força em BAG, TOO e HEA, e a voz sobe no fim.',
    ),
    LessonItem(
      text: 'Can I get an aisle seat?',
      translation: 'Posso ficar no corredor?',
      example: 'Can I get an aisle seat? I get up a lot on long flights.',
      exampleTranslation:
          'Posso ficar no corredor? Eu levanto bastante em '
          'voo longo.',
      audioAsset: 'audio/fase5/licao08/Can_I_get_an_aisle_seat.mp3',
      ipa: '/kən aɪ ˈɡɛɾ ən ˈaɪl ˌsit/',
      phonetic: 'kâ-nai GUÉ-rân ÁIL sit?',
      soundTip:
          "Aisle soa igual a I'll, o s é mudo. Get an vira GUÉ-rân, com "
          'r rápido, e can I sai fraco e junto: kâ-nai.',
    ),
  ],
);

/// Lição 9 — Na imigração e no raio-x: respostas curtas do viajante.
const fase5Licao09 = Lesson(
  id: 'fase5-licao09',
  title: 'Na imigração e no raio-x',
  objective:
      'Você vai responder ao agente da imigração e passar pela '
      'segurança sem travar.',
  microSkill: 'respostas curtas do viajante',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "Here's my passport.",
      translation: 'Aqui está meu passaporte.',
      example: "A: Passport, please. B: Sure, here's my passport.",
      exampleTranslation:
          'A: Passaporte, por favor. B: Claro, aqui está meu '
          'passaporte.',
      audioAsset: "audio/fase5/licao09/Here's_my_passport.mp3",
      ipa: '/ˈhɪrz maɪ ˈpæspɔrt/',
      phonetic: 'RRÍRZ mai PÉS-pórt',
      soundTip:
          "Here's sai com ar na garganta e termina zumbindo, como z. "
          'Força em PASS, boca bem aberta; port fecha no t, sem vogal depois.',
    ),
    LessonItem(
      text: "I'm here on vacation.",
      translation: 'Estou aqui de férias.',
      example: "A: What's the purpose of your visit? B: I'm here on vacation.",
      exampleTranslation:
          'A: Qual o motivo da sua viagem? B: Estou aqui de '
          'férias.',
      audioAsset: "audio/fase5/licao09/I'm_here_on_vacation.mp3",
      ipa: '/aɪm ˈhɪr ɑn veɪˈkeɪʃən/',
      phonetic: 'aim RRÍ-rán vei-KÊI-shân',
      soundTip:
          'Here e on se ligam: RRÍ-rán. Em vacation a força vai no KÊI; '
          'o começo sai leve e o fim é curto, shân.',
    ),
    LessonItem(
      text: 'I have nothing to declare.',
      translation: 'Não tenho nada a declarar.',
      example: 'A: Anything to declare? B: No, I have nothing to declare.',
      exampleTranslation:
          'A: Algo a declarar? B: Não, não tenho nada a '
          'declarar.',
      audioAsset: 'audio/fase5/licao09/I_have_nothing_to_declare.mp3',
      ipa: '/aɪ hæv ˈnʌθɪŋ tə dɪˈklɛr/',
      phonetic: 'ai rrév NÂ-thing tâ di-KLÉR',
      soundTip:
          'No th de nothing a ponta da língua fica entre os dentes e o '
          'ar passa. Força em NO e CLARE; o to sai fraquinho, tâ.',
    ),
    LessonItem(
      text: "I'll be here for two weeks.",
      translation: 'Vou ficar duas semanas.',
      example: "A: How long are you staying? B: I'll be here for two weeks.",
      exampleTranslation:
          'A: Quanto tempo vai ficar? B: Vou ficar duas '
          'semanas.',
      audioAsset: "audio/fase5/licao09/I'll_be_here_for_two_weeks.mp3",
      ipa: '/aɪl bi ˈhɪr fər ˈtu ˈwiks/',
      phonetic: 'ail bi RRÍR fâr TÚ UÍKS',
      soundTip:
          "I'll fecha com a língua no céu da boca. For sai fraco, fâr. "
          'Força em HERE, TWO e WEEKS, que termina em ks seco.',
    ),
    LessonItem(
      text: 'Should I take my shoes off?',
      translation: 'Preciso tirar os sapatos?',
      example: 'Should I take my shoes off, or just the belt?',
      exampleTranslation: 'Preciso tirar os sapatos ou só o cinto?',
      audioAsset: 'audio/fase5/licao09/Should_I_take_my_shoes_off.mp3',
      ipa: '/ʃʊd aɪ ˈteɪk maɪ ˈʃuz ˈɔf/',
      phonetic: 'shu-dai TÊIK mai shú-ZÓF?',
      soundTip:
          'Should I se liga, shu-dai, com o l mudo. Shoes off também se '
          'liga, shu-zóf, e a voz sobe no fim da pergunta.',
    ),
  ],
);

/// Lição 10 — Portão, conexão e atraso: perguntas no portão de embarque.
const fase5Licao10 = Lesson(
  id: 'fase5-licao10',
  title: 'Portão, conexão e atraso',
  objective:
      'Você vai achar o portão, perguntar sobre o embarque e avisar '
      'que tem uma conexão.',
  microSkill: 'perguntas no portão de embarque',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "Where's gate twelve?",
      translation: 'Onde fica o portão doze?',
      example: "Excuse me, where's gate twelve? I can't find it.",
      exampleTranslation:
          'Com licença, onde fica o portão doze? Não estou '
          'achando.',
      audioAsset: "audio/fase5/licao10/Where's_gate_twelve.mp3",
      ipa: '/ˈwɛrz ˈɡeɪt ˈtwɛlv/',
      phonetic: 'UÉRZ GUÊIT TUÉLV?',
      soundTip:
          "Where's zumbe no fim, como z. O t de gate fica preso, sem "
          'vogal depois; twelve fecha com a língua no céu da boca e um v '
          'vibrando.',
    ),
    LessonItem(
      text: 'Is my flight delayed?',
      translation: 'Meu voo está atrasado?',
      example: "Is my flight delayed? The screen doesn't say.",
      exampleTranslation: 'Meu voo está atrasado? O painel não mostra.',
      audioAsset: 'audio/fase5/licao10/Is_my_flight_delayed.mp3',
      ipa: '/ɪz maɪ ˈflaɪt dɪˈleɪd/',
      phonetic: 'iz mai FLÁIT di-LÊID?',
      soundTip:
          'Força em FLIGHT e LAY. Flight fecha preso no t, sem vogal '
          'depois; delayed termina num d leve, e a voz sobe no fim.',
    ),
    LessonItem(
      text: 'When does boarding start?',
      translation: 'Que horas começa o embarque?',
      example: 'A: When does boarding start? B: In about twenty minutes.',
      exampleTranslation:
          'A: Que horas começa o embarque? B: Daqui a uns '
          'vinte minutos.',
      audioAsset: 'audio/fase5/licao10/When_does_boarding_start.mp3',
      ipa: '/ˈwɛn dəz ˈbɔrdɪŋ ˈstɑrt/',
      phonetic: 'UÉN dâz BÓR-ding STÁRT?',
      soundTip:
          'Does sai fraco, dâz. Start começa direto no s, sem vogal '
          'antes, com o r enrolado antes do t. Com when, a voz desce no fim.',
    ),
    LessonItem(
      text: 'I have a connecting flight.',
      translation: 'Eu tenho uma conexão.',
      example: 'I have a connecting flight to Chicago at six.',
      exampleTranslation: 'Eu tenho uma conexão para Chicago às seis.',
      audioAsset: 'audio/fase5/licao10/I_have_a_connecting_flight.mp3',
      ipa: '/aɪ ˈhæv ə kəˈnɛktɪŋ ˌflaɪt/',
      phonetic: 'ai RRÉ-vâ kâ-NÉK-ting flait',
      soundTip:
          'Have a se liga: RRÉ-vâ. Em connecting a força cai no NEC e o '
          'co sai fraco, kâ. Flight fecha preso no t.',
    ),
    LessonItem(
      text: 'Am I going to miss my connection?',
      translation: 'Vou perder minha conexão?',
      example: "We're an hour late. Am I going to miss my connection?",
      exampleTranslation:
          'Estamos uma hora atrasados. Vou perder minha '
          'conexão?',
      audioAsset: 'audio/fase5/licao10/Am_I_going_to_miss_my_connection.mp3',
      ipa: '/əm aɪ ˈɡʌnə ˈmɪs maɪ kəˈnɛkʃən/',
      phonetic: 'â-mai GÂ-nâ MÍS mai kâ-NÉK-shân?',
      soundTip:
          'Am I sai junto e fraco, â-mai, e going to vira GÂ-nâ. Força '
          'em MISS e NEC, e a voz sobe no fim da pergunta.',
    ),
  ],
);

/// Lição 11 — Mala extraviada e imprevistos: relatar problema com bagagem.
const fase5Licao11 = Lesson(
  id: 'fase5-licao11',
  title: 'Mala extraviada e imprevistos',
  objective:
      'Você vai avisar que a mala não chegou, descrever a mala e pedir '
      'que mandem para o hotel.',
  microSkill: 'relatar problema com bagagem',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "My bag didn't arrive.",
      translation: 'Minha mala não chegou.',
      example: "Excuse me, my bag didn't arrive. Where should I go?",
      exampleTranslation: 'Com licença, minha mala não chegou. Aonde eu vou?',
      audioAsset: "audio/fase5/licao11/My_bag_didn't_arrive.mp3",
      ipa: '/maɪ ˈbæɡ ˈdɪdn̩t əˈraɪv/',
      phonetic: 'mai BÉG DÍ-dnt â-RÁIV',
      soundTip:
          "Didn't trava na garganta, quase DÍ-dn, e emenda no arrive. "
          'Força em RIVE, que termina com os dentes no lábio vibrando, v.',
    ),
    LessonItem(
      text: 'My suitcase is damaged.',
      translation: 'Minha mala está danificada.',
      example: 'My suitcase is damaged. The wheel is broken.',
      exampleTranslation: 'Minha mala está danificada. A rodinha quebrou.',
      audioAsset: 'audio/fase5/licao11/My_suitcase_is_damaged.mp3',
      ipa: '/maɪ ˈsutkeɪs ɪz ˈdæmɪdʒd/',
      phonetic: 'mai SÚT-keis iz DÉ-midjd',
      soundTip:
          'Suitcase soa SÚT-keis. Força em SUIT e DAM, boca bem aberta; '
          'damaged termina em dj e um d bem leve, sem vogal no fim.',
    ),
    LessonItem(
      text: "It's a big black suitcase.",
      translation: 'É uma mala preta grande.',
      example: "A: Can you describe it? B: It's a big black suitcase.",
      exampleTranslation: 'A: Pode descrever? B: É uma mala preta grande.',
      audioAsset: "audio/fase5/licao11/It's_a_big_black_suitcase.mp3",
      ipa: '/ɪts ə ˈbɪɡ ˈblæk ˈsutkeɪs/',
      phonetic: 'its â BÍG BLÉK SÚT-keis',
      soundTip:
          'Três batidas fortes seguidas: BIG, BLACK, SUIT. Big e black '
          'fecham secos, sem vogal no fim; black abre bem a boca, quase é.',
    ),
    LessonItem(
      text: 'Where do I report lost luggage?',
      translation: 'Onde eu registro bagagem extraviada?',
      example: 'Where do I report lost luggage? My bag never came out.',
      exampleTranslation:
          'Onde eu registro bagagem extraviada? Minha mala '
          'não saiu.',
      audioAsset: 'audio/fase5/licao11/Where_do_I_report_lost_luggage.mp3',
      ipa: '/ˈwɛr də aɪ rɪˈpɔrt ˈlɔs ˈlʌɡɪdʒ/',
      phonetic: 'UÉR dâ-ai ri-PÓRT LÓS LÂ-guidj?',
      soundTip:
          'Do I sai fraco e junto, dâ-ai. O t de lost some antes do '
          'luggage, que tem força no LU e termina em dj. Com where, a voz '
          'desce.',
    ),
    LessonItem(
      text: 'Can you send it to my hotel?',
      translation: 'Vocês podem mandar para o meu hotel?',
      example: 'When you find my bag, can you send it to my hotel?',
      exampleTranslation:
          'Quando acharem minha mala, podem mandar para o meu '
          'hotel?',
      audioAsset: 'audio/fase5/licao11/Can_you_send_it_to_my_hotel.mp3',
      ipa: '/kən jə ˈsɛndɪt tə maɪ hoʊˈtɛl/',
      phonetic: 'kân-iâ SÉN-dit tâ mai rrôu-TÉL?',
      soundTip:
          'Can you sai fraco, kân-iâ, e send it se liga, SÉN-dit. Em '
          'hotel a força vai no TEL, com a língua no céu da boca; a voz sobe '
          'no fim.',
    ),
  ],
);

/// Lição 12 — Táxi, metrô e ônibus: pedir destino e preço.
const fase5Licao12 = Lesson(
  id: 'fase5-licao12',
  title: 'Táxi, metrô e ônibus',
  objective:
      'Você vai dizer para onde quer ir, perguntar o preço e saber '
      'onde descer no táxi, no metrô e no ônibus.',
  microSkill: 'pedir destino e preço',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'To this address, please.',
      translation: 'Para este endereço, por favor.',
      example: "Hi. To this address, please. It's near the park.",
      exampleTranslation:
          'Oi. Para este endereço, por favor. Fica perto do '
          'parque.',
      audioAsset: 'audio/fase5/licao12/To_this_address_please.mp3',
      ipa: '/tə ˈðɪs ˈædrɛs ˈpliz/',
      phonetic: 'tâ DHÍS É-dres, PLÍZ',
      soundTip:
          'To sai fraco, tâ. No this a ponta da língua fica entre os '
          'dentes e vibra. Address tem força no A, com a boca bem aberta: '
          'É-dres.',
    ),
    LessonItem(
      text: 'How much to the airport?',
      translation: 'Quanto fica até o aeroporto?',
      example: 'A: How much to the airport? B: About forty dollars.',
      exampleTranslation:
          'A: Quanto fica até o aeroporto? B: Uns quarenta '
          'dólares.',
      audioAsset: 'audio/fase5/licao12/How_much_to_the_airport.mp3',
      ipa: '/ˈhaʊ ˈmʌtʃ tə ði ˈɛrpɔrt/',
      phonetic: 'RRÁU MÂTCH tâ dhi ÉR-pórt?',
      soundTip:
          'How começa com ar, RRÁU. To the sai fraco e rápido, tâ dhi. '
          'Força em MUCH e AIR; port fecha no t, sem vogal depois.',
    ),
    LessonItem(
      text: 'Where can I buy a ticket?',
      translation: 'Onde eu compro a passagem?',
      example: 'Where can I buy a ticket for the subway?',
      exampleTranslation: 'Onde eu compro a passagem do metrô?',
      audioAsset: 'audio/fase5/licao12/Where_can_I_buy_a_ticket.mp3',
      ipa: '/ˈwɛr kən aɪ ˈbaɪ ə ˈtɪkɪt/',
      phonetic: 'UÉR kâ-nai BÁI-â TÍ-kit?',
      soundTip:
          'Can I sai junto e fraco, kâ-nai, e buy a se liga, BÁI-â. '
          'Ticket tem força no TI e fecha preso no t; com where, a voz desce.',
    ),
    LessonItem(
      text: 'Does this bus go downtown?',
      translation: 'Esse ônibus vai para o centro?',
      example: 'A: Does this bus go downtown? B: Yes, get on.',
      exampleTranslation:
          'A: Esse ônibus vai para o centro? B: Vai, pode '
          'subir.',
      audioAsset: 'audio/fase5/licao12/Does_this_bus_go_downtown.mp3',
      ipa: '/dəz ðɪs ˈbʌs ɡoʊ ˌdaʊnˈtaʊn/',
      phonetic: 'dâz dhis BÂS gôu daun-TÁUN?',
      soundTip:
          'Does this sai fraco e junto, dâz dhis. Bus tem vogal curta, '
          'BÂS. A força maior vai em TOWN, e a voz sobe no fim.',
    ),
    LessonItem(
      text: 'Which stop should I get off at?',
      translation: 'Em que parada eu desço?',
      example: "I'm going to the museum. Which stop should I get off at?",
      exampleTranslation: 'Vou para o museu. Em que parada eu desço?',
      audioAsset: 'audio/fase5/licao12/Which_stop_should_I_get_off_at.mp3',
      ipa: '/ˈwɪtʃ ˈstɑp ʃəd aɪ ˌɡɛɾ ˈɔf ət/',
      phonetic: 'UÍTCH STÁP shâ-dai gué-RÓ-fât?',
      soundTip:
          'Should I vira shâ-dai, e get off at se liga com r rápido: '
          'gué-RÓ-fât. Stop começa direto no s, sem vogal antes.',
    ),
  ],
);

/// Lição 13 (revisão) — Revisão: aeroporto e transporte: revisão da zona.
const fase5Licao13 = Lesson(
  id: 'fase5-licao13',
  title: 'Revisão: aeroporto e transporte',
  objective:
      'Você vai juntar as frases da zona e dizer cada uma de primeira, '
      'do balcão da companhia até o táxi.',
  microSkill: 'revisão da zona',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Is the flight on time?',
      translation: 'O voo está no horário?',
      example: "Hi, I'm going to Miami at six. Is the flight on time?",
      exampleTranslation:
          'Oi, eu vou pra Miami às seis. O voo está no '
          'horário?',
      audioAsset: 'audio/fase5/licao08/Is_the_flight_on_time.mp3',
      ipa: '/ɪz ðə ˈflaɪɾ ɑn ˈtaɪm/',
      phonetic: 'iz dhâ FLÁI-rán TÁIM?',
      soundTip:
          'Flight e on se ligam: o t vira um r rápido, FLÁI-rán. Força '
          'em FLIGHT e TIME, e a voz sobe no fim da pergunta.',
    ),
    LessonItem(
      text: "I'm here on vacation.",
      translation: 'Estou aqui de férias.',
      example: "A: Business or pleasure? B: I'm here on vacation.",
      exampleTranslation: 'A: Trabalho ou lazer? B: Estou aqui de férias.',
      audioAsset: "audio/fase5/licao09/I'm_here_on_vacation.mp3",
      ipa: '/aɪm ˈhɪr ɑn veɪˈkeɪʃən/',
      phonetic: 'aim RRÍ-rán vei-KÊI-shân',
      soundTip:
          'Here e on se ligam: RRÍ-rán. Em vacation a força vai no KÊI; '
          'o começo sai leve e o fim é curto, shân.',
    ),
    LessonItem(
      text: 'When does boarding start?',
      translation: 'Que horas começa o embarque?',
      example: 'Excuse me, when does boarding start for this flight?',
      exampleTranslation: 'Com licença, que horas começa o embarque deste voo?',
      audioAsset: 'audio/fase5/licao10/When_does_boarding_start.mp3',
      ipa: '/ˈwɛn dəz ˈbɔrdɪŋ ˈstɑrt/',
      phonetic: 'UÉN dâz BÓR-ding STÁRT?',
      soundTip:
          'Does sai fraco, dâz. Start começa direto no s, sem vogal '
          'antes, com o r enrolado antes do t. Com when, a voz desce no fim.',
    ),
    LessonItem(
      text: "My bag didn't arrive.",
      translation: 'Minha mala não chegou.',
      example: "I waited an hour, but my bag didn't arrive.",
      exampleTranslation: 'Esperei uma hora, mas minha mala não chegou.',
      audioAsset: "audio/fase5/licao11/My_bag_didn't_arrive.mp3",
      ipa: '/maɪ ˈbæɡ ˈdɪdn̩t əˈraɪv/',
      phonetic: 'mai BÉG DÍ-dnt â-RÁIV',
      soundTip:
          "Didn't trava na garganta, quase DÍ-dn, e emenda no arrive. "
          'Força em RIVE, que termina com os dentes no lábio vibrando, v.',
    ),
    LessonItem(
      text: 'How much to the airport?',
      translation: 'Quanto fica até o aeroporto?',
      example: 'Hi. How much to the airport from here?',
      exampleTranslation: 'Oi. Quanto fica daqui até o aeroporto?',
      audioAsset: 'audio/fase5/licao12/How_much_to_the_airport.mp3',
      ipa: '/ˈhaʊ ˈmʌtʃ tə ði ˈɛrpɔrt/',
      phonetic: 'RRÁU MÂTCH tâ dhi ÉR-pórt?',
      soundTip:
          'How começa com ar, RRÁU. To the sai fraco e rápido, tâ dhi. '
          'Força em MUCH e AIR; port fecha no t, sem vogal depois.',
    ),
  ],
);

/// Lição 14 — BÔNUS — Bônus: viagem em frases longas: frases longas de viagem.
const fase5Licao14 = Lesson(
  id: 'fase5-licao14',
  title: 'Bônus: viagem em frases longas',
  objective:
      'Você vai dizer frases mais longas de viagem, do pedido de '
      'assento até um voo cancelado.',
  microSkill: 'frases longas de viagem',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: 'Is there any way we could sit together?',
      translation: 'Tem como a gente sentar junto?',
      example:
          'A: Here are your boarding passes. B: Is there any way we '
          'could sit together?',
      exampleTranslation:
          'A: Aqui estão seus cartões de embarque. B: Tem '
          'como a gente sentar junto?',
      audioAsset:
          'audio/fase5/licao14/Is_there_any_way_we_could_sit_together.mp3',
      ipa: '/ɪz ðɛr ˈɛni ˈweɪ wi kəd ˈsɪt təˈɡɛðɚ/',
      phonetic: 'iz thér É-ni UÊI ui kâd SÍT tâ-GUÉ-thâr?',
      soundTip:
          'Could sai fraco, kâd. Força em WAY, SIT e GE; no together a '
          'língua vai entre os dentes, e a voz sobe no fim.',
    ),
    LessonItem(
      text: "I'm here on business for about a week.",
      translation: 'Estou aqui a trabalho, por mais ou menos uma semana.',
      example:
          "A: How long will you stay? B: I'm here on business for about "
          'a week.',
      exampleTranslation:
          'A: Quanto tempo vai ficar? B: Estou aqui a '
          'trabalho, por mais ou menos uma semana.',
      audioAsset:
          "audio/fase5/licao14/I'm_here_on_business_for_about_a_week.mp3",
      ipa: '/aɪm ˈhɪr ɑn ˈbɪznəs fər əˈbaʊɾ ə ˈwik/',
      phonetic: 'aim RRÍ-rán BÍZ-nâs fâr â-BÁU-râ UÍK',
      soundTip:
          'Business tem só duas sílabas, BÍZ-nâs, com z no meio. About '
          'a vira â-BÁU-râ, com r rápido. Força em HERE, BIZ e WEEK.',
    ),
    LessonItem(
      text: 'My flight was canceled. What are my options?',
      translation: 'Meu voo foi cancelado. Quais são as minhas opções?',
      example: 'Hi. My flight was canceled. What are my options for tonight?',
      exampleTranslation:
          'Oi. Meu voo foi cancelado. Quais são as minhas '
          'opções para hoje à noite?',
      audioAsset:
          'audio/fase5/licao14/My_flight_was_canceled_What_are_my_options.mp3',
      ipa: '/maɪ ˈflaɪt wəz ˈkænsəld ˈwʌɾ ər maɪ ˈɑpʃənz/',
      phonetic: 'mai FLÁIT uâz KÉN-sâld. UÂ-râr mai ÁP-shânz?',
      soundTip:
          'Was sai fraco, uâz. Canceled tem força no CAN, boca aberta. '
          'What are vira UÂ-râr, e a voz desce no fim da pergunta.',
    ),
    LessonItem(
      text: 'Could you let me know when we get there?',
      translation: 'Você pode me avisar quando a gente chegar?',
      example:
          "I don't know this area. Could you let me know when we get "
          'there?',
      exampleTranslation:
          'Não conheço a região. Você pode me avisar quando a '
          'gente chegar?',
      audioAsset:
          'audio/fase5/licao14/Could_you_let_me_know_when_we_get_there.mp3',
      ipa: '/kʊdʒə ˈlɛmi ˈnoʊ wɛn wi ˈɡɛt ˈðɛr/',
      phonetic: 'kudja LÉ-mi NÔU uén ui GUÉT DHÉR?',
      soundTip:
          'Could you vira kudja e let me vira LÉ-mi. Força em KNOW e '
          'THERE; no there a língua fica entre os dentes, e a voz sobe no '
          'fim.',
    ),
    LessonItem(
      text: 'Can you call me when you find my bag?',
      translation: 'Vocês podem me ligar quando acharem minha mala?',
      example: "Here's my number. Can you call me when you find my bag?",
      exampleTranslation:
          'Aqui está meu número. Podem me ligar quando '
          'acharem minha mala?',
      audioAsset:
          'audio/fase5/licao14/Can_you_call_me_when_you_find_my_bag.mp3',
      ipa: '/kən jə ˈkɔl mi wɛn jə ˈfaɪnd maɪ ˈbæɡ/',
      phonetic: 'kân-iâ KÓL mi uén-iâ FÁIND mai BÉG?',
      soundTip:
          'Can you e when you saem fracos, kân-iâ e uén-iâ. Call fecha '
          'com a língua no céu da boca. Força em CALL, FIND e BAG.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// ZONA 3 — HOTEL, DIREÇÕES E COMPRAS
// ---------------------------------------------------------------------------

/// Lição 15 — Chegada e saída no hotel: Check-in e check-out.
const fase5Licao15 = Lesson(
  id: 'fase5-licao15',
  title: 'Chegada e saída no hotel',
  objective:
      'Você vai fazer o check-in e o check-out falando da sua reserva, '
      'do horário e do café da manhã sem travar no balcão.',
  microSkill: 'Check-in e check-out',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I'm checking in.",
      translation: 'Vim fazer o check-in.',
      example: "Hi, good evening. I'm checking in.",
      exampleTranslation: 'Oi, boa noite. Vim fazer o check-in.',
      audioAsset: "audio/fase5/licao15/I'm_checking_in.mp3",
      ipa: '/aɪm ˈtʃɛkɪŋ ˈɪn/',
      phonetic: 'aim TCHÉ-kin ÍN',
      soundTip:
          'Checking termina no fundo da boca, sem soltar um g, e já '
          'emenda no in. Força em CHECK e IN, e a voz desce no fim.',
    ),
    LessonItem(
      text: "It's under Silva.",
      translation: 'Está no nome de Silva.',
      example: "A: What name is the reservation under? B: It's under Silva.",
      exampleTranslation:
          'A: Em que nome está a reserva? B: Está no nome de '
          'Silva.',
      audioAsset: "audio/fase5/licao15/It's_under_Silva.mp3",
      ipa: '/ɪts ˈʌndər ˈsɪlvə/',
      phonetic: 'its ÂN-der SÍL-va',
      soundTip:
          'Under começa com um â fechado e termina com a língua '
          'enrolada. Em Silva, o L sai do fundo da boca e o a final fica '
          'fraco.',
    ),
    LessonItem(
      text: 'Is breakfast included?',
      translation: 'O café da manhã está incluso?',
      example: 'The room looks great. Is breakfast included?',
      exampleTranslation:
          'O quarto parece ótimo. O café da manhã está '
          'incluso?',
      audioAsset: 'audio/fase5/licao15/Is_breakfast_included.mp3',
      ipa: '/ɪz ˈbrɛkfəst ɪnˈkludəd/',
      phonetic: 'iz BRÉK-fâst in-KLÚ-ded',
      soundTip:
          'Breakfast tem força só no BREAK e o fim sai fraco. Em '
          'included a força vai no CLU e a voz sobe no fim da pergunta.',
    ),
    LessonItem(
      text: 'What time is checkout?',
      translation: 'Que horas é o check-out?',
      example: "A: What time is checkout? B: Eleven o'clock.",
      exampleTranslation: 'A: Que horas é o check-out? B: Às onze.',
      audioAsset: 'audio/fase5/licao15/What_time_is_checkout.mp3',
      ipa: '/wʌt ˈtaɪm ɪz ˈtʃɛkaʊt/',
      phonetic: 'uât TÁI-miz TCHÉK-aut',
      soundTip:
          'O t de what trava sem soltar ar e emenda no TIME. Time e is '
          'se grudam, tái-miz, e em checkout a força fica no CHECK.',
    ),
    LessonItem(
      text: 'Can I check in early?',
      translation: 'Posso fazer o check-in mais cedo?',
      example: 'My flight landed at eight. Can I check in early?',
      exampleTranslation:
          'Meu voo pousou às oito. Posso fazer o check-in '
          'mais cedo?',
      audioAsset: 'audio/fase5/licao15/Can_I_check_in_early.mp3',
      ipa: '/kən aɪ ˈtʃɛk ɪn ˈɝli/',
      phonetic: 'ke-nai TCHÉ-kin ÊR-li',
      soundTip:
          'Can I sai fraco, ke-nai. Check in se gruda, tché-kin, e '
          'early já começa com a língua enrolada para trás.',
    ),
  ],
);

/// Lição 16 — Problemas no quarto: Reclamar do quarto.
const fase5Licao16 = Lesson(
  id: 'fase5-licao16',
  title: 'Problemas no quarto',
  objective:
      'Você vai avisar a recepção de um problema no quarto e pedir o '
      'que precisa, com educação e sem rodeio.',
  microSkill: 'Reclamar do quarto',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "There's no hot water.",
      translation: 'Não tem água quente.',
      example: "I'm in room four twelve, and there's no hot water.",
      exampleTranslation: 'Estou no quarto 412 e não tem água quente.',
      audioAsset: "audio/fase5/licao16/There's_no_hot_water.mp3",
      ipa: '/ðɛrz ˈnoʊ ˈhɑt ˈwɑɾər/',
      phonetic: 'thérz NÔU RRÁT UÓ-rer',
      soundTip:
          'Hot sai com a boca bem aberta e o t trava sem soltar ar. Em '
          'water, o t vira um r rápido, como em caro: UÓ-rer.',
    ),
    LessonItem(
      text: 'The room is too noisy.',
      translation: 'O quarto está barulhento demais.',
      example: "The room is too noisy. It's right next to the elevator.",
      exampleTranslation:
          'O quarto é barulhento demais. Fica bem do lado do '
          'elevador.',
      audioAsset: 'audio/fase5/licao16/The_room_is_too_noisy.mp3',
      ipa: '/ðə ˈrum ɪz ˈtu ˈnɔɪzi/',
      phonetic: 'tha RÚ-miz TÚ NÓI-zi',
      soundTip:
          'No room, enrole a língua para trás sem raspar a garganta. '
          'Room e is se grudam, rú-miz, e a força vai em TOO e NOI.',
    ),
    LessonItem(
      text: 'Could I get more towels?',
      translation: 'Pode me trazer mais toalhas?',
      example: 'Hi, this is room two oh five. Could I get more towels?',
      exampleTranslation:
          'Oi, aqui é do quarto 205. Pode me trazer mais '
          'toalhas?',
      audioAsset: 'audio/fase5/licao16/Could_I_get_more_towels.mp3',
      ipa: '/kʊdaɪ ˈɡɛt ˈmɔr ˈtaʊəlz/',
      phonetic: 'ku-dai GUÉT MÓR TÁU-elz',
      soundTip:
          'Could I vira ku-dai, uma palavra só. Em towels a força é no '
          'TAU e o fim fecha com L e um z zumbindo.',
    ),
    LessonItem(
      text: "The air conditioner isn't working.",
      translation: 'O ar-condicionado não está funcionando.',
      example: "Excuse me, the air conditioner isn't working in my room.",
      exampleTranslation:
          'Com licença, o ar-condicionado do meu quarto não '
          'está funcionando.',
      audioAsset: "audio/fase5/licao16/The_air_conditioner_isn't_working.mp3",
      ipa: '/ði ˈɛr kənˌdɪʃənər ˈɪzənt ˈwɝkɪŋ/',
      phonetic: 'thi ÉR kan-DÍ-sha-ner Í-zant UÊR-kin',
      soundTip:
          "Força em AIR, e conditioner sai mais leve. Isn't fica "
          'í-zant, com o t quase mudo, e working começa com a língua '
          'enrolada.',
    ),
    LessonItem(
      text: 'Could I move to another room?',
      translation: 'Posso trocar de quarto?',
      example: 'The room smells like smoke. Could I move to another room?',
      exampleTranslation:
          'O quarto está com cheiro de cigarro. Posso trocar '
          'de quarto?',
      audioAsset: 'audio/fase5/licao16/Could_I_move_to_another_room.mp3',
      ipa: '/kʊdaɪ ˈmuv tə əˈnʌðər ˈrum/',
      phonetic: 'ku-dai MÚV ta-NÂ-ther RÚM',
      soundTip:
          'Move fecha com v vibrando no lábio. To another se liga, '
          'ta-NÂ-ther, com a língua entre os dentes no th.',
    ),
  ],
);

/// Lição 17 — Pedir direções na rua: Pedir e confirmar direções.
const fase5Licao17 = Lesson(
  id: 'fase5-licao17',
  title: 'Pedir direções na rua',
  objective:
      'Você vai perguntar como chegar a um lugar e confirmar o '
      'caminho, mesmo quando a resposta vem rápida.',
  microSkill: 'Pedir e confirmar direções',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "Excuse me, I'm lost.",
      translation: 'Com licença, estou perdido.',
      example: "Excuse me, I'm lost. Is this Main Street?",
      exampleTranslation: 'Com licença, estou perdido. Aqui é a Main Street?',
      audioAsset: "audio/fase5/licao17/Excuse_me_I'm_lost.mp3",
      ipa: '/ɪkˈskjuz mi aɪm ˈlɔst/',
      phonetic: 'eks-KIÚZ mi, aim LÓST',
      soundTip:
          'Excuse me começa fraco e a força cai no CUSE, que zumbe como '
          'z. Lost termina em st colado, sem vogal no final.',
    ),
    LessonItem(
      text: 'Can I walk there?',
      translation: 'Dá pra ir a pé?',
      example: 'A: The museum is next to the park. B: Great. Can I walk there?',
      exampleTranslation:
          'A: O museu fica do lado do parque. B: Ótimo. Dá '
          'pra ir a pé?',
      audioAsset: 'audio/fase5/licao17/Can_I_walk_there.mp3',
      ipa: '/kən aɪ ˈwɔk ðɛr/',
      phonetic: 'ke-nai UÓK thér',
      soundTip:
          'O L de walk é mudo: só UÓK, com a boca arredondada. There '
          'sai com a língua entre os dentes e a voz sobe no fim.',
    ),
    LessonItem(
      text: 'Is it on the left?',
      translation: 'Fica à esquerda?',
      example: 'A: Go straight for two blocks. B: Is it on the left?',
      exampleTranslation: 'A: Siga reto por duas quadras. B: Fica à esquerda?',
      audioAsset: 'audio/fase5/licao17/Is_it_on_the_left.mp3',
      ipa: '/ɪzɪɾ ɑn ðə ˈlɛft/',
      phonetic: 'i-zi-rón tha LÉFT',
      soundTip:
          'Is it on vira uma palavra só, i-zi-rón, com o t virando um r '
          'rápido. Força em LEFT, que fecha em ft colado.',
    ),
    LessonItem(
      text: 'How do I get to the museum?',
      translation: 'Como eu chego ao museu?',
      example: 'Excuse me, how do I get to the museum from here?',
      exampleTranslation: 'Com licença, como eu chego ao museu daqui?',
      audioAsset: 'audio/fase5/licao17/How_do_I_get_to_the_museum.mp3',
      ipa: '/ˈhaʊ dəwaɪ ˈɡɛt tə ðə mjuˈziəm/',
      phonetic: 'RRÁU da-uai GUÉT ta tha miu-ZÍ-am',
      soundTip:
          'Força em HOW, GET e no ZI de museum. Do I sai fraco e '
          'ligado, da-uai, e o t de get gruda no to sem soltar ar.',
    ),
    LessonItem(
      text: 'Can you show me on the map?',
      translation: 'Pode me mostrar no mapa?',
      example: "I don't know this area. Can you show me on the map?",
      exampleTranslation: 'Não conheço esta região. Pode me mostrar no mapa?',
      audioAsset: 'audio/fase5/licao17/Can_you_show_me_on_the_map.mp3',
      ipa: '/kən jə ˈʃoʊ mi ɑn ðə ˈmæp/',
      phonetic: 'kenia SHÔU mi ón tha MÉP',
      soundTip:
          'Can you sai junto e fraco, kenia. Força em SHOW e MAP; o a '
          'de map abre bem, entre a e é, e o p fecha os lábios.',
    ),
  ],
);

/// Lição 18 — Na loja de roupas: Loja e tamanho de roupa.
const fase5Licao18 = Lesson(
  id: 'fase5-licao18',
  title: 'Na loja de roupas',
  objective:
      'Você vai circular numa loja de roupas: dizer que só está '
      'olhando, pedir para provar e pedir outro tamanho.',
  microSkill: 'Loja e tamanho de roupa',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: "I'm just looking, thanks.",
      translation: 'Só estou olhando, obrigado.',
      example: "A: Can I help you find something? B: I'm just looking, thanks.",
      exampleTranslation:
          'A: Posso ajudar a encontrar alguma coisa? B: Só '
          'estou olhando, obrigado.',
      audioAsset: "audio/fase5/licao18/I'm_just_looking_thanks.mp3",
      ipa: '/aɪm ˈdʒʌs ˈlʊkɪŋ ˈθæŋks/',
      phonetic: 'aim DJÂS LÚ-kin, THÉNKS',
      soundTip:
          'O t de just quase some antes do looking. Em thanks, ponha a '
          'ponta da língua entre os dentes e sopre antes do a.',
    ),
    LessonItem(
      text: 'Can I try this on?',
      translation: 'Posso provar?',
      example: 'I really like this shirt. Can I try this on?',
      exampleTranslation: 'Gostei muito dessa camisa. Posso provar?',
      audioAsset: 'audio/fase5/licao18/Can_I_try_this_on.mp3',
      ipa: '/kən aɪ ˈtraɪ ðɪˈsɑn/',
      phonetic: 'ke-nai TRÁI thi-SÓN',
      soundTip:
          'Em try, a língua enrola logo depois do t. This on se liga, '
          'thi-SÓN, e a força final vai no ON.',
    ),
    LessonItem(
      text: 'Where are the fitting rooms?',
      translation: 'Onde ficam os provadores?',
      example: 'A: Where are the fitting rooms? B: In the back, on the right.',
      exampleTranslation:
          'A: Onde ficam os provadores? B: Lá no fundo, à '
          'direita.',
      audioAsset: 'audio/fase5/licao18/Where_are_the_fitting_rooms.mp3',
      ipa: '/ˈwɛr ər ðə ˈfɪɾɪŋ ˌrumz/',
      phonetic: 'UÉR er tha FÍ-rin RÚMZ',
      soundTip:
          'Where are vira quase uma palavra só, uér-er. Em fitting, o t '
          'vira um r rápido, FÍ-rin, e rooms termina zumbindo.',
    ),
    LessonItem(
      text: "It's a little too big.",
      translation: 'Ficou um pouco grande.',
      example: "It's a little too big. Can I try the next size down?",
      exampleTranslation:
          'Ficou um pouco grande. Posso provar um tamanho '
          'abaixo?',
      audioAsset: "audio/fase5/licao18/It's_a_little_too_big.mp3",
      ipa: '/ɪts ə ˈlɪɾəl ˈtu ˈbɪɡ/',
      phonetic: 'it-sa LÍ-rol TÚ BÍG',
      soundTip:
          "It's a se ligam, it-sa. Em little, o t vira um r rápido e o "
          'L final fica no fundo da boca; big fecha seco no g.',
    ),
    LessonItem(
      text: 'Do you have this in a medium?',
      translation: 'Tem esse no tamanho M?',
      example: 'This one is a small. Do you have this in a medium?',
      exampleTranslation: 'Esse é P. Tem esse no tamanho M?',
      audioAsset: 'audio/fase5/licao18/Do_you_have_this_in_a_medium.mp3',
      ipa: '/də jə ˈhæv ðɪs ɪn ə ˈmidiəm/',
      phonetic: 'da-ia RRÉV thi-si-na MÍ-di-am',
      soundTip:
          'Do you sai fraco, da-ia. This in a vira uma palavra só, '
          'thi-si-na, e a força final cai no ME de medium.',
    ),
  ],
);

/// Lição 19 — Preço, pagamento e troca: Preço, pagamento e troca.
const fase5Licao19 = Lesson(
  id: 'fase5-licao19',
  title: 'Preço, pagamento e troca',
  objective:
      'Você vai perguntar preço e promoção, acertar o pagamento e '
      'resolver uma troca ou devolução no caixa.',
  microSkill: 'Preço, pagamento e troca',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'How much is this jacket?',
      translation: 'Quanto custa esta jaqueta?',
      example: "Excuse me, how much is this jacket? I can't find the price.",
      exampleTranslation:
          'Com licença, quanto custa esta jaqueta? Não acho o '
          'preço.',
      audioAsset: 'audio/fase5/licao19/How_much_is_this_jacket.mp3',
      ipa: '/ˈhaʊ ˈmʌtʃ ɪz ðɪs ˈdʒækət/',
      phonetic: 'RRÁU MÂ-tchiz this DJÉ-ket',
      soundTip:
          'Much e is se grudam, mâ-tchiz. Em jacket a força é no JA, '
          'com a boca bem aberta, e o t final trava sem soltar ar.',
    ),
    LessonItem(
      text: 'Is this one on sale too?',
      translation: 'Este aqui também está em promoção?',
      example: 'These shoes are fifty percent off. Is this one on sale too?',
      exampleTranslation:
          'Estes sapatos estão com cinquenta por cento de '
          'desconto. Este aqui também está em promoção?',
      audioAsset: 'audio/fase5/licao19/Is_this_one_on_sale_too.mp3',
      ipa: '/ɪz ðɪs ˈwʌn ɑn ˈseɪl ˈtu/',
      phonetic: 'iz this UÂ-nón SÊIL TÚ',
      soundTip:
          'One on se liga, uâ-nón. Sale fecha com a ponta da língua no '
          'céu da boca, e a voz sobe no TOO, no fim da pergunta.',
    ),
    LessonItem(
      text: 'Can I pay with cash?',
      translation: 'Posso pagar em dinheiro?',
      example: "I don't have a card with me. Can I pay with cash?",
      exampleTranslation: 'Estou sem cartão. Posso pagar em dinheiro?',
      audioAsset: 'audio/fase5/licao19/Can_I_pay_with_cash.mp3',
      ipa: '/kən aɪ ˈpeɪ wɪð ˈkæʃ/',
      phonetic: 'ke-nai PÊI uith KÉSH?',
      soundTip:
          'Can I sai fraco, ke-nai. Força em PAY e CASH; cash abre bem '
          'a boca, entre a e é, e fecha num sh soprado, sem i no fim.',
    ),
    LessonItem(
      text: "I'd like to return this, please.",
      translation: 'Eu queria devolver isto, por favor.',
      example: "I'd like to return this, please. It doesn't fit.",
      exampleTranslation: 'Eu queria devolver isto, por favor. Não serviu.',
      audioAsset: "audio/fase5/licao19/I'd_like_to_return_this_please.mp3",
      ipa: '/aɪd ˈlaɪk tə rɪˈtɝn ðɪs ˈpliz/',
      phonetic: 'aid LÁIK ta ri-TÊRN this, PLÍZ',
      soundTip:
          "I'd like to sai rápido, aid-LÁIK-ta. Em return a força cai "
          'no TURN, com a língua enrolada; please termina zumbindo.',
    ),
    LessonItem(
      text: 'Could I get a gift receipt, please?',
      translation: 'Pode me dar um tíquete de troca, por favor?',
      example: "It's for my sister. Could I get a gift receipt, please?",
      exampleTranslation:
          'É pra minha irmã. Pode me dar um tíquete de troca, '
          'por favor?',
      audioAsset: 'audio/fase5/licao19/Could_I_get_a_gift_receipt_please.mp3',
      ipa: '/kʊdaɪ ˈɡɛɾə ˈɡɪft rɪˈsit ˈpliz/',
      phonetic: 'ku-dai GUÉ-ra GUÍFT ri-SÍT, PLÍZ',
      soundTip:
          'Get a vira gué-ra, com o t virando um r rápido. O p de '
          'receipt é mudo: ri-SÍT, com a força no SIT.',
    ),
  ],
);

/// Lição 20 (revisão) — Revisão: hotel, rua e loja: Revisão da zona.
const fase5Licao20 = Lesson(
  id: 'fase5-licao20',
  title: 'Revisão: hotel, rua e loja',
  objective:
      'Você vai repetir uma frase de cada lição da zona em situações '
      'novas, para ver o que já sai no automático.',
  microSkill: 'Revisão da zona',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Is breakfast included?',
      translation: 'O café da manhã está incluso?',
      example: 'A: The room is one fifty a night. B: Is breakfast included?',
      exampleTranslation:
          'A: O quarto custa cento e cinquenta por noite. B: '
          'O café da manhã está incluso?',
      audioAsset: 'audio/fase5/licao15/Is_breakfast_included.mp3',
      ipa: '/ɪz ˈbrɛkfəst ɪnˈkludəd/',
      phonetic: 'iz BRÉK-fâst in-KLÚ-ded',
      soundTip:
          'Breakfast tem força só no BREAK e o fim sai fraco. Em '
          'included a força vai no CLU e a voz sobe no fim da pergunta.',
    ),
    LessonItem(
      text: "There's no hot water.",
      translation: 'Não tem água quente.',
      example: "Sorry to bother you, but there's no hot water.",
      exampleTranslation: 'Desculpa incomodar, mas não tem água quente.',
      audioAsset: "audio/fase5/licao16/There's_no_hot_water.mp3",
      ipa: '/ðɛrz ˈnoʊ ˈhɑt ˈwɑɾər/',
      phonetic: 'thérz NÔU RRÁT UÓ-rer',
      soundTip:
          'Hot sai com a boca bem aberta e o t trava sem soltar ar. Em '
          'water, o t vira um r rápido, como em caro: UÓ-rer.',
    ),
    LessonItem(
      text: 'Can you show me on the map?',
      translation: 'Pode me mostrar no mapa?',
      example: "A: It's just past the bridge. B: Can you show me on the map?",
      exampleTranslation:
          'A: Fica logo depois da ponte. B: Pode me mostrar '
          'no mapa?',
      audioAsset: 'audio/fase5/licao17/Can_you_show_me_on_the_map.mp3',
      ipa: '/kən jə ˈʃoʊ mi ɑn ðə ˈmæp/',
      phonetic: 'kenia SHÔU mi ón tha MÉP',
      soundTip:
          'Can you sai junto e fraco, kenia. Força em SHOW e MAP; o a '
          'de map abre bem, entre a e é, e o p fecha os lábios.',
    ),
    LessonItem(
      text: 'Can I try this on?',
      translation: 'Posso provar?',
      example: 'This dress is beautiful. Can I try this on?',
      exampleTranslation: 'Esse vestido é lindo. Posso provar?',
      audioAsset: 'audio/fase5/licao18/Can_I_try_this_on.mp3',
      ipa: '/kən aɪ ˈtraɪ ðɪˈsɑn/',
      phonetic: 'ke-nai TRÁI thi-SÓN',
      soundTip:
          'Em try, a língua enrola logo depois do t. This on se liga, '
          'thi-SÓN, e a força final vai no ON.',
    ),
    LessonItem(
      text: 'Can I pay with cash?',
      translation: 'Posso pagar em dinheiro?',
      example: "My card isn't working. Can I pay with cash?",
      exampleTranslation:
          'Meu cartão não está passando. Posso pagar em '
          'dinheiro?',
      audioAsset: 'audio/fase5/licao19/Can_I_pay_with_cash.mp3',
      ipa: '/kən aɪ ˈpeɪ wɪð ˈkæʃ/',
      phonetic: 'ke-nai PÊI uith KÉSH?',
      soundTip:
          'Can I sai fraco, ke-nai. Força em PAY e CASH; cash abre bem '
          'a boca, entre a e é, e fecha num sh soprado, sem i no fim.',
    ),
  ],
);

/// Lição 21 — BÔNUS — Bônus: hotel, rua e loja: Frases longas de viagem.
const fase5Licao21 = Lesson(
  id: 'fase5-licao21',
  title: 'Bônus: hotel, rua e loja',
  objective:
      'Você vai resolver situações de hotel, rua e loja com frases '
      'mais longas, mantendo o ritmo ligado até o fim.',
  microSkill: 'Frases longas de viagem',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: 'Can I leave my bags here until three?',
      translation: 'Posso deixar minhas malas aqui até as três?',
      example: 'We already checked out. Can I leave my bags here until three?',
      exampleTranslation:
          'Já fizemos o check-out. Posso deixar minhas malas '
          'aqui até as três?',
      audioAsset:
          'audio/fase5/licao21/Can_I_leave_my_bags_here_until_three.mp3',
      ipa: '/kən aɪ ˈliv maɪ ˈbæɡz hɪr ənˈtɪl ˈθri/',
      phonetic: 'ke-nai LÍV mai BÉGZ RRÍR an-TÍL THRÍ',
      soundTip:
          'Leave tem i longo e fecha com v vibrando. Bags termina '
          'zumbindo, gz; em three, língua entre os dentes e o r logo depois.',
    ),
    LessonItem(
      text: 'Could someone come up and take a look?',
      translation: 'Alguém pode subir pra dar uma olhada?',
      example: "The TV isn't working. Could someone come up and take a look?",
      exampleTranslation:
          'A TV não está funcionando. Alguém pode subir pra '
          'dar uma olhada?',
      audioAsset:
          'audio/fase5/licao21/Could_someone_come_up_and_take_a_look.mp3',
      ipa: '/kʊd ˈsʌmwʌn ˈkʌm ˈʌp ən ˈteɪk ə ˈlʊk/',
      phonetic: 'kud SÂM-uan KÂ-MÂ-pen TÊI-ka LÚK',
      soundTip:
          'Come up and vira um bloco só, kâ-mâ-pen. Take a se grudam, '
          'têi-ka, e look fecha com um k seco.',
    ),
    LessonItem(
      text: 'How long does it take to walk there?',
      translation: 'Quanto tempo leva pra ir a pé até lá?',
      example:
          'A: The castle is up the hill. B: How long does it take to '
          'walk there?',
      exampleTranslation:
          'A: O castelo fica no alto do morro. B: Quanto '
          'tempo leva pra ir a pé até lá?',
      audioAsset: 'audio/fase5/licao21/How_long_does_it_take_to_walk_there.mp3',
      ipa: '/ˈhaʊ ˈlɔŋ dəzɪt ˈteɪk tə ˈwɔk ðɛr/',
      phonetic: 'RRÁU LÓN da-zit TÊIK ta UÓK thér',
      soundTip:
          'Long termina no fundo da garganta, sem soltar g. Does it '
          'vira da-zit, fraco; força em TAKE e WALK, com o L de walk mudo.',
    ),
    LessonItem(
      text: 'Do you have the same one in black?',
      translation: 'Tem esse mesmo modelo em preto?',
      example: 'I love this bag, but do you have the same one in black?',
      exampleTranslation:
          'Adorei essa bolsa, mas tem esse mesmo modelo em '
          'preto?',
      audioAsset: 'audio/fase5/licao21/Do_you_have_the_same_one_in_black.mp3',
      ipa: '/də jə ˈhæv ðə ˈseɪm ˈwʌn ɪn ˈblæk/',
      phonetic: 'da-ia RRÉV tha SÊIM UÂ-nin BLÉK',
      soundTip:
          'Same fecha com os lábios no m antes do one. One in se liga, '
          'uâ-nin, e black abre bem a boca e termina num k seco.',
    ),
    LessonItem(
      text: "I'd like to exchange this for a smaller size.",
      translation: 'Eu queria trocar isto por um tamanho menor.',
      example:
          "This shirt is too loose. I'd like to exchange this for a "
          'smaller size.',
      exampleTranslation:
          'Esta camisa ficou larga. Eu queria trocar por um '
          'tamanho menor.',
      audioAsset:
          "audio/fase5/licao21/I'd_like_to_exchange_this_for_a_smaller_size.mp3",
      ipa: '/aɪd ˈlaɪk tu ɪksˈtʃeɪndʒ ðɪs fərə ˈsmɔlər ˈsaɪz/',
      phonetic: 'aid LÁIK tu iks-TCHÊINDJ this fe-ra SMÓ-ler SÁIZ',
      soundTip:
          'Exchange tem força no CHANGE, que fecha em dj. For a vira '
          'fe-ra; smaller começa com s colado no m, e size zumbe no z.',
    ),
  ],
);

// ---------------------------------------------------------------------------
// ZONA 4 — SAÚDE E EMERGÊNCIAS
// ---------------------------------------------------------------------------

/// Lição 22 — Na farmácia: pedir remédio no balcão.
const fase5Licao22 = Lesson(
  id: 'fase5-licao22',
  title: 'Na farmácia',
  objective:
      'Você vai pedir um remédio no balcão da farmácia e perguntar se '
      'precisa de receita e como tomar.',
  microSkill: 'pedir remédio no balcão',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Is there a pharmacy nearby?',
      translation: 'Tem uma farmácia aqui perto?',
      example: 'Excuse me, is there a pharmacy nearby? I need some aspirin.',
      exampleTranslation:
          'Com licença, tem uma farmácia aqui perto? Preciso '
          'de aspirina.',
      audioAsset: 'audio/fase5/licao22/Is_there_a_pharmacy_nearby.mp3',
      ipa: '/ɪz ðɛr ə ˈfɑrməsi ˌnɪrˈbaɪ/',
      phonetic: 'iz thé-râ FÁR-mâ-si nir-BÁI?',
      soundTip:
          'Is there a sai colado e fraco, iz thé-râ. Força em FAR e BY, '
          'com o r do far curvado pra trás. A voz sobe no fim.',
    ),
    LessonItem(
      text: 'I need something for a headache.',
      translation: 'Preciso de alguma coisa pra dor de cabeça.',
      example: 'Hi, I need something for a headache. What do you have?',
      exampleTranslation:
          'Oi, preciso de alguma coisa pra dor de cabeça. O '
          'que você tem?',
      audioAsset: 'audio/fase5/licao22/I_need_something_for_a_headache.mp3',
      ipa: '/aɪ ˈnid ˈsʌmθɪŋ fɚr ə ˈhɛdeɪk/',
      phonetic: 'ai NÍD SÂM-thing fâ-râ RRÉ-dêik',
      soundTip:
          'For a se liga num fâ-râ rápido. Força em NEED, SOME e HEAD; '
          'o th de something é língua entre os dentes e o ache fecha seco no '
          'k.',
    ),
    LessonItem(
      text: 'Do I need a prescription?',
      translation: 'Precisa de receita?',
      example: 'A: This one is stronger. B: Do I need a prescription?',
      exampleTranslation: 'A: Esse é mais forte. B: Precisa de receita?',
      audioAsset: 'audio/fase5/licao22/Do_I_need_a_prescription.mp3',
      ipa: '/də aɪ ˈnid ə prəˈskrɪpʃən/',
      phonetic: 'dâ-ai NÍ-dâ prâ-SKRÍP-shân?',
      soundTip:
          'Do I sai num dâ-ai rápido e need a vira NÍ-dâ. No '
          'prescription, o s vem grudado no k e a força cai em SCRIP. Voz '
          'sobe no fim.',
    ),
    LessonItem(
      text: 'How often should I take it?',
      translation: 'De quanto em quanto tempo eu tomo?',
      example: 'A: Here you go. B: Thanks. How often should I take it?',
      exampleTranslation:
          'A: Aqui está. B: Obrigado. De quanto em quanto '
          'tempo eu tomo?',
      audioAsset: 'audio/fase5/licao22/How_often_should_I_take_it.mp3',
      ipa: '/haʊ ˈɔfən ʃəd aɪ ˈteɪk ɪt/',
      phonetic: 'rráu Ó-fân shâ-dai TÊI-kit?',
      soundTip:
          'Should I vira um shâ-dai rápido, sem o l. Take it se cola em '
          'TÊI-kit. Força em OF e TAKE; o t de often fica mudo.',
    ),
    LessonItem(
      text: 'Do you have cough syrup?',
      translation: 'Tem xarope pra tosse?',
      example: "I can't stop coughing. Do you have cough syrup?",
      exampleTranslation: 'Não consigo parar de tossir. Tem xarope pra tosse?',
      audioAsset: 'audio/fase5/licao22/Do_you_have_cough_syrup.mp3',
      ipa: '/də jə ˈhæv ˈkɔf ˌsɪrəp/',
      phonetic: 'dâ-iâ RRÉV KÓF SÍ-râp?',
      soundTip:
          'Do you passa num dâ-iâ fraco. Força em HAVE e COUGH; o cough '
          'termina num f soprado e o syrup fecha no p, com os lábios juntos.',
    ),
  ],
);

/// Lição 23 — Dizer o que está sentindo: descrever sintomas.
const fase5Licao23 = Lesson(
  id: 'fase5-licao23',
  title: 'Dizer o que está sentindo',
  objective:
      'Você vai descrever o que está sentindo e desde quando, com '
      'frases curtas que o médico ou o farmacêutico entendem na hora.',
  microSkill: 'descrever sintomas',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'I have a fever.',
      translation: 'Estou com febre.',
      example: 'I have a fever and I feel really tired.',
      exampleTranslation: 'Estou com febre e me sinto muito cansado.',
      audioAsset: 'audio/fase5/licao23/I_have_a_fever.mp3',
      ipa: '/aɪ ˈhæv ə ˈfivɚ/',
      phonetic: 'ai RRÉ-vâ FÍ-vâr',
      soundTip:
          'Have a se liga num RRÉ-vâ. Força em FE; no fim de fever, a '
          'língua curva pra trás no r e a voz para ali, sem vogal depois.',
    ),
    LessonItem(
      text: 'My stomach hurts.',
      translation: 'Estou com dor de estômago.',
      example: 'I think it was the fish. My stomach hurts.',
      exampleTranslation: 'Acho que foi o peixe. Tô com dor de estômago.',
      audioAsset: 'audio/fase5/licao23/My_stomach_hurts.mp3',
      ipa: '/maɪ ˈstʌmək ˈhɝts/',
      phonetic: 'mai STÂ-mâk RRÉRTS',
      soundTip:
          'Stomach começa direto no st, sem vogal antes, e termina num '
          'k seco. Hurts é um ar leve no h, r curvado e ts seco no fim.',
    ),
    LessonItem(
      text: 'I feel dizzy.',
      translation: 'Estou tonto.',
      example: 'Can I sit down for a minute? I feel dizzy.',
      exampleTranslation: 'Posso sentar um minuto? Tô tonto.',
      audioAsset: 'audio/fase5/licao23/I_feel_dizzy.mp3',
      ipa: '/aɪ ˈfil ˈdɪzi/',
      phonetic: 'ai FÍL DÍ-zi',
      soundTip:
          'Feel tem i longo e termina com a ponta da língua no céu da '
          'boca. Dizzy começa com d firme e seco, e o z do meio zumbe.',
    ),
    LessonItem(
      text: 'It hurts right here.',
      translation: 'Dói bem aqui.',
      example:
          'A: Where does it hurt? B: It hurts right here, on the left '
          'side.',
      exampleTranslation: 'A: Onde dói? B: Dói bem aqui, do lado esquerdo.',
      audioAsset: 'audio/fase5/licao23/It_hurts_right_here.mp3',
      ipa: '/ɪt ˈhɝts raɪt ˈhɪr/',
      phonetic: 'it RRÉRTS rait RRÍR',
      soundTip:
          'Right começa com a língua curvada pra trás, sem raspar a '
          'garganta, e o t dele quase some. Força em HURTS e HERE, apontando '
          'o lugar.',
    ),
    LessonItem(
      text: "I've been sick since yesterday.",
      translation: 'Estou doente desde ontem.',
      example: "I've been sick since yesterday, and it's getting worse.",
      exampleTranslation: 'Tô doente desde ontem, e está piorando.',
      audioAsset: "audio/fase5/licao23/I've_been_sick_since_yesterday.mp3",
      ipa: '/aɪv bɪn ˈsɪk sɪns ˈjɛstɚdeɪ/',
      phonetic: 'aiv bin SÍK sins IÉS-târ-dei',
      soundTip:
          "I've been sai rápido e fraco, aiv-bin, com um v curtinho que "
          'não some. Força em SICK e YES; since passa leve no meio.',
    ),
  ],
);

/// Lição 24 — Na consulta médica: pedir e conduzir consulta.
const fase5Licao24 = Lesson(
  id: 'fase5-licao24',
  title: 'Na consulta médica',
  objective:
      'Você vai pedir para ver um médico, avisar que tem seguro viagem '
      'e fazer as perguntas que importam na consulta.',
  microSkill: 'pedir e conduzir consulta',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Is it serious?',
      translation: 'É grave?',
      example: 'A: You have an ear infection. B: Is it serious?',
      exampleTranslation:
          'A: Você está com uma infecção no ouvido. B: É '
          'grave?',
      audioAsset: 'audio/fase5/licao24/Is_it_serious.mp3',
      ipa: '/ɪz ɪt ˈsɪriəs/',
      phonetic: 'i-zit SÍ-ri-âs?',
      soundTip:
          'Is it se cola num i-zit rápido. Toda a força vai em SE, o '
          'resto de serious sai leve, e a voz sobe no fim da pergunta.',
    ),
    LessonItem(
      text: 'I need to see a doctor.',
      translation: 'Preciso ver um médico.',
      example: 'I need to see a doctor. Is there a clinic near the hotel?',
      exampleTranslation:
          'Preciso ver um médico. Tem uma clínica perto do '
          'hotel?',
      audioAsset: 'audio/fase5/licao24/I_need_to_see_a_doctor.mp3',
      ipa: '/aɪ ˈnid tə ˈsi ə ˈdɑktɚ/',
      phonetic: 'ai NÍD tâ SÍ-â DÁK-târ',
      soundTip:
          'O to fica fraco, um tâ rápido. Força em NEED, SEE e DOC. No '
          'doctor, o k e o t vêm colados, sem vogal entre eles.',
    ),
    LessonItem(
      text: 'I have travel insurance.',
      translation: 'Tenho seguro viagem.',
      example:
          'A: How would you like to pay? B: I have travel insurance. '
          "Here's my card.",
      exampleTranslation:
          'A: Como prefere pagar? B: Tenho seguro viagem. '
          'Aqui está meu cartão.',
      audioAsset: 'audio/fase5/licao24/I_have_travel_insurance.mp3',
      ipa: '/aɪ ˈhæv ˈtrævəl ɪnˈʃʊrəns/',
      phonetic: 'ai RRÉV TRÉ-vâl in-SHÚ-râns',
      soundTip:
          'Força em TRA e SHU. Travel termina com a língua no céu da '
          'boca no l. No insurance, o som do meio é o ch de chave.',
    ),
    LessonItem(
      text: 'Can I see someone today?',
      translation: 'Dá pra ser atendido hoje?',
      example: "It's really painful. Can I see someone today?",
      exampleTranslation: 'Está doendo muito. Dá pra ser atendido hoje?',
      audioAsset: 'audio/fase5/licao24/Can_I_see_someone_today.mp3',
      ipa: '/kən aɪ ˈsi ˈsʌmwʌn təˈdeɪ/',
      phonetic: 'kâ-nai SÍ SÂM-uân tâ-DÊI?',
      soundTip:
          'Can I vira kâ-nai, colado e fraco. Força em SEE, SOME e DAY. '
          'O to de today é só um tâ leve, e a voz sobe no fim.',
    ),
    LessonItem(
      text: 'Could you write that down, please?',
      translation: 'Pode escrever isso pra mim, por favor?',
      example:
          "Sorry, my English isn't great. Could you write that down, "
          'please?',
      exampleTranslation:
          'Desculpa, meu inglês não é muito bom. Pode '
          'escrever isso pra mim, por favor?',
      audioAsset: 'audio/fase5/licao24/Could_you_write_that_down_please.mp3',
      ipa: '/kʊdʒə ˈraɪt ðæt ˈdaʊn ˈpliz/',
      phonetic: 'kú-djâ RÁIT thét DÁUN, PLÍZ?',
      soundTip:
          'Could you vira kú-djâ. O t de write fica preso, sem soltar, '
          'e o th de that vem logo atrás. Força em WRITE, DOWN e PLEASE.',
    ),
  ],
);

/// Lição 25 — Pedir socorro: pedir socorro com clareza.
const fase5Licao25 = Lesson(
  id: 'fase5-licao25',
  title: 'Pedir socorro',
  objective:
      'Você vai pedir ajuda numa emergência com frases curtas e '
      'firmes, que saem mesmo quando você está nervoso.',
  microSkill: 'pedir socorro com clareza',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'Call an ambulance!',
      translation: 'Chama uma ambulância!',
      example: "He fell and he can't get up. Call an ambulance!",
      exampleTranslation:
          'Ele caiu e não consegue levantar. Chama uma '
          'ambulância!',
      audioAsset: 'audio/fase5/licao25/Call_an_ambulance.mp3',
      ipa: '/ˈkɔl ən ˈæmbjələns/',
      phonetic: 'KÓ-lân ÉM-biâ-lâns!',
      soundTip:
          'Call an se liga em KÓ-lân. Toda a força vai em AM, com a '
          'boca bem aberta; o resto de ambulance sai rápido e fraco.',
    ),
    LessonItem(
      text: "It's an emergency.",
      translation: 'É uma emergência.',
      example: "Please let me through, it's an emergency.",
      exampleTranslation: 'Por favor, me deixa passar, é uma emergência.',
      audioAsset: "audio/fase5/licao25/It's_an_emergency.mp3",
      ipa: '/ɪts ən ɪˈmɝdʒənsi/',
      phonetic: 'its-ân i-MÉR-djân-si',
      soundTip:
          "It's an sai colado, its-ân. A força cai em MER, com o r "
          'curvado; o g soa dj e o fim da palavra fica fraco.',
    ),
    LessonItem(
      text: 'Please call nine one one!',
      translation: 'Por favor, liga pro 911!',
      example: 'Someone is hurt over there. Please call nine one one!',
      exampleTranslation:
          'Tem alguém ferido ali. Por favor, liga pra '
          'emergência!',
      audioAsset: 'audio/fase5/licao25/Please_call_nine_one_one.mp3',
      ipa: '/ˈpliz ˈkɔl ˈnaɪn ˈwʌn ˈwʌn/',
      phonetic: 'PLÍZ KÓL NÁIN UÂN UÂN!',
      soundTip:
          'O número sai dígito por dígito, nine, one, one, cada um com '
          'força. One soa uân, e call fecha com a língua no céu da boca.',
    ),
    LessonItem(
      text: "Where's the nearest hospital?",
      translation: 'Onde fica o hospital mais perto?',
      example: "Excuse me, where's the nearest hospital? My friend is hurt.",
      exampleTranslation:
          'Com licença, onde fica o hospital mais perto? Meu '
          'amigo se machucou.',
      audioAsset: "audio/fase5/licao25/Where's_the_nearest_hospital.mp3",
      ipa: '/ˈwɛrz ðə ˈnɪrəst ˈhɑspɪɾəl/',
      phonetic: 'UÉRZ thâ NÍ-râst RRÁS-pi-râl?',
      soundTip:
          "Where's the sai colado e rápido. Força em NEAR e HOS; no "
          'hospital, o t do meio vira um r leve e o fim fecha no l.',
    ),
    LessonItem(
      text: 'Does anyone here speak Portuguese?',
      translation: 'Alguém aqui fala português?',
      example:
          "I can't explain this in English. Does anyone here speak "
          'Portuguese?',
      exampleTranslation:
          'Não consigo explicar isso em inglês. Alguém aqui '
          'fala português?',
      audioAsset: 'audio/fase5/licao25/Does_anyone_here_speak_Portuguese.mp3',
      ipa: '/dəz ˈɛniwʌn ˈhɪr ˈspik ˈpɔrtʃəˌɡiz/',
      phonetic: 'dâz É-ni-uân RRÍR SPÍK PÓR-tchâ-guiz?',
      soundTip:
          'Does fica fraco, um dâz rápido. Speak começa direto no sp, '
          'sem vogal antes. Em Portuguese, força em POR e o fim soa guiz.',
    ),
  ],
);

/// Lição 26 — Perda, roubo e polícia: relatar perda e roubo.
const fase5Licao26 = Lesson(
  id: 'fase5-licao26',
  title: 'Perda, roubo e polícia',
  objective:
      'Você vai contar que perdeu algo ou foi roubado e pedir o '
      'registro na polícia, mesmo com o nervoso da hora.',
  microSkill: 'relatar perda e roubo',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'I lost my wallet.',
      translation: 'Perdi minha carteira.',
      example: 'I lost my wallet. I think I left it in the taxi.',
      exampleTranslation: 'Perdi minha carteira. Acho que deixei no táxi.',
      audioAsset: 'audio/fase5/licao26/I_lost_my_wallet.mp3',
      ipa: '/aɪ ˈlɔst maɪ ˈwɑlət/',
      phonetic: 'ai LÓST mai UÁ-lât',
      soundTip:
          'Lost fecha no st sem vogal depois, grudado no my. Força em '
          'LOST e WAL; o wallet termina num t curtinho.',
    ),
    LessonItem(
      text: 'Someone stole my phone.',
      translation: 'Roubaram meu celular.',
      example: 'Someone stole my phone on the subway.',
      exampleTranslation: 'Roubaram meu celular no metrô.',
      audioAsset: 'audio/fase5/licao26/Someone_stole_my_phone.mp3',
      ipa: '/ˈsʌmwʌn ˈstoʊl maɪ ˈfoʊn/',
      phonetic: 'SÂM-uân STÔUL mai FÔUN',
      soundTip:
          'Stole começa direto no st, sem vogal antes, e fecha com a '
          'língua no céu da boca. Força em SOME, STOLE e PHONE.',
    ),
    LessonItem(
      text: 'My passport was stolen.',
      translation: 'Roubaram meu passaporte.',
      example: "My passport was stolen. Where's the Brazilian consulate?",
      exampleTranslation:
          'Roubaram meu passaporte. Onde fica o consulado '
          'brasileiro?',
      audioAsset: 'audio/fase5/licao26/My_passport_was_stolen.mp3',
      ipa: '/maɪ ˈpæspɔrt wəz ˈstoʊlən/',
      phonetic: 'mai PÉS-pórt uâz STÔU-lân',
      soundTip:
          'Was fica fraco, um uâz rápido. Força em PASS e STO; o a de '
          'passport é aberto, como o é de café.',
    ),
    LessonItem(
      text: 'I need to report a theft.',
      translation: 'Preciso registrar um roubo.',
      example: 'A: How can I help you? B: I need to report a theft.',
      exampleTranslation:
          'A: Em que posso ajudar? B: Preciso registrar um '
          'roubo.',
      audioAsset: 'audio/fase5/licao26/I_need_to_report_a_theft.mp3',
      ipa: '/aɪ ˈnid tə rɪˈpɔrɾ ə ˈθɛft/',
      phonetic: 'ai NÍD tâ ri-PÓR-râ THÉFT',
      soundTip:
          'Report a se liga e o t vira um r leve. No theft, a língua '
          'aparece entre os dentes e o fim fecha seco no ft.',
    ),
    LessonItem(
      text: 'I need a police report for insurance.',
      translation: 'Preciso do boletim de ocorrência pro seguro.',
      example: 'My bag was stolen, and I need a police report for insurance.',
      exampleTranslation:
          'Roubaram minha bolsa, e preciso do boletim de '
          'ocorrência pro seguro.',
      audioAsset:
          'audio/fase5/licao26/I_need_a_police_report_for_insurance.mp3',
      ipa: '/aɪ ˈnid ə pəˈlis rɪˈpɔrt fɚr ɪnˈʃʊrəns/',
      phonetic: 'ai NÍ-dâ pâ-LÍS ri-PÓRT fâr in-SHÚ-râns',
      soundTip:
          'Police tem força no LICE e o po fica fraco, quase pâ. Need a '
          'se liga em NÍ-dâ, e for sai curtinho, fâr.',
    ),
  ],
);

/// Lição 27 (revisão) — Revisão: saúde e emergências: revisão da zona.
const fase5Licao27 = Lesson(
  id: 'fase5-licao27',
  title: 'Revisão: saúde e emergências',
  objective:
      'Você vai repetir uma frase de cada situação da zona, da '
      'farmácia à polícia, até ela sair sem precisar pensar.',
  microSkill: 'revisão da zona',
  approvalThreshold: 75,
  items: [
    LessonItem(
      text: 'I need something for a headache.',
      translation: 'Preciso de alguma coisa pra dor de cabeça.',
      example: 'I need something for a headache. Is this one strong?',
      exampleTranslation:
          'Preciso de alguma coisa pra dor de cabeça. Esse '
          'aqui é forte?',
      audioAsset: 'audio/fase5/licao22/I_need_something_for_a_headache.mp3',
      ipa: '/aɪ ˈnid ˈsʌmθɪŋ fɚr ə ˈhɛdeɪk/',
      phonetic: 'ai NÍD SÂM-thing fâ-râ RRÉ-dêik',
      soundTip:
          'For a se liga num fâ-râ rápido. Força em NEED, SOME e HEAD; '
          'o th de something é língua entre os dentes e o ache fecha seco no '
          'k.',
    ),
    LessonItem(
      text: 'I feel dizzy.',
      translation: 'Estou tonto.',
      example: 'I feel dizzy. I think I need some water.',
      exampleTranslation: 'Tô tonto. Acho que preciso de água.',
      audioAsset: 'audio/fase5/licao23/I_feel_dizzy.mp3',
      ipa: '/aɪ ˈfil ˈdɪzi/',
      phonetic: 'ai FÍL DÍ-zi',
      soundTip:
          'Feel tem i longo e termina com a ponta da língua no céu da '
          'boca. Dizzy começa com d firme e seco, e o z do meio zumbe.',
    ),
    LessonItem(
      text: 'I have travel insurance.',
      translation: 'Tenho seguro viagem.',
      example: "Don't worry about the cost, I have travel insurance.",
      exampleTranslation: 'Não se preocupa com o custo, tenho seguro viagem.',
      audioAsset: 'audio/fase5/licao24/I_have_travel_insurance.mp3',
      ipa: '/aɪ ˈhæv ˈtrævəl ɪnˈʃʊrəns/',
      phonetic: 'ai RRÉV TRÉ-vâl in-SHÚ-râns',
      soundTip:
          'Força em TRA e SHU. Travel termina com a língua no céu da '
          'boca no l. No insurance, o som do meio é o ch de chave.',
    ),
    LessonItem(
      text: "It's an emergency.",
      translation: 'É uma emergência.',
      example: "Can you help me? It's an emergency.",
      exampleTranslation: 'Pode me ajudar? É uma emergência.',
      audioAsset: "audio/fase5/licao25/It's_an_emergency.mp3",
      ipa: '/ɪts ən ɪˈmɝdʒənsi/',
      phonetic: 'its-ân i-MÉR-djân-si',
      soundTip:
          "It's an sai colado, its-ân. A força cai em MER, com o r "
          'curvado; o g soa dj e o fim da palavra fica fraco.',
    ),
    LessonItem(
      text: 'I lost my wallet.',
      translation: 'Perdi minha carteira.',
      example: 'A: Is everything okay? B: No, I lost my wallet.',
      exampleTranslation: 'A: Tudo bem? B: Não, perdi minha carteira.',
      audioAsset: 'audio/fase5/licao26/I_lost_my_wallet.mp3',
      ipa: '/aɪ ˈlɔst maɪ ˈwɑlət/',
      phonetic: 'ai LÓST mai UÁ-lât',
      soundTip:
          'Lost fecha no st sem vogal depois, grudado no my. Força em '
          'LOST e WAL; o wallet termina num t curtinho.',
    ),
  ],
);

/// Lição 28 — BÔNUS — Bônus: saúde e emergência em frases longas: frases longas de emergência.
const fase5Licao28 = Lesson(
  id: 'fase5-licao28',
  title: 'Bônus: saúde e emergência em frases longas',
  objective:
      'Você vai explicar situações de saúde e emergência em frases '
      'mais longas, mantendo o ritmo e as ligações entre as palavras.',
  microSkill: 'frases longas de emergência',
  approvalThreshold: 75,
  bonus: true,
  items: [
    LessonItem(
      text: "I've had a bad headache since this morning.",
      translation: 'Estou com uma dor de cabeça forte desde hoje de manhã.',
      example:
          "I've had a bad headache since this morning, and the pills "
          "didn't help.",
      exampleTranslation:
          'Estou com uma dor de cabeça forte desde hoje de '
          'manhã, e os comprimidos não ajudaram.',
      audioAsset:
          "audio/fase5/licao28/I've_had_a_bad_headache_since_this_morning.mp3",
      ipa: '/aɪv ˈhæd ə ˈbæd ˈhɛdeɪk sɪns ðɪs ˈmɔrnɪŋ/',
      phonetic: 'aiv RRÉ-dâ BÉD RRÉ-dêik sins this MÓR-ning',
      soundTip:
          "I've had a se liga em aiv RRÉ-dâ. Força em BAD, HEAD e MOR; "
          'since this passa rápido e fraco no meio.',
    ),
    LessonItem(
      text: 'Can you recommend something for a sore throat?',
      translation: 'Pode me indicar alguma coisa pra dor de garganta?',
      example:
          'A: Hi, can I help you? B: Yes, can you recommend something '
          'for a sore throat?',
      exampleTranslation:
          'A: Oi, posso ajudar? B: Sim, pode me indicar '
          'alguma coisa pra dor de garganta?',
      audioAsset:
          'audio/fase5/licao28/Can_you_recommend_something_for_a_sore_throat.mp3',
      ipa: '/kən jə ˌrɛkəˈmɛnd ˈsʌmθɪŋ fɚr ə ˈsɔr ˈθroʊt/',
      phonetic: 'kân-iâ ré-kâ-MÉND SÂM-thing fâ-râ SÓR THRÔUT?',
      soundTip:
          'Can you sai fraco, kân-iâ. Força em MEND, SORE e THROAT. No '
          'throat, língua entre os dentes e logo o r, sem vogal no meio.',
    ),
    LessonItem(
      text: "I'm allergic to penicillin. Is this medicine okay?",
      translation: 'Sou alérgico a penicilina. Posso tomar esse remédio?',
      example:
          "Just so you know, I'm allergic to penicillin. Is this "
          'medicine okay?',
      exampleTranslation:
          'Só pra avisar: sou alérgico a penicilina. Posso '
          'tomar esse remédio?',
      audioAsset:
          "audio/fase5/licao28/I'm_allergic_to_penicillin_Is_this_medicine_okay.mp3",
      ipa: '/aɪm əˈlɝdʒɪk tə ˌpɛnəˈsɪlən ɪz ðɪs ˈmɛdəsən oʊˈkeɪ/',
      phonetic: 'aim â-LÉR-djik tâ pé-nâ-SÍ-lân. iz this MÉ-dâ-sân ôu-KÊI?',
      soundTip:
          'Allergic pesa no LER, com r curvado e g soando dj. '
          'Penicillin pesa no SI. Na pergunta, força em MED e KAY, com a voz '
          'subindo.',
    ),
    LessonItem(
      text: "My friend passed out and won't wake up.",
      translation: 'Meu amigo desmaiou e não acorda.',
      example:
          "Help! My friend passed out and won't wake up. Call nine one "
          'one!',
      exampleTranslation:
          'Socorro! Meu amigo desmaiou e não acorda. Liga pro '
          '911!',
      audioAsset:
          "audio/fase5/licao28/My_friend_passed_out_and_won't_wake_up.mp3",
      ipa: '/maɪ ˈfrɛnd ˈpæst ˈaʊɾ ən ˈwoʊnt ˈweɪk ˈʌp/',
      phonetic: 'mai FRÉND PÉS-TÁU-rân UÔUNT uêi-KÂP',
      soundTip:
          'Passed out vira PÉS-TÁUT, o ed soa t. Out and se liga com r '
          'rápido, táu-rân, e wake up cola num bloco: uêi-KÂP.',
    ),
    LessonItem(
      text: 'Can you tell me where the police station is?',
      translation: 'Pode me dizer onde fica a delegacia?',
      example:
          'Excuse me, can you tell me where the police station is? I was '
          'robbed.',
      exampleTranslation:
          'Com licença, pode me dizer onde fica a delegacia? '
          'Fui assaltado.',
      audioAsset:
          'audio/fase5/licao28/Can_you_tell_me_where_the_police_station_is.mp3',
      ipa: '/kən jə ˈtɛl mi ˈwɛr ðə pəˈlis ˈsteɪʃən ɪz/',
      phonetic: 'kân-iâ TÉL mi UÉR thâ pâ-LÍS STÊI-shâ-niz?',
      soundTip:
          'Can you fica fraco, kân-iâ. Força em TELL, WHERE, LICE e '
          'STA. Station is se liga em STÊI-shâ-niz no fim.',
    ),
  ],
);
