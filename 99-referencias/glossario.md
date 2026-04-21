# 📖 Glossário — AI-Driven Development

> Definições dos termos técnicos usados ao longo do curso, em ordem alfabética.

---

## A

**Agent Mode**
Modo de operação do GitHub Copilot no VS Code onde o assistente executa tarefas autônomas de múltiplos passos, usando ferramentas como terminal, edição de arquivos e busca no workspace. Diferente do Edit Mode (edições pontuais) e Ask Mode (apenas conversa).

**Agentic Memory**
Mecanismo pelo qual o GitHub Copilot Cloud Agent acumula e reutiliza contexto sobre um repositório ao longo do tempo. O principal veículo de memória explícita é o arquivo `.github/copilot-instructions.md`.

**Agente de IA**
Sistema que percebe o ambiente, planeja ações e executa tarefas de forma autônoma usando ferramentas externas. Diferente de um chatbot simples, um agente opera em um loop: observar → planejar → agir → observar.

**AI-Driven Development**
Paradigma de desenvolvimento onde a IA é parceira ativa em todas as fases do ciclo de vida do software — não apenas para autocompletar código, mas para planejar, implementar, testar, revisar e documentar.

**Anthropic**
Empresa de pesquisa em segurança de IA, criadora da família de modelos Claude. Fundada em 2021.

---

## C

**Chain-of-Thought (CoT)**
Técnica de prompting que instrui o modelo a raciocinar passo a passo antes de dar a resposta final. Melhora significativamente a qualidade em problemas que exigem múltiplas etapas de raciocínio.

**Continue (extensão IDE)**
Extensão open source para VS Code e JetBrains que integra completions inline, chat e comandos de slash com qualquer backend compatível com a API OpenAI — incluindo Ollama e LM Studio. Alternativa ao GitHub Copilot para uso com modelos locais. Ver: `11-modelos-open-source/05-integrando-com-o-fluxo-de-desenvolvimento.md`.

**Claude**
Família de modelos de linguagem da Anthropic. Inclui Haiku (rápido e econômico), Sonnet (equilibrado) e Opus (máxima capacidade). Ver: `06-claude/`.

**Claude Code**
CLI da Anthropic que roda Claude diretamente no terminal, com acesso a ferramentas como edição de arquivos, execução de comandos e servidores MCP. Projetado para desenvolvimento de software. Ver: `06-claude/claude-code/`.

**CLAUDE.md**
Arquivo de instruções persistentes lido pelo Claude Code no início de cada sessão. Pode existir em múltiplos níveis: global (`~/.claude/`), repositório (raiz) e subdiretório. Equivalente ao `copilot-instructions.md` para o Claude Code.

**Cloud Agent (Copilot)**
Funcionalidade do GitHub Copilot que executa tarefas de desenvolvimento de forma assíncrona via GitHub Actions. Você atribui uma issue ao Copilot e recebe um Pull Request quando a tarefa termina.

**Completion**
Sugestão de código gerada pelo modelo em resposta ao contexto atual do editor (código acima e abaixo do cursor, nome do arquivo, imports). Exibida como "ghost text" — texto cinza que o desenvolvedor aceita com Tab ou descarta com Esc.

**Context Engineering**
Disciplina de estruturar e gerenciar o contexto fornecido a um modelo de linguagem para maximizar a qualidade das respostas. Vai além do prompting — engloba o que incluir, o que omitir, a ordem das informações e a gestão da janela de contexto. Ver: `03-context-engineering/`.

**copilot-instructions.md**
Arquivo `.github/copilot-instructions.md` que instrui o GitHub Copilot sobre padrões, stack e convenções do repositório. Lido automaticamente em sessões de Chat e Agent Mode.

---

## D

**DORA Metrics**
Framework de métricas de DevOps pesquisado pela Google: Deployment Frequency (frequência de deploy), Lead Time for Changes (tempo do commit ao deploy), Change Failure Rate (taxa de bugs em produção) e Time to Restore (tempo para recuperar de falha).

---

## E

**Edit Mode**
Modo do Copilot no VS Code onde o agente aplica edições em arquivos específicos que você indica, sem acesso ao terminal. Intermediário entre Ask Mode e Agent Mode.

**Extended Thinking**
Modo onde o modelo realiza um processo de raciocínio interno mais extenso antes de responder. Disponível em Claude Opus e modelos OpenAI o3/o4. Útil para problemas complexos com múltiplas restrições.

---

## F

**Few-Shot Prompting**
Técnica de fornecer exemplos de entrada/saída no prompt para calibrar o comportamento do modelo. Contraste com zero-shot (sem exemplos) e one-shot (um único exemplo).

