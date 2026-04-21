# Solução de Referência — taskr CLI

> Esta solução descreve a abordagem esperada. Não existe uma única resposta correta — compare com a sua implementação e analise as diferenças.

---

## Estrutura de Arquivos

```
taskr/
├── src/
│   ├── types.ts                    # Interface Task e tipos de enums
│   ├── commands/
│   │   ├── add.ts
│   │   ├── list.ts
│   │   ├── done.ts
│   │   ├── delete.ts
│   │   └── show.ts
│   ├── storage/
│   │   └── storage.ts
│   ├── utils/
│   │   ├── formatter.ts
│   │   └── validator.ts
│   └── index.ts                    # Entry point + Commander setup
├── tests/
│   ├── unit/
│   │   ├── storage.test.ts
│   │   ├── commands/
│   │   │   ├── add.test.ts
│   │   │   ├── list.test.ts
│   │   │   ├── done.test.ts
│   │   │   ├── delete.test.ts
│   │   │   └── show.test.ts
│   │   └── utils/
│   │       └── formatter.test.ts
│   └── integration/
│       └── cli.test.ts             # Testa a CLI via execução de processo
├── CLAUDE.md
├── package.json
├── tsconfig.json
└── README.md
```

---

## Pontos de Design Importantes

### types.ts

```typescript
export type Priority = 'low' | 'medium' | 'high';
export type Status = 'pending' | 'done';

export interface Task {
  id: number;
  title: string;
  status: Status;
  priority: Priority;
  createdAt: string;
  doneAt?: string;
}
```

### storage.ts — Tratamento de Erros

```typescript
export function loadTasks(): Task[] {
  try {
    if (!existsSync(TASKS_FILE)) {
      ensureDirExists();
      return [];
    }
    const raw = readFileSync(TASKS_FILE, 'utf-8');
    return JSON.parse(raw) as Task[];
  } catch (error) {
    if (error instanceof SyntaxError) {
      console.error('Erro: arquivo de tarefas corrompido. Recriando...');
      return [];
    }
    throw new Error(`Falha ao carregar tarefas: ${(error as Error).message}`);
  }
}
```

### formatter.ts — Renderização de Tabela

```typescript
const PRIORITY_EMOJI: Record<Priority, string> = {
  high: '🔴',
  medium: '🟡',
  low: '🟢',
};

export function formatTaskTable(tasks: Task[]): string {
  if (tasks.length === 0) return 'Nenhuma tarefa encontrada.';

  const header = 'ID   Prioridade    Status     Título';
  const divider = '─'.repeat(60);
  const rows = tasks.map((t) => {
    const status = t.status === 'done' ? '✓ done  ' : 'pending ';
    const priority = `${PRIORITY_EMOJI[t.priority]} ${t.priority.padEnd(6)}`;
    return `${String(t.id).padEnd(4)} ${priority}  ${status}  ${t.title}`;
  });

  return [header, divider, ...rows].join('\n');
}
```

---

## Cobertura Esperada

| Módulo | Cobertura mínima |
|--------|:----------------:|
| `storage/storage.ts` | 90% |
| `commands/*.ts` | 85% |
| `utils/formatter.ts` | 95% |
| `utils/validator.ts` | 95% |
| **Total** | **≥ 80%** |

---

## CLAUDE.md Final (exemplo bem-sucedido)

```markdown
# taskr — CLI de gerenciamento de tarefas

## Stack
- Node.js 20 LTS, TypeScript 5 (strict), Commander.js, Jest 29

## Estrutura
src/commands/  → um arquivo por comando
src/storage/   → storage.ts (lê/escreve ~/.taskr/tasks.json)
src/utils/     → formatter.ts, validator.ts

## Padrões
- Nunca use `any`
- Erros de usuário: console.error + process.exit(1)
- Testes: describe/it, Arrange-Act-Assert, mock do fs nos testes de storage

## CI
npm run lint && npm run type-check && npm test -- --coverage && npm run build
```

---

## Sinais de que o projeto foi bem executado

- ✅ O `CLAUDE.md` foi escrito **antes** de iniciar a implementação
- ✅ Cada passo do Claude tinha escopo claro e focado (um módulo por vez)
- ✅ Os testes foram pedidos junto com cada módulo, não ao final
- ✅ Você revisou e entendeu o código gerado — não apenas aceitou tudo
- ✅ O agente precisou de poucas correções porque o contexto estava bem definido
