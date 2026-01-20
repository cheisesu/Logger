const fs = require("fs");
const http = require("http");
const express = require("express");
const path = require("path");
require("dotenv").config();

const PORT = 9601;
const ADDRESS = "127.0.0.1";
const ROOT = path.resolve(__dirname);
const DOCUMENTATION_NAME = "loggerkit";

const app = express();

function readLatestTag() {
  try {
    const raw = fs.readFileSync(path.join(ROOT, "meta.json"), "utf8");
    const meta = JSON.parse(raw);
    if (typeof meta.latest_release === "string" && meta.latest_release.length) {
      return meta.latest_release;
    }
  } catch {}
  return null;
}

app.get("/api/docs/versions.json", (req, res) => {
  const tag = readLatestTag();
  if (!tag)
    return res.status(404).json({ error: "Couldn't fetch versions info." });
  const latest = tag.replace(/^v/i, "");
  res.type("application/json").send({
    apple: { latest, tag, href: `/docs/apple/${tag}/` },
    linux: { latest, tag, href: `/docs/linux/${tag}/` },
  });
});

app.get("/docs/:platform(apple|linux)/latest", (req, res) => {
  const tag = readLatestTag();
  if (!tag) return res.status(503).send("latest not available");
  res.redirect(
    302,
    `/docs/${req.params.platform}/${tag}/documentation/loggerkit/`,
  );
});

app.get("/docs/:platform(apple|linux)/:ver", (req, res) => {
  const { platform, ver } = req.params;
  res.redirect(
    302,
    `/docs/${platform}/${ver}/documentation/${DOCUMENTATION_NAME}/`,
  );
});

app.get(
  "/docs/:platform(apple|linux)/:ver/(documentation|tutorials)",
  (req, res) => {
    const { platform, ver } = req.params;
    res.redirect(
      302,
      `/docs/${platform}/${ver}/documentation/${DOCUMENTATION_NAME}/`,
    );
  },
);

app.get(
  "/docs/:platform(apple|linux)/:ver/(documentation|tutorials)/*",
  (req, res, next) => {
    const { platform, ver } = req.params;
    const p = path.join(ROOT, "docs", platform, ver, "index.html");
    if (!fs.existsSync(p)) return next();
    const result = fs.readFileSync(p, "utf8");
    res.type("html").send(result);
  },
);

app.get("/docs/:platform(apple|linux)/:ver/*", (req, res, next) => {
  const p = path.join(ROOT, req.path);
  if (fs.existsSync(p)) return res.sendFile(p);
  return next();
});

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "index.html"));
});

app.get("/index.js", (req, res) => {
  res.sendFile(path.join(__dirname, "index.js"));
});

app.use((req, res) => {
  res.status(404).sendFile(path.join(__dirname, "404.html"));
});

// STARTING SERVER

http.createServer(app).listen(PORT, ADDRESS, () => {
  console.log(`Started at http://${ADDRESS}:${PORT}`);
});
