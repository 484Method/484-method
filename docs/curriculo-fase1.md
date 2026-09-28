# Currículo — Fase 1: "Inglês que Você Já Conhece" (40h)

Fase mais importante do MVP. Objetivo: provar ao aluno que ele já sabe alguma
coisa, reorganizar palavras familiares pelo som correto e criar o hábito
ouvir → repetir → gravar → corrigir → regravar.

**Nunca** chamar esta fase de "Phonics" ou "Sons Críticos" na UI — o nome
comercial é "Inglês que Você Já Conhece".

A fase é organizada em **4 blocos pedagógicos internos** (não são fases
comerciais novas — Fase 1 continua sendo um único módulo/oferta):

1. **Reconhecimento e confiança** — vocabulário familiar, baixa ameaça
   emocional.
2. **Som e sílaba forte** — ritmo, stress e armadilhas de pronúncia
   (palavras parecidas com português, mas com som ou uso diferente).
3. **Da palavra à frase** — chunks, cortesia, pedidos e situações reais do
   dia a dia.
4. **Conversa do dia a dia** — small talk: saudações, respostas, clima e
   planos, em frases prontas para usar.

## Escala de dificuldade do banco de palavras (120–300 palavras)

| Nível | Exemplos | Função |
|---|---|---|
| Muito fácil | banana, pizza, taxi, video, menu | Alta familiaridade, baixa ameaça emocional |
| Familiar com stress diferente | hospital, cinema, chocolate, internet, camera | Treinar sílaba forte e ritmo |
| Familiar com som enganoso | business, comfortable, interesting, manager, project | Reduzir pronúncia aportuguesada |
| Familiar com uso diferente | outdoor, notebook, shopping, home office, chips | Explicar uso real quando necessário |

## As 31 microlições (5–10 min cada): 27 obrigatórias + 4 bônus opcionais

Cada um dos Blocos 1–4 termina com uma revisão (obrigatória) e um bônus
(`Lesson.bonus = true`, opcional): mesmo assunto do bloco, palavras/frases
mais difíceis. O bônus nunca é pré-requisito da próxima lição — a progressão
pula direto para ela a partir da revisão anterior. O Bloco 5 (novo) não segue
esse padrão — ver nota na própria seção do bloco.

Numeração abaixo é a posição real no app (sequencial, sem buracos). Os ids
internos (`fase1-licaoNN`) têm lacunas — ver comentário em `lib/data/fase1.dart`.

### Bloco 1 — Reconhecimento e confiança

| # | Tema | Palavras/frases | Foco | Critério de aprovação |
|---|---|---|---|---|
| 1 | Quebrando o gelo | apple, cinema, hotel, internet, pizza | Confiança e familiaridade | Gravar ≥1 vez; regravar após feedback |
| 2 | Palavras do celular | app, online, email, login, video | Inglês digital cotidiano | Accuracy leve + completude |
| 3 | Comida | coffee, burger, sandwich, cake, water | Vocabulário simples e útil | Repetição clara, finalizar a palavra |
| 4 | Viagem | airport, taxi, bus, passport, ticket | Inglês de sobrevivência | Pronúncia + associação com situação |
| 5 | Revisão Bloco 1 | 1 item de cada lição 1–4 | Progresso visível | Minutos aprovados |
| 6 | **Bônus** — Desafio: vocabulário avançado | calendar, celebrity, vegetable, elevator, umbrella | Vocabulário mais longo, mesmo assunto | Accuracy + fonema mínimo (opcional) |

### Bloco 2 — Som e sílaba forte

| # | Tema | Palavras/frases | Foco | Critério de aprovação |
|---|---|---|---|---|
| 7 | Ritmo diferente | hospital, chocolate, camera, restaurant, comfortable | Sílaba forte e redução | Repetir com sílaba forte correta (minProsody) |
| 8 | Som enganoso | business, interesting, mouse, delivery, feedback | Reduzir pronúncia aportuguesada | Accuracy + fonema mínimo |
| 9 | Uso diferente | outdoor, notebook, shopping, home office, chips | Significado real no inglês | Accuracy + compreensão do uso |
| 10 | Revisão Bloco 2 | 1 item de cada lição 7–9 | Progresso visível | Minutos aprovados |
| 11 | **Bônus** — Desafio: ritmo avançado | necessary, temperature, government, photography, vocabulary | Sílaba forte traiçoeira, palavras longas | minProsody (opcional) |

### Bloco 3 — Da palavra à frase

