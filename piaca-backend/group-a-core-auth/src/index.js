'use strict';

const express = require('express');

const app = express();
const PORT = process.env.PORT || 3001;

app.use(express.json());

// Health check
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'core-auth', version: '1.0.0' });
});

// Gestão de Usuários
app.get('/users', (_req, res) => {
  res.json({ message: 'Listagem de usuários - em desenvolvimento' });
});

app.post('/users', (_req, res) => {
  res.status(201).json({ message: 'Criação de usuário - em desenvolvimento' });
});

// Autenticação
app.post('/auth/login', (_req, res) => {
  res.json({ message: 'Login - em desenvolvimento' });
});

app.post('/auth/logout', (_req, res) => {
  res.json({ message: 'Logout - em desenvolvimento' });
});

app.post('/auth/refresh', (_req, res) => {
  res.json({ message: 'Refresh token - em desenvolvimento' });
});

// Perfis (ONG / Protetor / Adotante / Padrinho)
app.get('/profiles', (_req, res) => {
  res.json({
    types: ['ONG', 'Protetor', 'Adotante', 'Padrinho'],
    message: 'Perfis disponíveis - em desenvolvimento',
  });
});

// Logs de Auditoria
app.get('/audit-logs', (_req, res) => {
  res.json({ message: 'Logs de auditoria - em desenvolvimento' });
});

app.listen(PORT, () => {
  console.log(`[core-auth] Serviço rodando na porta ${PORT}`);
});

module.exports = app;
