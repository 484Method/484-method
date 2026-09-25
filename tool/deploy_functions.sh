#!/usr/bin/env bash
# Deploy das Edge Functions (assess, feedback, dev-stats) pro projeto Supabase.
#
# Não existia nenhum caminho documentado/scriptado pra isso — o schema.sql
# e as functions foram aplicados via MCP em sessões anteriores, e se uma
# function mudar sem alguém lembrar de rodar `supabase functions deploy` de
# novo, o código commitado fica dessincronizado do que está no ar. Foi
# assim que o painel do dev (`dev-stats`) apareceu como "indisponível": o
# código no repo estava certo, só não tinha ido pro Supabase.
#
# Requisitos: supabase CLI instalada e autenticada (`supabase login`).
set -euo pipefail
cd "$(dirname "$0")/.."

PROJECT_REF="pwijrjgdbosxamybukhg" # 484-method, sa-east-1 — ver CLAUDE.md > Stack

if ! command -v supabase >/dev/null 2>&1; then
  echo "Supabase CLI não encontrada. Instale: https://supabase.com/docs/guides/cli" >&2
  exit 1
fi

for fn in assess feedback dev-stats; do
  echo "==> Deploy $fn"
  supabase functions deploy "$fn" --project-ref "$PROJECT_REF"
done

cat <<EOF

Deploy concluído. Secrets exigidos por cada function (conferir se já estão
setados — não são recriados pelo deploy):
  - assess:     AZURE_SPEECH_KEY, AZURE_SPEECH_REGION
               (opcional: ASSESS_DAILY_LIMIT, padrão 150/usuário/dia)
  - feedback:   ANTHROPIC_API_KEY
               (opcional: FEEDBACK_DAILY_LIMIT, padrão 150/usuário/dia)
  - dev-stats:  nenhum (sem senha, de propósito — ver CLAUDE.md, 2026-09-25)
Setar: supabase secrets set NOME=valor --project-ref $PROJECT_REF
Listar (só os nomes, nunca o valor): supabase secrets list --project-ref $PROJECT_REF

⚠️  O deploy das functions NÃO aplica supabase/schema.sql. A quota de
`assess` (tabela assess_quota + consume_assess_quota, migração
assess_daily_quota) precisa estar no banco também, senão a function falha
aberto (não erra, mas também não limita nada). Aplique o schema.sql
atualizado no SQL editor do dashboard, ou via `supabase db push` se o
projeto estiver linkado (supabase link --project-ref $PROJECT_REF).
EOF
