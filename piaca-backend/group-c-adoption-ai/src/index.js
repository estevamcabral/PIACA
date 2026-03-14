'use strict';

const express = require('express');

const app = express();
const PORT = process.env.PORT || 3003;

app.use(express.json());

// Health check
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: 'adoption-ai', version: '1.0.0' });
});

// Fluxo de Interesse em Adoção
app.post('/adoption/interest', (_req, res) => {
  res.status(201).json({ message: 'Registro de interesse em adoção - em desenvolvimento' });
});

app.get('/adoption/interest', (_req, res) => {
  res.json({ message: 'Listagem de interesses em adoção - em desenvolvimento' });
});

app.get('/adoption/interest/:id', (req, res) => {
  res.json({ id: req.params.id, message: 'Detalhes do interesse em adoção - em desenvolvimento' });
});

app.put('/adoption/interest/:id/status', (req, res) => {
  res.json({
    id: req.params.id,
    statuses: ['pendente', 'em_analise', 'aprovado', 'recusado'],
    message: 'Atualização de status - em desenvolvimento',
  });
});

// Relatório de Compatibilidade via LLM
app.post('/adoption/compatibility-report', (_req, res) => {
  res.status(202).json({
    message: 'Geração de relatório de compatibilidade via LLM - em desenvolvimento',
    note: 'Requer integração com provedor de LLM (ex: OpenAI, Anthropic)',
  });
});

app.get('/adoption/compatibility-report/:id', (req, res) => {
  res.json({
    id: req.params.id,
    message: 'Resultado do relatório de compatibilidade - em desenvolvimento',
  });
});

app.listen(PORT, () => {
  console.log(`[adoption-ai] Serviço rodando na porta ${PORT}`);
});

module.exports = app;
