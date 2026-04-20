# 📝 Exercícios — Capítulo 06: Claude (Interface e Modelos)

> Exercícios para dominar a interface claude.ai, o uso de Projects e a escolha de modelos para cada contexto.

---

## Exercício 01 — Mapeando Casos de Uso por Modelo

**Objetivo:** Desenvolver intuição sobre qual modelo usar em cada situação.

**Tarefa:** Para cada cenário abaixo, decida qual modelo usar e justifique:

| Cenário | Modelo escolhido | Justificativa |
|---------|:----------------:|---------------|
| Classificar 10.000 tickets de suporte por categoria | | |
| Revisar arquitetura de um sistema distribuído complexo | | |
| Gerar docstrings para 50 funções simples | | |
| Implementar uma feature nova com múltiplos arquivos | | |
| Responder perguntas rápidas durante desenvolvimento | | |
| Analisar um PDF de 200 páginas de spec técnica | | |
| Pré-processamento em pipeline de alta throughput | | |

**Critério de sucesso:** Escolhas coerentes com os critérios de capacidade, velocidade e custo. Justificativas mencionam pelo menos um trade-off.

---

## Exercício 02 — Análise de Documento com claude.ai

**Objetivo:** Usar o upload de arquivos do claude.ai para análise técnica.

**Tarefa:**

1. Encontre um documento técnico relevante para seu trabalho (spec de API em PDF ou Markdown, RFC, arquitetura em texto)

2. Faça upload no claude.ai e execute estas análises:
   - "Quais são os pontos mais críticos de segurança neste documento?"
   - "Identifique ambiguidades ou lacunas que precisam de esclarecimento"
   - "Gere uma lista de perguntas que um desenvolvedor iniciante teria"

3. Compare com uma conversa sem o documento: faça a mesma pergunta sem upload.

**Critério de sucesso:** A resposta com upload é visivelmente mais específica e referencia o conteúdo real do documento.

---

## Exercício 03 — Criando um Project Efetivo

**Objetivo:** Configurar um Project no claude.ai que sirva como base para trabalho contínuo.

**Tarefa:** Crie um Project para um dos seus projetos reais (ou use o projeto fictício abaixo):

```
Projeto fictício: Sistema de Gestão de Entregas
- API REST em Go + PostgreSQL
- Frontend em React + TypeScript
- Deploy em AWS ECS
- Time: 4 devs
```

O Project deve ter:
- [ ] Nome claro e descritivo
- [ ] Instruções com: stack, contexto do negócio, tom de resposta desejado, 3+ restrições técnicas
- [ ] Pelo menos 1 documento carregado (pode ser um README real ou fictício)

Teste o Project com 3 conversas diferentes sobre o projeto e avalie se as respostas refletem as instruções e documentos configurados.

**Critério de sucesso:** As respostas mencionam detalhes das instruções sem que você precise repeti-los em cada conversa.

---

## Exercício 04 — Artefatos e Iteração

**Objetivo:** Usar o sistema de artefatos para criar e iterar sobre um documento técnico.

**Tarefa:** Peça ao Claude para criar um diagrama de arquitetura do seu projeto (real ou fictício) usando Mermaid, depois itere:

1. "Crie um diagrama de arquitetura para [seu projeto] usando Mermaid flowchart"
2. "Adicione o banco de dados e a fila de mensagens ao diagrama"
3. "Separe os componentes em zonas: público, privado, dados"
4. "Converta para um diagrama de sequência mostrando o fluxo de uma requisição"

Observe como o Claude atualiza o artefato a cada iteração.

**Critério de sucesso:** 4 versões do diagrama geradas, cada uma incorporando o feedback anterior. O resultado final está correto e legível.

---

## ✅ Auto-Avaliação

- [ ] Sei escolher entre Opus, Sonnet e Haiku para diferentes cenários
- [ ] Uso artefatos para iterar sobre código e documentos sem perder o histórico
- [ ] Tenho pelo menos um Project configurado com instruções e documentos relevantes
- [ ] Entendo as diferenças entre Projects (claude.ai) e CLAUDE.md (Claude Code)

---

## 🔗 Próxima Seção

👉 [Claude Code — Instalação e Configuração](./claude-code/01-instalacao-e-configuracao.md)
