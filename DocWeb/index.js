async function loadVersions() {
  try {
    const r = await fetch("/api/docs/versions.json", { cache: "no-store" });
    if (!r.ok) throw new Error("versions fetch failed");
    const v = await r.json();

    const appleA = document.getElementById("docs-link-apple");
    const linuxA = document.getElementById("docs-link-linux");

    appleA.href = (v.apple && v.apple.href) || "/docs/apple/latest/";
    linuxA.href = (v.linux && v.linux.href) || "/docs/linux/latest/";

    if (v.apple?.latest) appleA.textContent = `Apple (${v.apple.latest})`;
    if (v.linux?.latest) linuxA.textContent = `Linux (${v.linux.latest})`;
  } catch (e) {
    document.getElementById("docs-link-apple").href = "/docs/apple/latest/";
    document.getElementById("docs-link-linux").href = "/docs/linux/latest/";
  }
}

function getCurrentTheme() {
  const saved = localStorage.getItem("theme");
  if (saved === "dark" || saved === "light") return saved;
  return window.matchMedia("(prefers-color-scheme: dark)").matches
    ? "dark"
    : "light";
}

function saveCurrentTheme(newValue) {
  localStorage.setItem("theme", newValue);
}

function updateUiForTheme(theme) {
  if (theme === "dark") document.documentElement.classList.add("dark");
  else document.documentElement.classList.remove("dark");
  updateButton(theme);
}

function updateButton(theme) {
  const btn = document.getElementById("theme-toggle");
  if (!btn) return;
  btn.textContent = theme === "dark" ? "☀️" : "🌙";
}

// -----

window.addEventListener("DOMContentLoaded", () => {
  const currentTheme = getCurrentTheme();
  updateUiForTheme(currentTheme);
  loadVersions();

  document.getElementById("theme-toggle")?.addEventListener("click", () => {
    const newTheme = getCurrentTheme() === "dark" ? "light" : "dark";
    saveCurrentTheme(newTheme);
    updateUiForTheme(newTheme);
  });
});
