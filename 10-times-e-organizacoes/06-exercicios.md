# 📝 Exercícios — Capítulo 10: Times e Organizações

> Exercícios para consolidar as práticas de adoção, governança, padronização e segurança no uso de IA em times de desenvolvimento.

---

## Exercício 01 — Diagnóstico de Adoção

**Objetivo:** Avaliar o estágio atual de adoção de IA no seu time e identificar os principais bloqueadores.

**Tarefa:**

Aplique o seguinte diagnóstico (você mesmo se trabalhar solo, ou com seu time):

**Maturidade técnica:**
- [ ] Temos `copilot-instructions.md` e/ou `CLAUDE.md` versionados no repositório?
- [ ] Usamos agentes customizados (`.agent.md`) para tarefas recorrentes?
- [ ] O CI serve como gate de qualidade para PRs gerados por IA?
- [ ] Temos um repositório ou template centralizado de configurações de IA?

**Maturidade cultural:**
- [ ] Todos os devs do time usam ferramentas de IA regularmente?
- [ ] Existe um processo de revisão para mudanças nas instruções?
- [ ] A configuração de IA faz parte do onboarding de novos devs?
- [ ] Há um canal ou fórum para compartilhar aprendizados sobre IA?

**Segurança:**
- [ ] Existe política documentada sobre o que não enviar para modelos?
- [ ] Credenciais e dados de clientes estão explicitamente proibidos nos prompts?
- [ ] Há revisão humana obrigatória em PRs de agentes?

Com base no diagnóstico, escreva 3 ações prioritárias para evoluir para o próximo estágio.

**Critério de sucesso:** Você tem uma lista priorizada e realista de próximos passos — não uma lista de desejos.

---

## Exercício 02 — Criar o Processo de PR para Configurações de IA

**Objetivo:** Institucionalizar a revisão de mudanças nas instruções de IA.

**Tarefa:**

1. Crie `.github/PULL_REQUEST_TEMPLATE/ai_config_change.md` no seu repositório com o template de PR para mudanças de configuração de IA (baseado no modelo da aula 02)

2. Crie `.github/CODEOWNERS` e adicione uma regra para que mudanças em arquivos de configuração de IA exijam revisão de pelo menos um dev sênior:
   ```
   .github/copilot-instructions.md @seu-usuario
   .github/agents/ @seu-usuario
   CLAUDE.md @seu-usuario
   ```

3. Configure uma branch protection rule no repositório que exija revisão quando `copilot-instructions.md` for modificado

4. Faça uma mudança de teste nas instruções (ex: adicione um padrão de código) e siga o processo completo de PR

**Critério de sucesso:** Uma mudança nas instruções de IA requer PR, passa pelo template e precisa de aprovação antes de mergear.

---

## Exercício 03 — Estrutura de Instruções em Camadas

**Objetivo:** Criar uma hierarquia de instruções que funcione para múltiplos repositórios.

**Tarefa:**

Suponha que você tem (ou simule) dois repositórios: `backend-api` e `frontend-app`.

1. Crie um arquivo `copilot-instructions-shared.md` com os padrões que se aplicam a ambos:
   - Política de dados sensíveis
   - Padrões de testes
   - Padrões de commit message

2. Para `backend-api`, crie `.github/copilot-instructions.md` que inclui o conteúdo compartilhado e adiciona:
   - Stack específica (Node.js, ORM, etc.)
   - Padrões de API (REST ou GraphQL)
   - Padrões de erro do backend

3. Para `frontend-app`, crie `.github/copilot-instructions.md` que inclui o conteúdo compartilhado e adiciona:
   - Framework (React/Vue/Angular)
   - Padrões de componente
   - Padrões de estado

4. Teste: use o Copilot Chat em cada repositório e peça que descreva os padrões do projeto. As respostas devem ser consistentes na parte compartilhada e específicas na parte do repositório.

**Critério de sucesso:** Os dois repositórios têm instruções consistentes na base e específicas na extensão. Atualizar o arquivo compartilhado é refletido em ambos sem duplicação.

---

## Exercício 04 — Medição de Baseline

**Objetivo:** Coletar as métricas de baseline antes ou durante a adoção de ferramentas de IA.

**Tarefa:**

Em um repositório com histórico de PRs (pelo menos 2 meses):

