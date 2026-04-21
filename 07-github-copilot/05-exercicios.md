# 📝 Exercícios — Capítulo 07: GitHub Copilot

> Exercícios práticos para consolidar o uso do GitHub Copilot — desde completions básicas até Agent Mode, Cloud Agent e personalização avançada.

---

## Exercício 01 — Calibrando Completions com Comentários

**Objetivo:** Praticar o uso de comentários descritivos para guiar as sugestões inline do Copilot.

**Tarefa:**

Em um arquivo TypeScript ou Python novo, escreva apenas comentários descrevendo as funções abaixo — sem implementar nada — e deixe o Copilot gerar o código:

1. Uma função que valida um CNPJ brasileiro (formato com/sem pontuação)
2. Uma função que converte um valor em centavos para o formato `R$ 1.234,56`
3. Uma função que faz retry de uma promise assíncrona com backoff exponencial

Para cada uma:
- Escreva o comentário descritivo
- Adicione a assinatura com tipos
- Observe o ghost text e aceite ou refine

**Critério de sucesso:** As três funções estão implementadas e as implementações fazem sentido sem que você tenha escrito o corpo de nenhuma delas.

---

## Exercício 02 — Chat com Variáveis de Contexto

**Objetivo:** Usar variáveis de contexto (`#file`, `#selection`, `#codebase`) em sessões de chat para obter respostas mais precisas.

**Tarefa:**

Pegue qualquer arquivo de lógica de negócio do seu projeto (ou crie um com 30+ linhas):

1. Selecione uma função e use `/explain #selection` — leia a explicação
2. Use `@workspace Quais outras partes do projeto dependem desse módulo?`
3. Identifique um ponto de melhoria e peça: `/fix #selection — [descreva o problema]`
4. Use `/tests #file:NOME_DO_ARQUIVO.ts` e avalie os testes gerados

**Critério de sucesso:** Você completou os 4 comandos e consegue explicar por que `#selection` é mais preciso do que colar o código manualmente no chat.

---

## Exercício 03 — Agent Mode: Feature Completa

**Objetivo:** Usar o Agent Mode para implementar uma feature end-to-end sem intervenção manual no código.

**Tarefa:**

Em um projeto pessoal ou de prática (pode ser um repositório criado para o exercício), use o Agent Mode com esta instrução:

```
Crie um endpoint CRUD completo para uma entidade "Task" com os campos:
- id (uuid gerado automaticamente)
- title (string, obrigatório, máx 200 chars)
- status (enum: "pending" | "done")
- createdAt (timestamp automático)

Inclua:
- Controller, Service e Repository (ou equivalente para a sua stack)
- Validação de input
- Testes unitários para o Service
- Testes de integração para os endpoints
```

Monitore as ferramentas sendo invocadas no painel de chat. Ao final, revise o código gerado.

**Critério de sucesso:** O Agent completou a tarefa, os testes passam e você consegue identificar pelo menos uma melhoria que faria manualmente no código gerado.

---

## Exercício 04 — Cloud Agent: Issue para PR

**Objetivo:** Delegar uma tarefa ao Cloud Agent via issue e iteração via comentários no PR.

**Tarefa:**

Em um repositório no GitHub com GitHub Actions configurado:

1. Crie uma issue bem estruturada com:
   - Objetivo claro
   - Comportamento esperado
   - Pelo menos 3 critérios de aceite com checkbox
   - Referência ao(s) arquivo(s) envolvido(s)

2. Atribua a issue ao Copilot

3. Aguarde o PR ser criado

4. Revise o PR e:
   - Identifique pelo menos um ajuste necessário
   - Faça o ajuste via comentário com `@github-copilot [instrução específica]`
   - Aguarde o Copilot atualizar o PR

**Critério de sucesso:** O PR final reflete os critérios de aceite da issue e o ajuste solicitado foi aplicado via comentário, sem abrir o IDE.

---

## Exercício 05 — Personalização: Criar um Custom Agent

**Objetivo:** Criar um arquivo `.agent.md` para um agente especializado no contexto do seu projeto.

**Tarefa:**

1. Crie o diretório `.github/agents/` no seu repositório

