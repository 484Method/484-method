# 484 Method — MVP

## Produto
App Flutter (iOS + Android) de treino oral de inglês para brasileiros adultos
falso iniciantes (25–45 anos, "sei mais inglês do que consigo falar").
Princípio inegociável: **primeiro o ouvido, depois a boca, só depois os olhos** —
a escrita nunca aparece antes da primeira tentativa oral do aluno.

Loop core de uma lição (8 etapas):
1. Objetivo (1 frase) → 2. Ouça (áudio sem texto) → 3. Repita (grava de ouvido)
→ 4. Feedback (nota + orientação curta em PT-BR) → 5. Tente de novo (regrava)
→ 6. Livro Aberto (texto, tradução, exemplo) → 7. Regravação final
→ 8. Conclusão (minutos aprovados + próxima atividade)

Métrica norte do produto: **minutos de prática oral APROVADA**, nunca tempo de tela.

## Escopo do MVP (v1)
- ✅ Auth: **Supabase Auth** (decidido e em produção) — sign-in anônimo, cada
  usuário ganha um id estável. Progresso e eventos no Postgres com RLS por
  user_id; degrada para local-only sem credenciais.
- ✅ **Cadastro obrigatório, mas DEPOIS do "aha" (mudou em 2026-07-14):** nome
  + e-mail continuam obrigatórios pra usar o app de verdade (recrutamento de
  coorte), mas o gate (`SignupScreen`, `ProgressStore.hasRegistered`) saiu do
  topo do funil (entre consentimento e 1ª lição) e entrou dentro da
  `HomeScreen.build()`, condicionado a `hasDone('first_recording_completed')`.
  Motivo: dado real do funil (2026-07-13) mostrou 40 consentimentos de voz →
  só 10 cadastros = 75% de perda bem no portão antigo, antes de qualquer
  valor sentido. Agora: consentimento → 1ª lição direto (autostart, sem
  interromper) → ao voltar pra Home (fim da lição ou saída no meio) já tendo
  gravado ao menos 1x, o gate aparece. Nunca interrompe uma lição em
  andamento (só reavalia quando a Home reconstrói). Só captura, sem
  verificação. PII isolada na tabela `signups` (RLS por dono, migração
  `signups`), separada de progress/events/gravações; entra no export CSV do
  painel (nome/e-mail + atividade) e é apagada no clearAll (LGPD).
- Fase 1 "Inglês que Você Já Conhece": 21 microlições obrigatórias de 5–10
  min, em 4 blocos pedagógicos internos — reconhecimento/confiança, som/
  sílaba forte, palavra/frase, conversa do dia a dia — mais 4 lições BÔNUS
  opcionais (uma por bloco, `Lesson.bonus = true`, palavras/frases mais
  difíceis do mesmo assunto, nunca exigidas para progredir) — 25 lições no
  total (matriz completa em docs/curriculo-fase1.md)
- ✅ Loop core completo: áudio pré-gerado → gravação → Azure Pronunciation
  Assessment → feedback pedagógico em PT-BR → liberação da escrita → regravação
- ✅ Feedback gerado pela Claude API via Edge Function (fallback p/ mensagens
  fixas sem chave/rede) — ver "Regras de produto que viram código".
- ✅ Dashboard com progresso em minutos aprovados (barra das 484h) + streak
  + desafio do dia (lição sorteada por dia entre as liberadas; só local,
  expira ao virar o dia — ver ProgressStore.dailyChallengeLessonId)