1. Use GitHub CLI para extrair o tempo médio de merge dos últimos 60 dias:
   ```bash
   gh pr list --state merged --limit 100 \
     --json createdAt,mergedAt,title \
     | jq 'map({ title, hours: (((.mergedAt | fromdateiso8601) - (.createdAt | fromdateiso8601)) / 3600) }) | sort_by(.hours)'
   ```

2. Classifique os PRs por tipo (feature, bugfix, test, docs, chore) e calcule o tempo médio por tipo

3. Crie `docs/ai-metrics-baseline.md` com:
   - Data da medição
   - Tempo médio de PR por tipo
   - Cobertura de testes atual (se disponível)
   - Frequência de deploy (se disponível)

4. Defina os critérios de sucesso: qual melhoria você esperaria ver após 3 meses de uso intenso de IA?

**Critério de sucesso:** Você tem um baseline documentado que pode ser comparado com uma medição futura.

---

## Exercício 05 — Auditoria de Segurança das Configurações Atuais

**Objetivo:** Identificar riscos de segurança nas configurações de IA existentes.

**Tarefa:**

Revise as configurações de IA do seu projeto (ou crie um cenário hipotético) e verifique:

**Configurações de MCP:**
- [ ] Todos os servidores MCP têm acesso restrito ao mínimo necessário?
- [ ] As credenciais dos servidores MCP estão em variáveis de ambiente (não hardcoded)?
- [ ] O servidor de filesystem (se configurado) acessa apenas a pasta do projeto?

**Instruções de IA:**
- [ ] Há instrução explícita sobre não incluir dados de clientes?
- [ ] Há instrução explícita sobre não logar dados sensíveis?
- [ ] As instruções cobrem validação de input e prevenção de SQL injection?

**Processo de revisão:**
- [ ] PRs do Cloud Agent têm revisão humana obrigatória?
- [ ] Existe allow list de comandos que o agente pode executar sem aprovação?
- [ ] A allow list não inclui comandos destrutivos (rm -rf, git reset --hard, etc.)?

Para cada item marcado como ausente, crie uma tarefa concreta de correção com prazo.

**Critério de sucesso:** Você tem uma lista de gaps de segurança com plano de ação.

---

## Exercício 06 — Desafio Integrador: Plano de Adoção para o seu Contexto

**Objetivo:** Criar um plano de adoção completo e realista para o seu contexto atual.

**Tarefa:**

Produza um documento `docs/ai-adoption-plan.md` com:

**Seção 1 — Diagnóstico atual**
- Estágio atual de adoção (Fase 1/2/3/4)
- Principais bloqueadores identificados

**Seção 2 — Objetivos dos próximos 90 dias**
- Métricas-alvo específicas (ex: "80% dos devs usando completions diariamente")
- Entregas concretas (ex: "CLAUDE.md em todos os repositórios principais")

**Seção 3 — Plano de execução (semana a semana)**
- Semanas 1-2: O que fazer primeiro
- Semanas 3-4: O que vem depois
- Semanas 5-8: Expansão
- Semanas 9-12: Consolidação e medição

**Seção 4 — Riscos e mitigações**
- Quais resistências você antecipa?
- Como vai medir o progresso?
- O que vai pausar o rollout se der errado?

**Seção 5 — Política de uso (draft)**
- O que é permitido sem aprovação
- O que requer aprovação
- O que é proibido

**Critério de sucesso:** O plano é específico o suficiente para um novo dev entender o que está acontecendo e por quê. Não é genérico ou uma lista de ideias — é um compromisso com datas e entregas.

---

## ✅ Auto-Avaliação do Capítulo

- [ ] Entendo as 4 fases de adoção e em qual fase meu contexto atual está
- [ ] Consigo identificar e responder às resistências mais comuns com argumentos concretos
- [ ] Tenho ou sei criar um processo de PR para mudanças de configuração de IA
- [ ] Entendo como estruturar instruções em camadas (org → time → repositório)
- [ ] Sei quais métricas realmente capturam o impacto da IA (e quais são enganosas)
- [ ] Tenho um baseline documentado para medir progresso futuro
- [ ] Entendo os principais riscos de segurança e como mitigar cada um
- [ ] Sei o que a LGPD implica para o uso de IA com dados de clientes brasileiros

---

## 🔗 Próximo Capítulo

👉 [99 — Referências](../99-referencias/glossario.md)
