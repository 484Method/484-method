# Biblioteca de feedback (PT-BR)

O feedback transforma erro em ação. Nunca dizer só "errado" — sempre indicar
o que tentar na próxima gravação. Tom adulto, direto e encorajador.

Pipeline: resultado do Azure Pronunciation Assessment (accuracy, fluency,
completeness, erros por fonema/palavra) → classificar tipo de erro →
mensagem da biblioteca (ou Claude API para variações, mantendo o mesmo tom).

## Mensagens base por tipo de erro

| Tipo de erro | Mensagem |
|---|---|
| Sílaba forte errada | Você colocou força no final. Tente deixar a força no começo da palavra. |
| H inicial | Comece com ar saindo da boca, como uma respiração leve. |
| Vogal longa/curta | Esse som precisa ser um pouco mais longo. Escute e copie a duração. |
| Consoante final sumiu | Não deixe a última consoante desaparecer. Termine a palavra com clareza. |
| Ritmo aportuguesado | Copie o ritmo do áudio, não a escrita da palavra. |
| Boa tentativa | Muito bom. Agora tente repetir com o mesmo ritmo do áudio. |

## Métricas do Azure e uso

| Métrica | Uso |
|---|---|
| Accuracy | Critério principal para palavras e frases curtas |
| Fluency | Mais relevante em chunks e frases (lições 7–9) |
| Completeness | Evita que o aluno pule palavras |
| Prosody | Usar com cautela; não bloquear aprovação por prosody na Fase 1 |

## Threshold
Configurável por lição, nunca hardcoded. Fase 1 começa permissiva (gerar
vitória, não frustração) e o critério sobe gradualmente. Testar com vozes
brasileiras reais antes de confiar no score.

## Dica de som (Trilha 2)

Na Trilha 2 cada item tem uma `soundTip` — a instrução física contra a
armadilha que a lição treina (ex.: "Termine com a boca fechada no som final,
sem soltar vogal"). Ela entra em três lugares:

| Onde | Como |
|---|---|
| Livro Aberto | Card "Dica de som", junto da escrita — só depois da 1ª tentativa de ouvido |
| Feedback fixo | Reprovou por fonema, prosódia ou no caso genérico → a dica substitui a instrução genérica ("Escute de novo…"). Completude cortada continua com a mensagem de completude; aprovado não repete a dica |
| Feedback da Claude | Vai como `tip` para a Edge Function `feedback`, que a usa como base da instrução quando a tentativa não passou (com as próprias palavras, sem copiar) |

Regras de escrita da dica: no máximo 160 caracteres, PT-BR, imperativo/"você",
fala de boca/língua/ar/voz/duração — nunca "pronuncie a letra X", nunca
símbolos de IPA, sem emojis. Pode contrastar com o erro típico entre aspas
(ex.: big, não "bigui").