| # | Tema | Palavras/frases | Foco | Critério de aprovação |
|---|---|---|---|---|
| 12 | Primeiros chunks | I like it, I need it, I want this, I love it, I got it | Da palavra isolada à frase curta | Completeness + fluency |
| 13 | Frases de cortesia | Thank you, See you, Excuse me, It's okay, No problem | Comunicação imediata | Completeness + fluency |
| 14 | Pequenos pedidos | Can I have a coffee, I need help, One coffee please, Can you help me, Just a minute | Fala funcional | Completeness + fluency |
| 15 | Casa e lazer | closet, freezer, playground, babysitter, happy hour | Vocabulário doméstico e social | Accuracy + completude |
| 16 | Compras e dinheiro | cash, credit card, discount, voucher, cashback | Inglês prático de consumo | Accuracy + completude |
| 17 | Revisão final | 1 item de cada lição 12–16 | Fecha o básico, evolução visível | Minutos aprovados, evolução visível |
| 18 | **Bônus** — Desafio: pedidos mais longos | Could you help me please, I'd like to order a coffee, Do you have a discount, Where is the restroom, Can I get a receipt | Pedidos educados mais longos | Completeness + fluency (opcional) |

### Bloco 4 — Conversa do dia a dia

| # | Tema | Palavras/frases | Foco | Critério de aprovação |
|---|---|---|---|---|
| 19 | Variações de "How are you?" | How are you?, How are you doing?, How's it going?, How have you been?, How's your day going? | Abrir qualquer conversa | Completeness + fluency |
| 20 | Respondendo que está bem | I'm good thanks, I'm doing well, I'm great thank you, Pretty good actually, I'm feeling good today | Resposta automática ao "how are you" | Completeness + fluency |
| 21 | Falando do dia / weather | It's sunny today, It's a bit cloudy today, It's really hot today, It's a little cold today, The weather is nice today | Small talk universal | Accuracy + completude |
| 22 | "It's a beautiful day to…" | go outside, have a walk, study English, drink some coffee, enjoy the morning | Molde único, 5 finais | Completeness + fluency |
| 23 | "What's the plan…?" | for today, for this morning, for the afternoon, after class, for the weekend | Combinar atividades | Completeness + fluency |
| 24 | Revisão Bloco 4 | 1 frase de cada lição 19–23 | Progresso visível | Minutos aprovados |
| 25 | **Bônus** — Desafio: conversa mais natural | How have you been doing lately, I've been pretty busy but I'm good, It looks like it might rain later, It's the perfect day to relax outside, Do you have any plans for the weekend | Mesmo small talk, frases mais longas e naturais | Completeness + fluency (opcional) |

### Bloco 5 — Perguntas e respostas com "to be" (novo, 2026-09-28)

Grade gramatical (não mais vocabulário solto): a pergunta de sim/não com "to
be" → resposta curta afirmativa → negativa → as duas contrastadas numa frase
só → de volta às contrações. Sem revisão nem bônus próprios (o bloco em si já
é a revisão/expansão do padrão "to be" usado desde o Bloco 1). ⚠️ Introduz
deliberadamente o som TH ("thirsty") e frases de duas orações (licao32) —
ambos fora da regra "O que NÃO fazer" abaixo, que vale para os Blocos 1–4;
graduação intencional pro público que já passou pelo básico.

| # | Tema | Palavras/frases | Foco | Critério de aprovação |
|---|---|---|---|---|
| 26 | Perguntas com to be | Are you hungry?, Are you thirsty?, Are you comfortable?, Are you worried?, Are you available?, Is he polite?, Is she patient?, Is it necessary?, Are we early?, Are they interested? | Perguntas de sim/não com to be | Accuracy + completude |
| 27 | Perguntas com outros sujeitos | as mesmas perguntas com he, she, it, we, they | Trocar o sujeito sem travar | Accuracy + completude |
| 28 | Respostas curtas — sim | Yes, I am. / Yes, he is. / Yes, she is. / Yes, it is. / Yes, they are. (+ negativas correspondentes) | Responder sem travar | Completeness + fluency |
| 29 | Respostas curtas — não | No, I am not. / No, he is not. / No, she is not. / No, it is not. / No, we are not. / No, they are not. — perguntas com antônimo (uncomfortable, unavailable, rude, impatient, unnecessary, late, uninterested) | Dizer não com naturalidade + vocabulário negativo | Completeness + fluency |
| 30 | Sim e não na mesma frase | "Yes, I am. I am not thirsty.", "Yes, he is. He is not rude." — 10 combinações | Contrastar numa frase só | Completeness + fluency |
| 31 | Respostas com contrações | Yes, I am. / No, I'm not. / Yes, he is. / No, he isn't. — contrações de volta, vocabulário deste bloco | Contrações do dia a dia | Completeness + fluency |

## Regra de liberação da escrita
Uma tentativa oral é obrigatória antes de qualquer texto. Após a tentativa e
o feedback inicial, o app libera a escrita (Livro Aberto: palavra/frase,
tradução, fonética simplificada, exemplo) para evitar frustração. A aprovação
final exige nova gravação com critério mínimo.

## O que NÃO fazer na Fase 1
Não usar TH, pares mínimos difíceis, IPA complexo, explicações longas de
fonética ou frases extensas. Tudo isso é de fases posteriores (fora do MVP).

## Métricas de sucesso do MVP
- Conclusão da 1ª lição ≥ 60% · Retenção D1 ≥ 35% · D7 ≥ 20% (beta)
- Tentativas médias por item: 2–5 · Sessão média: 5–15 min
- Percentual de regravação ≥ 50% (valida se o feedback gera ação)
