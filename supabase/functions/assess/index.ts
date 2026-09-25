// Edge Function: proxy do Azure Pronunciation Assessment. A chave do Azure
// vive como secret do Supabase (AZURE_SPEECH_KEY / AZURE_SPEECH_REGION) —
// nunca no cliente, para a web pública não vazar a chave. verify_jwt fica
// ligado: só a sessão anônima do app chama.
//
// Recebe JSON { referenceText, audioBase64, attempt? } e devolve o JSON
// detalhado do Azure sem modificar. O feedback pedagógico é calculado no
// cliente por banda de nota (lib/services/feedback_messages.dart) — nada de
// chamada a IA aqui, que custava uma segunda viagem de rede em série por
// tentativa e deixava a tela "Avaliando..." mais lenta sem ganho real.
import { createClient } from "npm:@supabase/supabase-js@2";

// Teto diário de avaliações por usuário — o Azure é cobrado por hora de
// áudio, e sign-in anônimo sem fricção significa que criar conta nova é
// grátis, então SEM isto não existe teto de custo nenhum (achado ALTO da
// auditoria de segurança, 2026-09-25). ~150/dia cobre um dia bem puxado de
// prática de verdade (25 lições × poucas tentativas + revisões espaçadas) —
// mesmo teto já usado em `feedback` (que é chamado no MÁXIMO uma vez por
// avaliação, geralmente menos). Trocável por secret ASSESS_DAILY_LIMIT sem
// redeploy — "mínimo possível pro funcionamento", não generoso de propósito.
const DAILY_LIMIT = Number(Deno.env.get("ASSESS_DAILY_LIMIT") ?? "150");

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });

  const key = Deno.env.get("AZURE_SPEECH_KEY");
  const region = Deno.env.get("AZURE_SPEECH_REGION") ?? "brazilsouth";
  if (!key) {
    return new Response(JSON.stringify({ error: "azure_unconfigured" }), {
      status: 503,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  }

  // Teto por usuário/dia: incrementa atômico via RPC (conta por auth.uid()).
  // Acima do limite → 429. Fail-open: uma falha do contador não pode derrubar
  // o loop core do app por causa de um problema no próprio contador.
  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
    const authHeader = req.headers.get("Authorization");
    if (supabaseUrl && anonKey && authHeader) {
      const supabase = createClient(supabaseUrl, anonKey, {
        global: { headers: { Authorization: authHeader } },
      });
      const { data: allowed, error } = await supabase.rpc(
        "consume_assess_quota",
        { p_limit: DAILY_LIMIT },
      );
      if (!error && allowed === false) {
        return new Response(JSON.stringify({ error: "quota_exceeded" }), {
          status: 429,
          headers: { ...cors, "Content-Type": "application/json" },
        });
      }
    }
  } catch (_e) {
    // fail-open: não bloqueia a avaliação por causa do contador
  }

  try {
    const { referenceText, audioBase64 } = await req.json();
    if (!referenceText || !audioBase64) {
      return new Response(JSON.stringify({ error: "missing_params" }), {
        status: 400,
        headers: { ...cors, "Content-Type": "application/json" },
      });
    }

    const audio = Uint8Array.from(atob(audioBase64), (c) => c.charCodeAt(0));
    const config = btoa(
      JSON.stringify({
        ReferenceText: referenceText,
        // "HundredMark" — "HundredPoint" causa 400 no Azure.
        GradingSystem: "HundredMark",
        Granularity: "Phoneme",
        Dimension: "Comprehensive",
        EnableProsodyAssessment: "True",
      }),
    );

    const url =
      `https://${region}.stt.speech.microsoft.com` +
      `/speech/recognition/conversation/cognitiveservices/v1` +
      `?language=en-US&format=detailed`;

    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), 15_000);
    let azureRes: Response;
    try {
      azureRes = await fetch(url, {
        method: "POST",
        headers: {
          "Ocp-Apim-Subscription-Key": key,
          "Content-Type": "audio/wav; codecs=audio/pcm; samplerate=16000",
          "Pronunciation-Assessment": config,
          "Accept": "application/json",
        },
        body: audio,
        signal: controller.signal,
      });
    } finally {
      clearTimeout(timer);
    }

    const azureStatus = azureRes.status;
    const text = await azureRes.text();

    return new Response(text, {
      status: azureStatus,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  }
});