**Function Calling / Tool Use**
Capacidade de um modelo de linguagem de invocar funções ou ferramentas externas durante a resposta. Base do funcionamento de agentes de IA. A Anthropic documenta como "tool use".

---

## G

**Ghost Text**
Texto de sugestão exibido em cinza pelo Copilot enquanto o desenvolvedor digita. Representa a completion sugerida — não confirmada até o desenvolvedor pressionar Tab.

**GitHub Copilot**
Assistente de IA para desenvolvimento da GitHub (Microsoft), integrado ao VS Code, JetBrains e outros IDEs. Oferece completions inline, chat, Agent Mode e Cloud Agent. Ver: `07-github-copilot/`.

---

## H

**Hallucination**
Fenômeno onde um modelo de linguagem gera informação factualmente incorreta com aparente confiança. Em código, pode se manifestar como APIs inexistentes, parâmetros errados ou lógica incorreta apresentada como correta.

**Haiku (Claude)**
Modelo mais rápido e econômico da família Claude. Ideal para tarefas de alto volume, completions simples e casos onde latência é crítica.

**Hook (Claude Code)**
Script ou comando configurado para executar em resposta a eventos específicos do Claude Code (PreToolUse, PostToolUse, Stop, etc.). Permite automatizar verificações, formatação e notificações. Ver: `06-claude/claude-code/05-hooks-automacao-de-ciclo.md`.

**Human-in-the-Loop**
Padrão de design de agentes onde etapas críticas ou irreversíveis requerem aprovação humana antes de prosseguir. Fundamental para operação segura de agentes autônomos.

---

## J

**Janela de Contexto**
Quantidade máxima de texto (medida em tokens) que um modelo pode processar em uma única chamada — incluindo o prompt e a resposta. Modelos mais recentes têm janelas de contexto de 100K a 1M+ tokens.

---

## L

**LGPD**
Lei Geral de Proteção de Dados (Lei 13.709/2018). Regulamentação brasileira de proteção de dados pessoais. Aplicável ao uso de IA quando dados de pessoas físicas são processados.

**LLM (Large Language Model)**
Modelo de linguagem de grande escala treinado em vastas quantidades de texto. Base tecnológica de ferramentas como Claude, GPT-4, Gemini e Copilot.

**LM Studio**
Aplicação desktop com interface gráfica para rodar modelos de linguagem localmente. Integra download de modelos do Hugging Face, chat interativo, playground de parâmetros e servidor local compatível com a API OpenAI na porta 1234. Alternativa ao Ollama para quem prefere interface gráfica. Ver: `11-modelos-open-source/04-lm-studio-e-interfaces-graficas.md`.

---

## M

**MCP (Model Context Protocol)**
Protocolo aberto criado pela Anthropic para conectar modelos de linguagem a ferramentas e fontes de dados externas de forma padronizada. Análogo a um "USB-C para IA". Ver: `05-mcp-model-context-protocol/`.

**MCP Server**
Processo que expõe ferramentas (tools), recursos (resources) e prompts via o protocolo MCP. Pode ser local (processo no computador) ou remoto (servidor HTTP).

**Modelo de Linguagem**
Ver LLM.

**Multi-Agent**
Arquitetura onde múltiplos agentes de IA colaboram, com um orquestrador delegando subtarefas para subagentes especializados. Permite paralelismo e isolamento de contexto.

---

## N

**NES (Next Edit Suggestions)**
Funcionalidade do GitHub Copilot que prevê onde o desenvolvedor vai editar em seguida após uma mudança, e sugere o que escrever nesse próximo ponto. Funciona em cadeia para propagação de mudanças relacionadas. Ver: `07-github-copilot/03-next-edit-suggestions.md`.

---

## O

**Ollama**
Ferramenta open source que simplifica o download, execução e gerenciamento de modelos de linguagem locais. Expõe uma API REST na porta 11434 compatível com o formato da OpenAI, permitindo que qualquer cliente ou SDK que fala com OpenAI funcione com modelos locais sem modificação. Ver: `11-modelos-open-source/03-executando-localmente-com-ollama.md`.

**Open Weights**
Categoria de modelos de linguagem onde os pesos do modelo treinado são disponibilizados publicamente, mas os dados de treino e o código de treinamento podem não ser. Distinto de "open source" no sentido clássico (que exige abertura completa). Exemplos: Llama 3.1, Qwen 2.5, Mistral. Ver: `11-modelos-open-source/01-o-que-sao-modelos-open-source.md`.