- Threshold de aprovação CONFIGURÁVEL por lição (permissivo na Fase 1)
- ✅ Onboarding com promessa + regra som-first + consentimento de gravação de voz
- ✅ Analytics de eventos (conclusão, tentativas, regravação, retenção)
- ✅ Repetição espaçada (SRS) em cima do mapa de fala: o `WordMemoryScreen`
  responde "o que eu nunca acertei" (aprender); o agendador responde "o que eu
  acertei e já está na hora de conferir" (esquecer). Só palavra APROVADA entra
  na escada — a gravação FINAL da lição (etapa 7) é o que move o degrau, via
  `ProgressStore.recordSrsOutcome`, e SÓ quando a revisão está vencida:
  regravar no mesmo dia não é espaçar (sem essa trava o botão "Gravar de
  novo" da etapa 7 levaria a palavra de 1 pra 30 dias em dois minutos e
  contaria cada regravação como revisão). Acerto sobe um degrau
  (`srsIntervalsDays` = 1, 3, 10, 30 dias; depois do último repete a cada 30 —
  consolidada ≠ eterna), erro volta pro primeiro. Agenda só LOCAL (chave
  `srs_schedule`, JSON palavra→{stage,due}), como o desafio do dia e o de 21
  dias: não entra no snapshot do progresso, então não exige migração de coluna;
  prefs corrompido degrada pra agenda vazia em vez de derrubar a home. UI: card
  "Revisar hoje" na home (`_srsReviewCard`, só quando há palavra vencida) que
  abre a lição no item da palavra mais atrasada (`srsDueWords` ordena por data
  de vencimento) — cada revisão passa pelo loop normal, então
  rende minuto APROVADO, não só tempo de tela. Métrica sai como evento
  `srs_review_done` (props: item, from_stage, to_stage, approved) — só quando a
  palavra JÁ estava na escada, porque a 1ª aprovação apenas agenda e não prova
  que a memória durou.
- ✅ Teste de PMF (Sean Ellis): card na home pergunta "como se sentiria se não
  pudesse mais usar o 484?" (Muito/Pouco decepcionado, Indiferente) a quem
  sentiu o valor (`first_before_after_seen`) e voltou (`streakDays >= 2`); uma
  vez só (`ProgressStore.hasAskedPmf`). Complemento simétrico do survey de
  abandono (aquele = quem NÃO chegou ao "aha"). Evento `pmf_survey_answered`
  (props.answer = very/somewhat/not) na tabela `events`; o painel agrega em
  `pmf_breakdown` (função `get_phase0_activation`) e mostra o **% "muito
  decepcionado" (meta >40% = sinal de PMF)**.
- Paywall (oferta "Beta Fundador" — acesso à Fase 1): gating das lições atrás
  de `EntitlementService` JÁ implementado, fake local na web. 2026-06: todas
  as 25 lições estão grátis (`kFreeLessonCount`) até ter usuários reais e
  monetização ativa — falta a impl real com RevenueCat, bloqueada por conta
  Apple (ver Stack).
- ✅ Desafio de 21 dias (instrumento de validação — mede OUTCOME, não só
  comportamento): estado do cohort é local em `ProgressStore` (`cohortStartDate`,
  `cohortDay` 1-based, `cohortFinalUnlocked` no dia ≥ 21, confiança
  inicial/final 1–5) — não vai no snapshot do progresso (evita migração de
  coluna); as métricas saem como eventos (`cohort_started`, `final_confidence`,
  `before_after_review_completed`, `testimonial_submitted`) na tabela `events`
  (props jsonb). UI: card por estágio na home + pesquisa de confiança
  (`showConfidenceSurvey`) + `CohortReviewScreen` (antes/depois: delta de
  confiança + minutos aprovados + lições + depoimento). O par OBJETIVO
  (gravação de fala aberta baseline/final) está implementado (fatia 2):
  `AudioRecorderService.longForm()` (60s, sem auto-stop por silêncio),
  `CohortRecordingScreen` (prompts do memo, best-effort), upload pro bucket
  privado `cohort-recordings` via `Backend.uploadCohortRecording` + metadados
  em `public.cohort_recordings` (RLS por dono; migração
  `cohort_recordings_storage`). Consentimento AMPLIADO próprio
  (`ProgressStore.hasVoiceStorageConsent` — guardar áudio ≠ processar na hora);
  `deleteRemoteData` apaga Storage+metadados em bloco próprio (não trava o
  delete de progress/events). Política de privacidade atualizada. Rating cego
  IN-APP: painel do dev (`stats_screen` → `CohortRatingScreen`) ouve as
  gravações embaralhadas e às CEGAS (não revela baseline/final), dá nota 1–5 de
  clareza e mostra o antes/depois agregado (média baseline vs final). URLs
  assinadas e escrita das notas via Edge Function `dev-stats` (novas actions
  `list_recordings`/`rate`, service role + gate de senha; deploy v6); notas em
  `public.cohort_ratings` (migração `cohort_ratings`; RLS sem policy de cliente,
  igual feedback_quota).
