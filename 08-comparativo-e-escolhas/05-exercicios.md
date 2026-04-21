# 📝 Exercícios — Capítulo 08: Comparativo e Escolhas

> Exercícios para consolidar a capacidade de tomar decisões informadas sobre qual ferramenta, qual modelo e qual configuração usar em cada contexto.

---

## Exercício 01 — Mapeamento de Tarefas por Ferramenta

**Objetivo:** Desenvolver o reflexo de identificar qual ferramenta é mais adequada para cada tipo de tarefa.

**Tarefa:**

Para cada cenário abaixo, decida: **Copilot**, **Claude Code** ou **Ambos (híbrido)**. Justifique em uma frase.

| Cenário | Sua escolha | Justificativa |
|---------|------------|---------------|
| Implementar uma função enquanto escreve código no VS Code | | |
| Refatorar um módulo de 8 arquivos com padrão arquitetural novo | | |
| Gerar testes para um service de 200 linhas | | |
| Investigar um bug de produção reportado por um cliente | | |
| Criar um pipeline de CI/CD que usa IA para validar PRs | | |
| Responder a uma issue do GitHub "como funciona X no projeto?" | | |
| Migrar 40 arquivos de JavaScript para TypeScript | | |
| Revisar um PR de segurança crítica | | |

**Critério de sucesso:** Você consegue explicar o raciocínio por trás de cada escolha usando os critérios de IDE-first vs terminal-first, tarefa curta vs longa e autonomia necessária.

---

## Exercício 02 — Escolha de Modelo

**Objetivo:** Praticar a seleção do modelo correto com base na complexidade e tipo de tarefa.

**Tarefa:**

Para cada tarefa abaixo, selecione o modelo mais adequado e justifique:

```
Modelos disponíveis:
- Claude Haiku (rápido, econômico)
- Claude Sonnet (equilibrado — padrão)
- Claude Opus (capacidade máxima)
- GPT-4o (padrão Copilot)
- o3 / Claude Opus 4 (raciocínio avançado)
```

1. Gerar docstrings para 50 funções de um módulo utilitário
2. Decidir entre microserviços e monolito modular para um novo produto
3. Implementar um endpoint REST com validação e testes
4. Debugar um race condition em código assíncrono com múltiplos workers
5. Explicar o que uma função de 10 linhas faz
6. Projetar o schema de um banco de dados com 15 entidades e requisitos de auditoria

**Critério de sucesso:** Suas escolhas fazem sentido economicamente (não usar Opus onde Haiku é suficiente) e tecnicamente (não usar Haiku onde a tarefa exige raciocínio profundo).

---

## Exercício 03 — Configuração de Contexto Compartilhado

**Objetivo:** Criar uma configuração de contexto que serve tanto o Copilot quanto o Claude Code em um projeto real.

**Tarefa:**

Em um repositório seu (existente ou criado para o exercício):

1. Crie `docs/architecture.md` descrevendo brevemente:
   - Stack técnica
   - Estrutura de diretórios com responsabilidades
   - Padrões arquiteturais principais

2. Crie `.github/copilot-instructions.md` que **referencia** `docs/architecture.md` e adiciona:
   - Padrões de código específicos do Copilot
   - Padrões de teste
   - Comandos de CI

3. Crie `CLAUDE.md` que **referencia** `docs/architecture.md` e adiciona:
   - Instruções específicas para sessões longas do Claude Code
   - Quais MCP servers estão disponíveis (se houver)
   - O que o Claude pode executar sem pedir confirmação

4. Faça um commit com os três arquivos e peça para o Copilot Chat e para o Claude Code descreverem o projeto — compare as respostas.

**Critério de sucesso:** As duas ferramentas descrevem o projeto de forma consistente, sem contradições, e a fonte de verdade é `docs/architecture.md` — não cada arquivo de instrução individualmente.

---

## Exercício 04 — Fluxo Híbrido na Prática

**Objetivo:** Executar uma tarefa completa usando Copilot e Claude Code em etapas distintas, aproveitando o ponto forte de cada um.

**Tarefa:**

Implemente uma feature pequena (ex: endpoint de busca de usuário por email) usando o seguinte fluxo explicitamente dividido:

**Etapa 1 — Copilot Chat:** Use `@workspace` para encontrar onde a lógica de usuários está no projeto. Use `/explain` para entender os arquivos relevantes.

**Etapa 2 — Claude Code:** Peça ao Claude para planejar a implementação completa (arquivos a criar/modificar, ordem, critérios de aceite).

**Etapa 3 — Copilot (Edit Mode ou completions):** Implemente o controller e service usando completions inline e Edit Mode no VS Code.

**Etapa 4 — Claude Code:** Peça ao Claude para gerar os testes de integração do endpoint.

**Etapa 5 — Copilot `@code-reviewer`:** Revise o código gerado nas etapas anteriores.