**Opus (Claude)**
Modelo de maior capacidade da família Claude. Ideal para raciocínio arquitetural profundo, decisões com múltiplos trade-offs e problemas que exigem análise detalhada. O mais lento e custoso da família.

**Orquestrador**
Em arquiteturas multi-agente, o agente principal responsável por decompor a tarefa, delegar para subagentes e integrar os resultados. Ver: `04-agentes-e-automacao/02-topologias-de-agentes.md`.

---

## P

**Prompt**
Texto enviado ao modelo de linguagem como instrução ou contexto. A qualidade do prompt impacta diretamente a qualidade da resposta. Ver: `01-prompt-engineering/`.

**Prompt Engineering**
A prática de estruturar e refinar prompts para obter respostas de melhor qualidade de modelos de linguagem. Ver: `01-prompt-engineering/`.

**Prompt Injection**
Ataque onde conteúdo malicioso em dados lidos pelo agente contém instruções que redirecionam seu comportamento. Principal vetor de ataque em agentes que processam conteúdo externo (issues, arquivos, páginas web).

---

## Q

**Quantização**
Técnica de reduzir a precisão numérica dos pesos de um modelo para diminuir o uso de memória e aumentar a velocidade de inferência, com tradeoff controlado de qualidade. Modelos quantizados em Q4_K_M (4 bits) usam aproximadamente metade da memória de um modelo em FP16, com perda mínima de qualidade. O formato GGUF (usado pelo Ollama) usa nomenclaturas como Q4_K_M, Q6_K, Q8_0 para indicar o nível de quantização. Ver: `11-modelos-open-source/02-principais-modelos-para-desenvolvedores.md`.

---

## R

**RAG (Retrieval-Augmented Generation)**
Técnica de enriquecer o prompt com informações recuperadas de uma base de conhecimento externa (documentação, código, banco de dados) antes de enviá-lo ao modelo. Permite que o modelo responda com dados atualizados sem retraining. Ver: `03-context-engineering/05-rag-para-devs.md`.

**ReAct**
Padrão de agente que intercala raciocínio (Reasoning) e ação (Acting): o agente pensa sobre o que fazer, executa uma ação, observa o resultado e repete. Base de muitos frameworks agenticos.

---

## S

**Sandboxing**
Técnica de isolar a execução de um agente para limitar o acesso a recursos do sistema. No Claude Code, worktrees Git fornecem isolamento de sistema de arquivos para agentes paralelos.

**Skill (Claude Code)**
Arquivo Markdown com instruções especializadas para uma tarefa específica, invocável como slash command (`/nome-da-skill`). Permite criar comandos customizados reutilizáveis. Ver: `06-claude/claude-code/04-skills-criando-e-usando.md`.

**Sonnet (Claude)**
Modelo equilibrado da família Claude — combina boa capacidade com velocidade e custo razoáveis. Recomendado para a maioria das tarefas de desenvolvimento do dia a dia.

**Subagente**
Agente especializado criado pelo orquestrador para executar uma subtarefa específica em contexto isolado. No Claude Code, cada subagente pode ter suas próprias ferramentas e permissões.

---

## T

**Testes de Caracterização**
Testes escritos para documentar o comportamento *atual* de código existente (incluindo comportamentos possivelmente incorretos) antes de uma refatoração. Garantem que a refatoração não muda o comportamento observável. Técnica de Michael Feathers ("Working Effectively with Legacy Code").

**Token**
Unidade de texto processada pelo modelo — aproximadamente 4 caracteres ou 0,75 palavras em inglês. Janelas de contexto e custos são medidos em tokens.

**Tool Use**
Ver Function Calling.

---

## V

**vLLM**
Servidor de inferência open source de alto desempenho para modelos de linguagem, projetado para ambientes de produção com múltiplos usuários simultâneos. Usa técnicas como PagedAttention para maximizar throughput. Expõe API compatível com OpenAI. Alternativa ao Ollama para organizações que precisam escalar modelos self-hosted. Ver: `11-modelos-open-source/06-privacidade-compliance-e-casos-enterprise.md`.

---

## W

**Worktree (Git)**
Cópia independente de um repositório Git que compartilha o mesmo histórico mas tem um diretório de trabalho separado. Usado para executar múltiplos agentes em paralelo sem conflito de arquivos. Criado com `git worktree add`.

---

## Z

**Zero-Shot Prompting**
Técnica de pedir ao modelo uma tarefa sem fornecer exemplos — apenas com a instrução. Funciona bem para tarefas simples e bem definidas; para tarefas complexas, few-shot tende a produzir resultados melhores.
