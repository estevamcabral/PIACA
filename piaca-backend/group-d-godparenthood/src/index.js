'use strict';

const express = require('express');

const app = express();
const PORT = process.env.PORT || 3004;

app.use(express.json());

// Health check
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'godparenthood', version: '1.0.0' });
});

// Cadastro de Apadrinhamento
app.get('/godparenthood', (_req, res) => {
  res.json({ message: 'Listagem de apadrinhamentos - em desenvolvimento' });
});

app.post('/godparenthood', (_req, res) => {
  res.status(201).json({ message: 'Registro de apadrinhamento - em desenvolvimento' });
});

app.get('/godparenthood/:id', (req, res) => {
  res.json({ id: req.params.id, message: 'Detalhes do apadrinhamento - em desenvolvimento' });
});

app.put('/godparenthood/:id', (req, res) => {
  res.json({ id: req.params.id, message: 'Atualização de apadrinhamento - em desenvolvimento' });
});

app.delete('/godparenthood/:id', (req, res) => {
  res.json({ id: req.params.id, message: 'Cancelamento de apadrinhamento - em desenvolvimento' });
});

// Padrinhos
app.get('/godparents', (_req, res) => {
  res.json({ message: 'Listagem de padrinhos - em desenvolvimento' });
});

// Contribuições / Pagamentos
app.get('/godparenthood/:id/contributions', (req, res) => {
  res.json({
    godparenthoodId: req.params.id,
    message: 'Histórico de contribuições - em desenvolvimento',
  });
});

app.post('/godparenthood/:id/contributions', (req, res) => {
  res.status(201).json({
    godparenthoodId: req.params.id,
    message: 'Registro de contribuição - em desenvolvimento',
  });
});

app.listen(PORT, () => {
  console.log(`[godparenthood] Serviço rodando na porta ${PORT}`);
});

module.exports = app;
