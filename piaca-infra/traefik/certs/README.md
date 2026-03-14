# Certificados TLS

Este diretório armazena os certificados TLS utilizados pelo Traefik.

## Desenvolvimento Local

Gere um certificado autoassinado para `*.piaca.localhost`:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout local.key \
  -out local.crt \
  -subj "/CN=*.piaca.localhost" \
  -addext "subjectAltName=DNS:piaca.localhost,DNS:*.piaca.localhost,DNS:api.piaca.localhost,DNS:traefik.piaca.localhost"
```

Coloque os arquivos `local.crt` e `local.key` neste diretório.

## Produção

Em produção, configure o Traefik com Let's Encrypt ou utilize certificados
emitidos pela sua CA corporativa. **Nunca versione certificados ou chaves privadas.**
