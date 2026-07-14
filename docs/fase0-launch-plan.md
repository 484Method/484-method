# Plano de execução — Fase 0 (negócio): reter estranhos

Companheiro do `launch-kit.md` (que tem as mensagens/ganchos prontos). Aqui é o
**plano de execução e as métricas**: o que fazer, em que ordem, e como ler o
resultado. Data-base: 2026-07-07.

> ⚠️ **Não confundir fases.** Esta é a **Fase 0 do NEGÓCIO** (go-to-market),
> rodando sobre a **Fase 1 do CURRÍCULO** (o produto). Ver
> `docs/roadmap-fases.md` se existir, ou o mapa das fases.

## Objetivo único
Provar que **estranhos voltam**. Não é volume de cadastros — é a retenção não
desabar com quem não é seu amigo. É o portão que destrava a captação: investidor
de consumo compra curva de retenção achatando com não-amigos.

## A ressalva do teto de conteúdo (importante)
Só existem **25 microlições** no ar (o MVP da Fase 1 — NÃO as 40h planejadas;
as horas do currículo são metas de prática, não conteúdo pronto). Um usuário
engajado **esgota as 25 em poucos dias**. Logo:

- **D1 e a profundidade da 1ª semana são o sinal forte** — as 25 lições medem
  isso bem.
- **D7/D30 podem cair por falta de conteúdo, não por qualidade.** Se a retenção
  cair na 2ª semana, o suspeito nº1 é "acabou o que fazer" — não concluir
  "produto ruim" sem antes olhar quantas lições a pessoa já tinha feito.
- Se a retenção inicial vier boa, **ampliar a Fase 1 (mais lições dentro das
  40h) entra na fila** — mas depois de ter sinal, não antes.

## Métricas e barras (lê no painel do dev)
| Métrica | Evento/fonte | Barra (leva pequena, não escala) |
|---|---|---|
| **Ativação** | `first_recording_completed` / quem abriu | **>70%**. Abaixo = problema de onboarding/atrito, não de aquisição |
| **Retenção D1** | volta no dia seguinte | **alguns voltam** = sinal mais forte nesse estágio |
| **Profundidade sem. 1** | lições concluídas + minutos aprovados por usuário | quanto mais fundo antes de esgotar, melhor |
| **Esgotou conteúdo?** | usuários que chegam à lição 25 | é gatilho pra AMPLIAR conteúdo, não sinal de falha |
| **WTP (secundário)** | `paywall_viewed` → `access_code_redeemed` por `price_bucket` | intenção de pagar; fraco nessa fase, mas registra |

✅ **Atrito do cadastro corrigido (2026-07-14):** confirmado com dado real —
40 consentimentos de voz → só 10 cadastros (75% de perda no portão antigo,
que ficava ANTES do "aha"). O gate de nome+e-mail foi movido pra depois da
1ª gravação (`HomeScreen.build()`, condicionado a
`hasDone('first_recording_completed')` — ver CLAUDE.md). Reavaliar a
ativação depois de rodar tráfego novo com essa mudança no ar.

## Cronograma
**Dia 0 (pré-voo):**
- Merge #13 → #14 + `tool/deploy_pages.sh` (produção com paywall honesto + selo).
- Montar a lista de rede quente (abaixo).
- Anotar a linha de base do painel (o que vier depois é atribuível ao lançamento).

**Semana 1:**
- **Dia 1** — 10–20 DMs 1:1 (msg do kit), **rede quente primeiro**.
- **Dia 2** — responder objeções na hora (voz/preço/tempo — respostas do kit).
- **Dia 3** — post/vídeo de fundador (sua cara, "por que construí").
- **Dias 4–6** — 1 Reel/dia com os ganchos do kit (hotel/banana/internet).
- **Dia 7** — Stories no dia de maior alcance + colher 2–3 depoimentos.

## Rede quente — critério e acompanhamento
Só você monta. Critério por nome: **(a)** adulto que *entende mas trava* no
inglês; **(b)** idealmente **não** amigo íntimo (o retorno de um não-amigo é o
dado que vale); **(c)** dá feedback honesto.

Planilha de acompanhamento sugerida:

```
Nome | Como conheço | Trava no inglês? | Amigo íntimo? | DM enviada | Testou | Voltou D1
```

## Portão de decisão (~2 semanas ou ~30–50 estranhos)
- **Ativação >70% + alguns voltam no D1 + boa profundidade na sem. 1** → sinal.
  Montar deck + data room (dashboard ao vivo é o diferencial) → Fase 3 (levantar).
  Se gente esgotou o conteúdo, ampliar a Fase 1 em paralelo.
- **Ativação baixa** → consertar o funil (começar pelo gate nome+email) antes de
  mandar mais tráfego.
- **Cadastro caiu no dia seguinte a um post** → é falta de novo impulso (tráfego
  é pico manual), **não** produto ruim. Não interpretar como sinal.
