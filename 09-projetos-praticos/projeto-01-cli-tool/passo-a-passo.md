# Passo a Passo — CLI Tool com Claude Code

> Guia de execução do projeto. Cada passo tem a instrução exata para o Claude Code e o resultado esperado.

---

## Passo 1 — Configurar o CLAUDE.md antes de qualquer código

Antes de iniciar o Claude Code, crie o arquivo de contexto. Isso é o mais importante do projeto.

Crie `CLAUDE.md` na raiz do projeto com:

```markdown
# taskr — CLI de gerenciamento de tarefas

## Stack
- Node.js 20 LTS
- TypeScript 5 com strict: true
- Commander.js para parsing de CLI
- Jest 29 para testes

## Estrutura
src/
├── commands/   # Um arquivo por comando: add.ts, list.ts, done.ts, delete.ts, show.ts
├── storage/    # storage.ts: leitura e escrita do JSON em ~/.taskr/tasks.json
└── utils/      # formatter.ts (tabela), validator.ts (validações de input)

## Padrões
- Nunca use `any` no TypeScript
- Erros de usuário (ID inválido, título vazio): process.exit(1) com mensagem clara
- Erros de sistema (I/O): relançar com contexto
- Testes: describe/it com Arrange-Act-Assert

## Verificações de CI
npm run lint && npm run type-check && npm test -- --coverage && npm run build
```

---

## Passo 2 — Inicializar o projeto com Claude Code

Abra o terminal na pasta do projeto e inicie uma sessão:

```bash
claude
```

**Instrução para o Claude:**
```
Estou construindo a CLI `taskr` de gerenciamento de tarefas. Leia o CLAUDE.md.

Inicialize o projeto Node.js/TypeScript:
1. package.json com scripts: build, test, lint, type-check
2. tsconfig.json com strict: true
3. jest.config.ts
4. .eslintrc.json com regras básicas TypeScript
5. Instale as dependências: typescript, @types/node, commander, jest, ts-jest, @types/jest, eslint

Não crie nenhum arquivo src/ ainda — só o setup do projeto.
```

**Resultado esperado:** Projeto inicializado, `npm run build` sem erros (mesmo sem src/).

---

## Passo 3 — Criar o módulo de storage

**Instrução para o Claude:**
```
Crie src/storage/storage.ts com as funções:
- loadTasks(): Task[] — lê ~/.taskr/tasks.json, cria o arquivo se não existir
- saveTasks(tasks: Task[]): void — persiste no arquivo
- nextId(tasks: Task[]): number — retorna max(id) + 1

Crie a interface Task em src/types.ts conforme o modelo de dados no enunciado.

Crie os testes em tests/unit/storage.test.ts. Use tmp dir para não sujar o home do usuário.
Cobertura mínima: 90%.
```

**O que revisar:** Verifique se o erro de arquivo corrompido é tratado (JSON inválido).

---

## Passo 4 — Implementar os comandos um por um

Implemente cada comando em uma instrução separada para manter o contexto focado.

### 4a — Comando `add`

```
Crie src/commands/add.ts:
- Valida que o título não está vazio e tem no máximo 200 chars
- Priority padrão é 'medium', aceita --priority low|medium|high
- Usa storage para persistir
- Exibe confirmação: "✅ Tarefa #ID criada: TÍTULO"

Crie tests/unit/commands/add.test.ts com mock do storage.
```

### 4b — Comando `list`

```
Crie src/commands/list.ts:
- Sem filtros: exibe todas as tarefas
- --status pending|done: filtra por status
- --priority low|medium|high: filtra por prioridade
- Usa src/utils/formatter.ts para renderizar a tabela com emojis de prioridade
- Se não há tarefas: exibe "Nenhuma tarefa encontrada."

Crie o formatter em src/utils/formatter.ts e os testes correspondentes.
```

### 4c — Comandos `done`, `delete`, `show`

```
Crie src/commands/done.ts, delete.ts e show.ts:
- Todos recebem um ID numérico como argumento
- Se o ID não existir: exibe "Erro: tarefa #ID não encontrada." e process.exit(1)
- done: atualiza status para 'done' e preenche doneAt com new Date().toISOString()
- delete: remove do array e confirma "🗑️ Tarefa #ID deletada."
- show: exibe todos os campos formatados

Crie testes para os três comandos.
```

---

## Passo 5 — Conectar tudo no entry point

```
Crie src/index.ts usando Commander.js:
- Registre todos os comandos (add, list, done, delete, show)
- Versão lida do package.json
- Descrição: "taskr — gerenciador de tarefas no terminal"

Adicione o campo "bin" no package.json para permitir `taskr` como comando global.
```

---

## Passo 6 — Verificar cobertura e corrigir gaps

```
Rode os testes com cobertura:
npm test -- --coverage

Analise o relatório e adicione testes para qualquer módulo abaixo de 80%.
Foque especialmente em: erros de input inválido e edge cases do storage.
```

**Instrução para o Claude se houver gaps:**
```
A cobertura do módulo storage/storage.ts está em 65%. Os casos não cobertos são:
- loadTasks quando o arquivo JSON está corrompido
- saveTasks quando não há permissão de escrita no diretório

Adicione testes para esses casos e corrija a implementação se necessário.
```

---

## Passo 7 — README e documentação

```
Gere o README.md do projeto com:
- Descrição em português
- Pré-requisitos (Node.js 20+)
- Instalação (npm install -g / npm link)
- Exemplos de uso para cada comando
- Seção de desenvolvimento (como rodar testes, build)
```

---

## Passo 8 — Validação final

Execute manualmente e valide todos os critérios de aceite do enunciado:

```bash
# Build limpo
npm run build

# Teste todos os comandos manualmente
node dist/index.js add "Revisar PR do João"
node dist/index.js add "Preparar apresentação" --priority high
node dist/index.js list
node dist/index.js list --status pending
node dist/index.js done 1
node dist/index.js list
node dist/index.js show 2
node dist/index.js delete 2
node dist/index.js list

# Testes automatizados com cobertura
npm test -- --coverage
```

---

## Reflexões após o projeto

Anote as respostas para consolidar o aprendizado:

1. O `CLAUDE.md` que você escreveu antes de começar foi suficiente? O que adicionaria agora?
2. Em quais passos o Claude precisou de mais iterações do que você esperava?
3. Onde você interveio manualmente no código gerado e por quê?
4. O que faria diferente em um próximo projeto?
