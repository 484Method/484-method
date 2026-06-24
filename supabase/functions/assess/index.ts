// Edge Function: proxy do Azure Pronunciation Assessment. A chave do Azure
// vive como secret do Supabase (AZURE_SPEECH_KEY / AZURE_SPEECH_REGION) —
// nunca no cliente, para a web pública não vazar a chave. verify_jwt fica
// ligado: só a sessão anônima do app chama.
//
// Recebe JSON { referenceText, audioBase64, attempt? } e devolve o JSON
// detalhado do Azure acrescido de { aiFeedback } quando ANTHROPIC_API_KEY
// está configurada — score + feedback em uma única viagem de rede.
import Anthropic from "npm:@anthropic-ai/sdk@0.70.0";

const FEEDBACK_SYSTEM =
  `Você é o coach de pronúncia do 484 Method, um app que ensina ` +
  `brasileiros adultos a falar inglês. Tom adulto, direto e encorajador — nunca ` +
  `infantiliza, nunca promete fluência mágica.\n\n` +
  `Você recebe os scores do Azure Pronunciation Assessment de UMA tentativa e ` +
  `escreve UMA frase curta (no máximo duas) de feedback em português do Brasil.\n\n` +
  `Regras:\n` +
  `- NUNCA diga só "errado". Sempre aponte o que tentar na próxima gravação.\n` +
  `- Se houver um trecho/sílaba fraca, mencione esse pedaço específico.\n` +
  `- Se a prosódia (ritmo/sílaba forte) for o problema, oriente a copiar a "música" da palavra, não as letras.\n` +
  `- Se passou bem, comemore de forma sóbria e sugira repetir para fixar.\n` +
  `- Fale com "você". Não use emojis. Não use aspas. Não explique os números.\n` +
  `- Responda APENAS com a frase de feedback, nada mais.`;

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

  try {
    const { referenceText, audioBase64, attempt = 1 } = await req.json();
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

    // Erro do Azure: passa adiante sem modificar.
    if (azureStatus !== 200) {
      return new Response(text, {
        status: azureStatus,
        headers: { ...cors, "Content-Type": "application/json" },
      });
    }

    // Sucesso: adiciona feedback da Claude Haiku na mesma resposta.
    let responseBody = text;
    const anthropicKey = Deno.env.get("ANTHROPIC_API_KEY");
    if (anthropicKey) {
      try {
        const azureJson = JSON.parse(text);
        if (azureJson.RecognitionStatus === "Success") {
          const best = azureJson.NBest?.[0] ?? {};
          const accuracy     = (best.AccuracyScore     ?? 0) as number;
          const fluency      = (best.FluencyScore      ?? 0) as number;
          const completeness = (best.CompletenessScore ?? 0) as number;
          const prosody      = (best.ProsodyScore      ?? null) as number | null;

          let minPhoneme = 100;
          let worstSyllable: string | null = null;
          let worstSylScore = 100;
          for (const w of (best.Words ?? [])) {
            for (const p of (w.Phonemes ?? [])) {
              const sc = (p.AccuracyScore ?? 100) as number;
              if (sc < minPhoneme) minPhoneme = sc;
            }
            for (const s of (w.Syllables ?? [])) {
              const sc = (s.AccuracyScore ?? 100) as number;
              if (sc < worstSylScore) {
                worstSylScore = sc;
                worstSyllable = (s.Grapheme ?? s.Syllable ?? null) as string | null;
              }
            }
          }

          // Aprovação: heurística simples (thresholds por lição ficam no cliente).
          const approved = accuracy >= 75 && minPhoneme >= 55;

          const client = new Anthropic({ apiKey: anthropicKey });
          const msg = await client.messages.create({
            model: "claude-haiku-4-5-20251001",
            max_tokens: 150,
            system: FEEDBACK_SYSTEM,
            messages: [{
              role: "user",
              content:
                `Palavra-alvo: "${referenceText}". Tentativa ${attempt} de 2. ` +
                `Aprovada: ${approved ? "sim" : "não"}. ` +
                `Accuracy ${Math.round(accuracy)}, fluency ${Math.round(fluency)}, ` +
                `completeness ${Math.round(completeness)}, prosódia ${prosody != null ? Math.round(prosody) : "n/d"}. ` +
                `Fonema mais fraco: ${Math.round(minPhoneme)}. ` +
                (worstSyllable ? `Trecho mais fraco: "${worstSyllable}". ` : "") +
                `Escreva o feedback.`,
            }],
          });

          const aiFeedback = msg.content
            .filter((b) => b.type === "text")
            .map((b) => (b as { text: string }).text)
            .join(" ")
            .trim();

          if (aiFeedback) {
            responseBody = JSON.stringify({ ...azureJson, aiFeedback });
          }
        }
      } catch (e) {
        // Claude falhou: retorna só o Azure, cliente usa fallback fixo.
        console.error("[assess] Claude feedback failed:", e);
      }
    }

    return new Response(responseBody, {
      status: 200,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  }
});
