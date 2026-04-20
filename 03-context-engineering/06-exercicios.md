# 📝 Exercícios — Capítulo 03: Context Engineering

> Exercícios práticos para consolidar os conceitos de context engineering. Cada exercício exige construir ou auditar contexto real — não há resposta teórica suficiente.

---

## Exercício 01 — Auditoria de Contexto

**Objetivo:** Identificar o que está faltando e o que está sobrando no contexto de uma interação real.

**Tarefa:** Pegue uma interação recente com um modelo de IA em que o resultado foi insatisfatório. Analise o contexto que você forneceu:

1. Preencha a tabela de auditoria:

| Camada de contexto | Estava presente? | Era suficiente? | O que faltou? |
|-------------------|:----------------:|:---------------:|---------------|
| Papel/persona do modelo | Sim / Não | Sim / Não | |
| Contexto do sistema/stack | Sim / Não | Sim / Não | |
| O artefato da tarefa (código, doc) | Sim / Não | Sim / Não | |
| Restrições específicas | Sim / Não | Sim / Não | |
| Exemplos de input/output | Sim / Não | Sim / Não | |
| A instrução em si | Sim / Não | Sim / Não | |

2. Reescreva o contexto com as lacunas preenchidas.
3. Repita a interação com o contexto revisado.

**Critério de sucesso:** A segunda resposta é visivelmente melhor que a primeira, e você consegue apontar exatamente qual camada de contexto fez a diferença.

---

## Exercício 02 — Calculando o que Cabe

**Objetivo:** Desenvolver intuição sobre tamanho de contexto e aprender a priorizar.

**Tarefa:** Escolha um repositório seu ou open-source que você conhece bem.

1. Estime (ou meça) o tamanho total em tokens:
   ```bash
   # Aproximação: 1 token ≈ 4 caracteres
   find . -name "*.py" -o -name "*.ts" | xargs wc -c | tail -1
   # Divida o resultado por 4 para estimar tokens
   ```

2. Supondo que você vai pedir ao modelo para "implementar autenticação JWT neste projeto", responda:
   - Quais arquivos são **essenciais** para esta tarefa? (não pode omitir)
   - Quais arquivos são **úteis** mas podem ser omitidos se precisar economizar contexto?
   - Quais arquivos são **irrelevantes** e não devem entrar?

3. Monte a lista final de arquivos que você enviaria, na ordem de prioridade.

**Critério de sucesso:** Lista de arquivos com justificativa clara para cada decisão de incluir/excluir. O contexto total deve caber em menos de 100K tokens.

---

## Exercício 03 — Criando um CLAUDE.md

**Objetivo:** Construir um arquivo de memória de projeto funcional.

**Tarefa:** Crie um `CLAUDE.md` para um projeto real seu (ou use o projeto fictício abaixo):

```
Projeto fictício: API de delivery de alimentos
- Stack: FastAPI + PostgreSQL + Redis + Celery
- Funcionalidades: pedidos, pagamentos, rastreamento em tempo real
- Time: 3 devs + 1 QA
- Restrições: LGPD, PCI-DSS para pagamentos, SLA de 99.9%
```

O arquivo deve conter:
- [ ] Stack e versões
- [ ] Arquitetura de alto nível (quais módulos existem)
- [ ] Pelo menos 3 convenções de código do projeto
- [ ] Pelo menos 2 decisões técnicas com justificativa
- [ ] Comandos de desenvolvimento (build, test, lint)
- [ ] O que nunca fazer neste projeto

**Critério de sucesso:** Um dev (ou um modelo) lendo apenas o `CLAUDE.md` consegue começar a contribuir com o projeto sem perguntas adicionais de contexto.

---

## Exercício 04 — Handoff entre Sessões

**Objetivo:** Praticar a técnica de continuidade entre sessões longas.

**Tarefa:** Execute uma sessão de desenvolvimento com IA que dure pelo menos 30 minutos e envolva múltiplos passos (pode ser debugging, implementação de uma feature, refatoração).

Ao final da sessão:

1. Peça ao modelo este prompt de handoff:
```markdown
"Antes de encerrar esta sessão, crie um documento de handoff com:
1. Resumo das decisões técnicas tomadas (máximo 5 bullets)
2. Estado atual do que foi implementado/alterado
3. Próximos 3 passos em ordem de prioridade
4. Bloqueadores identificados (se houver)
5. Contexto crítico que alguém precisaria saber para continuar

Seja conciso e específico — este documento será usado no início da próxima sessão."
```

2. Salve o documento em `notas-sessao.md`.