- ✅ Teste de willingness-to-pay com COBRANÇA REAL (Pix manual, memo §13 Opção
  B): a `PaywallScreen` é um teste de preço A/B — variante estável por usuário
  (`lib/services/pricing.dart`, `ProgressStore.assignedPriceVariant`), funil em
  `events` com `price_bucket` (`paywall_viewed` → `paywall_subscribe_clicked` →
  `pix_checkout_started` → `access_code_redeemed` = pagou). Fluxo: mostra a
  chave Pix do dev (`app_config 'pix'`, leitura pública, `Backend.fetchPixConfig`)
  + valor; comprador paga, recebe um código de Fundador (o dev gera no painel:
  `stats_screen` → `Backend.generateAccessCode` → `dev-stats` action
  `gen_access_code`) e resgata (`Backend.redeemAccessCode` → RPC
  `redeem_access_code` SECURITY DEFINER, exige auth.uid()) → vira Fundador
  (`EntitlementService.setFounderAccess`). Códigos em `public.access_codes`
  (migração `access_codes`; RLS sem policy de cliente). Quem não quer pagar
  agora ainda entra na lista por e-mail (fake door, sinal fraco). Gatilho: card
  não-bloqueante na home no "momento uau"; não gateia as lições grátis (hoje
  `kFreeLessonCount`=25=todas). **Decisão de produto (2026-07-06): a Trilha 1 é
  grátis pra TODOS de propósito — não gatear o loop é o que permite validar
  retenção com estranhos (Fase 0/1). O Fundador NÃO é desbloqueio de conteúdo; é
  (1) apoio, (2) selo visível de Fundador na AppBar (`_founderBadge` em
  home_screen, aparece quando `hasFounderAccess`; a oferta some pra quem já é
  Fundador), (3) trava vitalícia de preço/acesso às PRÓXIMAS trilhas (Fase 2+)
  — PERSISTIDA no resgate via `ProgressStore.lockFounderPrice` (`founderSince` +
  `founderLockedPriceCents`/`Label`), exibida na confirmação do paywall e no
  tooltip do selo; é o que honra a promessa quando houver conteúdo pago,
  (4) linha direta/moldar o produto.** A copy do paywall reflete exatamente isso
  — sem perks ocos (removida a linha "feedback de pronúncia", que é grátis pra
  todos). Métrica que importa: `access_code_redeemed`/`paywall_viewed` por
  `price_bucket`. Dev precisa preencher `app_config 'pix'` (key/name) pra o Pix
  aparecer.

## Fora de escopo (NÃO implementar)
- Fases 2–8, múltiplos sotaques, connected speech, pares mínimos, IPA
- Conversa livre com IA generativa — **decidido em 2026-09-16: on hold. Se
  voltar, é como PACOTE DE SERVIÇOS cobrado à parte, NUNCA dentro de uma
  trilha.** Motivo 1 (contratual): o Fundador é pagamento ÚNICO (R$ 27,90–67,90,
  `pricing.dart`) e a copy promete "acesso antecipado às próximas trilhas" +
  "travado pra sempre — sem mensalidade" (`paywall_screen.dart`). Voz em tempo
  real tem custo marginal POR MINUTO (ordem de grandeza US$ 0,06–0,30/min), então
  embutir isso numa trilha da Fase 2+ obrigaria a servir custo recorrente
  vitalício por um pagamento único — R$ 27,90 compram ~50 min de conversa, e a
  meta do produto é 484 h. Como add-on à parte, a promessa segue honrada.
  Motivo 2 (medição): fala livre não é pontuável pelo Azure, logo não vira
  "minuto aprovado" — quebraria a métrica norte e o antes/depois da coorte.
