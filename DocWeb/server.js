const fs = require("fs");
const http = require("http");
const express = require("express");
const path = require("path");
require("dotenv").config();

const NODE_ENV = process.env.NODE_ENV || "DEV";
const PORT = 9601;
const ADDRESS = "127.0.0.1";

const app = express();

// Главная страница
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "index.html"));
});

// Обработка 404
app.use((req, res) => {
  res.status(404).sendFile(path.join(__dirname, "404.html"));
});

// STARTING SERVER

http.createServer(app).listen(PORT, ADDRESS, () => {
  console.log(`Started at http://${ADDRESS}:${PORT}`);
});
