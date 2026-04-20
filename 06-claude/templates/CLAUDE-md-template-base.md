# Projeto: [Nome do Projeto]

> Template base. Substitua os campos entre colchetes e remova esta linha.

---

## Visão Geral

[1-3 frases descrevendo o que o sistema faz e por que existe. Contexto de negócio relevante.]

---

## Stack

- **Linguagem:** [Python 3.11 / TypeScript 5 / Go 1.22 / ...]
- **Framework:** [FastAPI / Next.js / Gin / ...]
- **Banco de dados:** [PostgreSQL 15 / MySQL / MongoDB / ...]
- **Cache/Fila:** [Redis / RabbitMQ / ...]
- **Deploy:** [AWS ECS / GCP Cloud Run / Kubernetes / ...]
- **CI/CD:** [GitHub Actions / GitLab CI / ...]

---

## Comandos Essenciais

```bash
# Desenvolvimento local
[comando para subir o ambiente]

# Testes
[comando para rodar testes]

# Lint e formatação
[comando de lint]

# Build
[comando de build]
```

---

## Arquitetura

[Descrição dos módulos principais e suas responsabilidades. Exemplo:]

- `src/api/` — Rotas e controllers HTTP
- `src/services/` — Lógica de negócio
- `src/models/` — Modelos de dados
- `src/workers/` — Tarefas assíncronas

---

## Convenções de Código

- [Convenção 1: ex. "Tipos explícitos em toda assinatura pública"]
- [Convenção 2: ex. "Testes obrigatórios para lógica de negócio"]
- [Convenção 3]
- [Convenção 4]
- [Convenção 5]

---

## Decisões Técnicas

- **[Tecnologia X em vez de Y]:** [Justificativa — ex. "Escolhemos Redis para sessões porque simplifica o ambiente local vs DynamoDB"]
- **[Decisão de arquitetura]:** [Justificativa]

---

## O que NUNCA Fazer

- Não commitar credenciais — usar `.env` local
- [Restrição técnica crítica]
- [Outra restrição]

---

## Integrações Externas

| Serviço | Variável de ambiente | Para quê |
|---------|---------------------|---------|
| [Serviço] | `[VAR_NAME]` | [Uso] |
