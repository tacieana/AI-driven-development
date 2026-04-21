# Enunciado — CLI Tool: `taskr`

## Contexto

Você foi contratado para construir uma CLI simples de gerenciamento de tarefas pessoais chamada `taskr`. As tarefas devem ser persistidas em um arquivo JSON local (`~/.taskr/tasks.json`).

O objetivo deste projeto é praticar o fluxo completo de desenvolvimento com Claude Code — do planejamento à entrega.

---

## Requisitos Funcionais

### Comandos obrigatórios

```bash
# Adicionar uma tarefa
taskr add "Revisar PR do João"
taskr add "Preparar apresentação" --priority high

# Listar tarefas
taskr list
taskr list --status pending
taskr list --priority high

# Marcar como concluída
taskr done 3

# Deletar uma tarefa
taskr delete 3

# Detalhes de uma tarefa
taskr show 3
```

### Modelo de dados

```typescript
interface Task {
  id: number;           // sequencial, começa em 1
  title: string;        // obrigatório, máx 200 chars
  status: 'pending' | 'done';
  priority: 'low' | 'medium' | 'high';  // padrão: 'medium'
  createdAt: string;    // ISO 8601
  doneAt?: string;      // ISO 8601, preenchido ao marcar done
}
```

### Saída esperada do `taskr list`

```
ID  Prioridade  Status   Título
──────────────────────────────────────────────────
1   🔴 high     pending  Revisar PR do João
2   🟡 medium   pending  Preparar apresentação
3   🟢 low      ✓ done   Estudar TypeScript
```

---

## Requisitos Não-Funcionais

- **Linguagem:** TypeScript (Node.js 20+)
- **Testes:** Jest com cobertura ≥ 80% nos módulos de `storage` e `commands`
- **Sem dependências de banco de dados** — apenas arquivo JSON local
- **Tratamento de erros:** IDs inexistentes, arquivo corrompido, título vazio
- **Código documentado:** JSDoc nas funções públicas

---

## Critérios de Aceite

- [ ] `taskr add "título"` cria uma tarefa com status `pending` e priority `medium`
- [ ] `taskr add "título" --priority high` respeita a prioridade informada
- [ ] `taskr list` exibe todas as tarefas em formato de tabela
- [ ] `taskr list --status pending` filtra corretamente
- [ ] `taskr done ID` muda o status para `done` e preenche `doneAt`
- [ ] `taskr done ID` com ID inexistente exibe mensagem de erro clara
- [ ] `taskr delete ID` remove a tarefa do arquivo
- [ ] `taskr show ID` exibe todos os campos da tarefa
- [ ] Cobertura de testes ≥ 80% em `storage/` e `commands/`
- [ ] `npm run build` sem erros TypeScript
- [ ] `README.md` com exemplos de uso

---

## O que NÃO é necessário

- Sincronização em nuvem
- Interface gráfica
- Múltiplos usuários
- Categorias ou tags

---

## Entregável

Repositório Git com:
1. Código-fonte em `src/`
2. Testes em `tests/`
3. `CLAUDE.md` com o contexto que você configurou para o Claude Code
4. `README.md` com instruções de instalação e uso
