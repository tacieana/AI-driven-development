# 📝 Exercícios — Capítulo 11: Modelos Open Source e Self-Hosted

> Exercícios para consolidar a instalação, configuração e uso de modelos locais no fluxo de desenvolvimento.

---

## Exercício 01 — Instalar o Ollama e Rodar o Primeiro Modelo

**Objetivo:** Ter o ambiente de modelos locais funcionando e fazer uma comparação direta com Claude.

**Tarefa:**

1. Instale o Ollama seguindo o método para o seu sistema operacional (ollama.com/download)

2. Baixe e execute o Qwen 2.5 Coder 7B:
   ```bash
   ollama pull qwen2.5-coder:7b
   ollama run qwen2.5-coder:7b
   ```

3. Envie este prompt para o modelo local:
   ```
   Escreva uma função TypeScript que recebe um array de números e retorna
   um novo array sem duplicatas, preservando a ordem de primeira ocorrência.
   Inclua um exemplo de uso e explique a complexidade de tempo.
   ```

4. Envie o mesmo prompt para o Claude Sonnet (claude.ai ou API)

5. Documente as diferenças observadas em qualidade, completude e velocidade de resposta

**Critério de sucesso:** Você tem o Ollama rodando, um modelo local respondendo e uma comparação documentada entre modelo local e Claude Sonnet para a mesma tarefa.

---

## Exercício 02 — Comparar Modelos na Mesma Tarefa

**Objetivo:** Desenvolver intuição sobre qual modelo escolher para qual tipo de tarefa.

**Tarefa:**

1. Instale dois ou três modelos adicionais:
   ```bash
   ollama pull llama3.1:8b
   ollama pull phi4:14b
   # ou outro modelo que caiba no seu hardware
   ```

2. Para cada modelo, envie a mesma tarefa de código moderadamente complexa (escolha uma que seja desafiadora mas não impossível):
   ```
   Implemente uma função que recebe uma string com uma expressão matemática
   simples (ex: "3 + 4 * 2 - 1") e calcula o resultado respeitando
   precedência de operadores, sem usar eval(). Use TypeScript.
   ```

3. Para cada modelo, registre:
   - Qualidade da solução (correta, parcialmente correta, incorreta)
   - Tempo de geração (cronometre)
   - VRAM usada (`ollama ps` durante a execução)
   - Qualidade da explicação

4. Crie uma tabela de comparação com os resultados

**Critério de sucesso:** Você tem dados comparativos de pelo menos dois modelos e consegue articular por que escolheria cada um para tarefas diferentes.

---

## Exercício 03 — Configurar Continue + Ollama no VS Code

**Objetivo:** Ter completions inline e chat com modelo local funcionando diretamente no editor.

**Tarefa:**

1. Instale a extensão **Continue** no VS Code (busque "Continue" no marketplace)

2. Edite o arquivo `~/.continue/config.json` para apontar para o Ollama:
   ```json
   {
     "models": [
       {
         "title": "Qwen 2.5 Coder 7B",
         "provider": "ollama",
         "model": "qwen2.5-coder:7b",
         "apiBase": "http://localhost:11434"
       }
     ],
     "tabAutocompleteModel": {
       "title": "Qwen 2.5 Coder 7B",
       "provider": "ollama",
       "model": "qwen2.5-coder:7b",
       "apiBase": "http://localhost:11434"
     }
   }
   ```

3. Abra um arquivo de código existente no seu editor e teste:
   - Completions inline: comece a digitar uma função e aguarde a sugestão
   - Chat: selecione um trecho de código e pressione `Cmd/Ctrl + L`
   - Peça uma explicação do código selecionado

4. Compare a experiência com o GitHub Copilot (se você o tiver)

**Critério de sucesso:** Você tem completions inline funcionando com modelo local e conseguiu fazer uma pergunta sobre código via chat no Continue.

---

## Exercício 04 — Criar um Modelfile Customizado

**Objetivo:** Criar uma versão do modelo com system prompt específico para um projeto real, similar ao que o CLAUDE.md faz para o Claude Code.

**Tarefa:**

1. Escolha um projeto real (ou use o projeto de exercícios do curso)

2. Crie um arquivo `Modelfile` na raiz do projeto:
   ```dockerfile
   FROM qwen2.5-coder:7b

   SYSTEM """
   Você é um assistente de desenvolvimento para este projeto.

   [Preencha com as informações do seu projeto:]
   Stack: [sua stack]
   Padrões de código: [suas convenções]
   Padrões de teste: [seu framework de testes]
   Regras importantes: [restrições específicas do projeto]
   """

   PARAMETER temperature 0.1
   PARAMETER num_ctx 8192
   ```

3. Crie o modelo customizado:
   ```bash
   ollama create meu-projeto -f ./Modelfile
   ```

4. Teste a diferença: faça a mesma pergunta para `qwen2.5-coder:7b` e para `meu-projeto`:
   ```
   Como devo estruturar um novo serviço neste projeto?
   ```

5. Documente a diferença na qualidade e especificidade das respostas

**Critério de sucesso:** Você tem um modelo customizado que responde de acordo com o contexto do projeto, sem precisar repetir as convenções a cada conversa.

---

## Exercício 05 — Integrar Modelo Local com MCP

**Objetivo:** Usar um servidor MCP com modelo local via Continue, aplicando o que foi aprendido no capítulo 05.