3. Inicie uma nova sessão e use o documento como primeira mensagem. Avalie: o modelo conseguiu continuar sem perder contexto?

**Critério de sucesso:** A segunda sessão continua sem precisar re-explicar o que foi feito na primeira.

---

## Exercício 05 — RAG Manual com Sua Documentação

**Objetivo:** Implementar a versão mais simples de RAG usando apenas grep e inclusão manual de contexto.

**Tarefa:** Escolha uma base de documentação técnica (sua ou pública) e implemente "RAG manual":

1. Faça 3 perguntas diferentes que essa documentação deveria responder.

2. Para cada pergunta, use grep/busca para encontrar os trechos relevantes:
   ```bash
   grep -r "palavra-chave" docs/ --include="*.md" -l
   grep -r "palavra-chave" docs/ --include="*.md" -A 5 -B 2
   ```

3. Monte manualmente o contexto: pergunta + trechos encontrados.

4. Compare a resposta com e sem os trechos de documentação.

**Reflexão:**
- Qual foi a diferença qualitativa nas respostas?
- Quais perguntas se beneficiaram mais do RAG?
- Para quais perguntas o modelo já sabia a resposta sem documentação?

**Critério de sucesso:** Pelo menos 2 das 3 perguntas têm respostas visivelmente mais precisas ou específicas com o RAG manual.

---

## Exercício 06 — Pipeline RAG Automatizado

**Objetivo:** Construir um pipeline RAG funcional com embeddings e busca semântica.

**Tarefa:** Implemente o pipeline RAG básico usando Python:

**Pré-requisitos:**
```bash
pip install anthropic chromadb
```

**Implementação:**

1. Escolha uma base de documentação em Markdown (mínimo 10 arquivos ou 50KB total).

2. Implemente o indexador:
   - Leia todos os arquivos `.md`
   - Divida por seções (split em `\n## `)
   - Armazene no ChromaDB

3. Implemente a busca:
   - Receba uma pergunta
   - Recupere os 3 chunks mais relevantes
   - Monte o contexto com indicação de fonte

4. Implemente o gerador:
   - Use `claude-sonnet-4-6`
   - System prompt: "Responda com base na documentação fornecida. Se a resposta não estiver na documentação, diga explicitamente."

5. Teste com 5 perguntas diferentes.

**Critério de sucesso:** O sistema responde corretamente 4 das 5 perguntas, citando a fonte correta. Quando a pergunta não está na documentação, o modelo admite em vez de alucinar.

---

## Exercício 07 (Desafio Integrador) — Sistema de Contexto Completo

**Objetivo:** Combinar todos os conceitos do capítulo em um sistema coeso de context engineering.

**Cenário:** Você vai construir um "assistente de projeto" personalizado para um repositório seu, integrando:
- Memória persistente via `CLAUDE.md`
- RAG sobre a documentação do projeto
- Handoff documentado entre sessões

**Entregáveis:**

1. **`CLAUDE.md`** — arquivo de memória de projeto completo (Exercício 03 como base)

2. **Pipeline RAG** — indexação da documentação do projeto (Exercício 06 como base)

3. **Template de handoff** — script ou prompt padronizado para encerrar sessões

4. **Relatório de eficácia** — após usar o sistema por uma semana de desenvolvimento real, responda:
   - Quanto tempo a preparação de contexto economizou?
   - Quais partes do sistema foram mais úteis?
   - O que você mudaria?

**Critério de sucesso:** O sistema foi usado em pelo menos 5 sessões de desenvolvimento real. O `CLAUDE.md` foi atualizado pelo menos uma vez com novas decisões ou convenções.

---

## ✅ Auto-Avaliação do Capítulo

- [ ] Consigo explicar a diferença entre prompt engineering e context engineering
- [ ] Sei o que cabe em 200K tokens e como priorizar quando o contexto está cheio
- [ ] Entendo o efeito de primazia/recência e uso isso para posicionar informações críticas
- [ ] Tenho um `CLAUDE.md` funcional em pelo menos um projeto meu
- [ ] Sei quando usar compactação de sessão e o que é preservado vs perdido
- [ ] Implementei ou entendo como implementar um pipeline RAG básico
- [ ] Tenho um processo de handoff entre sessões que uso consistentemente
- [ ] Sei decidir entre RAG e inclusão direta no contexto para diferentes volumes de documentação

---

## 🔗 Próximo Capítulo

👉 [Capítulo 04 — Agentes e Automação](../04-agentes-e-automacao/01-o-que-sao-agentes.md)
