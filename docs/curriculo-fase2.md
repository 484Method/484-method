# Currículo — Trilha 2: "Sons do inglês real" (Fase 2 do currículo, 44h)

Construída em 2026-10-11. Objetivo: tirar o sotaque que ATRAPALHA ser
entendido — não "soar nativo". A trilha é organizada pelas armadilhas de som
clássicas do brasileiro, não pelos 44 fonemas do inglês nem pelas letras
(phonics ensina a LER quem já fala; o aluno do 484 tem o problema oposto).
A maior parte das consoantes do inglês o brasileiro já faz bem — o trabalho
está num conjunto pequeno e conhecido de pontos, ordenados pelo que mais
atrapalha a compreensão.

**Acesso:** grátis pra todos (decisão do dono, 2026-10-11) e sequencial — a
1ª lição exige a última lição obrigatória da Trilha 1. Bônus nunca são
pré-requisito. Código: `lib/data/fase2.dart`; estrutura trilha → zona →
lição em `lib/data/curriculum.dart`.

## Como uma lição da Trilha 2 ensina (todo → parte → todo)

O som nunca é o assunto da lição — a palavra ou frase útil é. Cada item:

1. **Todo** — ouve a palavra/frase real, sem texto, e repete de ouvido.
2. **Parte** — no Livro Aberto (só depois da 1ª tentativa), além de texto,
   IPA, fonética PT-BR e tradução, aparece a **dica de som** (`soundTip`): uma
   instrução física curta contra a armadilha ("termine com a boca fechada,
   sem soltar vogal: big, não 'bigui'"). Se a tentativa reprovou, a dica
   também vira a instrução do feedback (fixo e da Claude) — ver
   `docs/feedback-library.md`.
3. **Todo** — grava de novo. Nas Zonas 1–3, o 5º item de cada lição é uma
   frase curta que leva o som de volta pro contexto.

A fonética PT-BR desta trilha nunca escreve o erro que a lição combate (sem
"i" depois de consoante final, sem "u" no L final, sem "tchi/dji", sem "rr"
pro R do inglês, sem "f/t/d" pro TH). Quando o português não tem letra pro
som, a dica explica.

## As 28 lições (5–10 min cada): 24 obrigatórias + 4 bônus opcionais

Mesmo formato da Trilha 1: cada zona tem 5 lições, uma revisão (um item de
cada lição, reaproveitando o áudio) e um bônus (`Lesson.bonus = true`).
Numeração = posição dentro da trilha (ids `fase2-licao01..28`, sem lacunas).

### Zona 1 — Fim de palavra

| # | Tema | Palavras/frases | Foco | Critério de aprovação |
|---|---|---|---|---|
| 1 | O "i" fantasma | big, book, keep, club, Good luck. | Final em consoante, sem vogal extra | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 2 | S sem "e" na frente | stay, space, snack, skip, Please speak slowly. | S + consoante no início, sem "e" antes | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 3 | L no final | feel, tell, file, people, I'll call you. | L final com a língua encostada | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 4 | M, N e NG no final | time, phone, young, going, I'm leaving soon. | Fechar os finais nasais | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 5 | -ED do passado | watched, played, moved, ended, I cooked and cleaned. | Final do passado sem sílaba extra | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 6 | Revisão de sons — Zona 1 | big, stay, people, going, watched | Progresso visível | Minutos aprovados |
| 7 | **Bônus** — Desafio: finais difíceis | desk, next, changed, world, I helped a friend. | Grupos de consoantes no final | Accuracy ≥ 75 + fonema mínimo ≥ 65 (opcional) |

### Zona 2 — Vogais que o português junta

| # | Tema | Palavras/frases | Foco | Critério de aprovação |
|---|---|---|---|---|
| 8 | "ship" × "sheep" | ship, sheep, sit, seat, Is it cheap to ship? | i curto × i longo | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 9 | "full" × "fool" | full, fool, pull, pool, I cook good food. | u curto × u longo | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 10 | "bad" × "bed" | bad, bed, sad, said, I left my bag. | Boca bem aberta × "é" comum | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 11 | "cup" × "cop" | cup, cop, luck, lock, I got lucky. | "â" curto × "á" aberto | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 12 | "work" × "walk" | work, walk, shirt, short, I walk to work. | Vogal com R × "ó" aberto | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 13 | Revisão de sons — Zona 2 | seat, pool, bad, cup, work | Vogais separadas, progresso visível | Minutos aprovados |
| 14 | **Bônus** — Desafio: pares na mesma frase | Please sit back in your seat., His pool is full., She said she was sad., One cup is not much., My shirt was too short. | Os dois sons do par na mesma frase | Accuracy ≥ 75 + fonema mínimo ≥ 65 (opcional) |

### Zona 3 — Consoantes traiçoeiras

| # | Tema | Palavras/frases | Foco | Critério de aprovação |
|---|---|---|---|---|
| 15 | R do começo não é H | red, right, really, run, It's raining right now. | R inicial com a língua curvada | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 16 | R no meio e no fim | car, more, very, corner, Where is my car? | R depois de vogal, sem sumir | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 17 | T e D sem chiado | team, different, idea, city, It's a different city. | T e D limpos antes do som de "i" | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 18 | TH sem voz | think, thanks, nothing, both, I think it's nothing. | Língua entre os dentes, só ar | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 19 | TH com voz | they, this, other, together, This is the other one. | Língua entre os dentes, com voz | Accuracy ≥ 75 + fonema mínimo ≥ 65 |
| 20 | Revisão de sons — Zona 3 | right, car, different, think, together | Os sons da zona juntos | Minutos aprovados |
| 21 | **Bônus** — Desafio: TH e R juntos | three, north, rather, birthday, My brother's birthday is on the third. | TH e R na mesma palavra | Accuracy ≥ 75 + fonema mínimo ≥ 65 (opcional) |

### Zona 4 — Ritmo e música da frase

| # | Tema | Palavras/frases | Foco | Critério de aprovação |
|---|---|---|---|---|
| 22 | A vogal fraca | about, today, seven, breakfast, Breakfast is at seven. | Vogal fraca nas sílabas sem força | Accuracy ≥ 75 + fonema mínimo ≥ 65 + prosódia ≥ 70 |
| 23 | A força da frase | I need a break., I work from home., Let's grab some lunch., Pick me up at six., Call me when you land. | Força nas palavras que dão o sentido | Accuracy ≥ 75 + fonema mínimo ≥ 65 + prosódia ≥ 70 |
| 24 | Palavras pequenas, som pequeno | a cup of coffee, black and white, I need to go., It's for you., I'm at work. | Formas fracas: to, for, of, and, at | Accuracy ≥ 75 + fonema mínimo ≥ 65 + prosódia ≥ 70 |
| 25 | "can" × "can't" | I can come., I can't come., I can wait., I can't do it., We can go now. | can fraco × can't forte | Accuracy ≥ 75 + fonema mínimo ≥ 65 + prosódia ≥ 70 |
| 26 | Perguntas: sobe ou desce | Are you hungry?, Is it far from here?, Where are you from?, What time is it?, Do you like it? | Melodia: sobe no sim/não, desce no wh- | Accuracy ≥ 75 + fonema mínimo ≥ 65 + prosódia ≥ 70 |
| 27 | Revisão de sons — Zona 4 | Breakfast is at seven., Let's grab some lunch., a cup of coffee, I can't come., Where are you from? | Progresso visível | Minutos aprovados |
| 28 | **Bônus** — Desafio: tudo junto | I think I'll stay home tonight., I worked from home all week., I can't make it to the meeting., What time does the store open?, Is there a good place to eat here? | Todas as armadilhas juntas, frase longa | Accuracy ≥ 75 + fonema mínimo ≥ 65 + prosódia ≥ 70 (opcional) |

## Critério e calibração (⚠️ ler antes de mexer)

- Mesmo critério calibrado na Trilha 1 (accuracy ≥ 75 + fonema mínimo ≥ 65);
  a Zona 4 (ritmo e entonação) exige também prosódia ≥ 70, como as lições de
  ritmo da Trilha 1. Revisões não exigem prosódia.
- **Ainda sem calibração com vozes brasileiras reais nestas armadilhas.** O
  Azure Pronunciation Assessment pontua os fonemas do texto de referência —
  ele NÃO pontua um som INSERIDO. O "i" fantasma ("bigui") e o "e" antes do
  s- ("istart") não são fonemas do texto, então só aparecem de forma
  indireta (prosódia, fonema vizinho, fluência). Nessas lições a dica de som
  carrega mais peso que a nota.
- Pares mínimos (Zona 2): a nota do Azure mede o quanto a vogal se aproxima
  da esperada; uma troca (falar "sheep" querendo "ship") tende a derrubar o
  fonema, mas a margem depende do falante — medir antes de endurecer.
- Ajustar thresholds com dados de beta, não por opinião — mesma regra da
  Trilha 1 (evento `attempt_assessed`: accuracy, min_phoneme e prosódia por
  item e tentativa).

## Áudios

Gerados pelo dev com `./tool/gen_lesson_audio.sh` (função `gen2`, TTS neural
do Azure `en-US-JennyNeural`, mesma voz da Trilha 1; precisa de
`AZURE_SPEECH_KEY`/`AZURE_SPEECH_REGION` no `.env`). O script gera só o que
falta. Diferente da Trilha 1, o texto vai pro TTS com a pontuação (pergunta
soa como pergunta — a lição de entonação depende disso) e o nome do arquivo
fica só com letras, dígitos, apóstrofo e "_". `test/curriculum_test.dart`
falha enquanto faltar qualquer MP3 — e o deploy-web roda os testes, então
lição muda não vai pro ar.

## O que NÃO fazer na Trilha 2

- Não ensinar som isolado, letra ou IPA como conteúdo — o IPA é apoio no
  Livro Aberto, a dica é física.
- Ligação entre palavras (connected speech: "gonna", "didju") fica para a
  Fase 3 ("Frases prontas"), primeiro como treino de escuta.
- Não prometer sotaque nativo: a meta é ser entendido.

## Métricas de sucesso

- Quem conclui a Trilha 1 abre a Trilha 2 (lição `fase2-licao01` iniciada /
  `fase1-licao26` concluída) — mede se a trilha nova estende a retenção.
- Regravação após a dica: tentativa final > 1ª tentativa no mesmo item
  (`attempt_assessed`, delta de accuracy entre attempt 1 e 2) — mede se a
  dica gera ação.
- Itens com reprovação persistente (≥ 3 tentativas) apontam dica ruim ou
  critério duro demais.