**Critério de sucesso:** Você completou a feature usando cada ferramenta intencionalmente na etapa onde ela é mais forte — não alternando aleatoriamente entre elas.

---

## Exercício 05 — Desenho de Stack para um Cenário Real

**Objetivo:** Propor uma configuração completa de ferramentas para um cenário concreto.

**Tarefa:**

Escolha um dos cenários abaixo e documente a stack recomendada:

**Cenário A:** Startup de 5 devs construindo um SaaS B2B. Repositório no GitHub, stack TypeScript/Node.js/React, orçamento de US$ 200/mês em ferramentas de IA.

**Cenário B:** Agência de desenvolvimento com 20 devs atendendo múltiplos clientes em diferentes stacks. Cada projeto tem um repositório separado. Precisa de consistência entre projetos sem overhead de enterprise.

**Cenário C:** Banco regional com 200 devs. Dados sensíveis de clientes, SOC 2, auditoria de todas as interações com IA, múltiplos times com stacks diferentes.

Para o cenário escolhido, documente:
- Planos de Copilot e Claude Code selecionados e justificativa
- Quais arquivos de configuração criar e em qual nível (org, repositório, global)
- Quais agentes customizados criar e para quê
- Como o CI/CD servirá como gate de qualidade
- Quais controles de governança são necessários

**Critério de sucesso:** Sua proposta é coerente com as restrições do cenário (orçamento, conformidade, tamanho do time) e aborda todas as dimensões: ferramentas, configuração, governança.

---

## Exercício 06 — Análise Crítica de um PR Gerado por IA

**Objetivo:** Desenvolver o julgamento crítico necessário para revisar código gerado por agentes de IA.

**Tarefa:**

Gere um PR usando o Cloud Agent ou Agent Mode para uma tarefa real ou de prática. Depois, revise o PR respondendo as perguntas abaixo **antes** de aceitar qualquer mudança:

**Corretude:**
- A implementação atende todos os critérios de aceite da tarefa?
- Há casos de borda não tratados?

**Qualidade:**
- O código segue os padrões do projeto?
- Há código morto, imports não utilizados ou redundâncias?

**Segurança:**
- Há validação de input em todas as entradas externas?
- Algum dado sensível está sendo exposto (logs, responses)?

**Testes:**
- Os testes cobrem o happy path e os principais edge cases?
- Há testes que apenas testam que uma função foi chamada (frágeis)?

**Decisão:**
- Você aceitaria este PR em produção sem modificações? Se não, o que faria manualmente?

**Critério de sucesso:** Você identificou pelo menos um problema ou melhoria no PR e consegue explicar como o evitaria no futuro (ajustando as instruções ou a tarefa).

---

## Exercício 07 — Desafio Integrador: Avaliação de Ferramentas para seu Contexto

**Objetivo:** Aplicar todos os critérios do capítulo para definir sua própria stack de IA de desenvolvimento.

**Tarefa:**

Considere seu contexto atual (projeto pessoal, trabalho, time) e produza um documento `AI-STACK.md` com:

**1. Perfil do contexto:**
- Tamanho do time
- Tipo de projeto
- Stack técnica
- Requisitos de conformidade (se houver)
- Orçamento disponível

**2. Ferramentas selecionadas:**
- Copilot: qual plano e por quê
- Claude Code: qual plano e por quê
- Modelos padrão por tipo de tarefa

**3. Configuração de repositório:**
- Quais arquivos criar (copilot-instructions, CLAUDE.md, agentes)
- O que cada um vai conter

**4. Fluxo de trabalho definido:**
- Para cada tipo de tarefa recorrente, qual ferramenta usar e como
- Como as duas se integram no seu dia a dia

**5. Critérios de sucesso:**
- Como você vai saber que a configuração está funcionando?
- O que mediria para avaliar o impacto das ferramentas?

**Critério de sucesso:** O documento `AI-STACK.md` é específico o suficiente para ser seguido por outro dev no mesmo contexto — não é genérico ou apenas uma lista de ferramentas.

---

## ✅ Auto-Avaliação do Capítulo

- [ ] Consigo identificar instintivamente qual ferramenta usar para cada tipo de tarefa
- [ ] Entendo as diferenças práticas entre Haiku, Sonnet e Opus e quando usar cada um
- [ ] Sei configurar contexto compartilhado entre Copilot e Claude Code sem duplicação
- [ ] Já executei pelo menos um fluxo híbrido intencional (Copilot + Claude Code em etapas distintas)
- [ ] Entendo as diferenças de stack entre solo, time pequeno e enterprise
- [ ] Sei revisar criticamente um PR gerado por IA antes de mergear
- [ ] Tenho uma proposta concreta de stack de IA para o meu contexto atual

---

## 🔗 Próximo Capítulo

👉 [Capítulo 09 — Projetos Práticos](../09-projetos-praticos/projeto-01-cli-tool/README.md)