**Tarefa:**

1. Certifique-se de ter Node.js instalado

2. Adicione a configuração de MCP no `~/.continue/config.json`:
   ```json
   {
     "models": [...],
     "mcpServers": [
       {
         "name": "filesystem",
         "command": "npx",
         "args": [
           "-y",
           "@modelcontextprotocol/server-filesystem",
           "/caminho/para/seu/projeto"
         ]
       }
     ]
   }
   ```

3. Reinicie o Continue (Cmd/Ctrl+Shift+P → "Continue: Reload Config")

4. No chat do Continue, teste ferramentas do servidor MCP:
   ```
   Liste os arquivos TypeScript na pasta src/ e me diga qual deles
   tem mais linhas de código
   ```

5. Observe o modelo usando a ferramenta para ler o sistema de arquivos

**Critério de sucesso:** O modelo local consegue usar a ferramenta do servidor MCP para ler arquivos do projeto e responder sobre eles — sem você precisar copiar o conteúdo manualmente.

---

## Exercício 06 — Análise de Privacidade de um Projeto Real

**Objetivo:** Desenvolver o hábito de classificar dados antes de enviá-los a modelos de IA.

**Tarefa:**

Para um projeto real (de trabalho ou pessoal), faça uma auditoria de privacidade:

**Mapeie os tipos de dado presentes:**
- [ ] Nomes, e-mails, CPFs de usuários (dados pessoais simples)
- [ ] Dados financeiros ou bancários
- [ ] Dados de saúde
- [ ] Chaves de API, senhas, tokens
- [ ] Código de lógica de negócio proprietária
- [ ] Dados de menores de 18 anos

**Para cada tipo identificado, decida:**

| Tipo de dado | Pode ir para API cloud? | Por quê? | Alternativa se não |
|-------------|------------------------|----------|-------------------|
| [tipo 1] | Sim / Não | [razão] | [modelo local / omitir] |
| [tipo 2] | ... | ... | ... |

**Crie uma política de 3 linhas para o projeto:**

```
POLÍTICA DE IA PARA [NOME DO PROJETO]:
- Pode ir para Claude/Copilot: [lista]
- Deve usar modelo local: [lista]  
- Nunca incluir em prompts: [lista]
```

**Critério de sucesso:** Você tem uma política documentada e específica para o projeto — não uma lista genérica de boas práticas.

---

## Exercício 07 — Desafio Integrador: Stack Híbrida Documentada

**Objetivo:** Criar um documento de decisão de stack de IA que combine modelos locais e cloud de forma racional e justificada.

**Tarefa:**

Crie o arquivo `AI-STACK.md` na raiz de um projeto real com a seguinte estrutura:

```markdown
# Stack de IA — [Nome do Projeto]

## Ferramentas Ativas

| Ferramenta | Uso | Justificativa |
|-----------|-----|--------------|
| [ex: Qwen 2.5 Coder 7B via Ollama] | [ex: completions inline, chat sobre código] | [ex: código proprietário não sai da máquina] |
| [ex: Claude Sonnet via API] | [ex: arquitetura, debugging complexo] | [ex: qualidade superior para decisões difíceis] |
| [ex: GitHub Copilot] | [ex: pair programming no VS Code] | [ex: integração nativa, plano Business já contratado] |

## Política de Dados

**Pode usar API cloud (Claude/Copilot):**
- [lista específica]

**Deve usar modelo local:**
- [lista específica]

**Nunca incluir em prompts:**
- [lista específica]

## Configuração Local

**Modelo principal:** [modelo + quantização]
**Hardware:** [seu hardware]
**Velocidade:** [tokens/segundo aproximado]
**Extensão IDE:** [Continue / Twinny / outra]

## Quando Escalar para Self-Hosted em Servidor

[Defina critérios: volume de tokens/dia, número de usuários, requisito de compliance]

## Revisão

Data de criação: [data]
Próxima revisão: [data + 3 meses]
```

Após criar o documento:

1. Configure as ferramentas listadas conforme a decisão
2. Use o ambiente por pelo menos uma sessão de trabalho real
3. Anote o que funcionou e o que você mudaria

**Critério de sucesso:** O documento é específico o suficiente para que outro dev do projeto entenda exatamente o que usar e quando — e está baseado em razões concretas (privacidade, custo, qualidade), não em preferência genérica.

---

## ✅ Auto-Avaliação do Capítulo

- [ ] Entendo a diferença entre open source, open-weights e proprietário
- [ ] Consigo instalar o Ollama e rodar um modelo localmente
- [ ] Sei escolher qual modelo usar de acordo com hardware disponível e tipo de tarefa
- [ ] Tenho o Continue configurado com Ollama no meu editor
- [ ] Sei criar um Modelfile com system prompt específico para um projeto
- [ ] Entendo como servidores MCP se integram com modelos locais
- [ ] Consigo classificar dados de um projeto por nível de sensibilidade e decidir o que vai para API cloud
- [ ] Tenho uma política documentada de quando usar modelo local vs cloud para pelo menos um projeto real

---

## 🔗 Conclusão do Curso

Parabéns por chegar até aqui. O curso cobre desde os fundamentos de como LLMs funcionam até a operação de modelos em ambientes enterprise com requisitos de compliance.

👉 [Referências, glossário e leituras recomendadas](../99-referencias/glossario.md)
