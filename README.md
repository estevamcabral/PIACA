# 🐾 PIACA — Plataforma Integrada de Adoção e Cuidado Animal

## Estrutura do Repositório

```
PIACA/
├── docker-compose.yml          # Orquestração de todos os serviços (Traefik + apps)
├── piaca-frontend/             # Aplicação web (SPA / SSR)
│   ├── Dockerfile
│   └── src/
├── piaca-backend/
│   ├── group-a-core-auth/      # Grupo A: Core & Auth
│   │   ├── Dockerfile
│   │   └── src/
│   ├── group-b-pet-management/ # Grupo B: Gestão de Pets
│   │   ├── Dockerfile
│   │   └── src/
│   ├── group-c-adoption-ai/    # Grupo C: Adoção & IA
│   │   ├── Dockerfile
│   │   └── src/
│   └── group-d-godparenthood/  # Grupo D: Apadrinhamento
│       ├── Dockerfile
│       └── src/
├── piaca-mobile/               # Aplicação mobile (a definir)
└── piaca-infra/
    └── traefik/
        ├── dynamic/            # Configurações dinâmicas do Traefik
        └── certs/              # Certificados TLS (não versionar .crt/.key)
```

---

## Módulos do Backend

| Módulo | Grupo | Responsabilidades |
|---|---|---|
| `group-a-core-auth` | A — Core & Auth | Gestão de usuários, autenticação, perfis (ONG / Protetor / Adotante / Padrinho), logs de auditoria |
| `group-b-pet-management` | B — Gestão de Pets | Cadastro de animais, histórico dinâmico de ocorrências (vacinas, exames, etc.) |
| `group-c-adoption-ai` | C — Adoção & IA | Fluxo de interesse em adoção, relatório de compatibilidade via LLM |
| `group-d-godparenthood` | D — Apadrinhamento | Cadastro de apadrinhamentos, padrinhos e contribuições |

---

## Arquitetura de Rede

```
Internet
   │
   ▼
[Traefik Gateway]  ← porta 80/443 (pública)
   │ piaca-net (rede interna Docker)
   ├──► piaca-frontend      :3000  (https://piaca.localhost)
   ├──► piaca-core-auth     :3001  (https://api.piaca.localhost/auth, /users, ...)
   ├──► piaca-pet-management:3002  (https://api.piaca.localhost/animals)
   ├──► piaca-adoption-ai   :3003  (https://api.piaca.localhost/adoption)
   └──► piaca-godparenthood :3004  (https://api.piaca.localhost/godparenthood)
```

> Nenhum serviço de negócio expõe porta pública. Todo o tráfego externo passa pelo Traefik.

---

## Desenvolvimento Local

### Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) ≥ 24
- [Docker Compose](https://docs.docker.com/compose/) ≥ 2.20

### 1. Gerar certificado TLS autoassinado

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout piaca-infra/traefik/certs/local.key \
  -out  piaca-infra/traefik/certs/local.crt \
  -subj "/CN=*.piaca.localhost" \
  -addext "subjectAltName=DNS:piaca.localhost,DNS:*.piaca.localhost,DNS:api.piaca.localhost,DNS:traefik.piaca.localhost"
```

### 2. Adicionar hosts locais (`/etc/hosts`)

```
127.0.0.1  piaca.localhost api.piaca.localhost traefik.piaca.localhost
```

### 3. Subir todos os serviços

```bash
docker compose up --build
```

### 4. Acessar

| URL | Serviço |
|---|---|
| https://piaca.localhost | Frontend |
| https://api.piaca.localhost/auth/... | Core & Auth |
| https://api.piaca.localhost/animals/... | Gestão de Pets |
| https://api.piaca.localhost/adoption/... | Adoção & IA |
| https://api.piaca.localhost/godparenthood/... | Apadrinhamento |
| https://traefik.piaca.localhost | Dashboard Traefik |