- Gamificação social, ranking, comunidade, dashboards B2B
- Modo offline completo
- TTS dinâmico em runtime (áudios são PRÉ-GERADOS e servidos por CDN)

## Ambiente de desenvolvimento (restrições reais)
- Máquina: MacBook Pro 2013 Intel, 8 GB RAM, disco apertado — SEM Xcode local
  e SEM dispositivo Android. O dev tem apenas iPhone.
- Iteração diária: **Flutter web no Chrome** (`flutter run -d chrome`) — o
  navegador dá acesso ao microfone, então o loop core é testável na web.
- Toda feature deve funcionar na web durante o desenvolvimento; abstrair o
  que for específico de plataforma (gravação de áudio, por exemplo) atrás de
  uma interface para trocar a implementação entre web e mobile.
- Build Android: toolchain local funciona (`flutter build apk`), sem emulador.
- ⚠️ Ao adicionar QUALQUER plugin novo no pubspec: rodar
  `rm -rf .dart_tool/flutter_build` antes do próximo `flutter run -d chrome`,
  senão o web_plugin_registrant fica desatualizado e o plugin lança
  MissingPluginException em runtime (já causou tela branca duas vezes).
- Build/teste iOS: via CI na nuvem (Codemagic ou GitHub Actions) + TestFlight
  no iPhone do dev. Nunca sugerir instalar Xcode nesta máquina.

## Stack
- Flutter (iOS + Android)
- Azure Speech SDK — Pronunciation Assessment (accuracy, fluency, completeness)
- ElevenLabs — geração dos áudios das lições (offline/build-time, não em runtime)
- **Supabase** — auth (anônima) + progresso + eventos (RLS) + Edge Functions.
  Projeto dedicado `484-method` (ref pwijrjgdbosxamybukhg, sa-east-1).
- Claude API — feedback pedagógico em PT-BR, chamado pela Edge Function
  `feedback` (chave Anthropic como secret `ANTHROPIC_API_KEY`, nunca no
  cliente). Mapeia scores do Azure → mensagem acionável; base em
  docs/feedback-library.md (fallback fixo quando indisponível).
- RevenueCat — assinaturas. ⚠️ `purchases_flutter` NÃO roda na web: a venda
  real só funciona em build iOS/Android e exige Apple Developer Program
  ($99/ano, ainda não adquirido). Por isso o paywall vive atrás de
  `EntitlementService` (interface), com fake local na web e a impl RevenueCat
  prevista para entrar sem tocar a UI quando houver conta Apple + CI iOS.

## Regras de produto que viram código
- Aprovação de tentativa: accuracy como critério principal em palavras;
  completeness/fluency ganham peso em chunks (lições 7–9)
- Feedback nunca diz só "errado" — sempre indica o que tentar corrigir. A
  mensagem fixa aparece na hora e é trocada pela da Claude quando chega; sem
  rede/chave fica a fixa (o app nunca depende da Claude para funcionar)
- Paywall: as 25 lições da Fase 1 são grátis hoje (`kFreeLessonCount`, ver
  Stack) enquanto não há monetização real ativa; o gate volta a valer quando
  RevenueCat entrar. Gating passa SEMPRE pela interface `EntitlementService` —
  nunca checar compra direto da UI
- Lições bônus (`Lesson.bonus`) nunca são pré-requisito de progressão: a
  lição N exige a lição anterior NÃO bônus concluída, não literalmente N-1
  (ver home_screen.dart)
- Tom adulto, direto, encorajador; sem infantilizar, sem prometer fluência
- LGPD: gravação de voz é dado sensível — consentimento explícito antes da
  primeira gravação, política de retenção/exclusão definida, exclusão de conta
  apaga os dados, nunca usar áudio para treinar modelos

## Docs
- docs/curriculo-fase1.md — as 10 lições com palavras, foco e critérios
- docs/feedback-library.md — mensagens de feedback por tipo de erro
- Plano completo: ~/Downloads/484Method_Plano_Projeto_CORRIGIDO.docx
