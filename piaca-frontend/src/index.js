'use strict';

const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Carrega o index.html uma única vez na inicialização (sem I/O por requisição)
const indexHtml = fs.readFileSync(path.join(__dirname, 'public', 'index.html'), 'utf8');

app.use(express.json());

// Health check
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'piaca-frontend', version: '1.0.0' });
});

// Arquivos estáticos
app.use(express.static(path.join(__dirname, 'public')));

// Fallback SPA: retorna index.html pré-carregado (sem acesso ao filesystem por request)
app.use((_req, res) => {
  res.setHeader('Content-Type', 'text/html; charset=utf-8');
  res.send(indexHtml);
});

app.listen(PORT, () => {
  console.log(`[piaca-frontend] Serviço rodando na porta ${PORT}`);
});

module.exports = app;
