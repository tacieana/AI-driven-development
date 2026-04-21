# Enunciado — API REST: Notes API

## Contexto

Construa uma API REST de gerenciamento de notas pessoais com autenticação JWT. Cada usuário só tem acesso às suas próprias notas.

---

## Endpoints Obrigatórios

### Autenticação

```
POST /auth/register
Body: { email: string, password: string, name: string }
Response 201: { user: { id, name, email }, token: string }
Response 409: { error: "Email já cadastrado" }

POST /auth/login
Body: { email: string, password: string }
Response 200: { user: { id, name, email }, token: string }
Response 401: { error: "Credenciais inválidas" }
```

### Notas (requerem autenticação — Bearer token)

```
GET /notes
Response 200: { notes: Note[], total: number }

GET /notes/:id
Response 200: Note
Response 404: { error: "Nota não encontrada" }

POST /notes
Body: { title: string, content: string, tags?: string[] }
Response 201: Note

PUT /notes/:id
Body: { title?: string, content?: string, tags?: string[] }
Response 200: Note
Response 404: { error: "Nota não encontrada" }

DELETE /notes/:id
Response 204: (sem body)
Response 404: { error: "Nota não encontrada" }

GET /notes/search?q=termo
Response 200: { notes: Note[], total: number }
```

---

## Modelo de Dados

```typescript
interface User {
  id: string;          // UUID
  name: string;
  email: string;       // único
  passwordHash: string;
  createdAt: Date;
}

interface Note {
  id: string;          // UUID
  userId: string;      // FK para User
  title: string;       // obrigatório, máx 200 chars
  content: string;     // obrigatório
  tags: string[];      // array de strings, pode ser vazio
  createdAt: Date;
  updatedAt: Date;
}
```

---

## Requisitos Técnicos

- **Stack:** Node.js 20 + TypeScript + Express 4
- **Banco de dados:** PostgreSQL com Prisma ORM (ou SQLite para desenvolvimento)
- **Autenticação:** JWT com `jsonwebtoken` — expiração de 7 dias
- **Senha:** Hash com `bcrypt` (salt rounds: 10)
- **Validação:** `zod` para validação de request body
- **Testes:** Supertest + Jest com banco de dados real (SQLite em memória para testes)

---

## Critérios de Aceite

- [ ] `POST /auth/register` cria usuário com senha hasheada
- [ ] `POST /auth/login` retorna token JWT válido
- [ ] Endpoints de notas retornam 401 sem token válido
- [ ] Usuário A não consegue ver/editar/deletar notas do usuário B (403)
- [ ] `GET /notes/search?q=termo` busca em title e content
- [ ] Validação retorna 422 com campo inválido identificado
- [ ] Testes de integração para todos os endpoints
- [ ] Cobertura ≥ 75% nos services e repositories

---

## Regras de Negócio

- Um usuário não pode ver notas de outros usuários
- Email deve ser único no sistema
- Título e content são obrigatórios — strings vazias são inválidas
- Tags são opcionais e devem ser strings sem espaços extras
- A busca é case-insensitive
