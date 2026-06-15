const NovelFlexAuth = (() => {
  const SUPABASE_URL = "https://ifxzbwaxrloeuztavcef.supabase.co";
  const SUPABASE_ANON_KEY = "sb_publishable_1nvnpiJ7AT56Y37tGtNGqQ_p6Wz_bCc";
  const GUEST_KEY = "novelflex_guest_mode";

  const client = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
    auth: {
      persistSession: true,
      autoRefreshToken: true,
      detectSessionInUrl: true,
      flowType: "implicit",
      storageKey: "novelflex_supabase_auth",
    },
  });

  const listeners = new Set();
  const state = {
    ready: false,
    session: null,
    user: null,
    isGuest: localStorage.getItem(GUEST_KEY) === "true",
    lastError: "",
  };

  function notify() {
    listeners.forEach((listener) => listener({ ...state }));
  }

  function redirectUrl() {
    const { origin, pathname } = window.location;
    if (origin === "null") return window.location.href.split("#")[0];
    return `${origin}${pathname}`;
  }

  function normalizeError(error) {
    if (!error) return "";
    return error.message || "Authentication failed.";
  }

  function displayName() {
    const metadata = state.user?.user_metadata || {};
    return (
      metadata.username ||
      metadata.name ||
      metadata.full_name ||
      state.user?.email?.split("@")[0] ||
      (state.isGuest ? "ضيف" : "حسابي")
    );
  }

  async function init() {
    const { data, error } = await client.auth.getSession();
    if (error) state.lastError = normalizeError(error);
    state.session = data?.session || null;
    state.user = state.session?.user || null;
    if (state.user) {
      state.isGuest = false;
      localStorage.removeItem(GUEST_KEY);
    }
    state.ready = true;
    notify();

    client.auth.onAuthStateChange((_event, session) => {
      state.session = session || null;
      state.user = session?.user || null;
      if (state.user) {
        state.isGuest = false;
        localStorage.removeItem(GUEST_KEY);
      }
      notify();
    });
  }

  async function login(email, password) {
    state.lastError = "";
    const { error } = await client.auth.signInWithPassword({
      email: email.trim(),
      password,
    });
    if (error) throw new Error(normalizeError(error));
    localStorage.removeItem(GUEST_KEY);
    state.isGuest = false;
    notify();
  }

  async function register({ email, password, username }) {
    state.lastError = "";
    const { error } = await client.auth.signUp({
      email: email.trim(),
      password,
      options: {
        emailRedirectTo: redirectUrl(),
        data: {
          username: username.trim(),
          role: "reader",
        },
      },
    });
    if (error) throw new Error(normalizeError(error));
    localStorage.removeItem(GUEST_KEY);
    state.isGuest = false;
    notify();
  }

  async function oauth(provider) {
    state.lastError = "";
    const { error } = await client.auth.signInWithOAuth({
      provider,
      options: {
        redirectTo: redirectUrl(),
      },
    });
    if (error) throw new Error(normalizeError(error));
  }

  async function continueAsGuest() {
    await client.auth.signOut();
    localStorage.setItem(GUEST_KEY, "true");
    state.session = null;
    state.user = null;
    state.isGuest = true;
    state.lastError = "";
    notify();
  }

  async function logout() {
    await client.auth.signOut();
    localStorage.removeItem(GUEST_KEY);
    state.session = null;
    state.user = null;
    state.isGuest = false;
    notify();
  }

  return {
    init,
    login,
    register,
    oauth,
    continueAsGuest,
    logout,
    client,
    displayName,
    getState: () => ({ ...state }),
    onChange(listener) {
      listeners.add(listener);
      return () => listeners.delete(listener);
    },
  };
})();

window.NovelFlexAuth = NovelFlexAuth;
