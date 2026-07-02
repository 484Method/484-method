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
import { createClient } from "jsr:@supabase/supabase-js@2";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });

  const expected = Deno.env.get("DEV_STATS_PASSWORD");
  if (!expected) {
    return new Response(JSON.stringify({ error: "password_unconfigured" }), {
      status: 503,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  }

  try {
    const { password, set_maintenance } = await req.json();
    if (password !== expected) {
      return new Response(JSON.stringify({ error: "wrong_password" }), {
        status: 401,
        headers: { ...cors, "Content-Type": "application/json" },
      });
    }

    const client = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

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

    return new Response(
      JSON.stringify({ ...data, maintenance_mode: maintenanceOn }),
      {
        status: 200,
        headers: { ...cors, "Content-Type": "application/json" },
      },
    );
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  }
});
