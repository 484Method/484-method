# Currículo — Fase 2: "Verbo To Be — Forma e Som"

Módulo comercial novo (decisão de 2026-09-28 — ver CLAUDE.md). Objetivo:
consolidar o verbo *to be* em três camadas — forma completa, contraste
afirmativo/negativo, e a contração que um falante nativo realmente usa —
sempre respeitando a regra som-first (o aluno ouve e repete antes de ver
qualquer texto).

A fase é organizada em **8 blocos pedagógicos**, cada um virando UMA lição
(10 itens, diferente dos 5 itens/lição da Fase 1 — aqui o item já é uma
frase curta, não uma palavra solta, então o ritmo de 5-10min se mantém).

## Progressão

1. **Afirmativo, forma completa** — I am, you are, he is.
2. **Negativo, forma completa** — I am not, you are not, he is not.
3. **Contraste, forma completa** — afirmativo + negativo na mesma lição.
4. **Som da contração (afirmativo + negativo)** — I'm, you're, he's, I'm
   not, you aren't, he isn't. Ainda NÃO são frases: o objetivo é só o som
   da contração.
5. **Som da contração, reforço negativo** — mais uma rodada das formas
   negativas. Repetição proposital: pro método, repetição não é conteúdo
   duplicado, é prática oral.
6. **Afirmativo, contraído, em frase** — I'm happy, you're busy.
7. **Negativo, contraído, em frase** — I'm not sad, you aren't insecure.
8. **Contraste, contraído** — a versão final, do jeito que um nativo fala.

## As 8 lições (80 itens no total)

Ids: `fase2-licao01` a `fase2-licao08`, sequenciais sem lacunas. Dados
completos em `lib/data/fase2.dart`.

| # | Bloco | Tema | Foco |
|---|---|---|---|
| 1 | 1 | Eu sou, eu estou | Afirmativo completo |
| 2 | 2 | Eu não sou, eu não estou | Negativo completo |
| 3 | 3 | Sim e não | Contraste, forma completa |
| 4 | 4 | O som da contração | Som isolado, afirmativo + negativo |
| 5 | 5 | Reforçando o não | Som isolado, reforço negativo |
| 6 | 6 | Contraído e afirmativo | Contração em frase afirmativa |
| 7 | 7 | Contraído e negativo | Contração em frase negativa |
| 8 | 8 | Contraste contraído | Contraste final, contraído |

## Decisões de modelagem (por que os dados de `fase2.dart` são assim)

- **Sem bônus.** Diferente da Fase 1, nenhuma lição aqui é `bonus: true` —
  as 8 são sequenciais e obrigatórias.
- **`example`/`exampleTranslation` nos blocos 3 e 8 carregam a frase
  CONTRASTANTE** (a negativa, quando `text` é a afirmativa), não uma frase
  de uso genérica — o cartão do Livro Aberto mostra o par afirmativo/
  negativo de verdade.
- **Nos demais blocos, `example` repete `text`.** Não existe uma "frase de
  uso maior" natural quando o item já É a frase (ou, nos blocos 4-5, a
  contração isolada) — reaproveitar evita inventar conteúdo que ninguém
  pediu.
- **Licao03 e licao08 (contraste) não têm áudio próprio.** O item
  afirmativo de cada um é idêntico ao de licao01/licao06 — `audioAsset`
  aponta pros arquivos delas, mesmo padrão de reaproveitamento das lições
  de revisão da Fase 1.
- **Sem `ipa`/`phonetic`.** A convenção da Fase 1 já marca essas
  transcrições como aproximações que precisam de revisão por ouvido
  nativo; aqui o item é uma frase inteira (não uma palavra), então o risco
  de erro é maior — melhor não ter do que ter errado sem revisão.
- **`approvalThreshold: 75`, sem `minProsody`** — mesma calibração
  permissiva da Fase 1 no começo; ajustar com dados reais, não por opinião
  (mesma regra da Fase 1).

## Pendente antes de ir ao ar

- **Áudio**: `tool/gen_lesson_audio.sh` tem os 8 comandos novos
  (`gen_fase2`), mas GERAR os 80 MP3s exige rodar o script localmente com
  `AZURE_SPEECH_KEY` no `.env` — não é feito nesta sessão.
- **Integração de UI/progressão**: `fase2Lessons` existe como dado, mas
  ainda NÃO está plugada em `home_screen.dart` (dashboard, desafio do dia,
  gate de paywall). Isso é uma decisão de produto separada — ver CLAUDE.md
  pra o que falta decidir antes de expor a Fase 2 no app (grátis como a
  Fase 1? Fundador desbloqueia? entra no threshold de 484h?).
