import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

type JsonBody = Record<string, unknown>;

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(status: number, body: JsonBody): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return json(405, { error: "Method not allowed." });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!supabaseUrl || !anonKey || !serviceRoleKey) {
    return json(500, { error: "Function is missing Supabase secrets." });
  }

  const authorization = req.headers.get("Authorization") ?? "";
  const jwt = authorization.replace(/^Bearer\s+/i, "").trim();
  if (!jwt) {
    return json(401, { error: "Missing Authorization bearer token." });
  }

  const userClient = createClient(supabaseUrl, anonKey, {
    global: { headers: { Authorization: `Bearer ${jwt}` } },
    auth: { persistSession: false },
  });

  const {
    data: { user },
    error: userError,
  } = await userClient.auth.getUser();

  if (userError || !user) {
    return json(401, { error: "Invalid or expired session." });
  }

  const adminClient = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const userId = user.id;

  const deleteSteps: Array<PromiseLike<{ error: unknown }>> = [
    adminClient.from("notifications").delete().eq("user_id", userId),
    adminClient.from("reading_progress").delete().eq("user_id", userId),
    adminClient.from("ratings").delete().eq("user_id", userId),
    adminClient.from("favorites").delete().eq("user_id", userId),
    adminClient.from("follows").delete().eq("follower_id", userId),
    adminClient.from("follows").delete().eq("author_id", userId),
    adminClient.from("reports").delete().eq("reporter_id", userId),
    adminClient.from("reports").delete().eq("reported_user_id", userId),
    adminClient.from("books").delete().eq("author_id", userId),
    adminClient.from("writer_profiles").delete().eq("user_id", userId),
  ];

  for (const step of deleteSteps) {
    const { error } = await step;
    if (error) {
      console.error("Account deletion cleanup failed", error);
      return json(500, { error: "Failed to delete account data." });
    }
  }

  const { error: profileError } = await adminClient
    .from("profiles")
    .delete()
    .eq("id", userId);

  if (profileError) {
    console.error("Profile deletion failed", profileError);
    return json(500, { error: "Failed to delete profile." });
  }

  const { error: deleteUserError } =
    await adminClient.auth.admin.deleteUser(userId);

  if (deleteUserError) {
    console.error("Auth user deletion failed", deleteUserError);
    return json(500, { error: "Failed to delete auth user." });
  }

  return json(200, { ok: true });
});
