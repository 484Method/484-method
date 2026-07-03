// Edge Function: gate de senha para o painel de uso interno (get_dev_stats).
// A senha vive como secret do Supabase (DEV_STATS_PASSWORD) — nunca no
// cliente, então a checagem não pode ser pulada chamando a RPC direto com a
// anon key (get_dev_stats() teve EXECUTE revogado de anon/authenticated;
// só esta função, com a service role key, consegue chamá-la).
//
// Também é o ÚNICO caminho de escrita do liga/desliga do app (app_config/
// 'maintenance'): body opcional { set_maintenance: bool } atualiza a flag
// atrás do mesmo gate de senha; a tabela tem RLS sem policy de escrita, então
// a anon key não consegue alterá-la por fora. A resposta sempre inclui
// maintenance_mode junto das stats (estado do switch no painel).
//
// Rating cego das gravações do desafio de 21 dias (bucket privado
// cohort-recordings): { action: 'list_recordings' } devolve as gravações com
// URLs ASSINADAS (só a service role assina o bucket privado) + a nota já dada;
// { action: 'rate', recording_id, score, note } grava a nota.
//
// Pix manual: { action: 'gen_access_code', note?, price_bucket? } cria um
// código de acesso (Fundador) pra o dev entregar a quem pagou via Pix; o
// resgate é pela RPC redeem_access_code (não passa aqui). Tudo atrás do mesmo
// gate de senha.
import { createClient } from "jsr:@supabase/supabase-js@2";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...cors, "Content-Type": "application/json" },
  });

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });

  const expected = Deno.env.get("DEV_STATS_PASSWORD");
  if (!expected) return json({ error: "password_unconfigured" }, 503);

  try {
    const {
      password,
      set_maintenance,
      action,
      recording_id,
      score,
      note,
      price_bucket,
    } = await req.json();
    if (password !== expected) return json({ error: "wrong_password" }, 401);

    const client = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    // ── Rating cego: listar gravações com URL assinada + nota atual ──────────
    if (action === "list_recordings") {
      const { data: recs, error } = await client
        .from("cohort_recordings")
        .select("id, user_id, kind, storage_path, duration_ms, cohort_day, created_at")
        .order("created_at", { ascending: true });
      if (error) throw error;

      const { data: ratings } = await client
        .from("cohort_ratings")
        .select("recording_id, score, note");
      const ratingByRec = new Map(
        (ratings ?? []).map((r) => [r.recording_id, r]),
      );

      const out = [];
      for (const r of recs ?? []) {
        const { data: signed } = await client.storage
          .from("cohort-recordings")
          .createSignedUrl(r.storage_path, 3600); // 1h por sessão de rating
        const rating = ratingByRec.get(r.id);
        out.push({
          id: r.id,
          user_id: r.user_id,
          kind: r.kind,
          duration_ms: r.duration_ms,
          cohort_day: r.cohort_day,
          created_at: r.created_at,
          url: signed?.signedUrl ?? null,
          score: rating?.score ?? null,
          note: rating?.note ?? null,
        });
      }
      return json({ recordings: out });
    }

    // ── Rating cego: gravar/atualizar a nota de uma gravação ─────────────────
    if (action === "rate") {
      if (
        typeof recording_id !== "string" ||
        typeof score !== "number" ||
        score < 1 ||
        score > 5
      ) {
        return json({ error: "invalid_rating" }, 400);
      }
      const { error } = await client.from("cohort_ratings").upsert(
        {
          recording_id,
          score,
          note: typeof note === "string" && note.trim() ? note.trim() : null,
          rated_at: new Date().toISOString(),
        },
        { onConflict: "recording_id" },
      );
      if (error) throw error;
      return json({ ok: true });
    }

    // ── Pix manual: gerar um código de acesso (Fundador) pra dar ao pagante ──
    if (action === "gen_access_code") {
      const alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // sem I/O/0/1
      const rand = Array.from(
        { length: 6 },
        () => alphabet[Math.floor(Math.random() * alphabet.length)],
      ).join("");
      const code = `FUND-${rand}`;
      const { error } = await client.from("access_codes").insert({
        code,
        note: typeof note === "string" && note.trim() ? note.trim() : null,
        price_bucket: typeof price_bucket === "string" ? price_bucket : null,
      });
      if (error) throw error;
      return json({ code });
    }

    // ── Export CSV: uma linha por usuário — cadastro (nome/e-mail) + prática ──
    if (action === "export_users") {
      const { data: signups } = await client
        .from("signups")
        .select("user_id, name, email, created_at");
      const { data: prog, error } = await client
        .from("progress")
        .select(
          "user_id, approved_seconds, streak_days, completed_lessons, last_practice_day, updated_at",
        );
      if (error) throw error;
      const sMap = new Map((signups ?? []).map((s) => [s.user_id, s]));
      const pMap = new Map((prog ?? []).map((p) => [p.user_id, p]));
      // União: pega quem se cadastrou (mesmo sem praticar) e quem tem progresso.
      const ids = new Set([...sMap.keys(), ...pMap.keys()]);
      const users = [...ids].map((id) => {
        const s = sMap.get(id);
        const p = pMap.get(id);
        return {
          user_id: id,
          name: s?.name ?? "",
          email: s?.email ?? "",
          signed_up_at: s?.created_at ?? "",
          approved_seconds: p?.approved_seconds ?? 0,
          approved_minutes: Math.round((p?.approved_seconds ?? 0) / 60),
          streak_days: p?.streak_days ?? 0,
          lessons_completed: Array.isArray(p?.completed_lessons)
            ? p.completed_lessons.length
            : 0,
          last_practice_day: p?.last_practice_day ?? "",
          updated_at: p?.updated_at ?? "",
        };
      });
      return json({ users });
    }

    // ── Liga/desliga do app + stats agregadas (comportamento padrão) ─────────
    if (typeof set_maintenance === "boolean") {
      const { error } = await client.from("app_config").upsert({
        key: "maintenance",
        value: { on: set_maintenance },
        updated_at: new Date().toISOString(),
      });
      if (error) throw error;
    }

    const { data, error } = await client.rpc("get_dev_stats");
    if (error) throw error;

    const { data: cfg } = await client
      .from("app_config")
      .select("value")
      .eq("key", "maintenance")
      .maybeSingle();
    const maintenanceOn = cfg?.value?.on === true;

    return json({ ...data, maintenance_mode: maintenanceOn });
  } catch (e) {
    return json({ error: String(e) }, 500);
  }
});