2. Crie um arquivo `security-auditor.agent.md` com:
   - `name`: security-auditor
   - `description`: descrição do que o agente faz
   - `model`: claude-sonnet-3-7 (ou gpt-4o)
   - `tools`: codebase, problems
   - Instruções focadas em: SQL injection, XSS, exposição de dados, validação de input

3. Use o agente no chat:
   ```
   @security-auditor Audite #file:userController.ts
   ```

4. Compare a resposta com uma pergunta genérica:
   ```
   Analise a segurança de #file:userController.ts
   ```

**Critério de sucesso:** O agente especializado identifica problemas mais específicos e relevantes do que o chat genérico. O arquivo `.agent.md` está commitado no repositório.

---

## Exercício 06 — Copilot CLI no Dia a Dia

**Objetivo:** Incorporar `gh copilot explain` e `gh copilot suggest` no fluxo de trabalho do terminal.

**Tarefa:**

Com o Copilot CLI instalado e aliases configurados:

1. **Explain**: Encontre um comando no histórico do seu terminal (`history`) que você não tem certeza do que faz. Use `ghce "COMANDO"` para entendê-lo.

2. **Suggest — git**: Use `ghcs "revertir os commits dos últimos 2 dias em um branch de feature sem afetar o main"` — avalie a sugestão.

3. **Suggest — docker**: Use `ghcs "ver quanta memória e CPU cada container está usando em tempo real"` — execute com a opção interativa.

4. **Suggest — debug**: Copie uma mensagem de erro recente do seu terminal e use `ghce "MENSAGEM DE ERRO"` para diagnóstico.

**Critério de sucesso:** Você usou os dois comandos em pelo menos 4 situações reais e configurou os aliases no seu shell de forma persistente.

---

## Exercício 07 — Desafio Integrador: Setup Completo de Projeto

**Objetivo:** Configurar o GitHub Copilot de forma completa para um projeto real ou de prática, integrando todas as camadas de personalização.

**Tarefa:**

Em um repositório (existente ou criado para o exercício):

**Parte 1 — Instruções de repositório:**
- Crie `.github/copilot-instructions.md` documentando a stack, estrutura, padrões de código e de teste

**Parte 2 — Agentes customizados:**
- Crie `.github/agents/` com pelo menos 2 agentes: um revisor de código e um especialista em testes

**Parte 3 — CI como hooks:**
- Configure `.github/workflows/ci.yml` com lint, type-check, testes e build
- Configure branch protection exigindo que o CI passe antes do merge

**Parte 4 — Validação:**
- Use `@code-reviewer` para revisar um arquivo real do projeto
- Use `@test-expert` para gerar testes de um módulo sem cobertura
- Atribua uma issue ao Cloud Agent e valide que ele segue as instruções definidas

**Critério de sucesso:** O repositório está configurado com `copilot-instructions.md`, ao menos 2 agentes, CI ativo e branch protection. O Cloud Agent gera código que respeita os padrões definidos nas instruções sem que você precise corrigi-los manualmente na maioria dos casos.

---

## ✅ Auto-Avaliação do Capítulo

- [ ] Sei usar Tab, Esc, Ctrl+→ e Ctrl+Enter nas completions inline
- [ ] Entendo como comentários e nomes de função influenciam a qualidade das sugestões
- [ ] Usei Next Edit Suggestions (NES) em uma refatoração com mudanças em cadeia
- [ ] Sei usar #file, #selection, #codebase e @workspace no Copilot Chat
- [ ] Usei os slash commands /explain, /fix, /tests e /doc em situações reais
- [ ] Consigo distinguir quando usar Ask Mode, Edit Mode e Agent Mode
- [ ] Executei uma tarefa completa com o Agent Mode e revisei o output
- [ ] Entendo o fluxo completo do Cloud Agent: issue → PR → iteração via comentários
- [ ] Sei escrever uma issue de qualidade para o Cloud Agent produzir PRs úteis
- [ ] Criei e usei um arquivo .github/copilot-instructions.md
- [ ] Criei pelo menos um arquivo .agent.md e o usei via @nome no chat
- [ ] Instalei o Copilot CLI e usei ghce e ghcs em situações reais do terminal

---

## 🔗 Próximo Capítulo

👉 [Capítulo 08 — Comparativo e Escolhas](../08-comparativo-e-escolhas/01-claude-vs-copilot-quando-usar-cada.md)
