# Solução de Referência — Notes API

---

## Decisões de Design

### Por que NotFoundError em vez de 403 para notas de outros usuários?

Retornar 404 (não 403) quando um usuário tenta acessar nota de outro impede **enumeração de recursos**: o atacante não sabe se a nota existe mas não tem permissão, ou se simplesmente não existe.

```typescript
// notesService.ts — padrão correto
async findById(id: string, userId: string): Promise<Note> {
  const note = await this.notesRepository.findById(id);
  // retorna 404 em ambos os casos: nota inexistente ou de outro usuário
  if (!note || note.userId !== userId) {
    throw new NotFoundError('Nota não encontrada');
  }
  return note;
}
```

### Validação com Zod na camada de controller

```typescript
const createNoteSchema = z.object({
  title: z.string().min(1, 'Título obrigatório').max(200),
  content: z.string().min(1, 'Conteúdo obrigatório'),
  tags: z.array(z.string().trim().min(1)).optional().default([]),
});

// No controller:
const body = createNoteSchema.parse(req.body);
// ZodError é capturado pelo errorHandler e retorna 422
```

### JWT Middleware — o que verificar

```typescript
export function authMiddleware(req: Request, res: Response, next: NextFunction) {
  const auth = req.headers.authorization;
  if (!auth?.startsWith('Bearer ')) throw new UnauthorizedError('Token não fornecido');

  const token = auth.slice(7);
  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET!) as { userId: string };
    req.userId = payload.userId;
    next();
  } catch {
    throw new UnauthorizedError('Token inválido ou expirado');
  }
}
```

---

## Estrutura de Testes de Integração

```typescript
// tests/integration/notes.test.ts
describe('Notes API', () => {
  let userAToken: string;
  let userBToken: string;
  let noteId: string;

  beforeAll(async () => {
    // Cria dois usuários e obtém seus tokens
    userAToken = await createTestUser({ email: 'a@test.com' });
    userBToken = await createTestUser({ email: 'b@test.com' });
  });

  describe('POST /notes', () => {
    it('should create a note for authenticated user', async () => { ... });
    it('should return 401 without token', async () => { ... });
    it('should return 422 with empty title', async () => { ... });
  });

  describe('GET /notes/:id', () => {
    it('should return 404 when accessing other user note', async () => {
      // Cria nota como userA e tenta acessar como userB
      const res = await request(app)
        .get(`/notes/${noteId}`)
        .set('Authorization', `Bearer ${userBToken}`);
      expect(res.status).toBe(404); // não 403
    });
  });
});
```

---

## Cobertura Esperada

| Módulo | Mínimo |
|--------|:------:|
| `services/` | 80% |
| `repositories/` | 85% |
| `middlewares/authMiddleware.ts` | 90% |
| `controllers/` | 70% (coberto pelos de integração) |

---

## Pontos de Avaliação do Copilot Agent Mode

Ao final do projeto, reflita:

- O `copilot-instructions.md` foi lido e respeitado pelo agente? (padrão de erros, estrutura de pastas)
- O Agent Mode precisou de muita correção manual ou o contexto foi suficiente?
- Os agentes `@code-reviewer` e `@test-expert` foram mais precisos que o chat genérico?
- Onde o Agent Mode foi mais lento que escrever manualmente? Onde foi mais rápido?
