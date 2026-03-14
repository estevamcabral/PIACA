'use strict';

const express = require('express');

const app = express();
const PORT = process.env.PORT || 3002;

app.use(express.json());

// Health check
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'pet-management', version: '1.0.0' });
});

// Cadastro de Animais
app.get('/animals', (_req, res) => {
  res.json({ message: 'Listagem de animais - em desenvolvimento' });
});

app.post('/animals', (_req, res) => {
  res.status(201).json({ message: 'Cadastro de animal - em desenvolvimento' });
});

app.get('/animals/:id', (req, res) => {
  res.json({ id: req.params.id, message: 'Detalhes do animal - em desenvolvimento' });
});

app.put('/animals/:id', (req, res) => {
  res.json({ id: req.params.id, message: 'Atualização de animal - em desenvolvimento' });
});

// Histórico de Ocorrências (vacinas, exames, etc.)
app.get('/animals/:id/history', (req, res) => {
  res.json({
    animalId: req.params.id,
    types: ['vacina', 'exame', 'consulta', 'cirurgia', 'tratamento'],
    message: 'Histórico de ocorrências - em desenvolvimento',
  });
});

app.post('/animals/:id/history', (req, res) => {
  res.status(201).json({
    animalId: req.params.id,
    message: 'Registro de ocorrência - em desenvolvimento',
  });
});

app.listen(PORT, () => {
  console.log(`[pet-management] Serviço rodando na porta ${PORT}`);
});

module.exports = app;
