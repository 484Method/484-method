# Analytics

Pasta de trabalho pra analisar exports do painel do dev (`stats_screen.dart`
→ "Exportar usuários (CSV)") e transformar em números pra apresentar pra
investidores — sem nunca versionar dado pessoal de usuário real.

## Regra

- `raw/` guarda os CSVs originais (nome, e-mail, atividade por usuário) —
  **gitignored**, nunca commitado. Cada export novo entra aqui com o nome
  `AAAA-MM-DD-usuarios.csv`.
- `resumo-*.md` é o output de `analisar.py`: só números agregados (totais,
  contagens, médias), zero nome/e-mail individual — esse sim pode ser
  commitado e compartilhado.

## Uso

```
python3 analisar.py raw/AAAA-MM-DD-usuarios.csv
```

Gera `resumo-AAAA-MM-DD-usuarios.md` na mesma pasta.

## O que olhar antes de levar pra investidor

Ver a seção "PMF e traction" no CLAUDE.md do projeto — em resumo: o número
que mais importa aqui não é quantidade de linhas no CSV, é quantos usuários
reais bateram os critérios do teste de PMF (Sean Ellis, `streak >= 2` +
viu o antes/depois) e quantos completaram o desafio de 21 dias com
antes/depois objetivo gravado. Ver `resumo-*.md` mais recente pro estado
atual.
